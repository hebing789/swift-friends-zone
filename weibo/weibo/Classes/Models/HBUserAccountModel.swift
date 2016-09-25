//
//  HBUserAccountModel.swift
//  weibo
//
//  Created by hebing on 16/9/25.
//  Copyright © 2016年 hebing. All rights reserved.
//

import UIKit

class HBUserAccountModel: NSObject {
    
    
    
    init( dict:[String:Any]) {
        super.init()
        self.setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    

}
