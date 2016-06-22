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

class ProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    //reuse identifier for cell: ProfileCollCell
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var instaposts:[PFObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        getUserPosts()
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
        query.whereKey("user", equalTo: (PFUser.currentUser()?.username)!)
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
