//
//  UIBarButtonItem.swift
//  weibo
//
//  Created by hebing on 16/9/22.
//  Copyright © 2016年 hebing. All rights reserved.
//

import UIKit
extension UIBarButtonItem {
    convenience init(title:String="",imagName:String,tagert:Any?, actiong:Selector) {
        let button = UIButton()
        
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.setTitleColor(UIColor.orange, for: .highlighted)
        button.titleLabel?.font=UIFont.systemFont(ofSize: 14)
        button.setImage(UIImage(named: imagName), for: .normal)
        button.setImage(UIImage(named: imagName+"_highlighted"), for: .highlighted)
        button.sizeToFit()
        button.addTarget(tagert, action: actiong, for: .touchUpInside)
        self.init()
        self.customView=button
        
        
    }
    
}
