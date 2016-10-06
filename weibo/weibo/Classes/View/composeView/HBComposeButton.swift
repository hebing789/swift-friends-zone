//
//  HBComposeButton.swift
//  weibo
//
//  Created by hebing on 16/10/6.
//  Copyright © 2016年 hebing. All rights reserved.
//

import UIKit
let composeBtnH: CGFloat = 110
let composeBtnW: CGFloat = 80

class HBComposeButton: UIButton {

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //初始设置
        titleLabel?.font = UIFont.systemFont(ofSize: 15)
        titleLabel?.textAlignment = .center
        setTitleColor(UIColor.darkGray, for: .normal)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        
        
        return CGRect(x: 0, y: composeBtnW, width: composeBtnW, height: composeBtnH - composeBtnW)
    }
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        
        return CGRect(x: 0, y: 0, width: composeBtnW, height: composeBtnW)
        
    }
    

}
