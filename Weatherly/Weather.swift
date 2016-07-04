//
//  Weather.swift
//  Weatherly
//
//  Created by Arsalan Akhtar on 10/02/2016.
//  Copyright © 2016 Arsalan Akhtar. All rights reserved.
//

import UIKit
// 1. Import CoreData
import CoreData

// 2. Make Weather available to Objective-C code
//@objc(Weather)

class Weather : NSManagedObject {
    
   

    @NSManaged var descriptions: String
    @NSManaged var main: String
    @NSManaged var mainDetails: Main?
    @NSManaged var timeStamp : NSDate
 
    struct Keys {
        static let Description = "description"
        static let Main = "main"
        }
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String : AnyObject], context: NSManagedObjectContext) {
        
        // Core Data
        let entity =  NSEntityDescription.entityForName("Weather", inManagedObjectContext: context)!
        
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        // Dictionary
        descriptions = dictionary[Keys.Description] as! String
        
        main = dictionary[Keys.Main] as! String
        
        timeStamp = NSDate()
        
    }
    
   class func convertToUserDefinedUnit(temp:NSNumber) -> NSNumber
    {
        var convertedTemp :NSNumber?
        switch (getUserSelectedUnit()) {
        case 1:
            convertedTemp = Double(temp.doubleValue - 32) * 5 / 9 as NSNumber // Farenheit to Celcius
            break;
        case 2:
            convertedTemp = Double(temp.doubleValue + 459.67) * 5 / 9 as NSNumber // Farenheit to Kelvin
            break;
        default:
            convertedTemp = temp
            break;
        }
        return convertedTemp!
    }
    
    
   class func usersSelectedUnit() -> String
    {
        var strUnit:String?
        switch (getUserSelectedUnit()) {
        case 1:
            strUnit = "C"
            break;
        case 2:
            strUnit = "K"
            break;
        default:
            strUnit = "F"
            break;
        }
        return strUnit!
        
    }
    
   class func getUserSelectedUnit() ->Int{
        //        0=Farenheit, 1= celcius, 2 = kelvin
        let prefs = NSUserDefaults.standardUserDefaults()
        return prefs.integerForKey("userSelectedUnit")
    }
}