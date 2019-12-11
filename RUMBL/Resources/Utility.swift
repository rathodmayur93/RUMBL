//
//  Utility.swift
//  RUMBL
//
//  Created by ds-mayur on 12/9/19.
//  Copyright © 2019 Mayur Rathod. All rights reserved.
//

import UIKit
import AVFoundation

struct Utility {
    
    //Loading thumbnail cache images
    fileprivate let imageCache              = NSCache<NSString, UIImage>()
    
    /*
     - This function will read the local json file
     - It will conver the json file into the ContentModel arrayList
    */
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
    
    /*
        - Calculate the collectionView thumbnail width
     */
    static func calculateWidthOfTheThumbnail(numberOfItems : CGFloat, margin : CGFloat) -> CGFloat{
        
        let screenSize      = UIScreen.main.bounds
        let screenWidth     = screenSize.width
        
        let totalMargin     = numberOfItems * margin
        let remainingWidth  = screenWidth - CGFloat(totalMargin)
        
        let thumbnailWidth  = remainingWidth / CGFloat(numberOfItems)
       
        return thumbnailWidth
    }
    
    /*
        - Calculate the height of the collection thumbnail
        - This function will assume that image ration is 16:9 depending on that it will calculate the heigth
     */
    static func calculateHeightOfTheThumbnail(width : CGFloat) -> CGFloat{
        
        //Ratio Of the IMage is 16 : 9 so will calculate height by multiplying width by 16 and divide it by 9
        let ratioWidth = 16.0 * width
        let height     = ratioWidth / 9.0
        
        return height
    }
    
    /*
        - Getting thumbnail from the video file
     */
    static func generateThumbnail(videoUrl: String) -> UIImage? {
        
        do {
            let url                                         = URL(string: videoUrl)
            let asset                                       = AVURLAsset(url: url!)
            let imageGenerator                              = AVAssetImageGenerator(asset: asset)
            imageGenerator.appliesPreferredTrackTransform   = true
            let cgImage                                     = try imageGenerator.copyCGImage(at: CMTime(seconds: 2.0, preferredTimescale: 60),
                                                                                             actualTime: nil)
            
            return UIImage(cgImage: cgImage)
            
        } catch {
            
            print(error.localizedDescription)
            return nil
        }
    }
}

