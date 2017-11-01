//
//  ViewController.swift
//  图片折叠2
//
//  Created by umi on 2017/10/19.
//  Copyright © 2017年 wiseuc. All rights reserved.
//



import UIKit

class ViewController: UIViewController {
    
    var imageview1 = UIImageView.init(frame: CGRect.init(x: 0, y: 100, width: 200, height: 100))
    var imageview2 = UIImageView.init(frame: CGRect.init(x: 0, y: 202, width: 200, height: 100))

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.lightGray
        xxxxx()
    }
    
    
    func xxxxx() {
        
        imageview1.image = UIImage.init(named: "知道错了")
        imageview2.image = UIImage.init(named: "知道错了")
        self.view.addSubview(imageview1)
        self.view.addSubview(imageview2)
        
        
        self.imageview1.layer.contentsRect = CGRect.init(x: 0, y: 0, width: 1, height: 0.5)
        self.imageview2.layer.contentsRect = CGRect.init(x: 0, y: 0.5, width: 1, height: 0.5)
        
        self.imageview1.layer.anchorPoint = CGPoint.init(x: 0.5, y: 0.5)
        self.imageview2.layer.anchorPoint = CGPoint.init(x: 0.5, y: 0.5)
        
        
    }
}









