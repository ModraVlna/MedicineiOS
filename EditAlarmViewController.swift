//
//  EditAlarmViewController.swift
//  XMLMedicine
//
//  Created by Denis Dagidir on 22/04/2018.
//  Copyright © 2018 Denis Dagidir. All rights reserved.
//

import Foundation
import UIKit

class EditAlarmViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var infoTableView: UITableView!
    
    //infoTableView
    
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    //datePicker
    
    var alarm:Alarms = Alarms()
    var enabled:Bool!
    var enabledSnooze:Bool = false;
    var transfer:Transfer!
    var alarmTime:TimeDelegate = AlarmNotification()
    var snoozeEnabled: Bool = false
    
    override func viewDidLoad() {
                super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //returns the number of fields in the tablevView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else {
            return 1
        }
        
    }
    
    //display the information in the table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var field = tableView.dequeueReusableCell(withIdentifier: Path.setMedicine)
        if (field == nil){
            field = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: Path.setMedicine)
        }
        
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                field!.textLabel!.text = "Name"
                field!.detailTextLabel?.text = transfer.name
                field!.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            }
            else if indexPath.row == 1 {
                field!.textLabel!.text = "Amount"
                field!.detailTextLabel?.text = transfer.amount
                field!.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            }
            else if indexPath.row == 2 {
                field!.textLabel!.text = "Repeat every day"
               // field!.detailTextLabel!.text = DaysViewController.displayDay(days: transfer.days)
                //field!.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
                
                
            }
        }
        return field!
    }
    
    //notifies when the view is about to be added
    override func viewWillAppear(_ animated: Bool) {
        alarm=Alarms()
        infoTableView.reloadData()
        
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     When the save button is clicked, the user gets a request to allow local notifications.
     This method saves all of the information the user choosed
     */
    @IBAction func onClickedSave(sender: AnyObject) {
        print("Saved")
        var newAlarm = Alarm()
        
        
        let timeDate = AlarmNotification.formatNextPart(date: datePicker.date)
        
        let newId = transfer.id
        
        newAlarm.date = timeDate
        
        newAlarm.uuid = UUID().uuidString
        newAlarm.name = transfer.name
        newAlarm.amount = transfer.amount
        newAlarm.enabled = true
        newAlarm.days = transfer.days
        
        if transfer.edit{
            alarm.alarms[newId] = newAlarm
        }
        else {
            alarm.alarms.append(newAlarm)
        }
        self.performSegue(withIdentifier: Path.saveMedicine, sender: self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if transfer.edit{
            return 2
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let field = tableView.cellForRow(at: indexPath)
        if indexPath.section == 0 {
            switch indexPath.row{
                
            case 0:
                performSegue(withIdentifier: Path.nameOfMedicine, sender: self)
                field?.setSelected(true, animated: false)
                field?.setSelected(false, animated: false)
                
            case 1:
                performSegue(withIdentifier: Path.amountOfMedicine, sender: self)
                field?.setSelected(true, animated: false)
                field?.setSelected(false, animated: false)
              
            /*
            case 2:
                performSegue(withIdentifier: Path.chooseDay, sender: self)
                field?.setSelected(true, animated: false)
                field?.setSelected(false, animated: false)
            */
                
            default:
                break
            }
        }
        
    }
    
    
    //prepares for segue into another view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Path.saveMedicine{
            let newView = segue.destination as! MasterViewController
            
            let fields = newView.tableView.visibleCells
           alarmTime.newNotification()
        }
        
        
        if segue.identifier == Path.nameOfMedicine{
            let newView = segue.destination as! NameViewController
            newView.name = transfer.name
        }
        else if segue.identifier == Path.amountOfMedicine{
            let newView = segue.destination as! AmountViewController
            newView.amount = transfer.amount
        }
        else if segue.identifier == Path.chooseDay{
            let newView = segue.destination as! DaysViewController
            newView.days = transfer.days
        }
        
    }
    
    
    @IBAction func unwindFromLabelEditView(_ segue: UIStoryboardSegue) {
        let src = segue.source as! NameViewController
        transfer.name = src.name
    }
    
    @IBAction func unwindFromAmountEditView(_ segue: UIStoryboardSegue) {
        let src = segue.source as! AmountViewController
        transfer.amount = src.amount
    }
    
    
    @IBAction func unwindFromWeekdaysView(_ segue: UIStoryboardSegue) {
        let src = segue.source as! DaysViewController
        transfer.days = src.days
    }
    
}









