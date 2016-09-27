//
//  HBUserAccountModel.swift
//  weibo
//
//  Created by hebing on 16/9/25.
//  Copyright © 2016年 hebing. All rights reserved.
//

import UIKit

class HBUserAccountModel: NSObject,NSCoding {
    
    ///用户授权的唯一票据，用于调用微博的开放接口，同时也是第三方应用验证微博用户登录的唯一票据，第三方应用应该用该票据和自己应用内的用户建立唯一影射关系，来识别登录状态，不能使用本返回值里的UID字段来做登录识别
    var access_token: String?
    
    ///access_token的生命周期，单位是秒数。 token 从获取的那一刻开始过expires_in秒后会过期
    //存这个过期时间是没有意义的
    var expires_in: Int = 0 {
        didSet {
            //给 expires_date 赋值
            expires_date = Date(timeIntervalSinceNow: Double(expires_in))
        }
    }
    
    //增加一个过期日期的属性
    var expires_date: Date?
    
    ///授权用户的UID，本字段只是为了方便开发者，减少一次user/show接口调用而返回的，第三方应用不能用此字段作为用户登录状态的识别，只有access_token才是用户授权的唯一票据。
    var uid: String?
    
    //用户名
    var name: String?

    //用户头像 180 * 180
    var avatar_large: String?
    

    
    init( dict:[String:Any]) {
        super.init()
        self.setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    
//    func encode(with aCoder: NSCoder) {
//        
////        aCoder.encode(<#T##objv: Any?##Any?#>, forKey: <#T##String#>)
//                aCoder.encode(access_token, forKey: "access_token")
//                aCoder.encode(uid, forKey: "uid")
//                aCoder.encode(name, forKey: "name")
//                aCoder.encode(avatar_large, forKey: "avatar_large")
//                aCoder.encode(expires_date, forKey: "expires_date")
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
////        aDecoder.decodeObject(forKey: <#T##String#>)
//        access_token = aDecoder.decodeObject(forKey: "access_token") as? String
//                uid = aDecoder.decodeObject(forKey: "uid") as? String
//                name = aDecoder.decodeObject(forKey: "name") as? String
//                avatar_large = aDecoder.decodeObject(forKey: "avatar_large") as? String
//                expires_date = aDecoder.decodeObject(forKey: "expires_date") as? Date
//
//    }
    //实现归档
    func encode(with aCoder: NSCoder) {
        aCoder.encode(access_token, forKey: "access_token")
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(avatar_large, forKey: "avatar_large")
        aCoder.encode(expires_date, forKey: "expires_date")
        
    }
    
    //解档
    required init?(coder aDecoder: NSCoder) {
        //给模型的属性赋值
        access_token = aDecoder.decodeObject(forKey: "access_token") as? String
        uid = aDecoder.decodeObject(forKey: "uid") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        avatar_large = aDecoder.decodeObject(forKey: "avatar_large") as? String
        expires_date = aDecoder.decodeObject(forKey: "expires_date") as? Date
    }
    


}
