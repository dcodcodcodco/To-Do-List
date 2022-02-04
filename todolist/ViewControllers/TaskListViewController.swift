//
//  TaskListViewController.swift
//  todolist
//
//  Created by Alex on 01.02.2022.
//

import RealmSwift

class TaskListViewController: UITableViewController {
    
    private var taskLists: Results<TaskList>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskLists = StorageManager.shared.realm.objects(TaskList.self)
        //createTestData()
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
    
    private func createTestData() { // данные для первого запуска
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
        }
        
    }
    
}

extension TaskListViewController {
    
    private func showAlert() {
        let alert = AlertController(title: "New List", message: "Please insert new value", preferredStyle: .alert)
        
        alert.action { newValue in
            
        }
        
        present(alert, animated: true)
    }
    
}
