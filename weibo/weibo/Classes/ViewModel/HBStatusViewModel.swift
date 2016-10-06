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
    


    //计算型属性
    var timeText: String? {
        let dateString = status?.created_at ?? ""
        //let dateString = "Thu Sep 29 10:26:58 +0800 2016"
        //Thu Sep 29 10:26:58 +0800 2016
        //1. 实例化日期格式对象
//        let dateFormater = DateFormatter()
        //2. 对象字符串设置格式符
        sharedDateFormater.dateFormat = "EEE MMM dd HH:mm:ss zzz yyyy"
        //2.1 设置日期本地化信息, 真机上面转换会失败
        //设置什么本地化信息是根据字符串中包含的信息来设置
        sharedDateFormater.locale = Locale(identifier: "en")
        //3. 需要将日期字符串转换 日期(Date)对象
        let creatDate = sharedDateFormater.date(from: dateString)
        //如果创建的日期转换不成工就直接return一个空串
        guard let sinaDate = creatDate else {
            return ""
        }
        
        //日历对象 提供了非常丰富的日期判断方法
        let calendar = Calendar.current
        //判断日期
        if isDateInThisYear(targetDate: sinaDate) {
            if calendar.isDateInToday(sinaDate) {
                //创建当前日期对象
                let date = Date()
                let detla =  date.timeIntervalSince(sinaDate)
                if detla < 60 {
                    return "刚刚"
                } else if detla < 3600 {
                    //分钟前  去掉小数部分
                    return "\(Int(detla) / 60)分钟前"
                } else {
                    //小时前
                    return "\(Int(detla) / 3600)小时前"
                }
            } else if calendar.isDateInYesterday(sinaDate) {
                //昨天
                sharedDateFormater.dateFormat = "昨天 HH:mm"
                return sharedDateFormater.string(from: sinaDate)
            } else {
                //几年内的其他时间
                sharedDateFormater.dateFormat = "MM-dd"
                return sharedDateFormater.string(from: sinaDate)
            }
        } else {
            //非今年
            sharedDateFormater.dateFormat = "yyyy-MM-dd"
            return sharedDateFormater.string(from: sinaDate)
        }
    }
    
    
    var sourceText: String?


    
    var status: HBStatus? {
        didSet {
            dealAvatarImage()
            dealMemberImage()
            dealHeadURL()
            //底部工具条的字符串属性赋值
            comment_text = dealToolBarText(count: status?.comments_count ?? 0, defaultText: "评论")
            repost_text = dealToolBarText(count: status?.reposts_count ?? 0, defaultText: "转发")
            ohYeahText = dealToolBarText(count: status?.attitudes_count ?? 0, defaultText: "赞")

            //已经修改为了计算型属性来设置值
            //timeText = dealTime()

            //给来源属性赋值
            sourceText = dealSource()
        }
    }
    
    //处理微博来源
    private func dealSource() -> String {
        // <a href=\"http://app.weibo.com/t/feed/3jskmg\" rel=\"nofollow\">iPhone 6s</a>
        let str = status?.source ?? ""
        //定义开始标记
        let startFlag = "\">"
        //定义结束标记
        let endFlag = "</a>"
        //查找标记的所在的位置
        guard let startRangeIndex = str.range(of: startFlag),
            let endRangeIndex = str.range(of: endFlag) else {
                return "来自火星"
        }
        //获取拼接的范围
        //upperBound 从范围的后面开始
        let startIndex = startRangeIndex.upperBound
        //lowerBound 从范围的前面开始
        let endIndex = endRangeIndex.lowerBound
        
        let rangeIndex = startIndex..<endIndex
        let subStr = str.substring(with: rangeIndex)
        
        return subStr
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

    /*
     今年:
     今天:
     - 60s之内   --> 刚刚
     - 一小时之内  --> xx分钟前
     - 其他: 多少小时前
     昨天:
     - 昨天 HH:mm
     其他:
     - MM-dd
     
     非当年:
     - yyyy-MM-dd
     */
    /*
     private func dealTime() -> String {
     let dateString = status?.created_at ?? ""
     //let dateString = "Thu Sep 29 10:26:58 +0800 2016"
     //Thu Sep 29 10:26:58 +0800 2016
     //1. 实例化日期格式对象
     let dateFormater = DateFormatter()
     //2. 对象字符串设置格式符
     dateFormater.dateFormat = "EEE MMM dd HH:mm:ss zzz yyyy"
     //2.1 设置日期本地化信息, 真机上面转换会失败
     //设置什么本地化信息是根据字符串中包含的信息来设置
     dateFormater.locale = Locale(identifier: "en")
     //3. 需要将日期字符串转换 日期(Date)对象
     let creatDate = dateFormater.date(from: dateString)
     //如果创建的日期转换不成工就直接return一个空串
     guard let sinaDate = creatDate else {
     return ""
     }
     
     //日历对象 提供了非常丰富的日期判断方法
     let calendar = Calendar.current
     //判断日期
     if isDateInThisYear(targetDate: sinaDate) {
     if calendar.isDateInToday(sinaDate) {
     //创建当前日期对象
     let date = Date()
     let detla =  date.timeIntervalSince(sinaDate)
     if detla < 60 {
     return "刚刚"
     } else if detla < 3600 {
     //分钟前  去掉小数部分
     return "\(Int(detla) / 60)分钟前"
     } else {
     //小时前
     return "\(Int(detla) / 3600)小时前"
     }
     } else if calendar.isDateInYesterday(sinaDate) {
     //昨天
     dateFormater.dateFormat = "昨天 HH:mm"
     return dateFormater.string(from: sinaDate)
     } else {
     //几年内的其他时间
     dateFormater.dateFormat = "MM-dd"
     return dateFormater.string(from: sinaDate)
     }
     } else {
     //非今年
     dateFormater.dateFormat = "yyyy-MM-dd"
     return dateFormater.string(from: sinaDate)
     }
     }
     */
    
    private func isDateInThisYear(targetDate: Date) -> Bool {
//        let dateFormater = DateFormatter()
        //2. 对象字符串设置格式符
//        dateFormater.dateFormat = "EEE MMM dd HH:mm:ss zzz yyyy"
        //2.1 设置日期本地化信息, 真机上面转换会失败
        //设置什么本地化信息是根据字符串中包含的信息来设置
        sharedDateFormater.locale = Locale(identifier: "en")
        //3. 需要将日期字符串转换 日期(Date)对象
        
        let currentDate = Date()
        //重新设置日期格式符
        sharedDateFormater.dateFormat = "yyyy"
        //如果创建的日期转换不成工就直接return一个空串
        //获取创建的年份
        let creatYear = sharedDateFormater.string(from: targetDate)
        //获取当前的年份
        let currentYear = sharedDateFormater.string(from: currentDate)
        //返回比较的结果
        return currentYear == creatYear
    }
    
    



}
