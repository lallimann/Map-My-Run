//
//  SettingViewController.swift
//  MapMyRun
//
//  Created by Lalli Mann on 15/03/18.
//  Copyright © 2018 c0727815. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController,UITextFieldDelegate  {

    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightTextfield: UITextField!
    @IBOutlet weak var inchesTextField: UITextField!
    @IBOutlet weak var feetTextfield: UITextField!
    
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    @IBAction func tapTouch(_ sender: Any) {
        weightTextfield.resignFirstResponder()
        feetTextfield.resignFirstResponder()
        inchesTextField.resignFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        if(UserDefaults.standard.double(forKey: "weight") == 0)
        {
            weightLabel.text = "WEIGHT:"
        }
        else
        {
            weightLabel.text = "WEIGHT: \(UserDefaults.standard.double(forKey: "weight"))" + " kg"
        }
        if(UserDefaults.standard.double(forKey: "height") == 0)
        {
            heightLabel.text = "HEIGHT:"
        }
        else
        {
            heightLabel.text = "HEIGHT: \(UserDefaults.standard.double(forKey: "height"))" + " inches"
        }
    }
    
    
    @IBAction func saveButtonAction(_ sender: Any) {
        
        if(weightTextfield.text == "" || feetTextfield.text == "" || inchesTextField.text == nil)
        {
            let alert = UIAlertController(title: "Fill All Fields", message: "", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            UserDefaults.standard.set(Double(weightTextfield.text!), forKey: "weight")
            
            let height = Double(inchesTextField.text!)! + Double(feetTextfield.text!)!*12
            
            UserDefaults.standard.set(height, forKey: "height")
            
            viewWillAppear(true)
        }
        
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
