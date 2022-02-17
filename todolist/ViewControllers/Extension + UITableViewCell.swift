//
//  Extension + UITableViewCell.swift
//  todolist
//
//  Created by Alex on 17.02.2022.
//

import UIKit

extension UITableViewCell { // настройка галочки для tasklist
    func configure(with taskList: TaskList) {
        let currentTasks = taskList.tasks.filter("isComplete = false") // если false - то задача текущая
        let completedTasks = taskList.tasks.filter("isComplete = true")
        var content = defaultContentConfiguration() // экзмепляр
        
        content.text = taskList.name
        
        if !currentTasks.isEmpty {
            content.secondaryText = "\(currentTasks.count)"
            accessoryType = .none // чтобы цифры возвращались обратно , если задача вдруг окажется невыполненной
        } else if !completedTasks.isEmpty {
            content.secondaryText = nil
            accessoryType = .checkmark
        } else {
            accessoryType = .none
            content.secondaryText = "0"
        }
        
        contentConfiguration = content
    }
}
