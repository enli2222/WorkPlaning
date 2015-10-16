//
//  WorkListManager.swift
//  WorkPlaning
//
//  Created by Y3Compiler on 15/9/9.
//  Copyright (c) 2015年 Y3 Compiler. All rights reserved.
//

import Foundation
import CoreSpotlight

class WorkDetail {
    var id:String
    var title: String
    var content: String
    init(workId: String,workTitle: String,workContent: String){
        id = workId
        title = workTitle
        content = workContent
    }
}

class WorkListManager {
    var currentWorkID: String
    var currentWorkList: [WorkDetail]
    var historyWorkList: [WorkDetail]
    
    init(){
        currentWorkID = ""
        currentWorkList = []
        historyWorkList = []
    }
    
    func initDb(){
        
    }
    
    class var sharedInstance: WorkListManager{
        struct Static {
            static let instance = WorkListManager()
        }
        return Static.instance
    }
    
    func getWork(workID: String) -> (id:String, title: String, content: String) {
        var tmpIndex = 0
        for tmp in currentWorkList {
            if tmp.id == workID {
                return (tmp.id,tmp.title,tmp.content)
            }
            tmpIndex++
        }
        return ("","","")
    }
    
    func getCurrentWork() -> (id:String, title: String, content: String) {
        return getWork(currentWorkID)
    }
    
    func completedWork(workID: String) {
        var tmpIndex = 0
        for tmp in currentWorkList {
            if tmp.id == workID {
                //todo 
                currentWorkList.removeAtIndex(tmpIndex)
                break
            }
            tmpIndex++
        }
    }
    
    func addWork(workTitle: String, workContent: String) -> String{
        let tmpid = NSUUID().UUIDString
        let tmpWork = WorkDetail(workId: tmpid,workTitle: workTitle,workContent: workContent)
        currentWorkList.append(tmpWork)
        return tmpid
    }
    
    func modifyWork(workID: String, workTitle: String , workContent: String) {
        for tmp in currentWorkList {
            if tmp.id == workID {
                tmp.title = workTitle
                tmp.content = workContent
                break
            }
        }
        
    }
    
    func delete(workID: String) {
        print(workID, terminator: "")
        var tmpIndex = 0
        for tmp in currentWorkList {
            if tmp.id == workID {
                currentWorkList.removeAtIndex(tmpIndex)
                break
            }
            tmpIndex++
        }
    }
    
    func queryCurrentWorkList() {
        

    }
    
    func queryHistoryWorklist() {
   
    }
    
    func loadData() {
        self.initDb()        
    }
  
    func uploadCurrentWorkList() -> (result: Bool,resultMsg: String) {
        var result = true
        var resultMsg = ""
        if #available(iOS 9.0, *) {
            var items: [CSSearchableItem] = []
            for tmp in currentWorkList {
                let attributeSet = CSSearchableItemAttributeSet(itemContentType: "views")
                attributeSet.title = tmp.title
                attributeSet.contentDescription = tmp.content
                //attributeSet.thumbnailData =
                let item = CSSearchableItem(uniqueIdentifier: tmp.id, domainIdentifier: nil, attributeSet: attributeSet)
                items.append(item)
            }
            if items.count > 0 {
                CSSearchableIndex.defaultSearchableIndex().indexSearchableItems(items, completionHandler: {(error) in
                    if error != nil
                    {
                        result = false
                        let tmpdomain = (error?.domain)!
                        let tmpcode = (error?.code)!
                        resultMsg = "\(tmpdomain) :  \(tmpcode)"
                    }
                })
            }
        
        }
        return (result,resultMsg)
    }
    func downloadCurrentWorkList() -> (result: Bool,resultMsg: String) {
        var result = true
        var resultMsg = ""
        if #available(iOS 9.0,*) {
            CSSearchableIndex.defaultSearchableIndex().deleteAllSearchableItemsWithCompletionHandler({(error) in
                if error != nil
                {
                    result = false
                    let tmpdomain = (error?.domain)!
                    let tmpcode = (error?.code)!
                    resultMsg = "\(tmpdomain) :  \(tmpcode)"
                }
            })
        }
        return (result,resultMsg)
    }
    
}
