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
//    lazy var statuses: [HBStatus] = [HBStatus]()
    
    lazy var homeViewModel :HBHomeViewModel=HBHomeViewModel()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        VisetorLoginView.updateInfor(tipText: "关注一些人,快回到这里看看有什么惊喜")

        
        navigationItem.rightBarButtonItem=UIBarButtonItem(title:"", imagName: "navigationbar_pop", tagert: self, actiong:  #selector(push))
        
        homeViewModel.loadData { (success) in
            
            if !success{
                SVProgressHUD.showError(withStatus: errorTip)
                return
            }
            
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
        return self.homeViewModel.statuesViewModelAry.count
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let staues = homeViewModel.statuesViewModelAry[indexPath.row]
        let s = staues.status
        
        cell.textLabel?.text=s?.text
        
        
        return cell
        
    }

    
    
    
    
    
}
