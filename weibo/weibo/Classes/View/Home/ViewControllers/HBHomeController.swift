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

private let originalCellId = "HBHomeControllercell"
private let retweetedCellId = "HBRetweetedCellid"



class HBHomeController: HBBaseVistorController {

    //懒加载数据源数组
//    lazy var statuses: [HBStatus] = [HBStatus]()
    
    lazy var homeViewModel :HBHomeViewModel=HBHomeViewModel()
    

    //这个方法只能在组头上加一个分割空间
//    
//    init(){
//         super.init(style: .grouped)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //如果没登录就拦截不要注册加载数据什么的
        if !useLogIn {
            
            VisetorLoginView.updateInfor(tipText: "关注一些人,快回到这里看看有什么惊喜")
            
            return
        }
       
        
        navigationItem.rightBarButtonItem=UIBarButtonItem(title:"", imagName: "navigationbar_pop", tagert: self, actiong:  #selector(push))
        //原创微博
        let nibOrginal = UINib(nibName:"HBHomeCell" , bundle: nil)
        self.tableView.register(nibOrginal, forCellReuseIdentifier: originalCellId)
        
        //转发微博
        let nibRetweeted = UINib(nibName:"HBRetweetedCell" , bundle: nil)
        self.tableView.register(nibRetweeted, forCellReuseIdentifier: retweetedCellId)
        
         tableView.rowHeight = 360.0
        
        //取消分割线,原来是有分割线的
        tableView.separatorStyle = .none
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
        
        
        let viewmodel = homeViewModel.statuesViewModelAry[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: getCellId(model: viewmodel), for: indexPath) as! HBHomeCell
        
//        let staues = homeViewModel.statuesViewModelAry[indexPath.row]
//        let s = staues.status
//        
//        cell.textLabel?.text=s?.text
        
        
                //视图的数据的绑定 依赖模型数据 但是不符合MVVM的设计思想
        //cell.textLabel?.text = viewmodel.status?.created_at
        cell.viewmodel = viewmodel
        return cell


        
    }
//    //返回cell的行高的代理方法
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//       let viewmodel = homeViewModel.statuesViewModelAry[indexPath.row]
//        //1.根据数据获取对应的cell
//        let cellId = getCellId(model: viewmodel)
//        //计算高度不能够通过从缓冲池获取cell的方式
//        //自己从nib中读取cell对象的方式 和可重用的cell没有任何关系
    //这种方式需要先得到行高

//        //let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! HMStatusCell
//        let cell = cellWithId(cellId: cellId)
//        let rowHeight = cell.rowHeight(viewmodel: viewmodel)
//        //2.返回cell的toolBar的最大y值
//        return rowHeight
//    }
//    
    private func cellWithId(cellId: String) -> HBHomeCell {
        let nibName = cellId == originalCellId ? "HBHomeCell" : "HBRetweetedCell"
        return UINib(nibName: nibName, bundle: nil).instantiate(withOwner: nil, options: nil).last as! HBHomeCell
    }
//
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //根据模型获取cellId.cellid确定nib的哪种cell,通过传数据重新布局获取行高
        let viewmodel = homeViewModel.statuesViewModelAry[indexPath.row]
                //1.根据数据获取对应的cell
                let cellId = getCellId(model: viewmodel)
        //这种方式需要先得到行高
        
        //        //let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! HMStatusCell
                //计算高度不能够通过从缓冲池获取cell的方式
        let  cell = cellWithId(cellId: cellId)
        
        let rowHight = cell.rowHeight(viewmodel: viewmodel)
        return rowHight
        
        
        
        
    }


    private func getCellId(model:HBStatusViewModel)->String{
        
        if model.status?.retweeted_status == nil {
            return originalCellId
        }
        
        return retweetedCellId
        
    }
    
    
    
    
}
