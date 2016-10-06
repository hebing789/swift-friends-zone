//
//  HBTabBarController.swift
//  weibo
//
//  Created by hebing on 16/9/22.
//  Copyright © 2016年 hebing. All rights reserved.
//

import UIKit

class HBTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.view.backgroundColor=UIColor.yellow
        let tabbar = HBTabBar()
        tabbar.centerClick={
//            print("中间按钮被点击了",self)
            
            let composeView = HBcomposeView()
            
            composeView.show(target: self)
            
            //显示composeView
//            let window = UIApplication.shared.keyWindow
//            window?.addSubview(composeView)

        }
        
        self.setValue(tabbar, forKey: "tabBar")
        
        
        addChildViewControllers()
        
    }

    private func addChildViewController(vc:UIViewController,title:String,imgName:String,index:Int) -> () {
        
    
        vc.tabBarItem.image=UIImage(named: imgName)?.withRenderingMode(.alwaysOriginal)
        vc.tabBarItem.selectedImage=UIImage(named: imgName+"_selected")?.withRenderingMode(.alwaysOriginal)
        vc.tabBarItem.title=title
        vc.tabBarItem.tag=index
        vc.navigationItem.title=title
        vc.tabBarItem.setTitleTextAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 11)], for: .normal)
          vc.tabBarItem.setTitleTextAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 11),NSForegroundColorAttributeName:UIColor.orange], for: .selected)
//        home.tabBarItem.imageInsets=UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        //设置向上便宜
        vc.tabBarItem.titlePositionAdjustment=UIOffsetMake(0, -2)
        
        vc.tabBarItem.badgeValue=nil
        vc.tabBarItem.badgeColor=UIColor.purple
        
        let nav = HBBaseNavController(rootViewController: vc)
        
        addChildViewController(nav)
        
        
        
        
        
        
    }

   private func addChildViewControllers() -> () {
        
        addChildViewController(vc: HBHomeController(), title: "首页", imgName: "tabbar_home",index:0)
        addChildViewController(vc: HBMessageController(), title: "消息", imgName: "tabbar_message_center",index:1)
        addChildViewController(vc: HBDiscoverController(), title: "发现", imgName: "tabbar_discover",index:2)
        addChildViewController(vc: HBMeController(), title: "我", imgName: "tabbar_profile",index:3)

        
        
        
        
        
    }

//    //当用户点击了UITabBarButton就会触发该事件
//    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        //确定用户点击了哪个tabbaItem
//        print(item.tag)
//        //遍历子视图
//        var index = 0
//        for subview in tabBar.subviews {
//            if subview.isKind(of: NSClassFromString("UITabBarButton")!) {
//                //获取到UITabBarButton
//                if index == item.tag {
//                    //就已经查找到了被点击的UITabBarButton
//                    //遍历tabbarButton的子视图 判断类型是否是xxximageView
//                    for target in subview.subviews {
//                        if target.isKind(of: NSClassFromString("UITabBarSwappableImageView")!) {
//                            //做动画
//                            //修改transform
//                            target.transform = CGAffineTransform.init(scaleX: 0.4, y: 0.4)
//                            //在动画闭包中执行放大的操作
//                            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
//                                target.transform = CGAffineTransform.init(scaleX: 1, y: 1)
//                                }, completion: { (_) in
////                                    print("👌")
//                            })
//                        }
//                    }
//                }
//                index += 1
//            }
//        }
//    }

    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
      print(item.tag)
        var index = 0
       
        for target in tabBar.subviews{
            
            if target.isKind(of: NSClassFromString("UITabBarButton")!) {
                
                if item.tag == index {
                    
                    for subView in target.subviews{
                        
                        if subView.isKind(of:NSClassFromString("UITabBarSwappableImageView")!) {
                            
                            subView.transform = CGAffineTransform.init(scaleX: 0.4, y: 0.4)
                            
                            UIView.animate(withDuration: 0.6, animations: {
                                subView.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                            })
                            
                        }
                        
                        
                    }
                    
                    
                    
                }
                
                //只有是item才+1,里面还有文字什么的控件
                index += 1
            }
            
            
   
        }
        
        
        
        
    }
   
}
