//
//  ToDo.swift
//  ToDoList
//
//  Created by Olibo moni on 13/12/2021.
//

import UIKit

struct Todo: Equatable, Codable{
    let id = UUID()
    var name: String
    var dueDate: Date
    var note: String?
    var isComplete: Bool
    static func ==(lhs: Todo, rhs: Todo) ->Bool{
        return lhs.id == rhs.id
    }
    static func loadSampleTodos()->[Todo]{
           let todo1 = Todo( name: "Biology", dueDate: Date(), note: "sumbit me now", isComplete: true)
           let todo2 = Todo(name: "Chemistry", dueDate: Date(timeInterval: 86040, since: Date()), note: "notes 2", isComplete: false)
           let todo3 = Todo( name: "Physics", dueDate: Date(timeIntervalSinceReferenceDate: 48494984), note: "notes 3", isComplete: true)
        return [todo1, todo2, todo3]
    }
    
    static func loadTodos()->[Todo]?{
        guard let codedTodos = try? Data(contentsOf: archiveURL) else{return nil}
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode([Todo].self, from: codedTodos)
    }
    
    static func saveTodos(_ todos: [Todo]){
        let propertyListEncoder = PropertyListEncoder()
        let codedTodos = try? propertyListEncoder.encode(todos)
        try? codedTodos?.write(to: archiveURL, options: .noFileProtection)
    }
    
    static var dueDateFormatter : DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_GH")
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter
    }
    
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    static let archiveURL = documentsDirectory.appendingPathComponent("todos").appendingPathExtension("plist")
    
}
