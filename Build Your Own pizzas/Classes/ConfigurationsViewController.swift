//
//  ConfigurationsViewController.swift
//  Build Your Own pizzas
//
//  Created by Frank Mao on 2016-12-09.
//  Copyright © 2016 mazoic. All rights reserved.
//

import UIKit

class ConfigurationsViewController: UITableViewController {

    
    @IBOutlet var sortTypeSwitcher: UISegmentedControl!
    var items = [PizzaConfiguration]()
    
    var dateFormatter = DateFormatter()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        tableView.tableFooterView = UIView(frame: .zero)
        
        self.navigationItem.titleView =
        sortTypeSwitcher
        
       
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadData()
    }
    
    func reloadData() {
        
        let count = UserDefaults.standard.integer(forKey: AppConstants.KeyForMaxNumberOfItemsToDisplay)
        
        items = Repository.sharedInstance.getAllConfigurations(
            showCustomerMadeOnly: self.sortTypeSwitcher.selectedSegmentIndex == 1,
            
            top: count)
        
        self.tableView.reloadData()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConfigurationCell", for: indexPath)

        // Configure the cell...

        let item = items[indexPath.row]
        
        if item.isFavorite {
            cell.imageView?.image = UIImage(named: "heart" )
        }else{
            cell.imageView?.image = UIImage(named: "blank")
        }
        
        
        cell.textLabel?.text = item.toppings
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = String(item.countOfOrders)
        
        return cell
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let vc = segue.destination as? OrderViewController
        {
            if let cell = sender as? UITableViewCell,
                let indexPath = tableView.indexPath(for: cell) {
                vc.toppings = self.items[indexPath.row].toppings
            }else if let _ = sender as? UIBarButtonItem {
                vc.toppings = "" //build your own.
            }
            
            
        }
    }


    @IBAction func onSortListByType(_ sender: UISegmentedControl) {
        
        reloadData()
    }
}
