//
//  SynchronizeManager.swift
//  Todait
//
//  Created by CruzDiary on 2015. 8. 14..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import RealmSwift

class RealmManager: NSObject {
   
    
    var realm = Realm()
    let sequence:[String] = ["categorys","tasks","task_dates","weeks","days"]
    
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
    
    
    
    func synchronize(json:JSON){
        
        
        
        for var index = 0 ; index < sequence.count ; index++ {
            
            let key = sequence[index]
            let json = json[key]
            
            if json.count > 0 {
                switch key {
                case "categorys": synchronizeCategory(json)
                case "tasks": synchronizeTask(json)
                case "task_dates": synchronizeTaskDate(json)
                case "weeks": synchronizeWeek(json)
                case "days": synchronizeDay(json)
                default: continue
                }
            }
        }
    }
    
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
    
    func synchronizeCategory(jsons:JSON){
        
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
                let taskDate = taskDates.first!
                day.taskDate = taskDate
                
                if let index =  taskDate.days.indexOf(day){
                    
                }else{
                    taskDate.days.append(day)
                    self.realm.add(taskDate,update:true)
                }
            }
            
            
            self.realm.add(day)
        }
    }
    
}
