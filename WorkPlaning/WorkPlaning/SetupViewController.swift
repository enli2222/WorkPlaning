//
//  SetupViewController.swift
//  WorkPlaning
//
//  Created by Y3Compiler on 15/9/22.
//  Copyright © 2015年 Y3 Compiler. All rights reserved.
//

import UIKit


class SetupViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showMessage(title: String,Message: String){
        let alertView = UIAlertView()
        alertView.title = title
        alertView.message = Message
        alertView.addButtonWithTitle("确认")
        alertView.show()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if 0 == indexPath.section {
            //let cell = tableView.cellForRowAtIndexPath(indexPath)
            switch indexPath.row{
            case 0:
                let result = WorkListManager.sharedInstance.uploadCurrentWorkList()
                if result.result {
                    showMessage("确认", Message: "搜索内容添加成功！")
                }else{
                    showMessage("错误", Message: result.resultMsg)
                }
            case 1:
                let result = WorkListManager.sharedInstance.downloadCurrentWorkList()
                if result.result {
                    showMessage("确认", Message: "搜索内容删除成功！")
                }else{
                    showMessage("错误", Message: result.resultMsg)
                }
            default:
                return
                
            }
        }else if 1 == indexPath.section {
            self.performSegueWithIdentifier("pushListContent", sender: nil)

        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "pushListContent" {
            let vc = segue.destinationViewController as! ListConTentViewController
            vc.contentList = TF.printApp()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
