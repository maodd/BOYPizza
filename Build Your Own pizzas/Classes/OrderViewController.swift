//
//  OrderViewController.swift
//  Build Your Own pizzas
//
//  Created by Frank Mao on 2016-12-09.
//  Copyright © 2016 mazoic. All rights reserved.
//

import UIKit

class OrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,
ToppingsViewControllerDelegate
{

    var isCustomerMade = false
    
    var items: [String] = []
    
    var toppings:String!
    
    @IBOutlet weak var tableView: UITableView!
    
    var configuration:PizzaConfiguration?
    
    var favoriteButton:UIButton!
    
    var _isFavorite:Bool = false
    var isFavorite:Bool {
        set(value) {
            _isFavorite = value
            
            let imageNamge = _isFavorite ? "heart" : "heart-line"
            favoriteButton.setBackgroundImage(UIImage(named: imageNamge), for: .normal)
            
            self.configuration?.isFavorite = _isFavorite
        }
        
        get{
            return _isFavorite
        }
    }
    
    @IBOutlet weak var itemNumberLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.tableFooterView = UIView(frame: .zero)
        
        items = toppings.components(separatedBy: ",").filter({ (item) -> Bool in
            item.characters.count > 0
        })
        
        
        self.layoutFavoriteButton()
        
        
        self.configuration =  Repository.sharedInstance.findConigurationByToppings(toppings: items)
        
        
        
        
        if let configuration = self.configuration {

            
            self.isFavorite = configuration.isFavorite
            
        }else{
            self.isFavorite = false
        }
        
        
        
        tableView.reloadData()
        
        if items.count == 0 {
            
            let nvc = storyboard?.instantiateViewController(withIdentifier: "ToppingsNVC") as! UINavigationController
            
            guard let vc = nvc.viewControllers.first as? ToppingsViewController  else {fatalError()}
            
            vc.delegate = self
            
            self.navigationController?.present(nvc, animated: true, completion: {
                
            })
            
        }
        
        
    }
    
    func layoutFavoriteButton() {
        favoriteButton = UIButton(type: .custom)
        
        favoriteButton.tintColor = UIColor.customOrange()
        favoriteButton.bounds = CGRect(x: 0, y: 0, width: 22, height: 22)
        
        favoriteButton.addTarget(self,
                                 action: #selector(OrderViewController.onFavoriteOrUnfavorite(_:)),
                                 for: .touchUpInside)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: favoriteButton)
    }
    
    @IBAction func onNumberChanged(_ sender: UIStepper) {
        
        itemNumberLabel.text = String(format:"%.0f", sender.value)
    }

    @IBAction func onPlaceOrder(_ sender: Any) {
        
        let count = Int16(itemNumberLabel.text!)
        Repository.sharedInstance.saveNewOrder(toppings: self.items,
                                               isCustomerMade:  self.isCustomerMade,
                                               isFavorite: self.isFavorite,  count!)
        
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
    
    // MARK: - ToppingsViewControllerDelegate
    
    func onCancel() {

        self.navigationController?.dismiss(animated: true, completion: {
            
        })
        
        _ = self.navigationController?.popViewController(animated: true)
        
    }

    func onDone(toppings: [String]) {
        items = toppings
        tableView.reloadData()
        
        self.isCustomerMade = true
        
        self.navigationController?.dismiss(animated: true, completion: { 
            
        })
    }

    
    @IBAction func onFavoriteOrUnfavorite(_ sender: UIButton) {
        
        self.isFavorite = !self.isFavorite
        
    }
    
}
