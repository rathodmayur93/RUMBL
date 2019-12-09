//
//  Utility.swift
//  RUMBL
//
//  Created by ds-mayur on 12/9/19.
//  Copyright © 2019 Mayur Rathod. All rights reserved.
//

import Foundation

struct Utility {
    
    static func readJSONFromFile(fileName : String) -> [ContentModel]? {
        
        var json: [ContentModel]?
        
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                //Creating the URL from Path
                let fileUrl = URL(fileURLWithPath: path)
               
                // Getting data from JSON file using the file URL
                let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
                
                //Converting the json data into the ContentModel
                json = try? JSONDecoder().decode([ContentModel].self, from: data)
                
            } catch {
                /*
                  - Handle error here
                  - Invalid json format
                */
                
            }
        }
        return json
    }
}
