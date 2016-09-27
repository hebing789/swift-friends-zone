//
//  HBHomeCell.swift
//  weibo
//
//  Created by hebing on 16/9/27.
//  Copyright © 2016年 hebing. All rights reserved.
//

import UIKit

class HBHomeCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.backgroundColor=randomColor()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
