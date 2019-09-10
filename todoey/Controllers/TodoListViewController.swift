//
//  ViewController.swift
//  todoey
//
//  Created by Francesca Koulikov on 9/9/19.
//  Copyright © 2019 Francesca Koulikov. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray  = [Item]()
//    let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
        
    }
    
    //Mark - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        
        
        return cell
    }
    
    //MARK - TableView Deletegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            }else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            }
        
        
    }
    
    //MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
       
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            // What will happen once the user clicks the Add Item button on our UIAlert
            self.itemArray.append(newItem)
            
            
            self.saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
        }
        
        
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK - Model Manupulation Methods
    func saveItems(){
        do {
            try context.save()
        }
        catch {
            print("ERror saving context \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems(){
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        do {
            itemArray = try context.fetch(request)
        }
        catch{
            print("Error loading and fetching data from context \(error)")
        }
        
    }
    

}

