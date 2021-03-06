//
//  StorageManager.swift
//  
//
//  Created by Alex on 02.02.2022.
//

import RealmSwift
//import Combine

class StorageManager {
    
    static let shared = StorageManager()
    
    let realm = try! Realm()
    
    private init() {}
    
    // MARK: Work with Task Lists
    
    func save(taskLists: [TaskList]) { // метод для сохранения списка списков
        write {
            realm.add(taskLists) // добавили в массив
        }
    }
    
    func save(taskList: TaskList) { // сохранение одного списка
        write {
            realm.add(taskList) // сохраняем лист в базу данных
        }
    }
    
    func edit(taskList: TaskList, newValue: String) { // второй параметр - новое имя для списка
        write {
            taskList.name = newValue
        }
    }
    
    func delete(taskList: TaskList) { // метод для удаления одного списка
        write {
            realm.delete(taskList.tasks) // сначала удаляем задачи из списка
            realm.delete(taskList) // потом сам список
        }
    }
    
    func done(taskList: TaskList) {
        write {
            taskList.tasks.setValue(true, forKey: "isComplete")
        }
    }
    
    
    // MARK: Work with tasks
    
    func save(task: Task, in taskList: TaskList) { // два параметра для добавления самой и задачи и добавления ее в список
        write {
            taskList.tasks.append(task)
        }
    }
    
    func edit(task: Task, name: String, note: String) {
        write {
            task.name = name
            task.note = note
        }
    }
    
    func delete(task: Task) {
        write {
            realm.delete(task)
        }
    }
    
    func done(task: Task) {
        write {
            task.isComplete.toggle()
        }
    }
    
    private func write(_ completion: () -> Void) { // работа с базой без !
        do {
            try realm.write { completion() }
        } catch let error {
            print(error)
        }
    }
    
}
