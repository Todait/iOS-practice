//
//  SynchronizeManager.swift
//  Todait
//
//  Created by CruzDiary on 2015. 8. 14..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import RealmSwift



public func makeCategoryBatchParams(name:String,color:String)->[String:AnyObject]{
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var params:[String:AnyObject] = [:]
    
    var sync:[String:AnyObject] = [:]
    sync["method"] = "get"
    sync["url"] = SYNCHRONIZE
    sync["params"] = ["sync_at":defaults.objectForKey("sync_at") ?? 0,"today_date":getTodayDateNumber()]
    sync["headers"] = getUserHeaderValue()
    
    
    var category:[String:AnyObject] = [:]
    category["method"] = "post"
    category["url"] = CREATE_CATEGORY
    category["params"] = ["category":["name":name,"color":color],"today_date":getTodayDateNumber()]
    category["headers"] = getBaseHeaderValue()
    
    
    
    params["ops"] = [sync,category]
    params["sequential"] = true
    
    
    return params
}

public func makeBatchParams(url:String,param:[String:AnyObject])->[String:AnyObject]{
    
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    
    var params:[String:AnyObject] = [:]
    
    var sync:[String:AnyObject] = [:]
    sync["method"] = "get"
    sync["url"] = SYNCHRONIZE
    sync["params"] = ["sync_at":defaults.objectForKey("sync_at") ?? 0,"today_date":getTodayDateNumber()]
    sync["headers"] = getUserHeaderValue()
    
    
    var request:[String:AnyObject] = [:]
    request["method"] = "post"
    request["url"] = url
    request["params"] = param
    request["headers"] = getBaseHeaderValue()
    
    
    params["ops"] = [sync,request]
    params["sequential"] = true
    
    
    return params
    
}

public func getBaseHeaderValue()->[String:AnyObject]{
    return ["Content-Type":"application/json","Accept" : "application/vnd.todait.v1+json"]
}

public func getUserHeaderValue()->[String:AnyObject]{
    
    let defaults = NSUserDefaults.standardUserDefaults()
    return ["Content-Type":"application/json","Accept" : "application/vnd.todait.v1+json","X-User-Email":defaults.objectForKey("email")!,"X-User-Token":defaults.objectForKey("token")!]
}


class RealmManager: NSObject {
   
    
    
    
    
    
    var realm = Realm()
    let sequence:[String] = ["categories","tasks","task_dates","weeks","days","diarys","amount_ranges","time_histories","review_days","daily_total_results","preference","check_logs","amount_logs","time_logs","sync_at"]
    
    //let info:[String:RealmObject] = ["categorys":Category,"tasks":Task,"task_dates":TaskDate,"days":Day,"weeks":Week,"diarys":Diary,"amount_ranges":AmountRange,"time_histories":TimeHistory,"review_days":ReviewDay,"daily_total_results":DailyTotalResult,"preference":Preference,"check_logs":CheckLog,"amount_logs":AmountLog,"time_logs":TimeLog]
    
    
    class var sharedInstance: RealmManager {
        
        struct Realm {
            static var onceToken: dispatch_once_t = 0
            static var instance: RealmManager? = nil
            
        }
        
        dispatch_once(&Realm.onceToken) {
            Realm.instance = RealmManager()
        }
        
        return Realm.instance!
    }
    
    
    
    
    func synchronize(jsons:JSON){
        
        ProgressManager.show()
        
        for var index = 0 ; index < sequence.count ; index++ {
            
            let key = sequence[index]
            let json = jsons[key]
            
            if key == "sync_at"{
                NSUserDefaults.standardUserDefaults().setObject(json.stringValue, forKey: "sync_at")
            }
            
            if json.count > 0 {
                
                switch key {
                case "categories": synchronizeCategorys(json)
                case "tasks": synchronizeTask(json)
                case "task_dates": synchronizeTaskDate(json)
                case "weeks": synchronizeWeek(json)
                case "days": synchronizeDay(json)
                case "diarys": synchronizeDiary(json)
                case "amount_ranges": synchronizeAmountRange(json)
                case "review_days": synchronizeReviewDay(json)
                case "daily_total_results": synchronizeDailyTotalResult(json)
                case "preference": synchronizePreference(json)
                case "check_logs": synchronizeCheckLog(json)
                case "amount_logs": synchronizeAmountLog(json)
                case "time_logs": synchronizeTimeLog(json)
                default: return
                    
                }
                
                /*
                switch key {
                    case "categorys": Category.synchronizeModel(json, realm: realm)
                    case "tasks": Task.synchronizeModel(json, realm: realm)
                    case "task_dates": TaskDate.synchronizeModel(json, realm: realm)
                    case "weeks": Week.synchronizeModel(json, realm: realm)
                    case "days": Day.synchronizeModel(json, realm: realm)
                    case "diarys": Diary.synchronizeModel(json, realm: realm)
                    case "amount_ranges": AmountRange.synchronizeModel(json, realm: realm)
                    case "review_days": ReviewDay.synchronizeModel(json, realm: realm)
                    case "daily_total_results": DailyTotalResult.synchronizeModel(json, realm: realm)
                    case "preference": Preference.synchronizeModel(json, realm: realm)
                    case "check_logs": CheckLog.synchronizeModel(json, realm: realm)
                    case "amount_logs": AmountLog.synchronizeModel(json, realm: realm)
                    case "time_logs": TimeLog.synchronizeModel(json, realm: realm)
                default: return
                    
                }
                */
                
                //Task.synchronizeModel(json["tasks"], realm: realm)
                
                //synchronizeModel(info[key]!, jsons: json)
            }
        }
        
        ProgressManager.hide()
    }
    /*
    func synchronizeModel <T:RealmObject>(T,jsons:JSON){
        
        
        for var index = 0 ; index < jsons.count ; index++ {
            
            let json = jsons[index]
            
            if let serverId = json["id"].int {
                
                var results = realm.objects(T).filter("serverId == %lu", serverId)
                
                if results.count > 0 {
                    
                    update(results.first!,json:json)
                    
                    //updateDay(json,day:results.first!)
                    
                    //update<T>(json)
                    
                    continue
                }
            }
            
            create(T(),json:json)
        }
        
    }
    
    func update <T:RealmObject>(model:T,json:JSON){
        
        realm.write{
            
            if let serverId = json[model.getParentsServerIdKey()].int {
                
                let items = self.realm.objects(model.getParentsModel()).filter("serverId == %lu",serverId)
                let item = items.first!
                
                item.addRelation(model)
                self.realm.add(item,update:true)
                
            }
            
            model.setupJSON(json)
            self.realm.add(model,update:true)
        }
    }
    
    func create <T:RealmObject>(model:T,json:JSON){
        
        model.id = NSUUID().UUIDString
        model.setupJSON(json)
        
        realm.write{
            
            if let serverId = json[model.getParentsServerIdKey()].int {
                
                let items = self.realm.objects(model.getParentsModel()).filter("serverId == %lu",serverId)
                let item = items.first!
                
                item.addRelation(model)
                self.realm.add(item,update:true)
                
            }
            self.realm.add(model)
        }
    }
    */
    
    func synchronizeWeek(jsons:JSON){
        
        for var index = 0 ; index < jsons.count ; index++ {
            
            let json = jsons[index]
            
            if let serverId = json["id"].int {
                
                var results = realm.objects(Week).filter("serverId == %lu",serverId)
                
                if results.count > 0 {
                    updateWeek(json, week: results.first!)
                    continue
                }
            }
            
            createWeek(json)
        
        }
    }
    
    
    func updateWeek(json:JSON,week:Week){
        realm.write{
            
            if let taskDateId = json["task_date_id"].int {
                let taskDates = self.realm.objects(TaskDate).filter("serverId == %lu",taskDateId)
                let taskDate = taskDates.first!
                week.taskDate = taskDate
                
                if week == taskDate.week{
                    
                }else{
                    taskDate.week = week
                    self.realm.add(taskDate,update:true)
                }
            }
            
            week.setupJSON(json)
            self.realm.add(week,update:true)
        }
    }
    
    func createWeek(json:JSON){
        
        let week = Week()
        week.id = NSUUID().UUIDString
        week.setupJSON(json)
        
        realm.write{
            
            
            if let taskDateId = json["task_date_id"].int {
                let taskDates = self.realm.objects(TaskDate).filter("serverId == %lu",taskDateId)
                let taskDate = taskDates.first!
                week.taskDate = taskDate
                
                if week == taskDate.week{
                    
                }else{
                    taskDate.week = week
                    self.realm.add(taskDate,update:true)
                }
            }
            
            
            self.realm.add(week)
        }
    }
    
    func synchronizeCategorys(jsons:JSON){
        
        for var index = 0 ; index < jsons.count ; index++ {
            
            let json = jsons[index]
            
            if let serverId = json["id"].int {
                
                var results = realm.objects(Category).filter("serverId == %lu",serverId)
                
                if results.count > 0 {
                    updateCategory(json,category:results.first!)
                    continue
                }
            }
            
            createCategory(json)
            
        }
        
    }
    
    func synchronizeCategory(json:JSON){
        
        
        if let serverId = json["id"].int {
            
            var results = realm.objects(Category).filter("serverId == %lu",serverId)
            
            if results.count > 0 {
                updateCategory(json,category:results.first!)
                return
            }
        }
        
        createCategory(json)
        
    }
    
    func updateCategory(json:JSON,category:Category){
        realm.write{
            category.setupJSON(json)
            self.realm.add(category,update:true)
        }
    }
    
    func createCategory(json:JSON){
        
        let category = Category()
        category.id = NSUUID().UUIDString
        category.setupJSON(json)
        
        realm.write{
            
            self.realm.add(category)
        }
    }
    
    
    func synchronizeTask(jsons:JSON){
        
        for var index = 0 ; index < jsons.count ; index++ {
            
            let json = jsons[index]
            
            if let serverId = json["id"].int {
                
                var results = realm.objects(Task).filter("serverId == %lu", serverId)
                
                if results.count > 0 {
                    updateTask(json,task:results.first!)
                    continue
                }
            }
            
            createTask(json)
            
        }
    }
    
    func updateTask(json:JSON,task:Task){
        realm.write{
            
            if let categoryId = json["category_id"].int {
                let categorys = self.realm.objects(Category).filter("serverId == %lu",categoryId)
                let category = categorys.first!
                task.category = category
                
                if let index = category.tasks.indexOf(task){
                    
                }else{
                    category.tasks.append(task)
                    self.realm.add(category,update:true)
                }
            }
            
            
            task.setupJSON(json)
            self.realm.add(task,update:true)
        }
    }
    
    func createTask(json:JSON){
        
        let task = Task()
        task.setupJSON(json)
        task.id = NSUUID().UUIDString
        
        realm.write{
            
            
            if let categoryId = json["category_id"].int {
                let categorys = self.realm.objects(Category).filter("serverId == %lu",categoryId)
                let category = categorys.first!

                task.category = category
                
                if let index = category.tasks.indexOf(task){
                    
                }else{
                    category.tasks.append(task)
                    self.realm.add(category,update:true)
                }
            }
            
            self.realm.add(task)
        }
    }
    
    
    
    func synchronizeTaskDate(jsons:JSON){
        
        for var index = 0 ; index < jsons.count ; index++ {
            
            let json = jsons[index]
            
            if let serverId = json["id"].int {
                
                var results = realm.objects(TaskDate).filter("serverId == %lu",serverId)
                
                if results.count > 0 {
                    updateTaskDate(json,taskDate:results.first!)
                    continue
                }
            }
            
            createTaskDate(json)
        }
        
    }
    
    func updateTaskDate(json:JSON,taskDate:TaskDate){
        realm.write{
            
            if let taskId = json["task_id"].int {
                let tasks = self.realm.objects(Task).filter("serverId == %lu",taskId)
                let task = tasks.first!
                taskDate.task = task
                
                if let index = task.taskDates.indexOf(taskDate){
                    
                }else{
                    task.taskDates.append(taskDate)
                    self.realm.add(task,update:true)
                }
            }
            
            taskDate.setupJSON(json)
            self.realm.add(taskDate,update:true)
        }
    }
    
    func createTaskDate(json:JSON){
        
        let taskDate = TaskDate()
        taskDate.id = NSUUID().UUIDString
        taskDate.setupJSON(json)
        
        
        realm.write{
           
            
            if let taskId = json["task_id"].int {
                let tasks = self.realm.objects(Task).filter("serverId == %lu",taskId)
                let task = tasks.first!
                taskDate.task = task
                
                if let index = task.taskDates.indexOf(taskDate){
                    
                }else{
                    task.taskDates.append(taskDate)
                    self.realm.add(task,update:true)
                }
            }
            
            
            self.realm.add(taskDate)
        }
    }
    
    
    func synchronizeDay(jsons:JSON){
        
        for var index = 0 ; index < jsons.count ; index++ {
            
            let json = jsons[index]
            
            if let serverId = json["id"].int {
                
                var results = realm.objects(Day).filter("serverId == %lu", serverId)
                
                if results.count > 0 {
                    updateDay(json,day:results.first!)
                    continue
                }
            }
            createDay(json)
        }
    }
    
    func updateDay(json:JSON, day:Day){
        realm.write{
            
            if let taskDateId = json["task_date_id"].int {
                
                let taskDates = self.realm.objects(TaskDate).filter("serverId == %lu",taskDateId)
                let taskDate = taskDates.first!
                day.taskDate = taskDate
                
                if let index =  taskDate.days.indexOf(day){
                    
                }else{
                    taskDate.days.append(day)
                    self.realm.add(taskDate,update:true)
                }
            }
            
            day.setupJSON(json)
            self.realm.add(day,update:true)
        }
    }
    
    func createDay(json:JSON){
        
        let day = Day()
        day.id = NSUUID().UUIDString
        day.setupJSON(json)
        
        realm.write{
            
            if let taskDateId = json["task_date_id"].int {
                
                let taskDates = self.realm.objects(TaskDate).filter("serverId == %lu",taskDateId)
                
                if taskDates.count > 0 {
                    let taskDate = taskDates.first!
                    
                    if let index =  taskDate.days.indexOf(day){
                        
                    }else{
                        taskDate.addRelation(day)
                        self.realm.add(taskDate,update:true)
                    }
                }
            }
            
            
            self.realm.add(day)
        }
    }
    
    func synchronizeDiary(jsons:JSON){
        
        for var index = 0 ; index < jsons.count ; index++ {
            
            let json = jsons[index]
            
            if let serverId = json["id"].int {
                
                var results = realm.objects(Diary).filter("serverId == %lu", serverId)
                
                if results.count > 0 {
                    updateDiary(json,diary:results.first!)
                    continue
                }
            }
            createDiary(json)
        }
    }
    
    func updateDiary(json:JSON, diary:Diary){
        realm.write{
            
            if let serverId = json["day_id"].int {
                
                
                let days = self.realm.objects(Day).filter("serverId == %lu",serverId)
                
                if days.count > 0 {
                    let day = days.first!
                    
                    if let index =  day.diarys.indexOf(diary){
                        
                    }else{
                        day.addRelation(diary)
                        self.realm.add(day,update:true)
                    }
                }
            }
            
            diary.setupJSON(json)
            self.realm.add(diary,update:true)
        }
    }
    
    func createDiary(json:JSON){
        
        let diary = Diary()
        diary.id = NSUUID().UUIDString
        diary.setupJSON(json)
        
        realm.write{
            
            if let serverId = json["day_id"].int {
                
                let days = self.realm.objects(Day).filter("serverId == %lu",serverId)
                
                if days.count > 0 {
                    let day = days.first!
                    
                    if let index =  day.diarys.indexOf(diary){
                        
                    }else{
                        day.addRelation(diary)
                        self.realm.add(day,update:true)
                    }
                }
            }
            
            self.realm.add(diary)
        }
    }
    
    
    
    
    
    func synchronizeAmountRange(jsons:JSON){
        
        for var index = 0 ; index < jsons.count ; index++ {
            
            let json = jsons[index]
            
            if let serverId = json["id"].int {
                
                var results = realm.objects(AmountRange).filter("serverId == %lu", serverId)
                
                if results.count > 0 {
                    updateAmountRange(json,amountRange:results.first!)
                    continue
                }
            }
            createAmountRange(json)
        }
    }
    
    func updateAmountRange(json:JSON,amountRange:AmountRange){
        realm.write{
            
            if let serverId = json["day_id"].int {
                
                
                let days = self.realm.objects(Day).filter("serverId == %lu",serverId)
                
                if days.count > 0 {
                    let day = days.first!
                    
                    if let index =  day.amountRanges.indexOf(amountRange){
                        
                    }else{
                        day.addRelation(amountRange)
                        self.realm.add(day,update:true)
                    }
                }
            }
            
            amountRange.setupJSON(json)
            self.realm.add(amountRange,update:true)
        }
    }
    
    func createAmountRange(json:JSON){
        
        let amountRange = AmountRange()
        amountRange.id = NSUUID().UUIDString
        amountRange.setupJSON(json)
        
        realm.write{
            
            if let serverId = json["day_id"].int {
                
                let days = self.realm.objects(Day).filter("serverId == %lu",serverId)
                
                if days.count > 0 {
                    let day = days.first!
                    
                    if let index =  day.amountRanges.indexOf(amountRange){
                        
                    }else{
                        day.addRelation(amountRange)
                        self.realm.add(day,update:true)
                    }
                }
            }
            
            self.realm.add(amountRange)
        }
    }
    
    
   
    func synchronizeTimeHistory(jsons:JSON){
        
        for var index = 0 ; index < jsons.count ; index++ {
            
            let json = jsons[index]
            
            if let serverId = json["id"].int {
                
                var results = realm.objects(TimeHistory).filter("serverId == %lu", serverId)
                
                if results.count > 0 {
                    updateTimeHistory(json,timeHistory:results.first!)
                    continue
                }
            }
            createTimeHistory(json)
        }
    }
    
    func updateTimeHistory(json:JSON,timeHistory:TimeHistory){
        realm.write{
            
            if let serverId = json["day_id"].int {
                
                
                let days = self.realm.objects(Day).filter("serverId == %lu",serverId)
                
                if days.count > 0 {
                    let day = days.first!
                    
                    if let index =  day.timeHistorys.indexOf(timeHistory){
                        
                    }else{
                        day.addRelation(timeHistory)
                        self.realm.add(day,update:true)
                    }
                }
            }
            
            timeHistory.setupJSON(json)
            self.realm.add(timeHistory,update:true)
        }
    }
    
    func createTimeHistory(json:JSON){
        
        let timeHistory = TimeHistory()
        timeHistory.id = NSUUID().UUIDString
        timeHistory.setupJSON(json)
        
        realm.write{
            
            if let serverId = json["day_id"].int {
                
                let days = self.realm.objects(Day).filter("serverId == %lu",serverId)
                
                if days.count > 0 {
                    let day = days.first!
                    
                    if let index =  day.timeHistorys.indexOf(timeHistory){
                        
                    }else{
                        day.addRelation(timeHistory)
                        self.realm.add(day,update:true)
                    }
                }
            }
            
            self.realm.add(timeHistory)
        }
    }
    
    
    func synchronizeReviewDay(jsons:JSON){
        
        for var index = 0 ; index < jsons.count ; index++ {
            
            let json = jsons[index]
            
            if let serverId = json["id"].int {
                
                var results = realm.objects(ReviewDay).filter("serverId == %lu", serverId)
                
                if results.count > 0 {
                    updateReviewDay(json,reviewDay:results.first!)
                    continue
                }
            }
            createReviewDay(json)
        }
    }
    
    func updateReviewDay(json:JSON,reviewDay:ReviewDay){
        realm.write{
            
            if let serverId = json["day_id"].int {
                
                
                let days = self.realm.objects(Day).filter("serverId == %lu",serverId)
                
                if days.count > 0 {
                    let day = days.first!
                    
                    if let index =  day.reviewDays.indexOf(reviewDay){
                        
                    }else{
                        day.addRelation(reviewDay)
                        self.realm.add(day,update:true)
                    }
                }
            }
            
            reviewDay.setupJSON(json)
            self.realm.add(reviewDay,update:true)
        }
    }
    
    func createReviewDay(json:JSON){
        
        let reviewDay = ReviewDay()
        reviewDay.id = NSUUID().UUIDString
        reviewDay.setupJSON(json)
        
        realm.write{
            
            if let serverId = json["day_id"].int {
                
                let days = self.realm.objects(Day).filter("serverId == %lu",serverId)
                
                if days.count > 0 {
                    let day = days.first!
                    
                    if let index =  day.reviewDays.indexOf(reviewDay){
                        
                    }else{
                        day.addRelation(reviewDay)
                        self.realm.add(day,update:true)
                    }
                }
            }
            
            self.realm.add(reviewDay)
        }
    }
    
    
    func synchronizeDailyTotalResult(jsons:JSON){
        
        for var index = 0 ; index < jsons.count ; index++ {
            
            let json = jsons[index]
            
            if let serverId = json["id"].int {
                
                var results = realm.objects(DailyTotalResult).filter("serverId == %lu", serverId)
                
                if results.count > 0 {
                    updateDailyTotalResult(json,dailyTotalResult:results.first!)
                    continue
                }
            }
            createDailyTotalResult(json)
        }
    }
    
    func updateDailyTotalResult(json:JSON,dailyTotalResult:DailyTotalResult){
        realm.write{
            
            if let serverId = json["user_id"].int {
                
                
                let users = self.realm.objects(User).filter("serverId == %lu",serverId)
                
                if users.count > 0 {
                    let user = users.first!
                    
                    if let index =  user.dailyTotalResults.indexOf(dailyTotalResult){
                        
                    }else{
                        user.addRelation(dailyTotalResult)
                        self.realm.add(user,update:true)
                    }
                }
            }
            
            dailyTotalResult.setupJSON(json)
            self.realm.add(dailyTotalResult,update:true)
        }
    }
    
    func createDailyTotalResult(json:JSON){
        
        let dailyTotalResult = DailyTotalResult()
        dailyTotalResult.id = NSUUID().UUIDString
        dailyTotalResult.setupJSON(json)
        
        realm.write{
            
            if let serverId = json["user_id"].int {
                
                let users = self.realm.objects(User).filter("serverId == %lu",serverId)
                
                if users.count > 0 {
                    let user = users.first!
                    
                    if let index =  user.dailyTotalResults.indexOf(dailyTotalResult){
                        
                    }else{
                        user.addRelation(dailyTotalResult)
                        self.realm.add(user,update:true)
                    }
                }
            }
            
            self.realm.add(dailyTotalResult)
        }
    }
    
    func synchronizeCheckLog(jsons:JSON){
        
        for var index = 0 ; index < jsons.count ; index++ {
            
            let json = jsons[index]
            
            if let serverId = json["id"].int {
                
                var results = realm.objects(CheckLog).filter("serverId == %lu", serverId)
                
                if results.count > 0 {
                    updateCheckLog(json,checkLog:results.first!)
                    continue
                }
            }
            createCheckLog(json)
        }
    }
    
    func updateCheckLog(json:JSON,checkLog:CheckLog){
        realm.write{
            
            if let serverId = json["day_id"].int {
                
                
                let days = self.realm.objects(Day).filter("serverId == %lu",serverId)
                
                if days.count > 0 {
                    let day = days.first!
                    
                    if let index =  day.checkLogs.indexOf(checkLog){
                        
                    }else{
                        day.addRelation(checkLog)
                        self.realm.add(day,update:true)
                    }
                }
            }
            
            checkLog.setupJSON(json)
            self.realm.add(checkLog,update:true)
        }
    }
    
    func createCheckLog(json:JSON){
        
        let checkLog = CheckLog()
        checkLog.id = NSUUID().UUIDString
        checkLog.setupJSON(json)
        
        realm.write{
            
            if let serverId = json["day_id"].int {
                
                let days = self.realm.objects(Day).filter("serverId == %lu",serverId)
                
                if days.count > 0 {
                    let day = days.first!
                    
                    if let index =  day.checkLogs.indexOf(checkLog){
                        
                    }else{
                        day.addRelation(checkLog)
                        self.realm.add(day,update:true)
                    }
                }
            }
            
            self.realm.add(checkLog)
        }
    }
    
    
    
    func synchronizeTimeLog(jsons:JSON){
        
        for var index = 0 ; index < jsons.count ; index++ {
            
            let json = jsons[index]
            
            if let serverId = json["id"].int {
                
                var results = realm.objects(TimeLog).filter("serverId == %lu", serverId)
                
                if results.count > 0 {
                    updateTimeLog(json,timeLog:results.first!)
                    continue
                }
            }
            createTimeLog(json)
        }
    }
    
    func updateTimeLog(json:JSON,timeLog:TimeLog){
        realm.write{
            
            if let serverId = json["day_id"].int {
                
                
                let days = self.realm.objects(Day).filter("serverId == %lu",serverId)
                
                if days.count > 0 {
                    let day = days.first!
                    
                    if let index =  day.timeLogs.indexOf(timeLog){
                        
                    }else{
                        day.addRelation(timeLog)
                        self.realm.add(day,update:true)
                    }
                }
            }
            
            timeLog.setupJSON(json)
            self.realm.add(timeLog,update:true)
        }
    }
    
    func createTimeLog(json:JSON){
        
        let timeLog = TimeLog()
        timeLog.id = NSUUID().UUIDString
        timeLog.setupJSON(json)
        
        realm.write{
            
            if let serverId = json["day_id"].int {
                
                let days = self.realm.objects(Day).filter("serverId == %lu",serverId)
                
                if days.count > 0 {
                    let day = days.first!
                    
                    if let index =  day.timeLogs.indexOf(timeLog){
                        
                    }else{
                        day.addRelation(timeLog)
                        self.realm.add(day,update:true)
                    }
                }
            }
            
            self.realm.add(timeLog)
        }
    }
    
    
    func synchronizeAmountLog(jsons:JSON){
        
        for var index = 0 ; index < jsons.count ; index++ {
            
            let json = jsons[index]
            
            if let serverId = json["id"].int {
                
                var results = realm.objects(AmountLog).filter("serverId == %lu", serverId)
                
                if results.count > 0 {
                    updateAmountLog(json,amountLog:results.first!)
                    continue
                }
            }
            createAmountLog(json)
        }
    }
    
    func updateAmountLog(json:JSON,amountLog:AmountLog){
        realm.write{
            
            if let serverId = json["day_id"].int {
                
                
                let days = self.realm.objects(Day).filter("serverId == %lu",serverId)
                
                if days.count > 0 {
                    let day = days.first!
                    
                    if let index =  day.amountLogs.indexOf(amountLog){
                        
                    }else{
                        day.addRelation(amountLog)
                        self.realm.add(day,update:true)
                    }
                }
            }
            
            amountLog.setupJSON(json)
            self.realm.add(amountLog,update:true)
        }
    }
    
    func createAmountLog(json:JSON){
        
        let amountLog = AmountLog()
        amountLog.id = NSUUID().UUIDString
        amountLog.setupJSON(json)
        
        realm.write{
            
            if let serverId = json["day_id"].int {
                
                let days = self.realm.objects(Day).filter("serverId == %lu",serverId)
                
                if days.count > 0 {
                    let day = days.first!
                    
                    if let index =  day.amountLogs.indexOf(amountLog){
                        
                    }else{
                        day.addRelation(amountLog)
                        self.realm.add(day,update:true)
                    }
                }
            }
            
            self.realm.add(amountLog)
        }
    }
    
    
    func synchronizePreference(jsons:JSON){
        
        for var index = 0 ; index < jsons.count ; index++ {
            
            let json = jsons[index]
            
            if let serverId = json["id"].int {
                
                var results = realm.objects(Preference).filter("serverId == %lu", serverId)
                
                if results.count > 0 {
                    updatePreference(json,preference:results.first!)
                    continue
                }
            }
            createPreference(json)
        }
    }
    
    func updatePreference(json:JSON,preference:Preference){
        realm.write{
            
            if let serverId = json["user_id"].int {
                
                
                let users = self.realm.objects(User).filter("serverId == %lu",serverId)
                
                if users.count > 0 {
                    let user = users.first!
                    
                    if let index =  user.preferences.indexOf(preference){
                        
                    }else{
                        user.addRelation(preference)
                        self.realm.add(user,update:true)
                    }
                }
            }
            
            preference.setupJSON(json)
            self.realm.add(preference,update:true)
        }
    }
    
    func createPreference(json:JSON){
        
        let preference = Preference()
        preference.id = NSUUID().UUIDString
        preference.setupJSON(json)
        
        realm.write{
            
            if let serverId = json["day_id"].int {
                
                let users = self.realm.objects(User).filter("serverId == %lu",serverId)
                
                if users.count > 0 {
                    let user = users.first!
                    
                    if let index =  user.preferences.indexOf(preference){
                        
                    }else{
                        user.addRelation(preference)
                        self.realm.add(user,update:true)
                    }
                }
            }
            
            self.realm.add(preference)
        }
    }
}
