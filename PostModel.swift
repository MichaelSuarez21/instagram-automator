//
//  PostModel.swift
//  Reddit Approver
//
//  Created by Michael Suarez on 8/8/20.
//  Copyright © 2020 Michael Suarez. All rights reserved.
//

import Foundation

class PostModel: NSObject {
    
    //properties
    
    var id: String?
    var title: String?
    var postID: String?
    var url: String?
    var created: String?
    var user: String?
    
    
    //empty constructor
    
    override init()
    {
        
    }
    
    //construct with @name, @address, @latitude, and @longitude parameters
    
    init(id: String, title: String, postID: String, url: String, created: String, user: String) {
        
        self.id = id
        self.title = title
        self.postID = postID
        self.url = url
        self.created = created
        self.user = user
        
    }
    
    
    //prints object's current state
    
    override var description: String {
        return "ID: \(id), Title: \(title), postID: \(postID), URL: \(url), Created: \(created), User: \(user)"
        
    }
    
    
}
