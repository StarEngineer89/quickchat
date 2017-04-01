//
//  AddPostViewController.swift
//  GOT
//
//  Created by Kenneth Okereke on 3/31/17.
//  Copyright © 2017 Mexonis. All rights reserved.
//

import UIKit
import Firebase
import MobileCoreServices
import AVFoundation

class AddPostViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var itsfreelabel: UILabel! {
        didSet {
            self.itsfreelabel.alpha = 0
        }
    }
    
    
    
    
    @IBOutlet weak var postImageView: UIImageView! {
        didSet{
            self.postImageView.alpha = 0
        }
        
    }
    
    @IBOutlet weak var postSwitch: UISwitch!
    @IBOutlet weak var freeswitch: UISwitch!
    
    var netService = NetworkingServices()
    
    var videoURL: NSURL! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func postSwitchAction(_ sender: UISwitch) {
        
        if postSwitch.isOn {
            UIView.animate(withDuration: 0.5, animations: {
                self.postImageView.alpha = 1.0
            })
        }else {
            UIView.animate(withDuration: 0.5, animations: {
                self.postImageView.alpha = 0
            })
        }
        
    }
    
    @IBAction func freeswitch(_sender: UISwitch) {
        if freeswitch.isOn {
            UIView.animate(withDuration: 0.5, animations: {
                self.itsfreelabel.alpha = 1.0
            })
        }else {
            UIView.animate(withDuration: 0.5, animations: {
                self.itsfreelabel.alpha = 0
            })
        }
    }
    
    @IBAction func choosePostPicture(_ sender: UITapGestureRecognizer) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        
        pickerController.mediaTypes = [kUTTypeMovie as String]
        
        
        let alertController = UIAlertController(title: "Add a Media", message: "Choose From", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            pickerController.sourceType = .camera
            self.present(pickerController, animated: true, completion: nil)
            
        }
        let photosLibraryAction = UIAlertAction(title: "Media Library", style: .default) { (action) in
            pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true, completion: nil)
            
        }
        
        let savedPhotosAction = UIAlertAction(title: "Saved Photos Album", style: .default) { (action) in
            pickerController.sourceType = .savedPhotosAlbum
            self.present(pickerController, animated: true, completion: nil)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alertController.addAction(cameraAction)
        alertController.addAction(photosLibraryAction)
        alertController.addAction(savedPhotosAction)
        alertController.addAction(cancelAction)
        
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    
    
    
    func getThumbnail(_ videoURL: URL) -> UIImage! {
        do {
            let asset = AVURLAsset(url: videoURL , options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            
            return thumbnail
            
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
        }
        return nil
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.dismiss(animated: true, completion: nil)
        
        self.postImageView.image = nil
        self.videoURL = nil
        
        if let chosenvideo = info[UIImagePickerControllerMediaURL] as? NSURL {
            print("Here's the file url", chosenvideo)
            
            if let chosenImage = self.getThumbnail(chosenvideo as URL) {
                self.postImageView.image = chosenImage
            }
            else {
                self.postImageView.image = UIImage(named: "Video-thumb")
            }
            
            self.videoURL = chosenvideo
        }
        
        
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.postImageView.image = chosenImage
        }
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savePost(_ sender: CustomizableButtons) {
        
        SwiftLoader.show(animated: true)
        
        self.view.endEditing(true)
        
        let postText = postTextView.text ?? ""
        
        let postId = NSUUID().uuidString
        let postDate = NSDate().timeIntervalSince1970 as NSNumber
        
        if postSwitch.isOn {
            
            guard let image = self.postImageView.image else {
                SwiftLoader.hide()
                return
            }
            
            if let imageData = UIImageJPEGRepresentation(image, CGFloat(0.35)) {
                
                self.netService.uploadImageToFirebase(postId: postId, imageData: imageData, completion: { (imgUrl) in
                    
                    if let url = self.videoURL {
                        
                        self.netService.uploadVideoToFirebase(postId: postId, videoURL: url, completion: { (vUrl) in
                            
                            let post = Post(postId: postId, userId: FIRAuth.auth()!.currentUser!.uid, postText: postText, postVideoURL: String(describing:vUrl), postImageURL: String(describing:imgUrl), postDate: postDate, type:"VIDEO")
                            
                            self.netService.savePostToDB(post: post, completed: {
                                
                                SwiftLoader.hide()
                                
                                self.dismiss(animated: true, completion: nil)
                            })
                            
                        })
                        
                    }
                    else {
                        
                        let post = Post(postId: postId, userId: FIRAuth.auth()!.currentUser!.uid, postText: postText, postImageURL: String(describing:imgUrl), postDate: postDate, type:"IMAGE")
                        
                        self.netService.savePostToDB(post: post, completed: {
                            
                            SwiftLoader.hide()
                            
                            self.dismiss(animated: true, completion: nil)
                        })
                    }
                    
                })
            }
            
        } else {
            
            let post = Post(postId: postId, userId: FIRAuth.auth()!.currentUser!.uid, postText: postText, postImageURL: "", postDate: postDate, type: "TEXT")
            self.netService.savePostToDB(post: post, completed: {
                
                SwiftLoader.hide()
                
                self.dismiss(animated: true, completion: nil)
            })
            
        }
        
    }
    
}


    

   


