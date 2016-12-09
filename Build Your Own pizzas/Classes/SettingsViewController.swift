//
//  SettingsViewController.swift
//  Build Your Own pizzas
//
//  Created by Frank Mao on 2016-12-09.
//  Copyright © 2016 mazoic. All rights reserved.
//

import UIKit

struct AppConstants {
    static let KeyForMaxNumberOfItemsToDisplay = "KeyForMaxNumberOfItemsToDisplay"
}

class SettingsViewController: UIViewController {

    @IBOutlet weak var stepper: UIStepper!
 
    @IBOutlet weak var numberLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        stepper.value = Double( UserDefaults.standard.integer(forKey: AppConstants.KeyForMaxNumberOfItemsToDisplay) )
        
        onValueChanged(stepper)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onValueChanged(_ sender: UIStepper) {
        
        numberLabel.text = String(format: "%.0f", sender.value)
        
        UserDefaults.standard.set(Int(sender.value), forKey: AppConstants.KeyForMaxNumberOfItemsToDisplay)
        UserDefaults.standard.synchronize()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
