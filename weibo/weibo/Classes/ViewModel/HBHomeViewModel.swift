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

import SVProgressHUD
import YYModel
class HBHomeViewModel: NSObject {
    
    
    

    
    
    lazy var statuesViewModelAry: [HBStatusViewModel] = [HBStatusViewModel]()
    
    func loadData(finish:@escaping (Bool)->()) -> () {
        
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        let paramters = ["access_token" : HBAuthViewModel.sharedAuthViewModel.useModel?.access_token ?? ""]
        
        
        HBNetWorkTools.sharedTools.request(method: .GET, URLString: urlString, parameters: paramters) { (responsObject, error) in
            
            if error != nil {
                
//                SVProgressHUD.showError(withStatus: errorTip)
                finish(false)
                return
            }
            
            let dict = responsObject as! [String : Any]
            guard let array = dict["statuses"] as? [[String : Any]] else{
                finish(false)
                return
            }
            
            //遍历数组  字典转模型 添加到数组中
            //
            for item in array {
                //
                //                            let s = HBStatus(dict: item)
                //                            self.statuses.append(s)
                //
                
                let viewModle = HBStatusViewModel()
                let s = HBStatus()
                //通过YYModel方式来字典转模型
                s.yy_modelSet(with: item)
                viewModle.status=s
                //              let s = HMStatus(dict: item)
                self.statuesViewModelAry.append(viewModle)
                
                s.yy_modelSet(with: item)
                //              let s = HMStatus(dict: item)
                self.statuesViewModelAry.append(viewModle)
                
            }
            
            //程序走到这个地方 表示模型数字已经有元素了
            //刷新tableView
            //self.tableView.reloadData()
            //执行闭包

            
            finish(true)
            
            
            
            
        }

    }
    

}
