//
//  EditViewController.swift
//  WorkPlaning
//
//  Created by Y3Compiler on 15/9/8.
//  Copyright (c) 2015年 Y3 Compiler. All rights reserved.
//

import UIKit

class EditViewController: UIViewController,UITextViewDelegate {
    @IBOutlet weak var workTitle: UITextField!
    @IBOutlet weak var workDetail: UITextView!
    @IBAction func onSaveButtonClick(sender: AnyObject) {
        
        if WorkListManager.sharedInstance.currentWorkID.isEmpty {
            WorkListManager.sharedInstance.addWork(workTitle.text!, workContent: workDetail.text)

        } else {
            WorkListManager.sharedInstance.modifyWork(WorkListManager.sharedInstance.currentWorkID , workTitle: workTitle.text!, workContent: workDetail.text)
        }
        self.navigationController?.popViewControllerAnimated(true)

    }

    @IBAction func onTap(sender: AnyObject) {
        workDetail.resignFirstResponder()
        workTitle.resignFirstResponder()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        workDetail.delegate = self
        workDetail.layer.borderWidth = 1.0
        workDetail.layer.borderColor = UIColor.grayColor().CGColor
        workDetail.layer.cornerRadius = 3
    }
    
    override func viewDidAppear(animated: Bool) {
        if WorkListManager.sharedInstance.currentWorkID.isEmpty {
            self.workDetail.text = ""
            self.workTitle.text = ""
        }else{
            let tmp = WorkListManager.sharedInstance.getCurrentWork()
            self.workTitle.text = tmp.title
            self.workDetail.text = tmp.content
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
