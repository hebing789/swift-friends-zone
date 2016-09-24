//
//  HBVistorLoginView.swift
//  weibo
//
//  Created by hebing on 16/9/24.
//  Copyright © 2016年 hebing. All rights reserved.
//

import UIKit
import SnapKit

@objc protocol  HBVistorLoginViewDelegate: NSObjectProtocol{
    func willlogin() -> ()
    
    @objc optional  func willRegist()->()
}
class HBVistorLoginView: UIView {

    weak var delegate:HBVistorLoginViewDelegate?
    //对外提供外界设置信息的方法
    
    //第二个参数传uiImage更好,swift自带输入图片功能
    func updateInfor (tipText:String,imagName:String?=nil) -> () {
        tipLable.text=tipText
        if imagName==nil {
            startAnimation()
        }else{
            
            //不是首页
            circleVIew.image=UIImage(named: imagName!)
            iconView.isHidden=true
            backView.isHidden=true
            
        }
        
    }
    @objc private func loginBtnDidClick() {
        //使用代理对象调用 协议方法
        //判断代理对象是否为nil  是否响应该协议方法

        delegate?.willlogin()
    }
    
    @objc private func registerBtnDidClick() {
        //可选的协议方法 可以实现 也可以不实现
        //必选的协议方法 必须要实现

        delegate?.willRegist?()
    }
    


    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUI()
        self.backgroundColor=UIColor.init(colorLiteralRed: 237/255.0, green: 237/255.0, blue: 237/255.0, alpha: 1)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //圆圈动画
    private func startAnimation(){
        let animation=CABasicAnimation(keyPath: "transform.rotation")
        animation.toValue=M_PI*2
        animation.repeatCount=MAXFLOAT
        animation.duration=20
        animation.isRemovedOnCompletion=false
        //        // 添加到圈圈的图层上
        circleVIew.layer.add(animation, forKey: nil)
        
    }

    
    func setUI() -> () {
        
        addSubview(circleVIew)
        addSubview(backView)
        addSubview(iconView)
        addSubview(tipLable)
        addSubview(loginBtn)
        addSubview(registBtn)
        loginBtn.addTarget(self, action: #selector(loginBtnDidClick), for: .touchUpInside)
        registBtn.addTarget(self, action: #selector(registerBtnDidClick), for: .touchUpInside)
        
        circleVIew.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self).offset(-80)
//            make.center.equalTo(self)

        }
        
        iconView.snp.makeConstraints { (make) in
            make.center.equalTo(circleVIew)
        }
        
        backView.snp.makeConstraints { (make ) in
            
            make.center.equalTo(circleVIew)
        }
        
        tipLable.snp.makeConstraints { (make ) in
            
            make.top.equalTo(circleVIew.snp.bottom).offset(16)
            make.centerX.equalTo(self)
            make.width.equalTo(224)
        }
        loginBtn.snp.makeConstraints { (make ) in
            
            make.left.equalTo(tipLable)
            make.top.equalTo(tipLable.snp.bottom).offset(16)
            make.width.equalTo(100)
            
        }
        
        registBtn.snp.makeConstraints { (make ) in
            
            make.right.equalTo(tipLable)
            make.top.equalTo(tipLable.snp.bottom).offset(16)
            make.width.equalTo(100)

        }
    }
    //    //懒加载子视图
    //    //转动的圈圈
    private lazy var circleVIew:UIImageView = UIImageView(image: #imageLiteral(resourceName: "visitordiscover_feed_image_smallicon"))
    private lazy var iconView:UIImageView = UIImageView(image: #imageLiteral(resourceName: "visitordiscover_feed_image_house"))
    private lazy var backView:UIImageView=UIImageView(image: #imageLiteral(resourceName: "visitordiscover_feed_mask_smallicon"))
    private lazy var tipLable:UILabel={
       let L = UILabel(title: "关注一些人,看看有什么惊喜,关注一些人,看看有什么惊喜,关注一些人,看看有什么惊喜,", textColor: UIColor.darkGray, titleFont: 14)
        
        L.numberOfLines=0
        L.preferredMaxLayoutWidth=224
        L.textAlignment = .center
        
        return L
    }()
    
    private lazy var registBtn:UIButton={
        let b=UIButton(title: "注册", textColor: UIColor.orange, fontSize: 14)
        b.setBackgroundImage(#imageLiteral(resourceName: "common_button_white"), for: .normal)
        return b
    }()
    
    private lazy var loginBtn:UIButton={
        let b=UIButton(title: "登录", textColor: UIColor.darkGray, fontSize: 14)
        b.setBackgroundImage(#imageLiteral(resourceName: "common_button_white"), for: .normal)
        return b
    }()

    
}
