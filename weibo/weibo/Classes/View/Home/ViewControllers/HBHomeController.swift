//
//  HBHomeController.swift
//  weibo
//
//  Created by hebing on 16/9/22.
//  Copyright © 2016年 hebing. All rights reserved.
//

import UIKit

import SVProgressHUD
import YYModel

class HBHomeController: HBBaseVistorController {

    //懒加载数据源数组
    lazy var statuses: [HBStatus] = [HBStatus]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        VisetorLoginView.updateInfor(tipText: "关注一些人,快回到这里看看有什么惊喜")

        
        navigationItem.rightBarButtonItem=UIBarButtonItem(title:"", imagName: "navigationbar_pop", tagert: self, actiong:  #selector(push))
        
        loadData()
        
        
    }
    
    func loadData() -> () {
        


        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
                let paramters = ["access_token" : HBAuthViewModel.sharedAuthViewModel.useModel?.access_token ?? ""]
        
//        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
//        let paramters = ["access_token" : HBStatus.sharedAccountViewModel.userAccount?.access_token ?? ""]
//        //通过网络工具类发送get请求

//        print(path)
        HBNetWorkTools.sharedTools.request(method: .GET, URLString: urlString, parameters: paramters) { (responsObject, error) in
            
            if error != nil {
                
                SVProgressHUD.showError(withStatus: errorTip)
                return
            }
            
            let dict = responsObject as! [String : Any]
             guard let array = dict["statuses"] as? [[String : Any]] else{
                
                return
            }
            
            //遍历数组  字典转模型 添加到数组中
            //
                        for item in array {
//                            
//                            let s = HBStatus(dict: item)
//                            self.statuses.append(s)
//
                            let s = HBStatus()
                            //通过YYModel方式来字典转模型
                            s.yy_modelSet(with: item)
                            //              let s = HMStatus(dict: item)
                            self.statuses.append(s)

                            s.yy_modelSet(with: item)
                            //              let s = HMStatus(dict: item)
                            self.statuses.append(s)
                            
                        }
            
                        //程序走到这个地方 表示模型数字已经有元素了
                        //刷新tableView
                        self.tableView.reloadData()

            
            
            
            
            
        }

        


    }
    
    //按钮的监听事件
    @objc private func push() -> () {
        
        navigationController?.pushViewController(HBTestViewController(), animated: true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  

}

///s数据源方法
extension HBHomeController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.statuses.count
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let s = statuses[indexPath.row]
        
        cell.textLabel?.text=s.text
        
        
        return cell
        
    }

    
    
    
    
    
}
