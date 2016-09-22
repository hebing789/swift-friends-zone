//
//  UIView+extension.swift
//  weibo
//
//  Created by hebing on 16/9/22.
//  Copyright © 2016年 hebing. All rights reserved.
//

import UIKit
extension UIView{
    //定义可视化属性
    //制度属性  没有存储值的功能
    //只读属性 和 有返回值的方法是一样的
    @IBInspectable var cornerRadius:CGFloat{
        
        set{
            layer.cornerRadius=newValue
            layer.masksToBounds=newValue>0
            
        }
        
        get{
            
            return layer.cornerRadius
            
        }
    }
    
    
    
}
