//
//  CWChatXMPPManager.swift
//  CWWeChat
//
//  Created by chenwei on 2017/2/12.
//  Copyright © 2017年 chenwei. All rights reserved.
//

import UIKit
import XMPPFramework
import Alamofire

public let kCWMessageDispatchSuccessNotification = NSNotification.Name("kCWMessageDispatchSuccessNotification")

public let kCWNetworkReachabilityNotification = NSNotification.Name("kCWNetworkReachabilityNotification")


// xmpp管理实例
class CWChatXMPPManager: NSObject {
    
    public static let share = CWChatXMPPManager()
    /// xmpp流
    private(set) var xmppStream: XMPPStream
    /// xmpp重新连接
    private var xmppReconnect: XMPPReconnect
    private var autoPing: XMPPAutoPing
    /// xmpp队列
    private var xmppQueue: DispatchQueue

    fileprivate var streamManagement: XMPPStreamManagement

    var options: CWChatClientOptions!
    /// 网络状态监听
    public var reachable: NetworkReachabilityManager?
    
    var isLogin: Bool = true
    var password: String!
    var completion: CWClientCompletion?
    
    /// 初始化方法
    private override init() {
        xmppQueue = DispatchQueue(label: "com.cwxmppchat.cwcoder", attributes: DispatchQueue.Attributes.concurrent)
        
        let memoryStorage = XMPPStreamManagementMemoryStorage()
        streamManagement = XMPPStreamManagement(storage: memoryStorage)
        xmppStream = XMPPStream()
        xmppReconnect = XMPPReconnect()
        autoPing = XMPPAutoPing()
        super.init()
        
        /// xmpp
        xmppStream.enableBackgroundingOnSocket = true
        xmppStream.addDelegate(self, delegateQueue: xmppQueue)

        /// xmppstreamManagement
        streamManagement.activate(xmppStream)
        streamManagement.addDelegate(self, delegateQueue: xmppQueue)
        streamManagement.automaticallyRequestAcks(afterStanzaCount: 5, orTimeout: 2.0)
        streamManagement.automaticallySendAcks(afterStanzaCount: 5, orTimeout: 2.0)

        ///配置xmpp重新连接的服务
        xmppReconnect.reconnectDelay = 3.0
        xmppReconnect.reconnectTimerInterval = DEFAULT_XMPP_RECONNECT_TIMER_INTERVAL
        xmppReconnect.activate(xmppStream)
        xmppReconnect.addDelegate(self, delegateQueue: xmppQueue)

        //心跳机制
//        autoPing.activate(xmppStream)
//        autoPing.respondsToQueries = true

        setupNetworkReachable()
        registerApplicationNotification()
    }
    
    /// 注册观察者
    func registerApplicationNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground(_:)), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive(_:)), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
    }
    
    func setupNetworkReachable() {
        ///监视网络变化
        reachable = Alamofire.NetworkReachabilityManager(host: "www.baidu.com")
        let listener = { (status: NetworkReachabilityManager.NetworkReachabilityStatus) in
            
            var networkStatus = false
            switch status {
                
            case .notReachable:
                networkStatus = false
                
            case .unknown :
                networkStatus = false
                
            case .reachable(.ethernetOrWiFi):
                networkStatus = true
                
            case .reachable(.wwan):
                networkStatus = true
            }
            
            NotificationCenter.default.post(name: kCWNetworkReachabilityNotification, object: networkStatus)
        }
        reachable?.listener = listener
        reachable?.startListening()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func loginServer(with userName: String,
                     password: String,
                     isLogin: Bool = true,
                     completion: CWClientCompletion?) {

        if reachable?.isReachable == false {
            completion?(nil, CWChatError(error: "网络连接失败"))
            return
        }
        
        // 保存变量
        self.isLogin = isLogin
        self.password = password
        self.completion = completion
        
        let timeoutInterval: TimeInterval = 60
        let resource = options.resource
        let domain = options.domain
        
        xmppStream.hostName = options.host
        xmppStream.hostPort = options.port
        xmppStream.myJID = XMPPJID(user: userName, domain: domain, resource: resource)
        do {
            try xmppStream.connect(withTimeout: timeoutInterval)
        } catch {
            let error = CWChatError(errorCode: .serverTimeout)
            self.completion?(nil, error)
        }
    }
    
    
    //发送在线信息
    func goOnline() {
        let presence = XMPPPresence()
        xmppStream.send(presence)
    }
    
    func goOffline() {
        let offline = XMPPPresence(name: "unavailable")
        xmppStream.send(offline)
    }
    
    // MARK: 监听xmpp链接状态
    func xmppStatusChange(_ status: Int) {
     
        
    }
    
    // MARK: 销毁
    deinit {
        
        goOffline()
        
        xmppReconnect.removeDelegate(self, delegateQueue: xmppQueue)
        xmppReconnect.deactivate()
        
        xmppStream.removeDelegate(self, delegateQueue: xmppQueue)
        xmppStream.disconnect()
        
        reachable?.stopListening()
        
        NotificationCenter.default.removeObserver(self)
    }
    
}

// MARK: - XMPPStreamDelegate
extension CWChatXMPPManager: XMPPStreamDelegate {

    /// 开始连接
    func xmppStreamWillConnect(_ sender: XMPPStream!) {
        log.verbose("xmpp开始连接...")
    }
    
    /// 连接失败
    func xmppStreamDidDisconnect(_ sender: XMPPStream!, withError error: Error!) {
        self.completion?(nil, CWChatError(error: "连接服务器失败"))
    }
    
    /// 已经连接，就输入密码
    func xmppStreamDidConnect(_ sender: XMPPStream!) {
        do {
            if isLogin {
                try xmppStream.authenticate(withPassword: password)
            } else {
                let result = xmppStream.supportsInBandRegistration()
                log.debug("注册支持\(result)")
                try xmppStream.register(withPassword: password)
            }
        } catch {
            log.error(error)
        }
    }
    
    // 验证失败
    func xmppStream(_ sender: XMPPStream!, didNotAuthenticate error: DDXMLElement!) {
        log.error("xmpp验证失败...\(error)")
        self.completion?(nil, CWChatError(errorCode: .authenticationFailed))
        //登陆失败之后 则断开连接。
        sender.disconnect()
    }
    
    // 验证成功
    func xmppStreamDidAuthenticate(_ sender: XMPPStream!) {
        self.completion?(xmppStream.myJID.user, nil)

        goOnline()
        
        streamManagement.autoResume = true
        streamManagement.enable(withResumption: true, maxTimeout: 60)
    }
    
    func xmppStreamDidRegister(_ sender: XMPPStream!) {
        log.debug("xmpp注册成功")
        self.completion?(xmppStream.myJID.user, nil)
    }
    
    func xmppStream(_ sender: XMPPStream!, didNotRegister error: DDXMLElement!) {
        self.completion?(nil, CWChatError(error: "注册失败"))
    }
    
    // 收到错误信息
    func xmppStream(_ sender: XMPPStream!, didReceiveError error: DDXMLElement!) {
        
        /**
         <stream:error xmlns:stream="http://etherx.jabber.org/streams">
         <conflict xmlns="urn:ietf:params:xml:ns:xmpp-streams"/>
         <text xmlns="urn:ietf:params:xml:ns:xmpp-streams" lang="">
         Replaced by new connection
         </text>
         </stream:error>
         */
        let errormessage = error.elements(forName: "conflict")
        if errormessage.count > 0 {
            log.error("异常登录")
        }
    }
    
    func xmppStream(_ sender: XMPPStream!, didSend iq: XMPPIQ!) {
        log.debug(iq)
    }
    
    func xmppStream(_ sender: XMPPStream!, didReceive iq: XMPPIQ!) -> Bool {
        
        log.debug(iq)

        if iq.requiresResponse() {
            
        } else {
            
        }
        
        return true
    }

}

extension CWChatXMPPManager: XMPPStreamManagementDelegate {
    
    func xmppStreamManagementDidRequestAck(_ sender: XMPPStreamManagement!) {}
    
    func xmppStreamManagement(_ sender: XMPPStreamManagement!, wasEnabled enabled: DDXMLElement!) {
        log.info("xmppStreamManagement wasEnabled")
    }
    
    func xmppStreamManagement(_ sender: XMPPStreamManagement!, didReceiveAckForStanzaIds stanzaIds: [Any]!) {
        // 收到id
        guard let messageid = stanzaIds as? [String] else {
            return 
        }
        log.debug(messageid)
        NotificationCenter.default.post(name: kCWMessageDispatchSuccessNotification, object: messageid)
    }
}

