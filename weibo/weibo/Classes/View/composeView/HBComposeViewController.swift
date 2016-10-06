//
//  HBComposeViewController.swift
//  weibo
//
//  Created by hebing on 16/10/6.
//  Copyright © 2016年 hebing. All rights reserved.
//

import UIKit
import SVProgressHUD
class HBComposeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置背景颜色
        self.view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        setNavBar()
        setTextView()
        setToolBar()
        registerNotification()
    }
    
    private func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(n:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    //键盘弹出或者收起的时候系统会发出响应的通知
    @objc private func keyboardWillChange(n: Notification) {
        print(n)
        //需要 UIKeyboardFrameEndUserInfoKey 这个key 对应的键盘运动结束之后的frame
        //自定中不能够直接存放结构体对象
        let endFrame = (n.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        //更新toolBar的底部约束
        let offSetY = -ScreenHeight + endFrame.origin.y
        toolBar.snp.updateConstraints { (make) in
            make.bottom.equalTo(offSetY)
        }
        //添加动画时间
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc internal func close() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc internal func sendBtnDidClick() {
        let urlString = "https://api.weibo.com/2/statuses/update.json"
        //在数组和字典中不能够直接添加隐式的可选类型
        let parameters = ["access_token" : HBAuthViewModel.sharedAuthViewModel.useModel?.access_token ?? "" ,
                          "status" : textView.text ?? ""]
        HBNetWorkTools.sharedTools.request(method: .POST, URLString: urlString, parameters: parameters) { (_, error) in
            if error != nil {
                SVProgressHUD.showError(withStatus: "发布微博失败,请检查网络")
                return
            }
            
            SVProgressHUD.showSuccess(withStatus: "发布微博成功,棒棒哒!")
        }
        
    }
    
    @objc private func statueTypeBtnDidClick(btn: UIButton) {
        
        switch btn.tag {
        case 0:
            print("发布图片")
        case 1:
            print("@某人")
        case 2:
            print("发布话题")
        case 3:
            print("发送表情")
        case 4:
            print("更多")
        default:
            print("瞎点")
        }
    }
    
    
    internal lazy var sendBtn: UIBarButtonItem = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 35))
        //设置文字
        btn.setTitle("发送", for: .normal)
        //设置背景图片
        btn.setBackgroundImage(#imageLiteral(resourceName: "common_button_orange"), for: .normal)
        btn.setBackgroundImage(#imageLiteral(resourceName: "common_button_orange_highlighted"), for: .highlighted)
        btn.setBackgroundImage(#imageLiteral(resourceName: "common_button_white_disable"), for: .disabled)
        btn.setTitleColor(UIColor.darkGray, for: .disabled)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.addTarget(self, action: #selector(sendBtnDidClick), for: .touchUpInside)
        //设置文字颜色
        let barButtonItem = UIBarButtonItem(customView: btn)
        barButtonItem.isEnabled = false
        return barButtonItem
    }()
    
    //懒加载textView
    internal lazy var textView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = randomColor()
        //tv.text = "听说下雨天音乐和辣条更配哟"
        tv.textColor = UIColor.darkGray
        tv.font = UIFont.systemFont(ofSize: 16)
        //设置代理
        tv.delegate = self
        //设置键盘隐藏的方式  早期的滚动视图中包含了文本输入框,需要隐藏键盘的时候可以在滚动视图的代理方法中实现取消第一响应者的方法
        //tv.keyboardDismissMode = .onDrag
        //开启垂直方向可以滚动
        tv.alwaysBounceVertical = true
        return tv
    }()
    
    //占位文本
    internal lazy var placeHolderLabel: UILabel = UILabel(title: "听说下雨天音乐和辣条更配哟", textColor: UIColor.lightGray, titleFont: 16)
    
    //底部工具条
    internal lazy var toolBar: UIToolbar = {
        let tool = UIToolbar()
        var items = [UIBarButtonItem]()
        //添加五个按钮
        let imageNames = ["compose_toolbar_picture",
                          "compose_mentionbutton_background",
                          "compose_trendbutton_background",
                          "compose_emoticonbutton_background",
                          "compose_add_background"]
        for value in imageNames.enumerated() {
            let btn = UIButton()
            btn.setImage(UIImage(named: value.element), for: .normal)
            btn.setImage(UIImage(named: value.element + "_highlighted"), for: .highlighted)
            //设置索引
            btn.tag = value.offset
            //添加点击事件
            btn.addTarget(self, action: #selector(statueTypeBtnDidClick(btn:)), for: .touchUpInside)
            btn.sizeToFit()
            let barItem = UIBarButtonItem(customView: btn)
            //添加到数组中
            items.append(barItem)
            
            //添加等宽弹簧
            let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
            items.append(space)
        }
        items.removeLast()
        tool.items = items
        return tool
    }()
    
    
    deinit {
        //移除监听对象
        NotificationCenter.default.removeObserver(self)
    }
}

extension HBComposeViewController: UITextViewDelegate {
    //文本输入框一旦产生变化就得到响应
    func textViewDidChange(_ textView: UITextView) {
        //1. 设置发送按钮的交互
        self.sendBtn.isEnabled = textView.hasText
        //2. 设置占位文本的隐藏状态
        self.placeHolderLabel.isHidden = textView.hasText
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        textView.resignFirstResponder()
    }
}


//MARK: 设置UI界面的相关方法
extension HBComposeViewController {
    
    internal func setToolBar() {
        self.view.addSubview(toolBar)
        //toolBar 有默认的高度
        toolBar.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view)
            make.height.equalTo(36)
        }
    }
    
    internal func setNavBar() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", tagert: self, actiong: #selector(close))

        //自定义titleView
        let titleLabel = UILabel(title: "", textColor: UIColor.darkGray, titleFont: 16)
        var titleText = "发布微博"
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        if let name = HBAuthViewModel.sharedAuthViewModel.useModel?.name {
            //不为空
            titleText = "发布微博\n\(name)"
            //通过富文本修改文字的字体和颜色
//            //1. 实例化一个可变的(才能够添加属性)属性文本
//            let strM = NSMutableAttributedString(string: titleText)
//            let range = (titleText as NSString).range(of: name)
//            //给可变的属性字符串添加属性
//            strM.addAttributes([NSFontAttributeName : UIFont.systemFont(ofSize: 13),NSForegroundColorAttributeName : UIColor.orange], range: range)
//            //设置属性字符串
//            titleLabel.attributedText = strM
            let strM = NSMutableAttributedString(string: titleText)
            let range = (titleText as NSString).range(of: name)
            
            strM.addAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 13),NSForegroundColorAttributeName:UIColor.orange], range: range)
            titleLabel.attributedText=strM
        
            
        } else {
            //为空  设置一个相同属性的文字即可
            titleLabel.text = titleText
        }
        
        titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel
        //设置发送微博按钮
        self.navigationItem.rightBarButtonItem = sendBtn
    }
    
    internal func setTextView() {
        //添加到视图上
        self.view.addSubview(textView)
        //设置约束
        textView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.view)
            make.height.equalTo(ScreenHeight / 3)
        }
        //添加到textView
        textView.addSubview(placeHolderLabel)
        placeHolderLabel.snp.makeConstraints { (make) in
            make.top.equalTo(textView).offset(8)
            make.left.equalTo(textView).offset(5)
        }
    }

}
