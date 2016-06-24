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

    

}
