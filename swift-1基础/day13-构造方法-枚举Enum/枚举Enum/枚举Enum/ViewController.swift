//
//  ViewController.swift
//  枚举Enum
//
//  Created by umi on 2017/10/17.
//  Copyright © 2017年 wiseuc. All rights reserved.
//

import UIKit



enum UserInfo {
    case 司令
    case 军长
    case 师长
    case 旅长
    case 团长
    case 营长
    case 排长
    case 班长
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let name = UserInfo.师长
        
        
        switch name {
        case .司令:
            print("司令")
        case .军长:
            print("军长")
        case .师长:
            print("师长")
        case .团长:
            print("团长")
        case .营长:
            print("营长")
        case .排长:
            print("排长")
        case .班长:
            print("班长")
        default:
            print("other")
        }
        
        
    }


}

