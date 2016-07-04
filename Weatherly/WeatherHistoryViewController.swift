//
//  WeatherHistory.swift
//  Weatherly
//
//  Created by Arsalan Akhtar on 17/02/2016.
//  Copyright © 2016 Arsalan Akhtar. All rights reserved.
//


import UIKit
import MapKit
import CoreData

class WeatherHistoryViewController: UIViewController,UITableViewDelegate,NSFetchedResultsControllerDelegate {
    
    var history = [Weather]()
    
    
    // MARK: - Core Data Convenience. This will be useful for fetching. And for adding and saving objects as well.
    
    var sharedContext: NSManagedObjectContext {
  
        return CoreDataStackManager.sharedInstance().managedObjectContext!
    }
    
    func fetchAllWeather() -> [Weather] {
        let error: NSErrorPointer = nil
        
        // Create the Fetch Request
        let fetchRequest = NSFetchRequest(entityName: "Weather")
        
        // Execute the Fetch Request
        let results: [AnyObject]?
        do {
            results = try sharedContext.executeFetchRequest(fetchRequest)
        } catch let error1 as NSError {
            error.memory = error1
            results = nil
        }
        
        // Check for Errors
        if error != nil {
            print("Error in fectchAllWeather(): \(error)")
        }
        
        // Return the results, cast to an array of Weather objects
        return results as! [Weather]
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        history = fetchAllWeather()
       
        self.title = "History"
        
    }
    
    // MARK: - Table View
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let historyObj = history[indexPath.row] as Weather
        let CellIdentifier = "HistoryCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as! HistoryTableViewCell
        
        cell.descriptionLabel!.text = historyObj.descriptions
        
        cell.tempLabel.text = String(format: "%.2f\u{00B0} %@", (Weather.convertToUserDefinedUnit(historyObj.mainDetails!.temp )as Float),Weather.usersSelectedUnit())
        
        cell.humidityLabel.text = "\(historyObj.mainDetails!.humidity) %"
        cell.pressureLabel.text = "\(historyObj.mainDetails!.pressure) hPa"
        let formatter = NSDateFormatter()
        formatter.timeStyle = .MediumStyle
        formatter.dateStyle = .MediumStyle
        cell.dateLabel.text = formatter.stringFromDate(historyObj.timeStamp)
        
        
        
        return cell
    }
    
  override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

