//
//  DataManager.swift
//  todolist
//
//  Created by Alex on 05.02.2022.
//

import Foundation

class DataManager {
    
    static let shared = DataManager()
    
    private init() {}
    
    func createTempData(_ comptetion: @escaping () -> Void) { // здесь будет reload data
        if !UserDefaults.standard.bool(forKey: "done") {
            
            UserDefaults.standard.set(true, forKey: "done")
            
            let shoppingList = TaskList()
            shoppingList.name = "Shopping List"
            
            let moviesList = TaskList(value: ["Moview List", Date(), [["Best film ever"], ["The best of the best", "Must have", Date(), true]]])
            
            let milk = Task()
            milk.name = "Milk"
            milk.note = "2L"
            
            let bread = Task(value: ["Bread", "", Date(), true])
            let apples = Task(value: ["name": "Apples", "note": "2kg"])
            
            shoppingList.tasks.append(milk)
            shoppingList.tasks.insert(contentsOf: [bread, apples], at: 1)
            
            DispatchQueue.main.async {
                StorageManager.shared.save(taskLists: [shoppingList, moviesList])
                comptetion()
            }
        }
    }
}
