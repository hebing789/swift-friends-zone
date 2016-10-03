//
//  AppDelegate.swift
//  weibo
//
//  Created by hebing on 16/9/22.
//  Copyright © 2016年 hebing. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
       window=UIWindow(frame: UIScreen.main.bounds)
//        let mainTabContrller = HBTabBarController()
//        可以对比着2中区别
//        let nav = UINavigationController(rootViewController: mainTabContrller)
        
        window?.backgroundColor=UIColor.white
//        window?.rootViewController=mainTabContrller
//        window?.rootViewController=HBWelcomeController()
        window?.rootViewController =
            HBAuthViewModel.sharedAuthViewModel.useLogin ?
                HBWelcomeController():HBTabBarController()
        registNotifcation()
        window?.makeKeyAndVisible()
        
        
        
        
        return true
    }
    //希望将根视图控制器的切换全部放在 AppDelegate  可以使用通知来完成 这种一对多的逻辑操作
    //实际开发中不不建议大量使用通知
    //1. 注册某通知 添加观察者
    //2. 实现通知监听方法
    //3. 在需要的地方发出通知
    //4. 移除通知
    
    //注册通知
    private func registNotifcation(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(setRootViewController(n:)), name: NSNotification.Name(rawValue: KchangeRootViewController), object: nil)
        
    }
    
    func setRootViewController(n:NSNotification) -> () {
        
        if n.object == nil {
            //设置根视图控制器
            //tabbarVC
            window?.rootViewController = HBTabBarController()
        } else {
            //欢迎页面
            window?.rootViewController = HBWelcomeController()
        }

        
        
        
    }
    
    //    //移除通知
    //    //此处写移除通知没有意义
    //    //代码格式 规定
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    

    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

