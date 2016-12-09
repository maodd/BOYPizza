//
//  ToppingsViewController.swift
//  Build Your Own pizzas
//
//  Created by Frank Mao on 2016-12-09.
//  Copyright © 2016 mazoic. All rights reserved.
//

import UIKit

protocol ToppingsViewControllerDelegate {
    
    func onCancel()
    
    func onDone(toppings: [String])
    
}

class ToppingsViewController: UITableViewController {

    
    var delegate:ToppingsViewControllerDelegate? 
    
    var items: [Topping] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        items = Repository.sharedInstance.getAllToppings().sorted(by: { (a, b) -> Bool in
            a.name! < b.name!
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToppingCell", for: indexPath)

        // Configure the cell...
        let item = items[indexPath.row]
        
        cell.textLabel?.text = item.name
        
        var isCellSelected = false
        if let selectedIndexPaths = self.tableView.indexPathsForSelectedRows {
            isCellSelected = selectedIndexPaths.contains(indexPath)
        }
        cell.accessoryType  =  isCellSelected ?  .checkmark : .none

        return cell
    }
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType  =  .checkmark
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType  =  .none
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
   
    @IBAction func onCancel(_ sender: Any) {
        if let delegate = delegate {
         
            delegate.onCancel()
        }
    }
    
    @IBAction func onDone(_ sender: Any) {
        
        if let delegate = delegate {
            
            if let selectedIndexPathes = tableView.indexPathsForSelectedRows {
                var results = [String]()
                
                for indexPath in selectedIndexPathes {
                    results.append(self.items[indexPath.row].name!)
                }
                
                
                
                delegate.onDone(toppings: results)
                
                
                    
            }
        }
    }
    

}
