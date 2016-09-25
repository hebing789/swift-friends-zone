//
//  UIButton+extension.swift
//  weibo
//
//  Created by hebing on 16/9/24.
//  Copyright © 2016年 hebing. All rights reserved.
//

import UIKit
extension UIButton{
    
    convenience init(title: String,textColor: UIColor,fontSize: CGFloat) {
        
        
        self.init()
        self.setTitle(title, for: .normal)
        self.setTitleColor(textColor, for: .normal)
        self.titleLabel?.font=UIFont.systemFont(ofSize: fontSize)
        self.sizeToFit()
        
        
        
        
        
    }

    
    
}
