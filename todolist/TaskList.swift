//
//  TaskList.swift
//  
//
//  Created by Alex on 02.02.2022.
//

import RealmSwift

class TaskList: Object { // список задач
    @objc dynamic var name = ""
    @objc dynamic var date = Date()
    let tasks = List<Task>() // коллекция, где хранятся задачи 
    
}

class Task: Object { // задача
    @objc dynamic var name = ""
    @objc dynamic var note = ""
    @objc dynamic var date = Date()
    @objc dynamic var isComplete = false
}
