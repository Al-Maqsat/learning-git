//
//  Person.swift
//  Project 10
//
//  Created by Maksat Baiserke on 01.09.2022.
//

import UIKit

class Person: NSObject, Codable {
    var name: String
    var image: String
    
    init(name: String, image: String){
        self.name = name
        self.image = image
    }
}
