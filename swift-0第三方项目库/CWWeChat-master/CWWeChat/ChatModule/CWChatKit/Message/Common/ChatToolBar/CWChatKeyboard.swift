//
//  CWChatKeyboard.swift
//  CWWeChat
//
//  Created by wei chen on 2017/4/11.
//  Copyright © 2017年 cwcoder. All rights reserved.
//

import UIKit
import KVOController

enum CWChatKeyboardStyle {
    case chat    //聊天
    case comment //评论
}

/// 数据源
protocol CWChatKeyboardDataSource {
    func chatKeyBoardMoreItems() -> [CWMoreItem]
}

public class CWChatKeyboard: UIView {
        
    public weak var associateTableView: UITableView?

    /// 风格
    var keyboardStyle: CWChatKeyboardStyle = .chat
    
    /// 是否开启语言
    var allowVoice: Bool = true
    /// 是否开启表情
    var allowFace: Bool = true
    /// 是否开启更多功能
    var allowMore: Bool = true
    
    var lastChatKeyboardY: CGFloat = 0.0
    
    private convenience init() {
        let frame = CGRect(x: 0, y: kScreenHeight-kChatToolBarHeight,
                           width: kScreenWidth, height: kChatKeyboardHeight)
        self.init(frame: frame)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(chatToolBar)
        self.addSubview(moreInputView)
        self.addSubview(emoticonInputView)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChangeFrame(_:)),
                                               name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        self.kvoController.observe(self.chatToolBar, keyPath: "frame", options: [.new, .old], action: #selector(toolBarFrameChange(_:)))
    }
    
    var placeHolder: String? {
        didSet {
            
        }
    }
    
    var placeHolderColor: String? {
        didSet {
            
        }
    }
    
    func toolBarFrameChange(_ info: [String: Any]) {
        print(info)
        let newRect = (info["new"] as! NSValue).cgRectValue
        let oldRect = (info["old"] as! NSValue).cgRectValue
        let changeHeight = newRect.height - oldRect.height
        
        self.lastChatKeyboardY = self.y
        self.y = self.y - changeHeight
        self.height = self.height + changeHeight
        
        self.moreInputView.y = self.height - self.moreInputView.height
        self.emoticonInputView.y = self.height - self.emoticonInputView.height

        self.updateAssociateTableViewFrame()
    }
    
    func keyboardWillChangeFrame(_ notification: Notification) {
        
        if self.chatToolBar.faceSelected {
            
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveLinear, animations: {
                
                self.lastChatKeyboardY = self.y
                self.emoticonInputView.isHidden = false
                self.moreInputView.isHidden = true
                self.frame = CGRect(x: 0, y: self.superview!.height-self.height,
                                    width: kScreenWidth, height: self.height)
                
                self.emoticonInputView.y = self.height-kMoreInputViewHeight
                self.moreInputView.y = self.height

                self.updateAssociateTableViewFrame()
                
            }, completion: nil)
        }
        else if self.chatToolBar.moreSelected {
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveLinear, animations: {
                
                self.emoticonInputView.isHidden = true
                self.moreInputView.isHidden = false
                self.lastChatKeyboardY = self.y
                self.frame = CGRect(x: 0, y: self.superview!.height-self.height,
                                    width: kScreenWidth, height: self.height)
                
                
                self.emoticonInputView.y = self.height
                self.moreInputView.y = self.height-kMoreInputViewHeight
                
                self.updateAssociateTableViewFrame()
                
            }, completion: nil)
        }
        else {
        
            UIView.animate(withDuration: 0.25, animations: { 
                
                let beginFrameValue = notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue
                let beginFrame = beginFrameValue.cgRectValue
                
                let endFrameValue = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
                let endFrame = endFrameValue.cgRectValue
                
                let duration = (notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
                
                let chatToolBarHeight = self.height - kMoreInputViewHeight
                let targetY = endFrame.y - chatToolBarHeight - (kScreenHeight - self.superview!.height)
                
                if beginFrame.height > 0 && (beginFrame.y - endFrame.y > 0) {
                    // 键盘弹起 (包括，第三方键盘回调三次问题，监听仅执行最后一次)
                    self.lastChatKeyboardY = self.y
                    self.y = targetY
                    
                    self.moreInputView.y = self.height
                    self.emoticonInputView.y = self.height
                    self.updateAssociateTableViewFrame()
                    
                }
                else if (endFrame.y == kScreenHeight && beginFrame.y != endFrame.y && duration > 0) {
                    self.lastChatKeyboardY = self.y
                    if self.keyboardStyle == .chat {
                        self.y = targetY
                    } else {
                        if self.chatToolBar.voiceSelected {
                            self.y = targetY
                        } else {
                            self.y = self.superview!.height
                        }
                    }
                    self.updateAssociateTableViewFrame()
                }
                else if ((beginFrame.y-endFrame.y<0) && duration == 0) {
                    self.lastChatKeyboardY = self.y
                    self.y = targetY
                    self.updateAssociateTableViewFrame()
                }
                
            })
            
        }
    }
    
    func updateAssociateTableViewFrame() {
        guard let tableView = associateTableView else {
            return
        }
        
        let original = tableView.contentOffset.y
        let keyboardOffset = self.y - self.lastChatKeyboardY
        tableView.frame = CGRect(x: 0, y: 0, width: self.width, height: self.y)
        
        let tableViewContentDiffer = tableView.contentSize.height - tableView.height

        //是否键盘的偏移量，超过了表的整个tableViewContentDiffer尺寸
        var offset: CGFloat = 0
        if fabs(tableViewContentDiffer) > fabs(keyboardOffset) {
            offset = original-keyboardOffset
        }else {
            offset = tableViewContentDiffer
        }
        
        if tableView.contentSize.height + tableView.contentInset.top + tableView.contentInset.bottom > tableView.height {
            tableView.contentOffset = CGPoint(x: 0, y: offset)
        }
        
    }
    
    // 开启键盘
    func keyboardUp() {
        if self.keyboardStyle == .comment {
            
        } else {
            
        }
    }
    
    // 隐藏键盘
    func keyboardDown() {
        if self.keyboardStyle == .comment {
            
        } else {
            
        }
    }
    
    // MARK: Getter
    lazy var chatToolBar: CWChatToolBar = {
        let frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kChatToolBarHeight)
        let chatToolBar = CWChatToolBar(frame:frame)
        chatToolBar.delegate = self
        return chatToolBar
    }()
    
    // 表情
    lazy var emoticonInputView: CWEmoticonInputView = {
        let emoticonInputView = CWEmoticonInputView.shareView
        emoticonInputView.delegate = self
        emoticonInputView.y = self.moreInputView.y
        return emoticonInputView
    }()
    
    // 更多部分
    lazy var moreInputView: CWMoreInputView = {
        let frame = CGRect(x: 0, y: kChatKeyboardHeight-kMoreInputViewHeight, width: kScreenWidth, height: kMoreInputViewHeight)
        let moreInputView = CWMoreInputView(frame: frame)
        moreInputView.deleagte = self
        let items = CWMoreInputViewHelper().chatMoreKeyboardData
        moreInputView.loadMoreItems(items)
        return moreInputView
    }()
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension CWChatKeyboard: CWChatToolBarDelegate {
    
    public func chatToolBar(_ chatToolBar: CWChatToolBar, voiceButtonPressed select: Bool, keyBoardState change:Bool) {
        
        if select && change == false {
            
            UIView.animate(withDuration: 0.25, animations: {
                self.lastChatKeyboardY = self.y
                self.y = self.superview!.height - self.chatToolBar.height
                self.updateAssociateTableViewFrame()
            })
        }
        
        
    }
    
    public func chatToolBar(_ chatToolBar: CWChatToolBar, emoticonButtonPressed select: Bool, keyBoardState change:Bool) {
        if select && change == false {
            self.moreInputView.isHidden = true
            self.emoticonInputView.isHidden = false
            
            UIView.animate(withDuration: 0.25, animations: {
                
                self.lastChatKeyboardY = self.y
                self.y = self.superview!.height - self.height
                
                self.emoticonInputView.y = self.height - self.emoticonInputView.height
                self.moreInputView.y = self.height
                
                self.updateAssociateTableViewFrame()
            })
            
        }
    }
    
    public func chatToolBar(_ chatToolBar: CWChatToolBar, moreButtonPressed select: Bool, keyBoardState change:Bool) {
        if select && change == false {
            self.moreInputView.isHidden = false
            self.emoticonInputView.isHidden = true
            
            UIView.animate(withDuration: 0.25, animations: {
                
                self.lastChatKeyboardY = self.y
                self.y = self.superview!.height - self.height
                
                self.moreInputView.y = self.height - self.moreInputView.height
                self.emoticonInputView.y = self.height
                
                self.updateAssociateTableViewFrame()
            })
            
        }
    }
    
    ///发送文字
    public func chatToolBar(_ chatToolBar: CWChatToolBar, sendText text: String) {
        
    }
    
    ///发送图片
    public func chatToolBar(_ chatToolBar: CWChatToolBar, image: UIImage) {
        
    }
    
}

extension CWChatKeyboard: CWEmoticonInputViewDelegate {
    func emoticonInputDidTapComplete() {
        
    }
    
    func emoticonInputDidTapBackspace() {
        
        
    }
    
    func emoticonInputDidTapText(_ text: String) {
        
    }
    
}

extension CWChatKeyboard: CWMoreInputViewDelegate {
    public func moreInputView(_ inputView: CWMoreInputView, didSelect item: CWMoreItem) {
        
    }
}

