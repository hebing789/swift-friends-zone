//
//  HBStatus.swift
//  weibo
//
//  Created by hebing on 16/9/27.
//  Copyright © 2016年 hebing. All rights reserved.
//

import UIKit
import YYModel
class HBStatus: NSObject,YYModel {
    
    
    //	微博ID
    // Int看记机型  在32位的机型上面 会出错
    var id: Int = 0
    
    ///	微博信息内容
    var text: String?
    
    ///微博创建时间
    var created_at: String?
    
    ///微博来源
    var source: String?
    
    var user: HBUser?

    
    //配图视图的模型数组
    var pic_urls: [HBPictureInfor]?
    
    //转发的数量
    var reposts_count: Int = 0
    //评论的数量
    var comments_count: Int = 0
    //点赞的数量
    var attitudes_count: Int = 0
    
    
    //被转发的原创微博字段//包含一个自身类的属性
    var retweeted_status: HBStatus?

    
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
    
    //实际上是高度发YYModel在转换字典数组的时候 需要将字典转成什么类型的模型对象:类方法定义方法
//    class func modelContainerPropertyGenericClass() -> [String : Any]? {
//        return ["pic_urls": HBPictureInfor.self]
//    }
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["pic_urls": HBPictureInfor.self]
    }
    
}
