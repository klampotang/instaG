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
import MBProgressHUD

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    var instaposts:[PFObject] = []
    var isMoreDataLoading = false
    let HeaderViewIdentifier = "TableViewHeaderView"
    
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
        // Display HUD right before the request is made
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        getPosts()
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlGetPosts(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        tableView.registerClass(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: HeaderViewIdentifier)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return instaposts.count ?? 0;
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("feedCell", forIndexPath: indexPath) as! FeedCell
        
        let textPfObject = self.instaposts[indexPath.section]
        // get text string out of the pf object
        if let stringText = textPfObject.valueForKey("caption") {
            let dateNS = textPfObject.createdAt
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
            dateFormatter.timeStyle = .MediumStyle
            let dateString = "\(dateFormatter.stringFromDate(dateNS!))"
            
            cell.captionLabel.text = stringText as? String
            cell.dateLabel.text = dateString            
            cell.instaPostPic.file = textPfObject["media"] as? PFFile
            cell.instaPostPic.loadInBackground()
            if(textPfObject.valueForKey("likesCount") != nil)
            {
                let likeCountAsString = "\(textPfObject.valueForKey("likesCount")!)"
                cell.countsLabel.text = likeCountAsString + " likes"
            }
            else
            {
                cell.countsLabel.text = "0"
            }
            
        }
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        getPosts()
        let vc = segue.destinationViewController as! DetailViewController
        let indexPath1 = tableView.indexPathForCell(sender as! FeedCell)
        let post = self.instaposts[indexPath1!.section]
        
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        dateFormatter.timeStyle = .MediumStyle

        let dateString = "\(dateFormatter.stringFromDate(post.createdAt!))"
        vc.dateViaSegue = dateString
        let caption = (post.valueForKey("caption") as? String)!
        vc.captionViaSegue = caption
        let imagePostFile = post["media"] as? PFFile
        vc.file = imagePostFile
        
        let poster = post.valueForKey("author") as? PFUser
        vc.userClicked0 = poster
        let posterUsername = poster?.username
        vc.usernameViaSegue = posterUsername!
        
        let likes = post.valueForKey("likesCount")
        let likesAsString = "\(likes!)"
        vc.likesTextViaSegue = likesAsString + " likes"
        
        let userProfPic = poster!["ProfilePic"] as? PFFile
        vc.fileProfile = userProfPic
        
        vc.particularPost = post
        
    }
    func refreshControlGetPosts(refreshControl: UIRefreshControl)
    {
        getPosts()
        // Reload the tableView now that there is new data
        self.tableView.reloadData()
        // Tell the refreshControl to stop spinning
        refreshControl.endRefreshing()
    }
    @IBAction func likeTapped2(sender: AnyObject) {
        var indexPath: NSIndexPath!
        
        if let button = sender as? UIButton {
            if let superview = button.superview {
                if let cell = superview.superview as? FeedCell {
                    indexPath = (tableView.indexPathForCell(cell))
                }
            }
        }
        
        let cell1 = tableView.dequeueReusableCellWithIdentifier("feedCell", forIndexPath: indexPath) as! FeedCell
        
        let textPfObject = self.instaposts[indexPath.section]
        var currCount = 0
        if(textPfObject.valueForKey("likesCount") == nil)
        {
            currCount = 0
        }
        else
        {
            currCount = textPfObject.valueForKey("likesCount") as! Int
        }
        textPfObject["likesCount"] = currCount + 1
        textPfObject.saveInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if error != nil {
                print("failed")
            } else {
                print("YAY")
            }
        }
        let likesCountNum = textPfObject.valueForKey("likesCount")
        cell1.countsLabel.text = "\(likesCountNum!)"
        tableView.reloadData()
    }
    func getPosts()
    {
        let query = PFQuery(className: "Post")
        query.includeKey("author")
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock {(objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects {
                    self.instaposts = objects
                    self.tableView.reloadData()
                    // Hide HUD once the network request comes back (must be done on main UI thread)
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    
                }
            } else {
                print("not working")
            }
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier(HeaderViewIdentifier)! as UITableViewHeaderFooterView
        let lilPFObject = instaposts[section]
        let PFUserPLS = lilPFObject.valueForKey("author") as! PFUser
        let stringUser = PFUserPLS.username
        let view1 = PFImageView()

        if (PFUserPLS["ProfilePic"] != nil)
        {
            let PFFilePic = PFUserPLS["ProfilePic"] as! PFFile
            view1.file = PFFilePic
            view1.loadInBackground()
        }
        else
        {
            view1.image = UIImage(named: "PhotoLogo")
        }
        
        header.textLabel!.text = stringUser!
        view1.frame = CGRect(x:325, y:10, width: 35, height: 35)
        view1.layer.borderWidth = 1
        view1.layer.masksToBounds = false
        view1.layer.borderColor = UIColor.whiteColor().CGColor
        view1.layer.cornerRadius = view1.frame.height/2
        view1.clipsToBounds = true

        header.contentView.addSubview(view1)
        
        return header
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    
}
