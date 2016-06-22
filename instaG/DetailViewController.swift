//
//  DetailViewController.swift
//  instaG
//
//  Created by Kelly Lampotang on 6/21/16.
//  Copyright © 2016 Kelly Lampotang. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDate: UILabel!
    @IBOutlet weak var detailCaption: UILabel!
    
    var dateViaSegue = ""
    var captionViaSegue = ""
    var detailImageViaSegue = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let imageUrl = NSURL(string: detailImageViaSegue)
        //detailImage.setImageWithURL(imageUrl!)
        detailDate.text = dateViaSegue
        detailCaption.text = captionViaSegue
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
