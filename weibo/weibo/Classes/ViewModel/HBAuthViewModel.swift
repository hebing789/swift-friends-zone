//
//  HBAuthViewModel.swift
//  weibo
//
//  Created by hebing on 16/9/25.
//  Copyright © 2016年 hebing. All rights reserved.
//

import UIKit


private  let path = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last! as NSString) .appendingPathComponent("account.plist")
class HBAuthViewModel: NSObject {

    //单例对象
    static let sharedAuthViewModel: HBAuthViewModel = HBAuthViewModel()
//    static let sharedAuthViewModel: HBAuthViewModel = {
//        
//        return HBAuthViewModel()
//        
//    }()
    
//    static  let sharedAuthViewModel:HBAuthViewModel = HBAuthViewModel()
    
    override init() {
        
        super.init()
         //在构造函数中给属性赋值 不会执行到 didSet
        self.useModel=self.loadUseInforModel()
        //从沙盒中获取数据保存在单例对象的模型中
        //在构造函数中给属性赋值 不会执行到 didSet
        let urlString = useModel?.avatar_large ?? ""
        iconURL = URL(string: urlString)
         print(path)
        
    }
    var useModel:HBUserAccountModel?{
        
        didSet {
            //一旦外界给userAccount 赋值的时候就立即给iconURL 赋值,就能够确保iconURL一定有值
            let urlString = useModel?.avatar_large ?? ""
            iconURL = URL(string: urlString)
        }

        
    }
    
    //先不要关注给userAccount 赋值 一会详细讲
    /*
     赋值有两种情况
     1. 用户未登陆 -> 输入用户名,密码 -> 授权 -> 截取code -> code 换token, 获取用户信息 -> 给用户信息赋值
     2. 用户已经登陆,第二次打开应用的时候 -> 从沙盒中获取用户信息  -> 给 userAccount赋值
     */
    
    
    //可以使用计算性属性 计算型属性的特点是相当于一个方法 每次执行都会调用 消耗cpu  值如果需要一直变化 就需要使用计算型属性
    //存储型的属性 调用存储型的属性的时候 实际上回直接读取内存 不消耗cpu 但是消耗内存 值一旦设置就不需要变化 就可以使用 存储型属性
    var iconURL: URL?
    


    var useLogin:Bool {
        if ((useModel?.access_token) != nil) != nil && isExpiredDate == false {
            return true
        }
        
        return false
    }
    //判断当前日期 和过期日期比较 如果 当前日期小于过期日期 就是 没有过期   2016 9 20 < 2016 9 28
    //        // 2016 9 28   2016 9 20
    var isExpiredDate:Bool {
        if useModel?.expires_date?.compare(Date()) == ComparisonResult.orderedDescending {
            //过期时间:当前时间,降序
            return false
            
        }
        
        return true
    }
    
//    override init() {
//        super.init()
//        self.useModel=self.loadUseInforModel()
//        
//        
//    }
    
    func loadUseInforModel() -> HBUserAccountModel? {
        
//        if path == " "{
//            
//            return nil
//        }
        
        print(path)
        let model = (NSKeyedUnarchiver.unarchiveObject(withFile: path) ?? nil) as? HBUserAccountModel
        
        
        return model
        
    }
    
    func saveUseAccunt(useModel:HBUserAccountModel) -> () {
        //一般归档在沙盒的Document
        //拼接文件名的方法String 没有 需要将 String 转换为 NSStirng
        //使用默认 as 转换的前提是 被转换的对象不是可选类型
        //将某一个对象归档到某一个路径下
        print(path)
        //注意传值,不要传错值
        NSKeyedArchiver.archiveRootObject(useModel, toFile: path)
        
        
    }
    
    internal func loadAcessToken(code:String,finish:@escaping (Bool)->()){
        
        let urlStr = "https://api.weibo.com/oauth2/access_token"
        
        let parameters = ["client_id" : client_id,
                         "client_secret" : client_secret,
                         "grant_type" : "authorization_code",
                         "code" : code,
                         "redirect_uri" : redirect_uri
                ]
        
        HBNetWorkTools.sharedTools.request(method: .POST, URLString: urlStr, parameters: parameters) { (responsObject, error) in
            
            if error != nil {
                
                finish(false)
                return
            }
            
            print(responsObject)
            //获取用户数据,数据转模型
            //写这个不规定类型,接收不到数据
//            let dict=responsObject as! [String : Any]
            
            self.loadUseInfor(dict: responsObject as! [String : Any], finish: finish)
        }
        
        
    }
    

    
    
    
    
    private func loadUseInfor(dict:[String: Any],finish:@escaping (Bool)->())->(){
        
//        let urlString = "https://api.weibo.com/2/users/show.json"
//        let access_token = dict["access_token"]!
//                let uid = dict["uid"]!
//                //字典中不能添加nil
//                let paramters = ["access_token" : access_token,
//                                 "uid" : uid]
        let urlString = "https://api.weibo.com/2/users/show.json"
        
        let access_token = dict["access_token"]!
        let uid = dict["uid"]!
        //字典中不能添加nil
        let paramters = ["access_token" : access_token,
                         "uid" : uid]

        print(paramters)
        HBNetWorkTools.sharedTools.request(method: .GET, URLString: urlString, parameters: paramters) { (responsobject, error) in
            
            if error != nil {
                
                finish(false)
                return
            }
            
//            print(responsobject as! [String : Any])
            //获取用户数据,数据转模型
            //获取用户信息 将字典类型的用户信息 转换成模型数据 -> 将模型数据存储在本地(归档)
            //            //字典转模型
            //            var userInfoDict = responseObject as! [String : Any]
            var useInforDict = responsobject as! [String:Any]
            
            for keeValues in dict {
                useInforDict[keeValues.key]=keeValues.value
                
            }
            let useAccount = HBUserAccountModel(dict: useInforDict)
            print(useAccount)
            self.saveUseAccunt(useModel: useAccount)
            self.useModel = useAccount
            finish(true)
            print(useAccount)
        }
        
        
    }
   
}
