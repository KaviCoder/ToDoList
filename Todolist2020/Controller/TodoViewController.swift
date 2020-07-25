//
//  ViewController.swift
//  Todolist2020
//
//  Created by Kavya Joshi on 06/07/20.
//  Copyright © 2020 Kavya Joshi. All rights reserved.
//

import UIKit
import CoreData

class TodoViewController: UITableViewController {
    

  var CategoryArray = [Category]()
     
          var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
     
        loadItems()
        print(FileManager.default.urls(for: .documentDirectory, in : .userDomainMask))
 
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        print(#function)
    }

    
    //MARK: - tableview - Three methods are there
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CategoryArray.count
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCell", for: indexPath)
        
        cell.textLabel?.text = CategoryArray[indexPath.row].name
        
        
       
        
        return cell
    }
    
    
    // ON SELECT DO THE SGUE THINGS
    //In this case we need to transfer the parent details to the secondscreen so instead of creating the segue directly from cell to secondVC, I created segue from firstVC to secondVC... Now we can use didSelect function to take the current parent value
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
       
        performSegue(withIdentifier: "goToDetail", sender: self)
        
        
        
        //
        tableView.deselectRow(at: indexPath, animated: true)
       
    }
}


extension TodoViewController
{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetail"
        {
            let VC = segue.destination as! DetailToDoViewController
            if let indexPath = tableView.indexPathForSelectedRow
            {
            VC.selectedParent = CategoryArray[indexPath.row]
           
                
            }}
    }
    
    
    //selec
}

//MARK: - Adding Alert as popup
extension TodoViewController
{
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var myTextField : UITextField?
        
        let alert = UIAlertController(title: "Add To Do Category items", message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
        
            if let category = myTextField?.text
            {
                //create object in a specific context
                let newCategory = Category(context: self.context)
                
                //add the data to the object
                newCategory.name = category
              
                
                self.CategoryArray.append(newCategory)
                 //savecontext
                self.saveItems()
            }
            
 
          
        }
         alert.addAction(action)
        alert.addTextField { (textField) in
            textField.placeholder = "Create new item"
            
            myTextField = textField
            print(myTextField!)
        }
        
        
                    
                    present(alert, animated: true)
    }
      func loadItems()
      {
       let request : NSFetchRequest<Category> =  Category.fetchRequest()
       var count = 0
       do
       {
        CategoryArray = try context.fetch(request)
        count = try context.count(for: request)
        print(count)
        tableView.reloadData()
       }
       catch{
        print(error)
        }
        
       
       
       }
    
    
    func saveItems()
    {
        do
        {
            try context.save()
        }
        catch{
            print(error)
        }
                    self.tableView.reloadData()
    }
}
  //MARK: - Creating unwind segues to exit user from secondVC
//Also we need to create connect on story board for both the buttons
 // Unwind segues will automatically reverse all the segues from the scene you are exiting back to the scene you’re returning to.

extension TodoViewController
{
    @IBAction func myDoneAndBackButton(_ segue: UIStoryboardSegue)
    {
        // save the data
        print("Either back aur done button is pressed")
    }
    
}

extension TodoViewController
{
   
}

