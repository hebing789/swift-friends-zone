//
//  HBHomeViewModel.swift
//  weibo
//
//  Created by hebing on 16/9/27.
//  Copyright © 2016年 hebing. All rights reserved.
//
//  是用来处理tableView需要显示的数据  -> 请求服务器获取数据  -> 字典转模型
//  在这个工具类中: 封装本来应该在控制器中的网络请求数据字典转模型的代码


/*
 - vc
 - tableView   [HMStatus]
 - cell     HMStatus
 
 - vc
 - tableView, homeViewModel(数据的请求和处理)
 - cell   --> HMStatus
 
 - vc
 - tableView  homeViewmodel
 - cell  --> cell的viewmodel(HMStatus)
 
 */


import UIKit

class HBHomeViewModel: NSObject {
    
    
    
//    //模型数组
//    lazy var viewmodelArray: [HMStatusViewModel] = [HMStatusViewModel]()
//    
//    func loadData(finished: @escaping (Bool) -> ()) {
//        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
//        let paramters = ["access_token" : HMUserAccountViewModel.sharedAccountViewModel.userAccount?.access_token ?? ""]
//        //通过网络工具类发送get请求
//        HMNetworkTools.sharedTools.request(method: .GET, urlString: urlString, parameters: paramters) { (responseObject, error) in
//            if error != nil {
//                //提示用户
//                //SVProgressHUD.showError(withStatus: errorTip)
//                finished(false)
//                return
//            }
//            
//            //解析数据  转换字典数据,类型转换  字典转模型
//            //前面已经判断了error
//            let dict = responseObject as! [String : Any]
//            
//            //根据statuses 在字典中取值
//            guard let array = dict["statuses"] as? [[String : Any]] else {
//                finished(false)
//                return
//            }
//            
//            //遍历数组  字典转模型 添加到数组中
//            
//            //将json数据数据转换为什么类型的模型数组
//            //如果采用MVVM的方式就不推荐使用这种方式 MVC模式下推荐使用这种
//            //            let tempArray = NSArray.yy_modelArray(with: HMStatus.self, json: array) as! [HMStatus]
//            //            self.statuses = tempArray
//            
//            for item in array {
//                let viewmodel = HMStatusViewModel()
//                let s = HMStatus()
//                s.yy_modelSet(with: item)
//                viewmodel.status = s
//                //通过YYModel方式来字典转模型
//                //              let s = HMStatus(dict: item)
//                self.viewmodelArray.append(viewmodel)
//            }
//            
//            //程序走到这个地方 表示模型数字已经有元素了
//            //刷新tableView
//            //self.tableView.reloadData()
//            //执行闭包
//            finished(true)
//            
//        }
//    }

}
