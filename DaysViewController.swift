//
//  DaysViewController.swift
//  XMLMedicine
//
//  Created by Denis Dagidir on 22/04/2018.
//  Copyright © 2018 Denis Dagidir. All rights reserved.
//

import UIKit

class DaysViewController: UITableViewController {
    
    var days:[Int]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //exists the dayview
        performSegue(withIdentifier: Path.exitDay, sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //when the user selects a field, a checked symbol appears
    //when the user selects the field again, the checked symbol disappers
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let field = tableView.cellForRow(at: indexPath)!
        
        if let position = days.index(of: (indexPath.row + 1)){
            days.remove(at: position)
            field.setSelected(true, animated: true)
            field.setSelected(false, animated: true)
            field.accessoryType = UITableViewCellAccessoryType.none
        } else {
            days.append(indexPath.row + 1)
            field.setSelected(true, animated: true)
            field.setSelected(true, animated: true)
            field.accessoryType = UITableViewCellAccessoryType.checkmark
        }
        
    }
}


extension DaysViewController{
    //returns a string that the user selected
    static func displayDay(days: [Int] ) -> String{
        var dateString = String()
        
        if days.count == 1 {
            dateString = "Every day"
        }
        
        if days.isEmpty {
            dateString = "Only once"
        }
        
        return dateString
    }
}


















