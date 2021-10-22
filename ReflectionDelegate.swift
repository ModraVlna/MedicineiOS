//
//  ReflectionDelegate.swift
//  XMLMedicine
//
//  Created by Denis Dagidir on 22/04/2018.
//  Copyright © 2018 Denis Dagidir. All rights reserved.
//


import Foundation

protocol ReflectionDelegate{
    typealias Reflection = [String:Any]
    typealias Name = [String]
    typealias Value = [Any]
    
    var reflection:Reflection {get}
    var name:Name {get}
    var value:Value {get}
    static var numberOfAtributes: Int {get}
    
    init(_ reflect:Reflection)
}

extension ReflectionDelegate{
    var reflection: Reflection{
        var update: [String:Any] = [:] // an empty dictionary literal
        
        for case let (name, value) in Mirror(reflecting:self).children{
            guard let cName = name
                else{
                    continue
            }
            update.updateValue(value, forKey: cName)
        }
        return update
    }
    
    var name:Name{
        return Array(reflection.keys)
    }
    
    var value:Value{
        return Array(reflection.values)
    }
    
}


























