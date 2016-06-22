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

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var instaposts:[PFObject] = []
    
    
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
        // Do any additional setup after loading the view.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("feedCell", forIndexPath: indexPath) as! FeedCell
        let query = PFQuery(className: "Post")
        cell.captionLabel.text = "hi"
        query.findObjectsInBackgroundWithBlock {(objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                
                if let objects = objects {
                    for object in objects{
                        self.instaposts = objects
                        let captionString = object.valueForKey("caption") as! String
                        //cell.captionLabel.text = captionString
                        //print(object.valueForKey("caption") as! String)
                    }
                }
            } else {
                print("not working")
            }
            let textPfObject = self.instaposts[indexPath.row]
            // get text string out of the pf object
            if let stringText = textPfObject.valueForKey("caption") {
                print(stringText as? String)
                cell.captionLabel.text = stringText as? String
            }

            
        }
        //self.tableView.reloadData()
        return cell
    }

}
