//
//  CWChatroomManager.swift
//  CWWeChat
//
//  Created by wei chen on 2017/4/5.
//  Copyright © 2017年 cwcoder. All rights reserved.
//

import Foundation

// 多人聊天
protocol CWChatroomManagerDelegate {
    
}


protocol CWChatroomManager {
    
    /// 添加代理
    ///
    /// - Parameter delegate: 代理
    /// - Parameter delegateQueue: 代理执行线程
    func addChatroomDelegate(_ delegate: CWGroupManagerDelegate, delegateQueue: DispatchQueue)
    
    /// 删除代理
    ///
    /// - Parameter delegate: 代理
    func removeChatroomDelegate(_ delegate: CWGroupManagerDelegate)
    
    func fetchChatrooms();
    
    func createGroup(title: String,
                     invitees: [String],
                     message: String,
                     setting: CWChatGroupOptions,
                     completion: CWGroupCompletion)
}
