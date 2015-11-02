//
//  FirstViewController.swift
//  WorkPlaning
//
//  Created by Y3Compiler on 15/9/8.
//  Copyright (c) 2015年 Y3 Compiler. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var workList: UITableView!
    var editViewController: EditViewController? = nil
    var navi: UINavigationController? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        workList.delegate = self
        workList.dataSource = self
        workList.tableFooterView = UIView()
        navi = self.navigationController
        editViewController = self.storyboard?.instantiateViewControllerWithIdentifier("EditViewController") as? EditViewController
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        workList.reloadData()
    }
    
    @IBAction func onAddButtonClick(sender: AnyObject) {
        WorkListManager.sharedInstance.currentWorkID = 0
        self.navigationController?.pushViewController(editViewController!, animated: true)
//        self.presentViewController(editViewController!, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    //新增快捷键
    func addShortcutItem(workTitle: String, workID: Int){
        if #available(iOS 9.0, *) {
            if let items = UIApplication.sharedApplication().shortcutItems {
                let icon = UIApplicationShortcutIcon(type: .Share)
                let item = UIApplicationShortcutItem(type: "work\(workID)", localizedTitle: workTitle, localizedSubtitle: "", icon: icon, userInfo: ["id":workID])
                var updateItems = items
                if updateItems.count > 0 {
                    updateItems[0] = item
                }else{
                    updateItems.append(item)
                }
                //动态和静态shortcut一起用会造成不覆盖
                UIApplication.sharedApplication().shortcutItems = updateItems
                //UIApplication.sharedApplication().shortcutItems = items
                workList.reloadData()
            }
        } else {
            // Fallback on earlier versions
        }

        
        
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let editButton = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "编辑", handler: {(sender,indexPath)->Void in
                WorkListManager.sharedInstance.currentWorkID =
                    WorkListManager.sharedInstance.currentWorkList[indexPath.row]["work_id"]!.asInt()
                self.navi!.pushViewController(self.editViewController!, animated: true)
            })
        editButton.backgroundColor = UIColor.grayColor()
        func onCompletedButtonClick(sender:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void{
            WorkListManager.sharedInstance.completedWork(WorkListManager.sharedInstance.currentWorkList[indexPath.row]["work_id"]!.asInt())
            workList.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Right)
        }
        let completedButton = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "完成",handler:onCompletedButtonClick)
        
        func onDeleteButtonClick(sender:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void{
        WorkListManager.sharedInstance.delete(WorkListManager.sharedInstance.currentWorkList[indexPath.row]["work_id"]!.asInt())
            workList.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)

        }
        
        func onAddShortcutItem(sender: UITableViewRowAction!, indexPath: NSIndexPath! ) -> Void{
            let title = WorkListManager.sharedInstance.currentWorkList[indexPath.row]["work_title"]!.asString()
            let id = WorkListManager.sharedInstance.currentWorkList[indexPath.row]["work_id"]!.asInt()
            self.addShortcutItem(title, workID: id)
            
        }
        let addShortcutItemButton = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "菜单", handler: onAddShortcutItem)
        addShortcutItemButton.backgroundColor = UIColor.greenColor()
        
        //completedButton.backgroundColor = UIColor.grayColor()
        let deleteButton = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "删除", handler: onDeleteButtonClick)
        deleteButton.backgroundColor = UIColor.grayColor()
        
        return [deleteButton,editButton,addShortcutItemButton,completedButton]
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return WorkListManager.sharedInstance.currentWorkList.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tmpIdentifier = "WorkListCell";
        let cell:WorkTableViewCell? = tableView.dequeueReusableCellWithIdentifier(tmpIdentifier) as? WorkTableViewCell
//        if cell == nil {
//            cell = WorkTableViewCell();
////          cell = UITableViewCell(style: UITableViewCellStyle.Value1							, reuseIdentifier: tmpIdentifier)
//        }
        if indexPath.row < WorkListManager.sharedInstance.currentWorkList.count {
            cell!.titleLabel.text = WorkListManager.sharedInstance.currentWorkList[indexPath.row]["work_title"]?.asString()
            cell!.workDatetimeLabel.text = WorkListManager.sharedInstance.currentWorkList[indexPath.row]["work_create_date"]?.asString()
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        WorkListManager.sharedInstance.currentWorkID =
            WorkListManager.sharedInstance.currentWorkList[indexPath.row]["work_id"]!.asInt()
        self.navi!.pushViewController(self.editViewController!, animated: true)
    }
}

