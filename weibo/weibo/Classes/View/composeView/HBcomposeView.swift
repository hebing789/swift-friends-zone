//
//  HBcomposeView.swift
//  weibo
//
//  Created by hebing on 16/10/6.
//  Copyright © 2016年 hebing. All rights reserved.
//

import UIKit
import pop
class HBcomposeView: UIView {

    //        //懒加载可以不用考虑可选类型
    lazy var buttonArray = [HBComposeButton]()
    //使用属性记录参数
    var targetVC: UIViewController?

    //在内部指定大小
    //这个构造函数是指定的构造函数
    //init() 将消息转发给 init(frame:) 带的参数 是 CGRect.zero
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        //设置背景颜色
        self.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //展示微博类型选择视图
    func show(target: UIViewController?) {
        self.targetVC = target
        //将自己添加到targetVC的根视图上
        target?.view.addSubview(self)
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for value in buttonArray.reversed().enumerated() {
            startAnimation(btn: value.element, index: value.offset, isUp: false)
        }
        
//        //延迟执行
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
//            self.removeFromSuperview()
//        }
DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
    
    self.removeFromSuperview()
        }
        
    }
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        //完成每个按钮的弹出动画
        //1. 遍历所有的按钮
        for value in buttonArray.enumerated() {
            startAnimation(btn: value.element, index: value.offset)
        }
    }
    
    //执行动画
    private func startAnimation(btn: HBComposeButton, index: Int,isUp: Bool = true) {
        //实例化pop的弹簧的动画执行对象
        let anim = POPSpringAnimation(propertyNamed: kPOPViewCenter)
        //设置动画对象的基本属性
        anim?.springBounciness = 10
        anim?.springSpeed = 12
        //设置动画时间
        anim?.beginTime = CACurrentMediaTime() + Double(index) * 0.025
        //设置toValue 结构体 应该包装成 NSValue
        //直接设置程序会崩溃
        anim?.toValue = NSValue.init(cgPoint: CGPoint(x: btn.center.x, y: btn.center.y + (isUp == true ? -350 : 350)))
        //添加到按钮上
        btn.pop_add(anim, forKey: nil)
      
        
    }
    
//    //设置UI界面
    private func setupUI() {
        //1.截取当前屏幕
        
        //将图片设置成背景视图
        let backImgView = UIImageView(image: UIImage.snapShotCurrentPhoto().applyLightEffect())
        
//        let toolBar = UIToolbar(frame: UIScreen.main.bounds)
//        toolBar.barStyle = .black

        
        //将截取的图片视图添加到视图上
        self.addSubview(backImgView)
        
//        self.addSubview(toolBar)
        
        let slogan = UIImageView(image: #imageLiteral(resourceName: "compose_slogan"))
        self.addSubview(slogan)
        //设置约束
        slogan.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(100)
        }
        
        //添加微博类型的按钮
        addChildButtons()
    }
    
    private func addChildButtons() {
        
//        let btnW: CGFloat = 80
//        let btnH: CGFloat = 110
        let margin = (ScreenWidth - 3 * composeBtnW) / (3 + 1)
        for i in 0..<6 {
            let btn = HBComposeButton()
            btn.setTitle("位置", for: .normal)
            btn.setImage(#imageLiteral(resourceName: "tabbar_compose_lbs"), for: .normal)
//            btn.backgroundColor = UIColor.red
            //自适应大小
            //btn.sizeToFit()
            //计算X 和Y
            //获取 行 和 列
            let colIndex = i % 3
            let rowIndex = i / 3
            let btnX = margin + (margin + composeBtnW) * CGFloat(colIndex)
            let btnY = (margin + composeBtnH) * CGFloat(rowIndex) + ScreenHeight
            btn.frame = CGRect(x: btnX, y: btnY, width: composeBtnW, height: composeBtnH)
            self.addSubview(btn)
            //添加点击事件
            btn.addTarget(self, action: #selector(composeTypeBtnDidClick(btn:)), for: .touchUpInside)
            
            self.buttonArray.append(btn)
        }
    }

    
    //按钮的监听事件
    @objc private func composeTypeBtnDidClick(btn: HBComposeButton) {
        //1. 对点击的按钮执行放大的操作
        //2. 对没有被点击的其他按钮执行缩小的操作
        UIView.animate(withDuration: 0.5, animations: {
            //遍历按钮数组 用参数btn 和 按钮数组中的每一个元素比较 如果相等就是被点击的按钮 否则就是其他按钮
            for composeBtn in self.buttonArray {
                composeBtn.alpha = 0.1
                if composeBtn == btn {
                    //执行放大
                    composeBtn.transform = CGAffineTransform.init(scaleX: 2, y: 2)
                } else {
                    //执行缩小
                    composeBtn.transform = CGAffineTransform.init(scaleX:0.1, y: 0.1)
                }
                
            }
        }) { (_) in
            //跳转页面 如果交给服务器配置 就只能够获取到控制器的名称的字符串
            //1. 从数据中解析需要跳转的控制器的类名(字符串)
            let productName = Bundle.main.infoDictionary!["CFBundleName"] as! String
            let className = productName + "." + "HBComposeViewController"
            //2. 根据字符串获取类型
            // as! 表示一定要根据字符串获取到对象的类型  如果没有获取到程序就崩溃
            // UIViewController.Type 获取类型
            let type = NSClassFromString(className) as! UIViewController.Type
            //3. 根据类型 实例化对象  init()需要手动敲
            let vc = type.init()
            let nav = UINavigationController(rootViewController: vc)
            //4. 跳转到目标控制器
            //可以通过根视图控制器的方式来进行页面跳转
            self.targetVC?.present(nav, animated: true, completion: {
                //2. 页面跳转结束之后应该移除当前视图
                self.removeFromSuperview()
            })
        }
    }

    


    

}
