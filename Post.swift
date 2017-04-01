//
//  Post.swift
//  GOT
//
//  Created by Kenneth Okereke on 3/31/17.
//  Copyright © 2017 Mexonis. All rights reserved.
//

import Foundation
import Firebase

struct Post {
    
    var postId: String!
    var userId: String!
    var postText: String
    var postImageURL: String
    var postVideoURL: String
    var postDate: NSNumber
    var ref: FIRDatabaseReference!
    var key: String = ""
    var type: String = "TEXT" // "VIDEO"
    
    init(postId: String,userId: String,postText: String , postVideoURL: String = "", postImageURL: String, postDate: NSNumber, key: String = "", type:String = "TEXT") {
        self.postId = postId
        self.postDate = postDate
        self.postText = postText
        self.postImageURL = postImageURL
        self.postVideoURL = postVideoURL
        self.postId = postId
        self.userId = userId
        self.type = type
        self.ref = FIRDatabase.database().reference()
    }
    
    init(snapshot:FIRDataSnapshot!) {
        self.postId = (snapshot.value! as! NSDictionary)["postId"] as! String
        self.postDate = (snapshot.value! as! NSDictionary)["postDate"] as! NSNumber
        self.postText = (snapshot.value! as! NSDictionary)["postText"] as? String ?? ""
        self.postImageURL = (snapshot.value! as! NSDictionary)["postImageURL"] as? String ?? ""
        self.postVideoURL = (snapshot.value! as! NSDictionary)["postVideoURL"] as? String ?? ""
        self.userId = (snapshot.value! as! NSDictionary)["userId"] as! String
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.type = (snapshot.value! as! NSDictionary)["type"] as? String ?? "TEXT"
        
    }
    
    func toAnyObject()->[String: Any] {
        return ["postId": self.postId,
                "postDate": self.postDate,
                "postText": self.postText,
                "postVideoURL": self.postVideoURL,
                 "postImageURL": self.postImageURL,
                "userId": self.userId,
                "type": self.type]
    }
    
    
}

