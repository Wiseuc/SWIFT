//
//  ArchiverArray.swift
//  归档-模型数组
//
//  Created by umi on 2017/10/16.
//  Copyright © 2017年 wiseuc. All rights reserved.
//

import UIKit

class ArchiverArray: NSObject ,NSCoding{
    var blogList : [AnyObject]
    
    init(blogList : [AnyObject]) {
        self.blogList = blogList
    }
    convenience required init?(coder aDecoder: NSCoder) {
        let blogList = aDecoder.decodeObject(forKey: "blogs") as? [AnyObject]
        self.init (blogList : blogList!)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(blogList, forKey: "blogs")
    }
}
