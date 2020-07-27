//
//  TableViewController.swift
//  Todolist2020
//
//  Created by Kavya Joshi on 07/07/20.
//  Copyright © 2020 Kavya Joshi. All rights reserved.
//

import UIKit
import CoreData

class DetailToDoViewController: UITableViewController {
    
    @IBOutlet weak var SearchBar: UISearchBar!
    var childList = [Item]()
       
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

       
    
    
    var selectedParent: Category?
  {
    didSet
    {
        
        //load the items initially for all which are child of the selectedParent
        loadItems()
        navigationItem.title = selectedParent?.name
    }
    }
    
    
    
    
    override func viewDidLoad() {
           super.viewDidLoad()
           
           SearchBar.delegate = self
           SearchBar.placeholder = "Search the items"
          
       
        
        
        
       
            
        }
        
           // Uncomment the following line to preserve selection between presentations
           // self.clearsSelectionOnViewWillAppear = false

           // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
           // self.navigationItem.rightBarButtonItem = self.editButtonItem
       
    
    
   //MARK: - UIBarButton - Add Item Methods
    @IBAction func DetailAddButtonPressed(_ sender: UIBarButtonItem) {
         var myTextField : UITextField?
               
               let alert = UIAlertController(title: "Add To Do List items", message: nil, preferredStyle: .alert)
               
               let action = UIAlertAction(title: "Add", style: .default) { (action) in
               
                   if let myItem = myTextField?.text
                   {
                    
                      print("*******************")
                  
                        let newChild = Item(context: self.context)
                        newChild.title = myItem
                        newChild.done = false
                        newChild.parentCategory = self.selectedParent
                    self.childList.append(newChild)
                    self.saveItems()
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        
                    //                        print( listData.myDict[x])
                    //?.append(myItem)
                    }}
                   
                   
                  
                   
               }
                alert.addAction(action)
               alert.addTextField { (textField) in
                   textField.placeholder = "Create new item"
                   
                   myTextField = textField
                   //print(myTextField)
               }
               
               
                           
                           present(alert, animated: true)
        
    }
    

   

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
            return 1
    
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return childList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoDetail", for: indexPath)

        cell.textLabel?.text = childList[indexPath.row].title
        cell.accessoryType = childList[indexPath.row].done ? .checkmark: .none

        return cell
    }
    
    
    //MARK: - table View Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.SearchBar?.resignFirstResponder()
        SearchBar.endEditing(true)
        
        
        childList[indexPath.row].done = !childList[indexPath.row].done
        //childList[indexPath.row].setValue(true, forKey: "done")
          

          tableView.deselectRow(at: indexPath, animated: true)
        saveItems()

    
    }
    
    
    //MARK: - Load Items
    
    func loadItems(request : NSFetchRequest<Item> =  Item.fetchRequest() , predicate : NSPredicate? = nil  )
    
    {
        SearchBar?.endEditing(true)
        SearchBar?.resignFirstResponder()
        
    let predicate1 = NSPredicate(format: "parentCategory.name MATCHES %@", selectedParent!.name!  )
        
        
        if predicate != nil {
        let coumpoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate!, predicate1])
                             request.predicate = coumpoundPredicate
        }
        else{
            request.predicate = predicate1
        }
         
        do
     {
      childList = try context.fetch(request)
        
      tableView.reloadData()
        print(childList)
     }
     catch{
      print(error)
      }
      
     }
    
    
    //MARK: - Save Items
    
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





//MARK: - Search Bar Methods


extension DetailToDoViewController : UISearchBarDelegate
{
    
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        print (searchBar.text)
//    }
//    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
//            print (searchBar.text)
//        if searchBar.text?.count != 0
//        {
//        return true
//        }
//
//        else{
//            return false
//        }
//    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print (searchBar.text!)
        
        if searchBar.text?.count != 0
        {
              SearchBar?.endEditing(true)
                   SearchBar?.resignFirstResponder()
            
             let request : NSFetchRequest<Item> =  Item.fetchRequest()
            
          
             request.predicate = NSPredicate(format: " title CONTAINS[cd] %@" , searchBar.text!   )
             
            
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
           
            
            loadItems(request: request)
             
             
        }
        
        else{
            searchBar.placeholder = " Enter something"
        }
    }
    
    
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
         loadItems()
          
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if  searchBar.text?.count == 0
        {
              loadItems()
        }
        
}
}
