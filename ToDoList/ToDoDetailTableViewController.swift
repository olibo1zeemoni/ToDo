//
//  ToDoDetailTableViewController.swift
//  ToDoList
//
//  Created by Olibo moni on 14/12/2021.
//

import UIKit

class ToDoDetailTableViewController: UITableViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var isCompleteButton: UIButton!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var dueDatePickerView: UIDatePicker!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var todo: Todo?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let todo = todo {
            navigationItem.title = todo.name
            titleTextField.text = todo.name
            notesTextView.text = todo.note
            //dueDateLabel.text = Todo.dueDateFormatter.string(from: todo.dueDate) // String(describing: todo.dueDate.formatted())
            dueDatePickerView.date = todo.dueDate
            isCompleteButton.isSelected = todo.isComplete
            
        } else {
        dueDatePickerView.date = Date(timeInterval: 86400, since: Date()) // or Date().addingTimeInterval(24*60*60)
        
        }
        updateDueDateLabel(date: dueDatePickerView.date)
        updateSaveButtonState()

    }
    func updateSaveButtonState(){
        let shouldEnableSaveButton = titleTextField.text?.isEmpty == false
        saveButton.isEnabled = shouldEnableSaveButton
    }
    

    @IBAction func textEditingChanged(_ sender: UITextField){
        updateSaveButtonState()
    }

    @IBAction func returnPressed(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func isCompletionButtonTapped(_ sender: UIButton) {
        isCompleteButton.isSelected.toggle()
    }
    
    func updateDueDateLabel(date: Date){
        dueDateLabel.text = Todo.dueDateFormatter.string(from: dueDatePickerView.date)
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        updateDueDateLabel(date: sender.date)
    }
    
    let dueDateLabelIndexPath = IndexPath(row: 0, section: 1)
    let dueDatePickerIndexPath = IndexPath(row: 1, section: 1)
    let notesIndexPath = IndexPath(row: 0, section: 2)
    
    var isDueDatePickerHidden : Bool = true
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath{
        case dueDatePickerIndexPath where isDueDatePickerHidden == true:
            return 0
        case notesIndexPath:
            return 200
        default:
            return UITableView.automaticDimension
            
        }
    }
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == dueDateLabelIndexPath {
            isDueDatePickerHidden.toggle()
            dueDateLabel.textColor = .black
            updateDueDateLabel(date: dueDatePickerView.date)
            tableView.reloadData()
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard  segue.identifier == "saveUnwind" else {return}
        
        
        
        let title = titleTextField.text!
        let date = dueDatePickerView.date
        let notes = notesTextView.text
        let isComplete = isCompleteButton.isSelected
        
        if todo != nil{  // if todo isn't nil, update todo else create new todo
            todo?.name = title
            todo?.dueDate = date
            todo?.note = notes
            todo?.isComplete = isComplete

        }
        
        else {
            todo = Todo(name: title, dueDate: date, note: notes, isComplete: isComplete)
        }
        
        
        
    }

   

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
