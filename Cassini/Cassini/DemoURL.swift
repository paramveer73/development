//
//  DemoURL.swift
//  Cassini
//
//  Created by Paramveer  on 2020-01-27.
//  Copyright © 2020 Paramveer . All rights reserved.
//

import Foundation

struct DemoURL
{
    static let localIMG = Bundle.main.url(forResource: "oval", withExtension: "jpg")
    
    static var NASA: Dictionary<String,URL> = {
        let NASAURLStrings = [
            "Cassini" : "https://www.jpl.nasa.gov/images/cassini/20090202/pia03883-full.jpg",
            "Earth": "https://www.jpl.nasa.gov/spaceimages/images/largesize/PIA23408_hires.jpg",
            "Saturn": "https://www.jpl.nasa.gov/spaceimages/images/largesize/PIA23535_hires.jpg"
        ]
        var urls = Dictionary<String, URL>()
        for(key,value) in NASAURLStrings{
            urls[key] = URL(string:value)
        }
        return urls
    }()
    
    
}
