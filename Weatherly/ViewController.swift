//
//  ViewController.swift
//  Weatherly
//
//  Created by Arsalan Akhtar on 17/01/2016.
//  Copyright © 2016 Arsalan Akhtar. All rights reserved.
//

import UIKit

import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var mainTempLbl: UILabel!
    
    @IBOutlet weak var descriptionLbl: UILabel!
    
    @IBOutlet weak var humidityLbl: UILabel!
    
    @IBOutlet weak var pressureLbl: UILabel!
    
    @IBOutlet weak var minTempLbl: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var maxTempLbl: UILabel!
    
    @IBOutlet weak var unitSelectorSegment: UISegmentedControl!
    
    var localWeather:Weather?
    var manager: LocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
     
      /* Create and set the logout button */
        self.navigationItem.rightBarButtonItems =  [UIBarButtonItem(barButtonSystemItem: .Bookmarks, target: self, action: "historyButtonTouchUp"),UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "saveButtonTouchUp")]
        
       
        self.navigationItem.leftBarButtonItem =  UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "refreshButtonTouchUp")
        
        unitSelectorSegment.selectedSegmentIndex = getUserSelectedUnit()
        
        
       fetchLocationAndUpdate()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func downloadAndUpdate(lat:Double,lon:Double)
    {
       WeatherApi.sharedInstance().getWeather(lat, lon: lon) {
            
            success , result, errorString  in
            
            if  success
            {
                    dispatch_async(dispatch_get_main_queue()) {
                  
                    let dictionary = result as! NSDictionary
                    
                    let weatherDictionary = dictionary.objectForKey(WeatherApi.Keys.WEATHER) as! [[String : AnyObject]]
             
                    let mainDictionary = dictionary.objectForKey(WeatherApi.Keys.MAIN) as! [String : AnyObject]

                    let mainObj : Main = Main(dictionary: mainDictionary, context: self.sharedContext)
                    
                    let weatherObj : Weather = Weather(dictionary: weatherDictionary[0], context: self.sharedContext)
                    
                    weatherObj.mainDetails = mainObj
                        
                   self.localWeather = weatherObj
                        
                    self.updateView(weatherObj)
                        self.hideShowActivityIndicator(false)
                }
                
            } else {
                print(errorString)
                dispatch_async(dispatch_get_main_queue()) {
                    self.alert(errorString!)
                self.hideShowActivityIndicator(false)
                }
            }
        }
    }

    // MARK: - Core Data Convenience
    
    lazy var sharedContext: NSManagedObjectContext =  {
        return CoreDataStackManager.sharedInstance().managedObjectContext!
        }()
    
    func saveContext() {
        CoreDataStackManager.sharedInstance().saveContext()
    }
    
    func refreshButtonTouchUp() {
        
        fetchLocationAndUpdate()
        
    }
    
    func historyButtonTouchUp() {
        let controller =
        storyboard!.instantiateViewControllerWithIdentifier("WeatherHistoryViewController") as!WeatherHistoryViewController
        
        self.navigationController!.pushViewController(controller, animated: true)
    }

    func saveButtonTouchUp(){
    saveContext()
    }
    
    func fetchLocationAndUpdate(){
        
        hideShowActivityIndicator(true)
        
        manager = LocationManager()
        manager!.fetchWithCompletion {location, error in
            // fetch location or an error
            if let _ = location {
                
                self.downloadAndUpdate((location?.coordinate.latitude)!,lon:(location?.coordinate.longitude)!)
                
            } else if let err = error {
                print(err.localizedDescription)
                dispatch_async(dispatch_get_main_queue()) {
                self.hideShowActivityIndicator(false)
                }
            }
            self.manager = nil
        }
    }
    
    func updateView(weather:Weather){
    
        mainTempLbl.text    = String(format: "%.2f\u{00B0} %@", (Weather.convertToUserDefinedUnit(weather.mainDetails!.temp )as Float),Weather.usersSelectedUnit())
        descriptionLbl.text = weather.descriptions
        humidityLbl.text    = "\(weather.mainDetails!.humidity) %"
        pressureLbl.text    = "\(weather.mainDetails!.pressure) hPa"
        minTempLbl.text     = String(format: "%.2f\u{00B0} %@",  (Weather.convertToUserDefinedUnit( weather.mainDetails!.tempMin )as Float),Weather.usersSelectedUnit())
        maxTempLbl.text     = String(format: "%.2f\u{00B0} %@",(Weather.convertToUserDefinedUnit (weather.mainDetails!.tempMax )as Float),Weather.usersSelectedUnit())
    }
    
    func hideShowActivityIndicator(show:Bool){
    
        activityIndicator.hidden = !show
        if show{
        activityIndicator.startAnimating()
        }else{
        activityIndicator.stopAnimating()
        }
    }
    
    func setUserSelectedUnit(index:Int){
//        0=Farenheit, 1= celcius, 2 = kelvin
        let prefs = NSUserDefaults.standardUserDefaults()
        prefs.setInteger(index, forKey: "userSelectedUnit")
    }
    
    func getUserSelectedUnit() ->Int{
        //        0=Farenheit, 1= celcius, 2 = kelvin
        let prefs = NSUserDefaults.standardUserDefaults()
        return prefs.integerForKey("userSelectedUnit")
    }
    
    @IBAction func changeUnitAction(sender: UISegmentedControl) {
        
        setUserSelectedUnit(sender.selectedSegmentIndex)
        
        if ((self.localWeather) != nil)
        {
            updateView(self.localWeather!)
        }
    }
    
    func convertToUserDefinedUnit(temp:NSNumber) -> NSNumber
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
    
    func alert(message:String){
        let alert = UIAlertController(title: "Error!", message:message , preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
   

}
