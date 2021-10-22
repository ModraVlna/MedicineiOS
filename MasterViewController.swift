//
//  MasterViewController.swift
//  XMLMedicine
//
//  Created by Denis Dagidir on 22/04/2018.
//  Copyright © 2018 Denis Dagidir. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    
    var alarm:Alarms = Alarms()
    var timeAlarm:TimeDelegate = AlarmNotification()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        timeAlarm.controlNotification()
        tableView.allowsSelectionDuringEditing = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        alarm = Alarms()
        tableView.reloadData()
        if alarm.amount != 0{
            self.navigationItem.leftBarButtonItem = editButtonItem
        } else {
            self.navigationItem.leftBarButtonItem = nil
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //returns the size of the list in the main window
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    //seperaters the lists
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if alarm.amount == 0{
            tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        } else {
            tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        }
        return alarm.amount
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isEditing {
            performSegue(withIdentifier: Path.editMedicine, sender: Transfer(id: indexPath.row, name: alarm.alarms[indexPath.row].name, amount: alarm.alarms[indexPath.row].amount, days: alarm.alarms[indexPath.row].days, edit: true, enabled: alarm.alarms[indexPath.row].enabled))
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: Path.cellMedicine)
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: Path.cellMedicine)
        }
        
        //displays the time and timezone, name, amount
        //the name of the medicine and the amount is set into a single string
        cell!.selectionStyle = .none
        cell!.tag = indexPath.row
        let clock: Alarm = alarm.alarms[indexPath.row]
        let zone: [NSAttributedStringKey : Any] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue) : UIFont.systemFont(ofSize: 20.0)]
        let toString = NSMutableAttributedString(string: clock.time, attributes: zone)
        let timeZone: [NSAttributedStringKey : Any] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue) : UIFont.systemFont(ofSize: 40.0)]
        toString.addAttributes(timeZone, range: NSMakeRange(0, toString.length-2))
        cell!.textLabel?.attributedText = toString
        
        cell!.detailTextLabel?.text = clock.name + " " + clock.amount + "x"
        
        
        if clock.enabled {
            cell!.backgroundColor = UIColor.white
            cell!.textLabel?.alpha = 4.0
            cell!.detailTextLabel?.alpha = 1.0
        } else {
            cell!.backgroundColor = UIColor.groupTableViewBackground
            cell!.textLabel?.alpha = 0.5
            cell!.detailTextLabel?.alpha = 0.5
        }
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        return cell!
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let position = indexPath.row
            alarm.alarms.remove(at:position)
            let cells = tableView.visibleCells
        }
        if alarm.amount == 0{
            self.navigationItem.leftBarButtonItem = nil
        }
        
        tableView.deleteRows(at: [indexPath], with: .fade)
        timeAlarm.newNotification()
        
    }
    
    //prepares for segue for adding or edditing the medicine
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let newView = segue.destination as! UINavigationController
        let editAlarm = newView.topViewController as! EditAlarmViewController
        if segue.identifier == Path.newMedicine {
            editAlarm.navigationItem.title = "Add Medicine"
            editAlarm.transfer = Transfer(id: alarm.amount, name: "Medicine", amount: "", days: [], edit: false, enabled: false)
        }
            
        else if segue.identifier == Path.editMedicine {
            editAlarm.navigationItem.title = "Edit Medicine"
            editAlarm.transfer = sender as! Transfer
        }
    }
    
    @IBAction func unwindFromEdit(_ segue: UIStoryboardSegue){
        isEditing = false
    }
    
}










