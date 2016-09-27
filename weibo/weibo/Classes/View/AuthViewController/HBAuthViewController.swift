//
//  HBAuthViewController.swift
//  weibo
//
//  Created by hebing on 16/9/25.
//  Copyright © 2016年 hebing. All rights reserved.
//

import UIKit

import SVProgressHUD
//访问控制
/*
 public(公有的) ,internal(无论在本类还是分类中都可以访问), fileprivate(只是在当前文件中私有), private(绝对的私有, 在分类中都无法访问)
 */

class HBAuthViewController: UIViewController {
    
    
    let webview  = UIWebView()
    
    
    override func loadView() {
        //解决webView没有数据的时候底部的黑条
        //isOpaque 不透明的

        webview.isOpaque=false
        webview.delegate=self
        view = webview
        view.backgroundColor=#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        setNavGationBar()
        loadAuthPage()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    func setNavGationBar() -> () {
        navigationItem.leftBarButtonItem=UIBarButtonItem(title: "关闭",  tagert: self, actiong: #selector(close))
        navigationItem.rightBarButtonItem=UIBarButtonItem(title: "自动填充测试",  tagert: self, actiong: #selector(fillAccount))
    }
    
    func close() -> () {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func fillAccount() -> () {
//        //webView执行js
//        let jsStr = "document.getElementById('userId').value = 'leiggee@126.com', document.getElementById('passwd').value = 'onoyomg' "
//        webView.stringByEvaluatingJavaScript(from: jsString)
//        let jsStr = "document.getElementById('userId').value = 'leiggee@126.com', document.getElementById('passwd').value = 'onoyomg' "
        
        let jsStr = "document.getElementById('userId').value = '18756089702', document.getElementById('passwd').value = 'hebing789' "
        webview.stringByEvaluatingJavaScript(from: jsStr)
        
//
        
        
    }
    func loadAuthPage() -> () {
        
        
//        let urlString = "https://api.weibo.com/oauth2/authorize?" + "client_id=" + client_id + "&redirect_uri=" + redirect_uri
//        let url = URL(string: urlString)
//        let req = URLRequest(url: url!)
//        //加载页面
//        webView.loadRequest(req)
//        //演示用的
//        //loadAccessToken()
        let urlString="https://api.weibo.com/oauth2/authorize?" + "client_id=" + client_id + "&redirect_uri=" + redirect_uri
        let url=URL(string: urlString)
        
        let urlRequest=URLRequest(url: url!)
        self.webview.loadRequest(urlRequest)

    }
    

}


extension HBAuthViewController: UIWebViewDelegate{
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        //开始加载页面
        //显示等待指示器
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        //加载完成
        //关闭等待指示器
        SVProgressHUD.dismiss()

        
    }
    
    
    //网页每次加载新的页面实际上都是重写发送了request 在该方法中就可以拦截该请求
    //该协议方法的返回值是bool类型 如果返回true 该空间可以正常使用否则就不能够正常
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
//        //截取重定向url中的code
//        //绝对路径 url对象的 Sting 形式
//        let urlStirng = request.url?.absoluteString ?? ""
//        
//        //如果urlStirng 中包含了 重定向地址 就认为授权成功 就可以开始 截取code
//        let flag = "code="
//        if urlStirng.contains(flag) {
//            //只完成截取code操作
//            //http://www.itheima.com/?code=71e33a0143d3ea89c189513cac17b594
//            
//            //获取url的参数部分
//            let query = request.url?.query ?? ""
//            let code = (query as NSString).substring(from: flag.characters.count)
//            
//            //利用code 请求token
//            //成功了之后需要加载itheima.com
//            //控制器关注请求的状态  成功还是失败
//            HMUserAccountViewModel.sharedAccountViewModel.loadAccessToken(code: code, finished: { (success) in
//                //如果失败
//                if !success {
//                    SVProgressHUD.showError(withStatus: "世界上最遥远的距离就是没有网络")
//                    return
//                }
//                //如果成功
//                print("登录获取用信息成功")
//            })
        //截取重定向url中的code
        //        //绝对路径 url对象的 Sting 形式

        let urlStr=request.url?.absoluteString ?? ""
        
        let flagStr = "code="
        
        if (urlStr.contains(flagStr)) {
            
            let query = request.url?.query ?? ""
            let code = (query as NSString).substring(from: flagStr.characters.count)
            
            print(code)
                       //利用code 请求token
            //            //成功了之后需要加载itheima.com
            //            //控制器关注请求的状态  成功还是失败
            HBAuthViewModel.sharedAuthViewModel.loadAcessToken(code: code, finish: { (success) in
                
                if !success{
                    
                    SVProgressHUD.showError(withStatus: "世界上最遥远的距离就是没有网络")
                    return
                }
                
                
                
                print("用户信息登录成功")
                //modal 一个欢迎页面的控制器控制器
                //不建议使用modal的方式切换视图控制器  而是应该切换根视图控制器
                //也不建议使用者者两种方式切换
                //下面的window后面一定要有?号
                //UIApplication.shared.delegate?.window?.rootViewController =
                //UIApplication.shared.keyWindow?.rootViewController
                //表示哪个对象发出的通知 一般用这个参数来传递参数
//
                NotificationCenter.default.post(name: NSNotification.Name(KchangeRootViewController), object: "Welcome")
                
                
            })

            return false
        }
        
        
  
        


        return true
}

}
