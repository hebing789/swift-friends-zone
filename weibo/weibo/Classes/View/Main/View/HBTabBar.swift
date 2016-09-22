//
//  HBTabBar.swift
//  weibo
//
//  Created by hebing on 16/9/22.
//  Copyright © 2016年 hebing. All rights reserved.
//

import UIKit

class HBTabBar: UITabBar {

    var centerClick: (()->())?
    
    lazy var centBut:UIButton={
        let but=UIButton()
        but.setImage(UIImage(named: "tabbar_compose_icon_add"), for: .normal)
        but.setImage(#imageLiteral(resourceName: "tabbar_compose_icon_add_highlighted"), for: .highlighted)
        but.setBackgroundImage(#imageLiteral(resourceName: "tabbar_compose_button"), for: .normal)
        but.setBackgroundImage(#imageLiteral(resourceName: "tabbar_compose_button_highlighted"), for: .highlighted)
        but.sizeToFit()
        but.addTarget(self, action: #selector(cententClickToChange), for: .touchUpInside)

        return but
        
    }()
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let width = self.bounds.width/5
        let hight = self.bounds.height
        var index = 0
        
        
        
        
        
        for subview in subviews{
            if subview .isKind(of: NSClassFromString("UITabBarButton")!)    {
                subview.frame=CGRect(x: CGFloat(index)*width, y: 0, width: width, height: hight)
                
                index += ( index == 1 ?2:1)
                
            }
            
        }
        
        centBut.bounds.size=CGSize(width: width, height: hight)
        centBut.center=CGPoint(x: self.center.x, y: hight*0.5)
        
        
        
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        addSubview(centBut)
        
            }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   @objc private func cententClickToChange() -> () {
        
        
        
        centerClick!()
    }
    
    
    
}
