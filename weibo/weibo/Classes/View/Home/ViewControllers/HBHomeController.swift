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
    
       let hbRefreshControl = HBRefreshControl()
    //实例化小菊花视图
    lazy var indiacitivitorView:UIActivityIndicatorView = {
        let indictor = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
//        indictor.stopAnimating()
        
        return indictor
        
    }()
    
    private lazy var tipLabel: UILabel = {
        let l = UILabel(title: "", textColor: UIColor.white, titleFont: 14)
        //设置背景颜色
        l.backgroundColor = UIColor.orange
        //设置对齐
        l.textAlignment = .center
        l.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 35)
        l.isHidden = true
        return l
    }()
    

//    lazy var indicatorView : UIActivityIndicatorView = {
//        let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
//        //测试转动 , 应该在加载更多数据的时候就开始转动
//        //什么时候执行静默加载
//        // indicator.startAnimating()
//        return indicator
//        
//    }()

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
        
        //设置tableView tableFooterView
        tableView.tableFooterView = indiacitivitorView
//        refreshControl=UIRefreshControl()
        
        //        //添加系统的刷新控件
        //        refreshControl = UIRefreshControl()
        //        //添加监听事件
        //        refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
        
        hbRefreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        self.view.addSubview(hbRefreshControl)

        //添加到导航视图控制器的view上
        self.tipLabel.frame.origin.y = navBarHeight - 35
        self.navigationController?.view.addSubview(tipLabel)
        //将tipLabel放到导航条的下面
        //更改数组的顺序
        self.navigationController?.view.insertSubview(tipLabel, belowSubview: self.navigationController!.navigationBar)

        
        refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
        loadData()
        //取消分割线,原来是有分割线的
        tableView.separatorStyle = .none
        
    }
    
    
    func loadData() -> () {
        homeViewModel.loadData(isPullup: self.indiacitivitorView.isAnimating) { (success,count) in
            
            if !success{
                SVProgressHUD.showError(withStatus: errorTip)
                return
            }
            
            
            //执行lable的动画效果
            if !self.indiacitivitorView.isAnimating {
                //没有转动就执行提示动画
                self.startTipLabelAnimation(count: count!)
            }

            //self.refreshControl?.endRefreshing()
//            self.hbRefreshControl.refreshStatue = .Normal
            //将结束动画封装成一个方法,让调用的意图更加清晰
            self.hbRefreshControl.stopAnimation()


//            self.refreshControl?.endRefreshing()
            self.indiacitivitorView.stopAnimating()
            self.tableView.reloadData()
            
        }
        

    }
    //提示刷新了多少条数据
    private func startTipLabelAnimation(count: Int) {
        
        //如果正在做动画就直接return
        if self.tipLabel.isHidden == false {
            return
        }
        //设置文字
        self.tipLabel.text = count == 0 ? "没有新微博数据" : "有\(count)条新微博数据"
        //执行动画效果
        //动画执行前 修改alpha
        self.tipLabel.isHidden = false
        //在动画之前先记录之前的y值
        let lastY = self.tipLabel.frame.origin.y
        UIView.animate(withDuration: 1, animations: {
            self.tipLabel.frame.origin.y = navBarHeight
        }) { (_) in
            //添加一个返回原位置的动画 需要延迟
            UIView.animate(withDuration: 1, delay: 1, options: [], animations: {
                self.tipLabel.frame.origin.y = lastY
                }, completion: { (_) in
                    self.tipLabel.isHidden = true
            })
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
//    //将要显示最后一个cell的时候就开始执行静默加载
//    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        //将要显示倒数第二行并且 小菊花没有有转动的时候 才开始加载更多数据
//        if indexPath.row == homeViewModel.viewmodelArray.count - 2 && indicatorView.isAnimating == false {
//            indicatorView.startAnimating()
//            print("开始执行静默加载数据")
//            print("~~~~~~~~~~~~~~~~~~~~~~")
//        }
//    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.homeViewModel.statuesViewModelAry.count - 2 && indiacitivitorView.isAnimating == false
    {
        indiacitivitorView.startAnimating()
        loadData()
        print("开始执行静默加载数据")
        
        }
        
    }

    
    
    
}
