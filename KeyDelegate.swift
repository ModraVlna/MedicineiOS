//
//  KeyDelegate.swift
//  XMLMedicine
//
//  Created by Denis Dagidir on 22/04/2018.
//  Copyright © 2018 Denis Dagidir. All rights reserved.
//

import Foundation


protocol KeyDelegate{
    var userDefaults:UserDefaults {get}
    var key:String {get}
    func start()
    func end()
}



