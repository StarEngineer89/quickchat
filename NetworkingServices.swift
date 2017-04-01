//
//  NetworkingServices.swift
//  GOT
//
//  Created by Kenneth Okereke on 3/31/17.
//  Copyright © 2017 Mexonis. All rights reserved.
//

import Foundation
import Firebase


struct NetworkingServices {
    var databaseRef: FIRDatabaseReference! {
        
        return FIRDatabase.database().reference()
    }
    
    var storageRef: FIRStorageReference! {
        
        return FIRStorage.storage().reference()
    }
    
    func fetchPostUserInfo(forUserID: String, completion: @escaping (User?)->()){
       
        //let currentUser = FIRAuth.auth()!.currentUser!
        let userRef = databaseRef.child("user").child(forUserID).child("credentials")
        
        userRef.observeSingleEvent(of: .value, with: { (currentUser) in
            
            let user: User = User(snapshot: currentUser)
            completion(user)
            
            
            
            
        }) { (error) in
            print(error.localizedDescription)
            
        }
        
        
    }
    
    func uploadVideoToFirebase(postId: String, videoURL: NSURL, completion: @escaping (URL)->()){
        
        let postImagePath = "postImages/\(postId)video.mov"
        let postImageRef = storageRef.child(postImagePath)
        
        
        postImageRef.putFile(videoURL as URL, metadata: nil) { (metadata, error) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                if let postVideoURL = metadata?.downloadURL() {
                    completion(postVideoURL)
                }
            }
        }
        
    }
    
    
    func uploadImageToFirebase(postId: String, imageData: Data, completion: @escaping (URL)->()){
        
        let postImagePath = "postImages/\(postId)image.jpg"
        let postImageRef = storageRef.child(postImagePath)
        let postImageMetadata = FIRStorageMetadata()
        postImageMetadata.contentType = "image/jpeg"
        
        
        postImageRef.put(imageData, metadata: postImageMetadata) { (newPostImageMD, error) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                if let postImageURL = newPostImageMD?.downloadURL() {
                    completion(postImageURL)
                }
            }
        }
        
    }

    
    func savePostToDB(post: Post, completed: @escaping ()->Void){
        
        let postRef = databaseRef.child("Gotposts").childByAutoId()
        postRef.setValue(post.toAnyObject()) { (error, ref) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                let alertView = SCLAlertView()
                _ = alertView.showSuccess("Success", subTitle: "Post saved successfuly", closeButtonTitle: "Done", duration: 4, colorStyle: UIColor(colorWithHexValue: 0x3D5B94), colorTextButton: UIColor.white)
                completed()
            }
        }
        
    }
    
    func fetchAllPosts(completion: @escaping ([Post])->()){
        
        let postsRef = databaseRef.child("Gotposts")
        postsRef.observe(.value, with: { (Gotposts) in
            
            var resultArray = [Post]()
            for post in Gotposts.children {
                
                let post = Post(snapshot: post as! FIRDataSnapshot)
                resultArray.append(post)
            }
            completion(resultArray)
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    
    
    
    
    
    

}
