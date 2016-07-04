//
//  Main.swift
//  Weatherly
//
//  Created by Arsalan Akhtar on 10/02/2016.
//  Copyright © 2016 Arsalan Akhtar. All rights reserved.
//

import UIKit
// 1. Import CoreData
import CoreData

// 2. Make Main available to Objective-C code
//@objc(Main)

class Main : NSManagedObject {
    
    @NSManaged var temp:        NSNumber
    @NSManaged var pressure:    NSNumber
    @NSManaged var humidity:    NSNumber
    @NSManaged var tempMin:     NSNumber
    @NSManaged var tempMax:     NSNumber
    @NSManaged var seaLevel:    NSNumber
    @NSManaged var groundLevel: NSNumber
    
    
    struct Keys {
        static let Temp = "temp"
        static let Pressure = "pressure"
        static let Humidity = "humidity"
        static let TempMin = "temp_min"
        static let TempMax = "temp_max"
        static let SeaLevel = "sea_level"
        static let GroundLevel = "grnd_level"
        
      
    }
    
    
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String : AnyObject], context: NSManagedObjectContext) {
        
        // Core Data
        let entity =  NSEntityDescription.entityForName("Main", inManagedObjectContext: context)!
        
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        // Dictionary
        temp = dictionary[Keys.Temp] as! NSNumber
        pressure = dictionary[Keys.Pressure] as! NSNumber
        humidity = dictionary[Keys.Humidity] as! NSNumber
        tempMin = dictionary[Keys.TempMin] as! NSNumber
        tempMax = dictionary[Keys.TempMax] as! NSNumber
       
    }
    
    

    
}