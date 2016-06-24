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
            
        }
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        getPosts()
        let vc = segue.destinationViewController as! DetailViewController
        let indexPath1 = tableView.indexPathForCell(sender as! FeedCell)
        let post = self.instaposts[indexPath1!.row]
        
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        dateFormatter.timeStyle = .MediumStyle

        let dateString = "\(dateFormatter.stringFromDate(post.createdAt!))"
        vc.dateViaSegue = dateString
        let caption = (post.valueForKey("caption") as? String)!
        vc.captionViaSegue = caption
        let imagePostFile = post["media"] as? PFFile
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
    @IBAction func likeTapped(sender: AnyObject) {
        let hitPoint = sender.convertPoint(CGPointZero, toView: self.feedView)
        let indexPath = self.feedView.indexPathForRowAtPoint(hitPoint)
        let specificPFObject = instaposts[section]
        specificPFObject["likesCount"] = specificPFObject["likesCount"]+1
    }
    func getPosts()
    {
        let query = PFQuery(className: "Post")
        query.includeKey("author")
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
