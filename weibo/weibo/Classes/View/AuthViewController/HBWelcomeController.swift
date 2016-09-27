//
//  HBWelcomeController.swift
//  weibo
//
//  Created by hebing on 16/9/25.
//  Copyright © 2016年 hebing. All rights reserved.
//

import UIKit
import SDWebImage
private let bottomMargin: CGFloat = 120
class HBWelcomeController: UIViewController {

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        //有bug,研究图片大小到底写在哪里好,为什么不生效
//        iconView.bounds.size=CGSize(width: 85, height: 85)
//        iconView.layer.bounds.size=CGSize(width: 85, height: 85)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor=UIColor.white
        self.setupUI()
        // Do any additional setup after loading the view.
    }

    //执行动画需要放在视图已经显示的生命周期方法
    override func viewDidAppear(_ animated: Bool) {
        
        statrAnimation()
        
    }
    
    func  statrAnimation() -> () {
        
//        //usingSpringWithDamping: 阻尼系数 0 ~ 1 值越小 越弹
//        //initialSpringVelocity: 加速度 值越大 加速度越快
//        //位移枚举 可以 使用  | 表示多个枚举值

        let offsetY = -(UIScreen.main.bounds.height - bottomMargin - 85)
        
        self.iconView.snp.updateConstraints { (make) in
            
            make.bottom.equalTo(self.view).offset(offsetY)
            
        }
        
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5, options: [], animations: {
            self.view.layoutIfNeeded()
            
            
            }) { (_) in
                UIView.animate(withDuration: 0.5, animations: {
                    
                    self.welcomeLabel.alpha=1
                    
                    }, completion: { (_) in
         
                        
                        //切换到tabContr控制器
                        NotificationCenter.default.post(name: NSNotification.Name(KchangeRootViewController), object: nil)
                        
                        
                        
                })
                
                
                
        }
        
        
        
        
    }
    
    
    //设置UI界面
    private func setupUI() {
        //添加子控件
        view.addSubview(iconView)
        view.addSubview(welcomeLabel)

        //设置约束
        iconView.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.snp.bottom).offset(-bottomMargin)
            make.centerX.equalTo(view)
//            make.width.equalTo(<#T##other: ConstraintRelatableTarget##ConstraintRelatableTarget#>)
            make.size.equalTo(CGSize(width: 85, height: 85))
        }
        
        welcomeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconView.snp.bottom).offset(20)
            make.centerX.equalTo(iconView)
        }
////        iconView.bounds.size=CGSize(width: 42.5, height: 42.5)
//        iconView.layer.bounds.size=CGSize(width: 42.5, height: 42.5)
        iconView.sd_setImage(with: HBAuthViewModel.sharedAuthViewModel.iconURL)
        
//        此方法不行
//        iconView.bounds.size=CGSize(width: 85, height: 85)
//        self.view.layoutIfNeeded()
    }
    
    //懒加载控件
    private lazy var iconView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "avatar_default_big"))
        //UIImageView 不是继承自 UIControl的
        iv.cornerRadius = 42.5
        //设置边线
       
        
        //这2种方式都没有效果
//        iv.bounds.size=CGSize(width: 42.5, height: 42.5)
        
//        iv.layer.bounds.size=CGSize(width: 10, height: 10)
       //设置边线颜色
//        iv.bounds.size=CGSize(width: 42.5, height: 42.5)
//        iv.contentMode = UIViewContentMode.scaleAspectFill
        iv.layer.borderWidth = 1
        iv.layer.borderColor=UIColor.orange.cgColor
        
        return iv
    }()
    
    private lazy var welcomeLabel: UILabel = {
        let l = UILabel(title: "欢迎归来", textColor: UIColor.darkGray, titleFont: 16)
        l.alpha=0
        return l
    }()
    
    
    


    
}
