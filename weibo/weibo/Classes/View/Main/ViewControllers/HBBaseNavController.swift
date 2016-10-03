//
//  HBBaseNavController.swift
//  weibo
//
//  Created by hebing on 16/9/22.
//  Copyright © 2016年 hebing. All rights reserved.
//

import UIKit

class HBBaseNavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
//        self.navigationBar.tintColor=UIColor.white
        //如果高斯模糊不开,第一页整体颜色基本一样,开着,后面比较模糊
        //默认开启
        self.navigationBar.isTranslucent=false

        
        
        
        
    }

 
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        let count=childViewControllers.count
        if count>0 {
            //第二层时,左边标题为返回,而且,影藏tabBar
            //
//            viewController.navigationItem.leftBarButtonItem=UIBarButtonItem(title: "返回", style: .done, target: self, action: #selector(back))
            viewController.navigationItem.leftBarButtonItem=UIBarButtonItem(title: "返回", imagName: "navigationbar_back_withtext", tagert: self, actiong: #selector(back))
            viewController.hidesBottomBarWhenPushed=true
        }
        super.pushViewController(viewController, animated: animated)
        
    }
    
    //按钮的监听事件
    @objc private func back() -> () {
        
        self.popViewController(animated: true)
    }
}
