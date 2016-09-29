//
//  HBStatusViewModel.swift
//  weibo
//
//  Created by hebing on 16/9/27.
//  Copyright © 2016年 hebing. All rights reserved.
//

import UIKit

class HBStatusViewModel: NSObject {
    

    
    //cell不能够直接显示显示的数据 都可以在viewmodel中处理
    
    //通过一个存储型的属性 给cell提供直接需要的数据
    var avatarImage: UIImage?
    var memberImage: UIImage?
    var iconURL: URL?
    
    //评论的文字
    var comment_text: String?
    //点赞的文字
    var ohYeahText: String?
    //转发的文字
    var repost_text: String?

    //处理底部工具条显示的文字
    //1. 如果有评论就是先品论了多少条
    //2. 没有就显示默认文字
    //3.如果评论的数量超过 12345条   --> 1.2万条
    /*
     工厂方法
     猪肉 + 淀粉 --> 火腿肠
     面向对象封装的一个非常重要的设计模式
     组合设计模式  -> 先拆再合   -> 模块化的封装要求非常
     */
    func dealToolBarText(count: Int, defaultText: String) -> String {
        if count == 0 {
            return defaultText
        }
        if count > 10000 {
            return "\(Double(count / 1000) / 10)万"
        }
        //不等于0
        //description 相当java toString方法
        return count.description
    }

    //根据是否是转发微博返回不同的配图视图的数据源
    //转发微博图片的数据加载和原微博图片加载的切换
    var pictureInfos: [HBPictureInfor]? {
        return status?.retweeted_status == nil ? status?.pic_urls : status?.retweeted_status?.pic_urls
    }
    



    
    var status: HBStatus? {
        didSet {
            dealAvatarImage()
            dealMemberImage()
            dealHeadURL()
            //底部工具条的字符串属性赋值
            comment_text = dealToolBarText(count: status?.comments_count ?? 0, defaultText: "评论")
            repost_text = dealToolBarText(count: status?.reposts_count ?? 0, defaultText: "转发")
            ohYeahText = dealToolBarText(count: status?.attitudes_count ?? 0, defaultText: "赞")

        }
    }
    
    //cell不能够直接显示显示的数据 都可以在viewmodel中处理
    
    private func dealAvatarImage() {
        let verified_type = status?.user?.verified_type ?? -1
        switch verified_type {
        case 0:
            avatarImage = #imageLiteral(resourceName: "avatar_vip")
        case 2,3,5:
            avatarImage = #imageLiteral(resourceName: "avatar_enterprise_vip")
        case 220:
            avatarImage = #imageLiteral(resourceName: "avatar_grassroot")
            
        default:
            avatarImage = nil
        }
    }
    
    //处理用户等级的图片
    func dealMemberImage() {
        //在if let/var 语句中赋值对象后面跟 ',' ','就可以直接使用前面赋值的对象
        if let mbrank = status?.user?.mbrank, mbrank > 0 && mbrank < 7 {
            let imageName = "common_icon_membership_level\(mbrank)"
            memberImage = UIImage(named: imageName)
        }
    }

    private func dealHeadURL() {
        let urlString = status?.user?.avatar_large ?? ""
        iconURL = URL(string: urlString)
    }



}
