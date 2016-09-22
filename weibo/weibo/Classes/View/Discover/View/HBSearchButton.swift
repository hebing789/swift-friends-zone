//
//  HBSearchButton.swift
//  weibo
//
//  Created by hebing on 16/9/22.
//  Copyright © 2016年 hebing. All rights reserved.
//

import UIKit

@IBDesignable class HBSearchButton: UIButton {

    class func loadSearchView()->HBSearchButton{
        
        let nib = UINib.init(nibName: "SearchView", bundle: nil)
        
        let searchView=nib.instantiate(withOwner: nil
            , options: nil).last as! HBSearchButton
        return searchView
        
    }
    
    override func awakeFromNib() {
        
        self.imageEdgeInsets=UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
        self.titleEdgeInsets=UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        
        self.bounds.size=CGSize(width: UIScreen.main.bounds.width, height: 36)
        
        
    }
    
    
}
