//
//  Alarm.swift
//  XMLMedicine
//
//  Created by Denis Dagidir on 22/04/2018.
//  Copyright © 2018 Denis Dagidir. All rights reserved.
//

import Foundation

struct Alarm: ReflectionDelegate {
    
    var uuid:String = "" //unique value
    var name:String = "Medicine"
    var amount:String = "Number"
    var date:Date = Date()
    var days: [Int] = []
    var enabled:Bool = false
    var snoozeEnabled:Bool = false
    var onSnooze:Bool = false
    var mediaLabel: String = "bell"
    
    
    
    init(){
        
    }
    
    init(uuid:String, name:String, amount:String, date:Date, days:[Int], enabled:Bool, snoozeEnabled:Bool, onSnooze:Bool, mediaLabel:String){
        
        self.uuid = uuid
        self.name = name
        self.amount = amount
        self.date = date
        self.days = days
        self.enabled = enabled
        self.snoozeEnabled = snoozeEnabled
        self.onSnooze = onSnooze
        self.mediaLabel = mediaLabel
        
        
        
    }
    
    init(_ dictionary: ReflectionDelegate.Reflection) {
        uuid = dictionary["uuid"] as! String
        name = dictionary["name"] as! String
        amount = dictionary["amount"] as! String
        date = dictionary["date"] as! Date
        days = dictionary["days"] as! [Int]
        mediaLabel = dictionary["mediaLabel"] as! String
        enabled = dictionary["enabled"] as! Bool
        snoozeEnabled = dictionary["snoozeEnabled"] as! Bool
        onSnooze = dictionary["onSnooze"] as! Bool
        
        
        
    }
    
    static var numberOfAtributes:Int = 9
}

extension Alarm{
    //formats the date
    var time:String{
        let timeDate = DateFormatter()
        timeDate.dateFormat = "h:mm a" //hours, minutes, am or pm
        return timeDate.string(from: self.date)
    }
}

class Alarms:KeyDelegate{
    
    let userDefaults:UserDefaults = UserDefaults.standard
    let key:String = "key"
    var alarms: [Alarm] = []{
        didSet{
            start()
        }
    }
    
    
    func getAlarmsReflection() -> [ReflectionDelegate.Reflection]{
        //loops over the collection and applies the same operation to each element
        return alarms.map{$0.reflection}
    }
    
    init(){
        alarms = getAlarms()
    }
    
    func start() {
        userDefaults.set(getAlarmsReflection(), forKey: key)
        userDefaults.synchronize();
    }
    
    func end() {
        for def in userDefaults.dictionaryRepresentation().keys{
            UserDefaults.standard.removeObject(forKey: def.description)
        }
    }
    
    var amount:Int{
        return alarms.count
    }
    
    //returns alarams
    private func getAlarms() -> [Alarm]{
        let store = UserDefaults.standard.array(forKey: key)
        guard let storeAlarm = store
            else {
                return [Alarm]()
        }
        
        if let open = storeAlarm as? [ReflectionDelegate.Reflection]{
            if open.first?.count == Alarm.numberOfAtributes{
                return open.map{Alarm($0)}
            }
        }
        end()
        return [Alarm]()
    }
}


































