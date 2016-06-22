//
//  FeedViewController.swift
//  instaG
//
//  Created by Kelly Lampotang on 6/20/16.
//  Copyright © 2016 Kelly Lampotang. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    var instaposts:[PFObject] = []
    var imagePLS = UIImage()
    var isMoreDataLoading = false
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // Calculate the position of one screen length before the bottom of the results
        let scrollViewContentHeight = tableView.contentSize.height
        let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
            isMoreDataLoading = true
            
            // ... Code to load more results ...
            getPosts()
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func logOut(sender: AnyObject) {
        
        PFUser.logOutInBackgroundWithBlock { (error: NSError?) in
            // PFUser.currentUser() will now be nil
        }
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        getPosts()
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlGetPosts(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 6
        return instaposts.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("feedCell", forIndexPath: indexPath) as! FeedCell
        
        let textPfObject = self.instaposts[indexPath.row]
        // get text string out of the pf object
        if let stringText = textPfObject.valueForKey("caption") {
            cell.captionLabel.text = stringText as? String
            cell.instaPostPic.file = textPfObject["media"] as? PFFile
            cell.instaPostPic.loadInBackground()
            
        }
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        getPosts()
        let vc = segue.destinationViewController as! DetailViewController
        let indexPath1 = tableView.indexPathForCell(sender as! FeedCell)
        let post = self.instaposts[indexPath1!.row]
        
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let dateString = "\(dateFormatter.stringFromDate(post.createdAt!))"
        vc.dateViaSegue = dateString
        vc.captionViaSegue = (post.valueForKey("caption") as? String)!
        
        let imagePostFile = post["media"] as? PFFile
        //let newImage = PFImageView();
        //newImage.file = imagePostFile
        //vc.detailImage = newImage;
        vc.file = imagePostFile
        
    }
    func refreshControlGetPosts(refreshControl: UIRefreshControl)
    {
        getPosts()
        // Reload the tableView now that there is new data
        self.tableView.reloadData()
        // Tell the refreshControl to stop spinning
        refreshControl.endRefreshing()
    }
    func getPosts()
    {
        let query = PFQuery(className: "Post")
        query.findObjectsInBackgroundWithBlock {(objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects {
                    self.instaposts = objects
                    self.tableView.reloadData()
                    
                }
            } else {
                print("not working")
            }
        }
    }
    
    
}
