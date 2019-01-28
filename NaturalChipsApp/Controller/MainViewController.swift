//
//  ViewController.swift
//  Realm ToDoList
//
//  Created by MauriRios on 1/15/19.
//  Copyright © 2019 Pencil. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UITableViewController{
    
    var realm: Realm!
    
    var productItem: Results<ProductItem>{
        get {
            return realm.objects(ProductItem.self)
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try! Realm()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let backgroundImage = UIImage(named: "chips.jpeg")
        let imageView = UIImageView(image: backgroundImage)
        imageView.alpha = 0.3
        self.tableView.backgroundView = imageView
        
        
    }
    
    
    //MARK - Add DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productItem.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = productItem[indexPath.row]
        cell.textLabel!.text = item.name
        cell.backgroundColor = .clear
        
        //Ternary operator....basically an if else statement on one line
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        return cell
    }
    
    
    //MARK - Add Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = productItem[indexPath.row]
        
        try! self.realm.write({
            item.done = !item.done
        })
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == .delete) {
            let item = productItem[indexPath.row]
            
            try! self.realm.write ({
                self.realm.delete(item)
            })
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

   


    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
      let alertVC = UIAlertController(title: "New product to order", message: "product name", preferredStyle: .alert)
        alertVC.addTextField { (UITextField) in
            
        }
        
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .destructive, handler: nil)
        alertVC.addAction(cancelAction)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (UIAlertAction) -> Void in
            
            let todoItemTextField = (alertVC.textFields?.first)! as UITextField
            
            let newProdcut = ProductItem()
            newProdcut.name = todoItemTextField.text!
            newProdcut.done = false
            
            try! self.realm.write({
                self.realm.add(newProdcut)
                
                self.tableView.insertRows(at: [IndexPath.init(row: self.productItem.count-1, section: 0)], with: .automatic)
            })
        }
        
        alertVC.addAction(addAction)
        present(alertVC, animated: true, completion: nil)
        
    }
    
    
}

