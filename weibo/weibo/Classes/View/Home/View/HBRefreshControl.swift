//
//  HBRefreshControl.swift
//  weibo
//
//  Created by hebing on 16/9/30.
//  Copyright © 2016年 hebing. All rights reserved.
//

import UIKit
//private let refreshHeight: CGFloat = 50
private let refreshHeight: CGFloat = 44

//枚举表示刷新的三种状态
enum RefreshStatue: Int {
    case Normal = 0     //默认状态
    case Pulling        //准备刷新状态
    case Refreshing     //正在刷新状态
}


class HBRefreshControl: UIControl {
    
    var refreshStatue: RefreshStatue = .Normal {
        didSet {
            switch refreshStatue {
            case .Normal:
                //更新UI界面
                arrowIcon.isHidden = false
                tipLabel.text = "下拉起飞"
                indicator.stopAnimating()
                //刷新结束之后调整contentInset.top 判断如果上一次的刷新状态是 Refreshing状态 才减去高度
                //让悬停效果复位
                if oldValue == .Refreshing {
                    UIView.animate(withDuration: 0.5, animations: {
                        self.scrollView!.contentInset.top = self.scrollView!.contentInset.top - refreshHeight
                    })
                }
                
                //在动画闭包中执行箭头的转动
                UIView.animate(withDuration: 0.25, animations: {
                    //修改箭头的transform
                    self.arrowIcon.transform = CGAffineTransform.identity
                })
            case .Pulling:
                arrowIcon.isHidden = false
                tipLabel.text = "松手起飞"
                indicator.stopAnimating()
                //在动画闭包中执行箭头的转动
                UIView.animate(withDuration: 0.25, animations: {
                    //修改箭头的transform
                    self.arrowIcon.transform = CGAffineTransform.init(rotationAngle: CGFloat(M_PI))
                })
            case .Refreshing:
                tipLabel.text = "高宇飞"
                //隐藏箭头
                arrowIcon.isHidden = true
                //开始小菊花的动画
                indicator.startAnimating()
                //刷新的时候修改scrollView的contentInset//悬停效果
                scrollView!.contentInset.top = scrollView!.contentInset.top + refreshHeight
                //能够让刷新控件能够发出 valueChanged类型的事件是不是就可以调用到loadData
                //让HMRefreshControl能够主动发出 valueChanged的事件
                self.sendActions(for: .valueChanged)
            }
        }
    }

    //所有构造函数最终都会调用到指定的构造函数
    override init(frame: CGRect) {
        let rect = CGRect(x: 0, y: -refreshHeight, width: ScreenWidth, height: refreshHeight)
        super.init(frame: rect)
//        self.backgroundColor = randomColor()
        self.backgroundColor = UIColor.blue
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(tipLabel)
        addSubview(indicator)
        addSubview(arrowIcon)
        
        //设置约束
        tipLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self).offset(10)
            make.centerY.equalTo(self)
        }
        
        //不动画的时候是隐藏
        indicator.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(tipLabel.snp.left).offset(-5)
        }
        
        arrowIcon.snp.makeConstraints { (make) in
            make.center.equalTo(indicator)
        }
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        //1. 滚动的视图的contentOffset.y
        let offsetY = scrollView?.contentOffset.y ?? 0
        //2. 确定临界值 -114 -(64 + 50)
        //比较这两个值
        let targetY: CGFloat = -(scrollView!.contentInset.top + refreshHeight)
        if scrollView!.isDragging {
            //正在拽动,因为targerY是负数,所以是小于符号
            if  refreshStatue == .Normal && offsetY < targetY {
                //小于 处于准备刷新状态
                refreshStatue = .Pulling
            } else if refreshStatue == .Pulling && offsetY > targetY {
                //大于 默认状态
                refreshStatue = .Normal
            }
        } else {
            //如果是准备刷新状态 并且用户已经松手 就应该是 正在刷新状态
            if refreshStatue == .Pulling {
                refreshStatue = .Refreshing
            }
        }
        
        
    }
    
    //该方法是UIView的方法
    //当该视图将要移动到新的父视图上的时候 系统会自动调用该方法
    //刷新控件只能够给UIScrollView及其子类添加才有意义
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if let fatherView = newSuperview as? UIScrollView {
            //如果父视图是滚动视图  就监听contentOffset
            self.scrollView = fatherView
            fatherView.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
        }
    }
    
    
    private var scrollView: UIScrollView?

    
    //懒加载子控件
    //箭头控件
    private lazy var arrowIcon: UIImageView = UIImageView(image: #imageLiteral(resourceName: "tableview_pull_refresh"))
    //提示文字
    private lazy var tipLabel: UILabel = UILabel(title: "下拉刷新",textColor: UIColor.orange,titleFont: 14)
    //菊花按钮
    private lazy var indicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
    
    deinit {
        self.scrollView?.removeObserver(self, forKeyPath: "contentOffset")
    }
    //定义一个动画结束的方法
    func stopAnimation() {
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
//            self.refreshStatue = .Normal
//        })
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5) { 
            self.refreshStatue = .Normal
        }
    }

    
}
