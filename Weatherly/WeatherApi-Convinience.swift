//
//  WeatherApi-Convinience.swift
//  Weatherly
//
//  Created by Arsalan Akhtar on 17/01/2016.
//  Copyright © 2016 Arsalan Akhtar. All rights reserved.
//

import Foundation

extension WeatherApi {

    
    func getWeather(lat:Double,lon:Double, completionHandler:(success:Bool, result:AnyObject?, errorString:String?) -> Void) {
        
        let parameters = [
            
            WeatherApi.Keys.APP_ID : WeatherApi.Constants.AppID,
            WeatherApi.Keys.LATITUDE : lat,
            WeatherApi.Keys.LONGITUDE : lon,
            "units" : "imperial"
        ]
        
        WeatherApi.sharedInstance().taskForResource("", parameters: parameters as! [String : AnyObject]){  JSONResult, error  in
            
            if let _ = error
            {
                
                completionHandler(success: false, result: nil, errorString: "Can not find weather for location")
                
            }
            else
                
            {
                
                let jsonResultDictionary = JSONResult as! NSDictionary
                
                if jsonResultDictionary.valueForKey("cod") as? NSNumber == WeatherApi.Values.SUCCESS_CODE
                    
                {
                    completionHandler(success: true, result: JSONResult, errorString: nil)
                }
                    
                else
                    
                {
                    let error = NSError(domain: "Weather for Location Parsing. Cant find Location in \(JSONResult)", code: 0, userInfo: nil)
                    print(error)
                    completionHandler(success: false, result: nil, errorString: error.localizedDescription)
                    
                }
                
            }
        }
    }




}