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
import SDWebImage

import SVProgressHUD
import YYModel
class HBHomeViewModel: NSObject {
    
    
    

    
    
    lazy var statuesViewModelAry: [HBStatusViewModel] = [HBStatusViewModel]()
    
    /// 加载数据  cmd + option + /
    ///
    /// - parameter isPullup: 标识是否正在做上拉操作
    /// - parameter finished: 回调闭包

    func loadData(isPullup:Bool,finish:@escaping (Bool,Int?)->()) -> () {
        
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        var paramters = ["access_token" : HBAuthViewModel.sharedAuthViewModel.useModel?.access_token ?? ""]
        
        if isPullup {

//增加参数,在字典中增加键值,-1?防止最后一天数据重复
            //第一次加载数据的时候 数组为空数组 获取的id就是0

            paramters["max_id"] = "\((statuesViewModelAry.last?.status?.id ?? 0) - 1)"

        }else{
//            paramters["since_id"] = "\(id)"
            //第一次加载数据的时候 数组为空数组 获取的id就是0

            paramters["since_id"] = "\(statuesViewModelAry.first?.status?.id ?? 0)"
        }
        
        HBNetWorkTools.sharedTools.request(method: .GET, URLString: urlString, parameters: paramters) { (responsObject, error) in
            
            if error != nil {
                
//                SVProgressHUD.showError(withStatus: errorTip)
                finish(false,nil)
                return
            }
            
            let dict = responsObject as! [String : Any]
            guard let array = dict["statuses"] as? [[String : Any]] else{
                finish(false,nil)
                return
            }
            
            //遍历数组  字典转模型 添加到数组中
            //
            //上拉加载更多数据 数据的拼接: 追加在viewmodelArray后面
            //下拉刷新数据 数据的拼接: 插入到数组最前面
            var temAry=[HBStatusViewModel]()
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
//                self.statuesViewModelAry.append(viewModle)
                
                s.yy_modelSet(with: item)
                //              let s = HMStatus(dict: item)
                //挨个添加元素
                temAry.append(viewModle)
                
            }
            if isPullup{
                self.statuesViewModelAry = self.statuesViewModelAry + temAry
            }else{
                self.statuesViewModelAry = temAry + self.statuesViewModelAry
            }
            
            //程序走到这个地方 表示模型数字已经有元素了
            //刷新tableView
            //self.tableView.reloadData()
            //执行闭包

            
//            finish(true,temAry.count)
            
            //执行闭包  此处不要执行回调 需要等到所有的单张图片下载完毕之后再执行回调
            
            self.cacheSingleImage(dataArray: temAry, cacheImageFinished: finish)
        }
    }
    
    
    private func cacheSingleImage(dataArray: [HBStatusViewModel], cacheImageFinished: @escaping (Bool,Int) -> ()) {
        //执行单张图片的下载任务
        //遍历数组
        
        //在外界显示实例化调度组  用来监听一组任务的完成
        let group = DispatchGroup.init()
        for viewmodel in dataArray {
            //是否是单张图片
            if viewmodel.pictureInfos?.count == 1 {
                //单张图片 下载图片
                let url = URL(string: viewmodel.pictureInfos?.first?.wap_pic ?? "")
                //在开始异步任务之前 就应该入组  调度组中的异步任务 + 1
                group.enter()
                SDWebImageManager.shared().downloadImage(with: url, options: [], progress: nil, completed: { (image, _, _, _, _) in
                    //程序走到这个地方 表示单张图片已经被下载完毕
                    
                    //能够在这里执行回调
                    //这个地方只能够监听单张图片下载完毕
                    print("单张图片下载完成")
                    //出组 调度组中的异步任务 -1
                    group.leave()
                })
            }
        }
        //执行回调
        group.notify(queue: DispatchQueue.main) {
            //执行回调
            print("所有的单张图片下载完毕")
            cacheImageFinished(true, dataArray.count)
        }
}
}
