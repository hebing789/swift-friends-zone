//
//  HBPictureInfor.swift
//  weibo
//
//  Created by hebing on 16/9/27.
//  Copyright © 2016年 hebing. All rights reserved.
//

import UIKit

class HBPictureInfor: NSObject {
    
    //缩略图
//    var thumbnail_pic: String?

    var thumbnail_pic: String? {
        didSet {
            //设置bmiddle
            //可以加载gif图片
            bmiddle_pic = thumbnail_pic?.replacingOccurrences(of: "/thumbnail/", with: "/bmiddle/")
            wap_pic = thumbnail_pic?.replacingOccurrences(of: "/thumbnail/", with: "/wap360/")
        
        }
    }
    
    
    var bmiddle_pic: String?
    
    var wap_pic: String?

}
