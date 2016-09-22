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
            print("中间按钮被点击了",self)
        }
        
        self.setValue(tabbar, forKey: "tabBar")
        
        
        addChildViewControllers()
        
    }

   private func addChildViewController(vc:UIViewController,title:String,imgName:String) -> () {
        
    
        vc.tabBarItem.image=UIImage(named: imgName)?.withRenderingMode(.alwaysOriginal)
        vc.tabBarItem.selectedImage=UIImage(named: imgName+"_selected")?.withRenderingMode(.alwaysOriginal)
        vc.tabBarItem.title=title
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
        
        addChildViewController(vc: HBHomeController(), title: "首页", imgName: "tabbar_home")
        addChildViewController(vc: HBMessageController(), title: "消息", imgName: "tabbar_message_center")
        addChildViewController(vc: HBDiscoverController(), title: "发现", imgName: "tabbar_discover")
        addChildViewController(vc: HBMeController(), title: "我", imgName: "tabbar_profile")

        
        
        
        
        
    }

   
}
