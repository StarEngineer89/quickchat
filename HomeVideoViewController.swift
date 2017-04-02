//
//  HomeVideoViewController.swift
//  GOT
//
//  Created by Kenneth Okereke on 3/31/17.
//  Copyright © 2017 Mexonis. All rights reserved.
//

import UIKit
import Firebase

class HomeVideoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var databaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    
    @IBOutlet weak var tableView: UITableView!
    var postsArray = [Post]()
    var netservice = NetworkingServices()
    
    override func viewDidLoad() {
        super.viewDidLoad()
          fetchAllPosts()
        // Do any additional setup after loading the view.
    }
    
    private func fetchAllPosts(){
        netservice.fetchAllPosts {(posts) in
            self.postsArray = posts
            self.postsArray.sort(by: { (post1, post2) -> Bool in
                Int(post1.postDate) > Int(post2.postDate)
            })
            
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    struct CellIdentifiers {
        var postimage = "imageCell"
        var posttext = "textCell"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if postsArray[indexPath.row].type == "IMAGE" {
          let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers().postimage, for: indexPath) as! PostimageTableViewCell
            cell.configureCell(post: postsArray[indexPath.row])
            return cell
        } else if postsArray[indexPath.row].type == "VIDEO" {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers().postimage, for: indexPath) as! PostimageTableViewCell
            cell.configureCell(post: postsArray[indexPath.row])
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers().posttext, for: indexPath) as! TextTableViewCell
            cell.configureCell(post: postsArray[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    }

}
