//
//  ProfileViewController.swift
//  instaG
//
//  Created by Kelly Lampotang on 6/22/16.
//  Copyright © 2016 Kelly Lampotang. All rights reserved.
//

import UIKit
import ParseUI
import Parse

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UINavigationControllerDelegate {
    //reuse identifier for cell: ProfileCollCell
    @IBOutlet weak var profilePic: PFImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var buttonSet: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var instaposts:[PFObject] = []

    @IBAction func buttonSetProfPic(sender: AnyObject) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.Camera
        
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // Get the image captured by the UIImagePickerController
        //let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Do something with the images (based on your use case)
        profilePic.image = editedImage
        //Upload pic
        let currentUser = PFUser.currentUser()
        currentUser!.setObject(getPFFileFromImage(editedImage)!, forKey: "ProfilePic")
        currentUser!.saveInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if error != nil {
                print("failed")
            } else {
                print("YAY")
            }
        }
        buttonSet.hidden = true
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismissViewControllerAnimated(true, completion: nil)
    }
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
        collectionView.dataSource = self
        getUserPosts()
        usernameLabel.text = PFUser.currentUser()?.username as String?
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshPull(_:)), forControlEvents: UIControlEvents.ValueChanged)
        collectionView.insertSubview(refreshControl, atIndex: 0)
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
            
            
            
        }
    }
    
    func refreshPull(refreshControl: UIRefreshControl)
    {
        getUserPosts()
        // Reload the tableView now that there is new data
        self.collectionView.reloadData()
        
        // Tell the refreshControl to stop spinning
        refreshControl.endRefreshing()
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return instaposts.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ProfileCell", forIndexPath: indexPath) as! ProfileCollectionCell
        
        let textPfObject = self.instaposts[indexPath.row]
        // get text string out of the pf object
        if (textPfObject.valueForKey("media") != nil) {
            cell.profileCollImage1.file = textPfObject["media"] as? PFFile
            cell.profileCollImage1.loadInBackground()
            
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
        
        query.whereKey("author", equalTo: PFUser.currentUser()!)
        query.findObjectsInBackgroundWithBlock {(objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects {
                    self.instaposts = objects
                    self.collectionView.reloadData()
                    
                }
            } else {
                print("not working")
            }
        }
    }


}
