//
//  ToDoTableViewController.swift
//  ToDoList
//
//  Created by Olibo moni on 13/12/2021.
//

import UIKit

class ToDoTableViewController: UITableViewController, ToDoCellDelegate {
   
    
//    let dateString = "10/12/2021"
//    let formatter = DateFormatter()
//    formatter.dateFormat = "dd/MM/yy"
    
    
   // date = formatter.date(from: dateString)
    
    var todos: [Todo] = [ ]

    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: Add sorting and search to APP
       
        
        if let savedTodos = Todo.loadTodos(){
            todos = savedTodos
        } else {
            todos = Todo.loadSampleTodos()
        }
        navigationItem.leftBarButtonItem = editButtonItem
        
        self.tableView.separatorColor = .black
        let view = UIView()
        view.frame = self.tableView.frame
        view.backgroundColor = UIColor.lightGray
        self.tableView.backgroundView = view
        self.tableView.tintColor = .black
            
        
    }

   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Todos", for: indexPath) as! ToDoCell
        cell.delegate = self
        let todo = todos[indexPath.row]
        cell.titleLabel.text = todo.name
        cell.isCompleteButton.isSelected = todo.isComplete
        cell.dueDateLabel.text = Todo.dueDateFormatter.string(from: todo.dueDate)
        cell.contentView.backgroundColor = .darkGray

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //print(todos[indexPath.row].name)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       
        if editingStyle == .delete{
            todos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            Todo.saveTodos(todos)
        }
        
        
    }
    
    
    @IBAction func unwindToToDoList(segue: UIStoryboardSegue){
        guard segue.identifier == "saveUnwind" else{return}
        
        let sourceViewController = segue.source as! ToDoDetailTableViewController
        
        if let todo = sourceViewController.todo {
            if let indexOfExistingToDo = todos.firstIndex(of: todo) {
                todos[indexOfExistingToDo] = todo
                tableView.reloadRows(at: [IndexPath(row: indexOfExistingToDo, section: 0)], with: .automatic)

            } else {
            
            
            let newIndexPath = IndexPath(row: todos.count , section: 0)
            todos.append(todo)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            
    }
            //tableView.reloadData()
            
        }
        Todo.saveTodos(todos)
                
        
    }
    
    
    @IBSegueAction func editToDo(_ coder: NSCoder, sender: Any?) -> ToDoDetailTableViewController? {
        // unwrap sender and cast it as uiTableviewCell. get indexpath
        guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else {return nil}
        tableView.deselectRow(at: indexPath, animated: true)
        let detailController = ToDoDetailTableViewController(coder: coder)
        detailController?.todo = todos[indexPath.row]
        
        return detailController
    }
        
    func checkmarkTapped(sender: ToDoCell) {
        if let indexPath = tableView.indexPath(for: sender) {
            var todo = todos[indexPath.row]
            todo.isComplete.toggle()
            todos[indexPath.row] = todo
            tableView.reloadRows(at: [indexPath], with: .automatic)
            Todo.saveTodos(todos)
        }
       
    }
    
    

    
    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     
         let todo = Todo(name: "Maths", dueDate: Date(), note: "added something", isComplete: true)
         todos.append(todo)
         tableView.reloadData()
     }
     }
    }
    */


    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let movedTodo = todos.remove(at: fromIndexPath.row)
        todos.insert(movedTodo, at: destinationIndexPath.row)
        tableView.reloadData()
    }
    

    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    

   

}
