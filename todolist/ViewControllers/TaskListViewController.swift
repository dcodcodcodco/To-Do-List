//
//  TaskListViewController.swift
//  todolist
//
//  Created by Alex on 01.02.2022.
//

import RealmSwift
import UIKit

class TaskListViewController: UITableViewController {
    
    private var taskLists: Results<TaskList>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskLists = StorageManager.shared.realm.objects(TaskList.self)
        createTempData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData() // перезагрузка таблицы
    }
    
    // MARK: Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskLists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskListCell", for: indexPath)
        let taskList = taskLists[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = taskList.name
        content.secondaryText = "\(taskList.tasks.count)"
        cell.contentConfiguration = content
        
        return cell
    }
    
    // MARK: TableViewDelegate
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? { // действие по свайпу в справа налево
        
        let taskList = taskLists[indexPath.row] // извлекаем из массива список
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            StorageManager.shared.delete(taskList: taskList) // удаление из базы данных
            tableView.deleteRows(at: [indexPath], with: .automatic) // удаление в интерфейсе
            
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { // инициализируем свойства при переходе на другой экран
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        guard let tasksVC = segue.destination as? TasksViewController else { return }
        let taskList = taskLists[indexPath.row] // извлекаем конкретный список из массива списков
        tasksVC.taskList = taskList // передаем список на другой вью контроллер
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        showAlert()
    }
    
    @IBAction func sortingList(_ sender: UISegmentedControl) {
        
    }
    
    private func createTempData() {
        DataManager.shared.createTempData {
            self.tableView.reloadData()
        }
    }
}

extension TaskListViewController {
    
    private func showAlert() {
        let alert = UIAlertController.createAlert(withTitle: "New List", andMessage: "Please set new title")
        
        alert.action { newValue in
            self.save(taskList: newValue)
        }
        
        present(alert, animated: true)
    }
    
    
    private func save(taskList: String) { // передаем название для списка задач
        let taskList = TaskList(value: [taskList]) // создаем экземпляр модели
        StorageManager.shared.save(taskList: taskList) // передаем экземпляр в Storage Manager
        let rowIndex = IndexPath(row: taskLists.count - 1, section: 0) // определяем индекс добавляемой строки
        tableView.insertRows(at: [rowIndex], with: .automatic) // анимированное добавление строки
    }
}
