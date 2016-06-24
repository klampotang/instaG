//
//  GenProfileViewController.swift
//  instaG
//
//  Created by Kelly Lampotang on 6/23/16.
//  Copyright © 2016 Kelly Lampotang. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class GenProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UINavigationControllerDelegate {

    var instaposts:[PFObject] = []
    var userClicked:PFUser?
    
    @IBOutlet weak var genCollectionView: UICollectionView!
    
    func getPFFileFromImage(image: UIImage?) -> PFFile? {
        // check if image is not nil
        if let image = image {
            // get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        genCollectionView.dataSource = self
        getUserPosts()
        //usernameLabel.text = PFUser.currentUser()?.username as String?
        
        /*
        //Check if a current profile picture already:
        let currUser = PFUser.currentUser()
        if(currUser!["ProfilePic"] == nil)
        {
            buttonSet.hidden = false
        }
        else
        {
            buttonSet.hidden = true
            let currUser = PFUser.currentUser()
            let profilePicFile = currUser!["ProfilePic"] as! PFFile
            profilePic.file = profilePicFile
            profilePic.loadInBackground()
            
            profilePic.layer.borderWidth = 1
            profilePic.layer.masksToBounds = false
            profilePic.layer.borderColor = UIColor.whiteColor().CGColor
            profilePic.layer.cornerRadius = profilePic.frame.height/2
            profilePic.clipsToBounds = true
            
            
            
        }*/
    }
    
   
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return instaposts.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("GenProfileCell", forIndexPath: indexPath) as! GenProfileCell
        
        let textPfObject = self.instaposts[indexPath.row]
        // get text string out of the pf object
        if (textPfObject.valueForKey("media") != nil) {
            cell.genProfileImages.file = textPfObject["media"] as? PFFile
            cell.genProfileImages.loadInBackground()
            
        }
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getUserPosts()
    {
        let query = PFQuery(className: "Post")
        query.includeKey("author")
        
        query.whereKey("author", equalTo: userClicked!)
        query.findObjectsInBackgroundWithBlock {(objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects {
                    self.instaposts = objects
                    self.genCollectionView.reloadData()
                    
                }
            } else {
                print("not working")
            }
        }
    }


}
