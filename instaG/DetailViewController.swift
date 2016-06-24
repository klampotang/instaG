//
//  DetailViewController.swift
//  instaG
//
//  Created by Kelly Lampotang on 6/21/16.
//  Copyright © 2016 Kelly Lampotang. All rights reserved.
//

import UIKit
import ParseUI

class DetailViewController: UIViewController {

    @IBOutlet weak var likesLabelDetailScreen: UILabel!
    @IBOutlet weak var usernameLabelDetailScreen: UILabel!
    @IBOutlet weak var profilePicDetailScreen: PFImageView!
    @IBOutlet weak var detailImage: PFImageView!
    @IBOutlet weak var detailDate: UILabel!
    @IBOutlet weak var detailCaption: UILabel!
    
    var dateViaSegue = ""
    var captionViaSegue = ""
    var detailImageViaSegue = ""
    internal var file:PFFile?
    internal var fileProfile:PFFile?
    var likesTextViaSegue = ""
    var usernameViaSegue = ""
    var userClicked0 : PFUser?
    var particularPost:PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailDate.text = dateViaSegue
        detailCaption.text = captionViaSegue
        detailImage.file = file
        detailImage.loadInBackground()
        profilePicDetailScreen.file = fileProfile
        profilePicDetailScreen.loadInBackground()
        likesLabelDetailScreen.text = likesTextViaSegue
        usernameLabelDetailScreen.text = usernameViaSegue
        
        profilePicDetailScreen.layer.borderWidth = 1
        profilePicDetailScreen.layer.masksToBounds = false
        profilePicDetailScreen.layer.borderColor = UIColor.whiteColor().CGColor
        profilePicDetailScreen.layer.cornerRadius = profilePicDetailScreen.frame.height/2
        profilePicDetailScreen.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! GenProfileViewController
        vc.userClicked = userClicked0!
    }

    override func previewActionItems() -> [UIPreviewActionItem] {
        
        let likeAction = UIPreviewAction(title: "Like", style: .Default) { (action, viewController) -> Void in
            self.like()
            print("You liked the photo")
        }
        
        let deleteAction = UIPreviewAction(title: "Cancel", style: .Destructive) { (action, viewController) -> Void in
            print("Cancelled")
        }
        
        return [likeAction, deleteAction]
        
    }
    func like()
    {
        var currCount = 0
        if(particularPost!.valueForKey("likesCount") == nil)
        {
            currCount = 0
        }
        else
        {
            currCount = particularPost!.valueForKey("likesCount") as! Int
        }
        particularPost!["likesCount"] = currCount + 1
        particularPost!.saveInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if error != nil {
                print("failed")
            } else {
                print("YAY")
            }
        }
        
        
        let likesCountNum = particularPost!.valueForKey("likesCount")
        likesLabelDetailScreen.text = "\(likesCountNum!)"
    }
    override func viewDidAppear(animated: Bool) {
        let query = PFQuery(className: "Post")
        do
        {
            let objectUpdated = try query.getObjectWithId((particularPost?.objectId)!)
            let likesAsString0 = "\(objectUpdated["likesCount"])"
            likesLabelDetailScreen.text = likesAsString0 + " likes"
        }
        catch
        {
            print("RIP")
        }
    }
}
