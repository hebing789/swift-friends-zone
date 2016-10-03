//
//  HBBaseVistorController.swift
//  weibo
//
//  Created by hebing on 16/9/24.
//  Copyright © 2016年 hebing. All rights reserved.
//

import UIKit
/*
 协议和代理的使用  完成了多继承
 1. 定义协议
 2. 遵守协议,指定代理
 3. 实现协议方法
 */

//多继承
//OC有多继承吗? 如果没有 通过什么来替代?  协议
//必选的协议方法 必须要实现 否则报错
class HBBaseVistorController: UITableViewController,HBVistorLoginViewDelegate {

    
    var useLogIn = HBAuthViewModel.sharedAuthViewModel.useLogin
//    var useLogIn = false
    
    lazy var VisetorLoginView:HBVistorLoginView = HBVistorLoginView()
    
    override func loadView() {
        
        if useLogIn {
            super.loadView()
        }else{
            
            
            self.view=VisetorLoginView
            VisetorLoginView.delegate=self
            
        }
        
    }
    
    func willlogin() {
       
        //使用push 还是 modal  人机交互 push 执行线性的操作就应该使用push 如果打断线性的操作就应该使用modal(模态)
        //实例化导航视图控制器
        let auth: HBAuthViewController = HBAuthViewController()
        let nav  = UINavigationController(rootViewController: auth)
        
        
        self.present(nav, animated: true, completion: nil)

        
    }
    
    func willRegist() {
        print("用户将要注册")
        print("~~~~~~~~~~~~~~~~~~~~~~")

    }
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
