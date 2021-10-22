//
//  AmountViewController.swift
//  XMLMedicine
//
//  Created by Denis Dagidir on 26/04/2018.
//  Copyright © 2018 Denis Dagidir. All rights reserved.
//

import UIKit

class AmountViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var amountTextField: UITextField!
    
    var amount:String!
    
    //amountTextField
    
    override func viewDidLoad() {
        super.viewDidLoad()
        amountTextField.becomeFirstResponder() ///when the window opens, the cursor in the textfield
        self.amountTextField.delegate = self //press enter
        amountTextField.text = amount // to string
        amountTextField.returnKeyType = UIReturnKeyType.done //finish
        amountTextField.enablesReturnKeyAutomatically = true
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //return to the main window
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        amount = textField.text!
        performSegue(withIdentifier: Path.amountUnwindidentifier, sender: self)
        return false
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

