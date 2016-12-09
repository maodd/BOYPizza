//
//  OrderViewController.swift
//  Build Your Own pizzas
//
//  Created by Frank Mao on 2016-12-09.
//  Copyright © 2016 mazoic. All rights reserved.
//

import UIKit

class OrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var items: [String] = []
    
    var toppings:String!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var itemNumberLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        items = toppings.components(separatedBy: ",")
        
        tableView.tableFooterView = UIView(frame: .zero)
        
        tableView.reloadData()
        
        
    }
    @IBAction func onNumberChanged(_ sender: UIStepper) {
        
        itemNumberLabel.text = String(format:"%.0f", sender.value)
    }

    @IBAction func onPlaceOrder(_ sender: Any) {
        
        let count = Int16(itemNumberLabel.text!)
        Repository.sharedInstance.saveNewOrder(toppings: self.items, count!)
        
        let ac = UIAlertController(title: "Success",
                          message: "Order placed successfully",
                          preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok",
                                   style: .default,
                                   handler: { (action) in
                                    _ = self.navigationController?.popViewController(animated: true)
                                    
        }))
        
        self.navigationController?.present(ac, animated: true, completion: { 
            
        })
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Toppings"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderToppingCell", for: indexPath)
        
        // Configure the cell...
        let item = items[indexPath.row]
        
        cell.textLabel?.text = item
        
        return cell
    }
    
    


}
