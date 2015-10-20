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
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    

    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        var editButton = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "编辑", handler: {(sender,indexPath)->Void in
                WorkListManager.sharedInstance.currentWorkID =
                    WorkListManager.sharedInstance.currentWorkList[indexPath.row]["work_id"]!.asInt()
                self.navi!.pushViewController(self.editViewController!, animated: true)
            })
        editButton.backgroundColor = UIColor.grayColor()
        func onCompletedButtonClick(sender:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void{
            WorkListManager.sharedInstance.completedWork(WorkListManager.sharedInstance.currentWorkList[indexPath.row]["work_id"]!.asInt())
            workList.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Right)
        }
        var completedButton = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "完成",handler:onCompletedButtonClick)
        
        func onDeleteButtonClick(sender:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void{
        WorkListManager.sharedInstance.delete(WorkListManager.sharedInstance.currentWorkList[indexPath.row]["work_id"]!.asInt())
            workList.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)

        }
        //completedButton.backgroundColor = UIColor.grayColor()
        let deleteButton = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "删除", handler: onDeleteButtonClick)
        deleteButton.backgroundColor = UIColor.grayColor()
        return [deleteButton,editButton,completedButton]
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
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(tmpIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: tmpIdentifier)
        }
        if indexPath.row < WorkListManager.sharedInstance.currentWorkList.count {
            cell!.textLabel?.text = WorkListManager.sharedInstance.currentWorkList[indexPath.row]["work_title"]?.asString()
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        WorkListManager.sharedInstance.currentWorkID =
            WorkListManager.sharedInstance.currentWorkList[indexPath.row]["work_id"]!.asInt()
        self.navi!.pushViewController(self.editViewController!, animated: true)
    }
}

