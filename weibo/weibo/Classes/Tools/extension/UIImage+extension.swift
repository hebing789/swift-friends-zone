//
//  UIImage+extension.swift
//  weibo
//
//  Created by hebing on 16/10/6.
//  Copyright © 2016年 hebing. All rights reserved.
//

import UIKit

extension UIImage{
    
    class func snapShotCurrentPhoto()-> UIImage{
        
        let kwindow = UIApplication.shared.keyWindow!
        
        UIGraphicsBeginImageContextWithOptions(kwindow.bounds.size, false, UIScreen.main.scale)
        
        kwindow.drawHierarchy(in: kwindow.bounds, afterScreenUpdates: false)
        
        let img = UIGraphicsGetImageFromCurrentImageContext()
        
        
        UIGraphicsEndImageContext()
        
        return img!
        
    }
    
    
    
    
    
    
    
    
    
    
}
