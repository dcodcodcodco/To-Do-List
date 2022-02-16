//
//  TasksViewController.swift
//  
//
//  Created by Alex on 02.02.2022.
//

import RealmSwift

class TasksViewController: UITableViewController {
    
    var taskList: TaskList! // инициализированный список задач
    
    private var currentTasks: Results<Task>! // текущие
    private var completedTasks: Results<Task>! // выполненные
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = taskList.name
        currentTasks = taskList.tasks.filter("isComplete = false")
        completedTasks = taskList.tasks.filter("isComplete = true")
        
        let addButton = UIBarButtonItem( // добавление кнопки
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonPressed)
        )
        
        navigationItem.rightBarButtonItems = [addButton, editButtonItem] // добавление кнопок в интерфейс
    }

    // MARK: Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { // кол-во строк в секции
        section == 0 ? currentTasks.count : completedTasks.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { // отображение заголовков секций
        section == 0 ? "Current Tasks" : "Completed Tasks"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TasksCell", for: indexPath)
        let task = indexPath.section == 0 ? currentTasks[indexPath.row] : completedTasks[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = task.name
        content.secondaryText = task.note
        cell.contentConfiguration = content
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? { // действие по свайпу в справа налево
        
        let task = indexPath.section == 0 // извлекаем из нужной коллекции задачу
        ? currentTasks[indexPath.row]
        : completedTasks[indexPath.row]
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { _, _, isDone in
            self.showAlert(with: task) {
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            isDone(true) // фиксит фриз свайпа ячейки и последующую его работу после редактирования
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            StorageManager.shared.delete(task: task) // удаление из базы данных
            tableView.deleteRows(at: [indexPath], with: .automatic) // удаление в интерфейсе
            
        }
        
        let doneTitle = indexPath.section == 0 ? "Done" : "Undone"
        
        let doneAction = UIContextualAction(style: .normal, title: doneTitle) { _, _, isDone in
            StorageManager.shared.done(task: task)
            
            let indexPathForCurrentTask = IndexPath(row: self.currentTasks.count - 1, section: 0)
            let indexPathForCompletedTask = IndexPath(row: self.completedTasks.count - 1, section: 1)
            
            let destinationIndexRow = indexPath.section == 0 ? indexPathForCompletedTask : indexPathForCurrentTask // место назначения при перемещении задачи
            tableView.moveRow(at: indexPath, to: destinationIndexRow) // куда перемещаем строку
            
            isDone(true)
        }
        
        editAction.backgroundColor = .orange
        doneAction.backgroundColor = #colorLiteral(red: 0.3581389785, green: 0.7033968568, blue: 0.4212189317, alpha: 1)
        

        return UISwipeActionsConfiguration(actions: [doneAction, editAction, deleteAction])
    }
    
    @objc private func addButtonPressed() {
        showAlert()
    }
}


extension TasksViewController {
    
    private func showAlert(with task: Task? = nil, completion: (() -> Void)? = nil) {
        let title = task != nil ? "Edit Task" : "New Task"
        
        let alert = UIAlertController.createAlert(withTitle: title, andMessage: "What do you want to do?")
        
        alert.action(with: task) { newValue, note in
            if let task = task, let completion = completion {
                StorageManager.shared.edit(task: task, name: newValue, note: note)
                completion()
            } else {
                self.saveTask(withName: newValue, andNote: note)
            }
        }
        
        present(alert, animated: true)
    }
    
    private func saveTask(withName name: String, andNote note: String) { // сохранение задачи
        let task = Task(value: [name, note]) // создаем экземпляр задачи
        StorageManager.shared.save(task: task, in: taskList) // сохраняем задачу в списке в базу
        let rowIndex = IndexPath(row: currentTasks.count - 1, section: 0) // определяем ячейку для отображения
        tableView.insertRows(at: [rowIndex], with: .automatic)
    }
    
}
