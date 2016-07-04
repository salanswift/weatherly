//
//  WeatherApi-Constants.swift
//  Weatherly
//
//  Created by Arsalan Akhtar on 17/01/2016.
//  Copyright © 2016 Arsalan Akhtar. All rights reserved.
//

import Foundation

extension WeatherApi {
    
    struct Constants {
        
        // MARK: - URLs
        static let AppID = "0dcfead72fc7e969e5dfe0e1b3bc7df5"
        static let BaseUrl = "http://api.openweathermap.org/data/2.5/weather"
        
    }
    
    struct Resources {
      
        
        // MARK: - Extras
        static let EXTRAS = "data/2.5/weather"
    }
    
    struct Keys {
        static let METHOD           = "method"
        static let APP_ID           = "appid"
        static let TEMP_MAX         = "temp_max"
        static let TEMP_MIN         = "temp_min"
        static let WEATHER          = "weather"
        static let MAIN             = "main"
        static let HUMIDITY         = "humidity"
        static let PRESSURE         = "pressure"
        static let COUNTRY          = "country"
        static let NAME             = "name"
        static let SUNRISE          = "sunrise"
        static let SUNSET           = "sunset"
        static let DESCRIPTION      = "description"
        static let LATITUDE         = "lat"
        static let LONGITUDE        = "lon"
        
    }
    
    struct Values {
        static   let SUCCESS_CODE = 200

    
    }
   
}