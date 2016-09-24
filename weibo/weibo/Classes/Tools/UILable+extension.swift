//
//  UILable+extension.swift
//  weibo
//
//  Created by hebing on 16/9/24.
//  Copyright © 2016年 hebing. All rights reserved.
//

import UIKit
extension UILabel{
    
    convenience init(title:String,textColor:UIColor,titleFont:CGFloat){
        
        self.init()
        
        text=title
        self.textColor=textColor
        self.font=UIFont.systemFont(ofSize: titleFont)
        self.sizeToFit()
        
        
        
        
        
    }
    
    
}
