//
//  Common.swift
//  weibo
//
//  Created by hebing on 16/9/25.
//  Copyright © 2016年 hebing. All rights reserved.
//

import UIKit
//定义的是全局的变量
//同一个命名空间中所有的文件默认共享 并且不是在class 内部 就是一个全局
//let client_id = "1017936454"
//let client_secret = "662966e686ecc64b7b750d7eb8e10554"
//let redirect_uri = "http://www.itheima.com"

///更换账号
let redirect_uri = "http://www.baidu.com"
let client_id = "4036390044"
let client_secret = "448937ddd868e8a924a88902216ded9f"

let KchangeRootViewController = "KchangeRootViewController"



let errorTip = "世界上最遥远的距离就是没有网络"

func randomColor() -> UIColor {
    
//    let h = CGFloat(arc4random()%256)/255.0
    
    let r = CGFloat(arc4random() % 256) / 255.0
    let g = CGFloat(arc4random() % 256) / 255.0
    let b = CGFloat(arc4random() % 256) / 255.0
    return UIColor(red: r, green: g, blue: b, alpha: 1)
}
//定义屏幕宽度和高度
let ScreenWidth = UIScreen.main.bounds.width
let ScreenHeight = UIScreen.main.bounds.height
