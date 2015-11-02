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
    var id:Int
    var title: String
    var content: String
    init(workId: Int,workTitle: String,workContent: String){
        id = workId
        title = workTitle
        content = workContent
    }
}

class WorkListManager {
    var currentWorkID: Int
    var currentTab: Int
    var currentWorkList: [SQLRow]
    var HistoryWorkList: [SQLRow]
    var db: SQLiteDB
    init(){
        currentWorkID = 0
        currentTab = 0
        db = SQLiteDB.sharedInstance()
        currentWorkList = []
        HistoryWorkList = []
        self.initDb()
    }
    
    static let sharedInstance = WorkListManager()
    
    //    class var sharedInstance: WorkListManager{
    //        struct Static {
    //            static let instance = WorkListManager()
    //        }
    //        return Static.instance
    //    }
    
    func initDb(){
        if !db.tableExists("tb_worklist") {
            db.execute("CREATE TABLE 'tb_worklist' ('work_id' INTEGER PRIMARY KEY AUTOINCREMENT, 'work_title' TEXT NOT NULL, 'work_content' TEXT, 'work_status' INTEGER NOT NULL, 'work_relation' INTEGER, 'work_create_date' TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, 'work_completed_date' TIMESTAMP)")
        }
        
    }
    
    func getWork(workID: Int) -> (id:Int, title: String, content: String, createDate: String) {
        let sql = "select * from tb_worklist where work_id = @id"
        let result = db.query(sql, parameters: [workID])
        return ((result[0]["work_id"]?.asInt())!,(result[0]["work_title"]?.asString())!,(result[0]["work_content"]?.asString())!,(result[0]["work_create_date"]?.asString())!)
    }
    
    func getCurrentWork() -> (id:Int, title: String, content: String, createDate: String) {
        return getWork(currentWorkID)
    }
    
    func completedWork(workID: Int) {
        let sql = "update tb_worklist set work_status = 1, work_completed_date = datetime('now') where work_id =@id"
        db.execute(sql, parameters: [workID])
        loadData()
    }
    
    func addWork(workTitle: String, workContent: String) {
        db.execute("insert into tb_worklist(work_title,work_content,work_status)values(@title,@content,0)", parameters: [workTitle,workContent])
        loadData()
        
    }
    
    func modifyWork(workID: Int, workTitle: String , workContent: String) {
        //db.execute("update tb_worklist set work_title=@title,work_content = @content  where work_id =\(workID)", parameters: [workTitle,workContent])
        db.execute("UPDATE tb_worklist SET work_title=@titile,work_content = @content where work_id =@id", parameters: [workTitle,workContent,workID])
        loadData()
    }
    
    func delete(workID: Int) {
        let sql = "delete from tb_worklist where work_id =@id"
        db.execute(sql, parameters: [workID])
        loadData()
    }
    
//    func queryCurrentWorkListCount() -> Int{
//        let sql = "select count(1) as work_count from tb_worklist where work_status = 0"
//        let result = db.query(sql)
//        return (result[0]["work_count"]?.asInt())!
//        return currentWorkList.count
//    }
    
//    func queryHistoryWorkListCount() -> Int{
//        let sql = "select count(1) as work_count from tb_worklist"
//        let result = db.query(sql)
//        return (result[0]["work_count"]?.asInt())!
//        return HistoryWorkList.count
//    }
    
    func queryCurrentWorkList() -> [SQLRow] {
        let sql = "select rowid,* from tb_worklist where work_status = 0"
        return db.query(sql)
    }
    
    func queryHistoryWorklist() -> [SQLRow] {
        let sql = "select rowid,* from tb_worklist"
        return db.query(sql)
    }
    
    private func loadCurrentData() {
        currentWorkList = queryCurrentWorkList()
    }
    
    private func loadHistoryData() {
        HistoryWorkList = queryHistoryWorklist()
    }
    
    func loadData() {
        loadCurrentData()
        loadHistoryData()
    }
    

  
    func uploadCurrentWorkList() -> (result: Bool,resultMsg: String) {
        var result = true
        var resultMsg = ""
//        if #available(iOS 9.0, *) {
//            var items: [CSSearchableItem] = []
//            for tmp in currentWorkList {
//                let attributeSet = CSSearchableItemAttributeSet(itemContentType: "views")
//                attributeSet.title = tmp.title
//                attributeSet.contentDescription = tmp.content
//                //attributeSet.thumbnailData =
//                let item = CSSearchableItem(uniqueIdentifier: tmp.id, domainIdentifier: nil, attributeSet: attributeSet)
//                items.append(item)
//            }
//            if items.count > 0 {
//                CSSearchableIndex.defaultSearchableIndex().indexSearchableItems(items, completionHandler: {(error) in
//                    if error != nil
//                    {
//                        result = false
//                        let tmpdomain = (error?.domain)!
//                        let tmpcode = (error?.code)!
//                        resultMsg = "\(tmpdomain) :  \(tmpcode)"
//                    }
//                })
//            }
//        
//        }
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
