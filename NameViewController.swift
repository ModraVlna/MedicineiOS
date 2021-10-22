//
//  NameViewController.swift
//  XMLMedicine
//
//  Created by Denis Dagidir on 22/04/2018.
//  Copyright © 2018 Denis Dagidir. All rights reserved.
//

import UIKit

class NameViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var nameTextField: UITextField!
    var name:String!
    
    //nameTextField
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.becomeFirstResponder() //when the window opens, the cursor in the textfield
        self.nameTextField.delegate = self //press enter
        nameTextField.text = name // to string
        nameTextField.returnKeyType = UIReturnKeyType.done //finish
        nameTextField.enablesReturnKeyAutomatically = true
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //return to the main window
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        name = textField.text!
        performSegue(withIdentifier: Path.labelUnwindIdentifier, sender: self)
        
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

