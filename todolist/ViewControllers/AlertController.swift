//
//  AlertController.swift
//  todolist
//
//  Created by Alex on 01.02.2022.
//

import UIKit

class AlertController: UIAlertController {
    
    func action(completion: @escaping (String) -> Void) { // добавление группы задач
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let newValue = self.textFields?.first?.text else { return } // извлекаем опционал
            guard !newValue.isEmpty else { return } // проверяем на пустоту
            completion(newValue)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        addAction(saveAction)
        addAction(cancelAction)
        addTextField { textField in
            textField.placeholder = "List Name"
        }
        
    }
    
    func action(completion: @escaping (String, String) -> Void) { // добавление одной задачи в группе
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let newTask = self.textFields?.first?.text else { return }
            guard !newTask.isEmpty else { return }
            
            if let note = self.textFields?.last?.text, !note.isEmpty { // проверка не обязательного для заполнения поля
                completion(newTask, note)
            } else {
                completion(newTask, "")
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        addAction(saveAction)
        addAction(cancelAction)
        
        addTextField { textField in
            textField.placeholder = "New Task"
        }
        
        addTextField { textField in
            textField.placeholder = "Note"
        }
    }
}

