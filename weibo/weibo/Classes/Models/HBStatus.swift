//
//  HBStatus.swift
//  weibo
//
//  Created by hebing on 16/9/27.
//  Copyright © 2016年 hebing. All rights reserved.
//

import UIKit

class HBStatus: NSObject {
    
    
    //	微博ID
    // Int看记机型  在32位的机型上面 会出错
    var id: Int = 0
    
    ///	微博信息内容
    var text: String?
    
    ///微博创建时间
    var created_at: String?
    
    ///微博来源
    var source: String?
    
//    //kvc模型加载数据方法1
//    init(dict: [ String: Any]) {
//        super.init()
//        self.setValuesForKeys(dict)
//    }
//    
//    override func setValue(_ value: Any?, forUndefinedKey key: String) {
//        
//    }
//    

}
