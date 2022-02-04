//
//  StorageManager.swift
//  
//
//  Created by Alex on 02.02.2022.
//

import RealmSwift

class StorageManager {
    
    static let shared = StorageManager()
    
    let realm = try! Realm()
    
    private init() {}
    
    func save(taskLists: [TaskList]) { // сохранение списка списков
        
        try! realm.write { // внесение изменений
            realm.add(taskLists) // добавили массив
        }
        
    }
    
}
