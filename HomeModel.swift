//
//  HomeModel.swift
//  Reddit Approver
//
//  Created by Michael Suarez on 8/8/20.
//  Copyright © 2020 Michael Suarez. All rights reserved.
//

import Foundation

protocol HomeModelProtocol: class {
    func itemsDownloaded(items: NSArray)
}


class HomeModel: NSObject, URLSessionDataDelegate {
    
    //properties
    func parseJSON(_ data:Data) {
           
           var jsonResult = NSArray()
           
           do{
               jsonResult = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
               
           } catch let error as NSError {
               print(error)
               
           }
           
           var jsonElement = NSDictionary()
           let posts = NSMutableArray()
           
           for i in 0 ..< jsonResult.count
           {
               
               jsonElement = jsonResult[i] as! NSDictionary
               print(jsonResult[i])
               
               let post = PostModel()
               
               //the following insures none of the JsonElement values are nil through optional binding
               if let id = jsonElement["id"] as? String,
                   let title = jsonElement["title"] as? String,
                   let postID = jsonElement["postID"] as? String,
                   let url = jsonElement["url"] as? String,
                   let created = jsonElement["created"] as? String,
                   let user = jsonElement["user"] as? String
               {
                   
                   post.id = id
                   post.title = title
                   post.postID = postID
                   post.url = url
                   post.created = created
                   post.user = user
            
               }
               
               posts.add(post)
               
           }
           
           DispatchQueue.main.async(execute: { () -> Void in
               
               self.delegate.itemsDownloaded(items: posts)
               
           })
       }
    
    
    weak var delegate: HomeModelProtocol!
    
    let urlPath = "https://your_websites_url.com/grab_posts.php" //path to grab_posts.php
 
    func downloadItems() {
        
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.ephemeral)
        
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                print("Failed to download data")
            }else {
                print("Data downloaded")
                self.parseJSON(data!)
            }
            
        }
        
        task.resume()
    }
}
