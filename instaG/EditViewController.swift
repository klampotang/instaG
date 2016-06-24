//
//  EditViewController.swift
//  instaG
//
//  Created by Kelly Lampotang on 6/24/16.
//  Copyright © 2016 Kelly Lampotang. All rights reserved.
//

import UIKit
import ParseUI
import Parse
import MBProgressHUD


class EditViewController: UIViewController {
    var newpost: Post?
    
    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var imageViewEdited: UIImageView!
    internal var imageSent = UIImage()
    internal var editedImage = UIImage()
    override func viewDidLoad() {
       
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func filter1Pressed(sender: AnyObject) {
        let filter = CIFilter(name: "CISepiaTone")
        let imageSentCI = CIImage(image: imageSent)
        filter!.setValue(imageSentCI, forKey: kCIInputImageKey)
        filter!.setValue(0.5, forKey: kCIInputIntensityKey)

        let context = CIContext(options:nil)

        let cgimg = context.createCGImage(filter!.outputImage!, fromRect: filter!.outputImage!.extent)

        let newImage = UIImage(CGImage: cgimg)
        self.imageViewEdited.image = newImage
        self.editedImage = newImage
    }
    
    @IBAction func saveButtonClicked(sender: AnyObject) {
        // Display HUD right before the request is made
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        let captionText = captionTextField.text;
        print(captionText)
        //newimage = resize(newimage!, newSize: CGSize)
        let successValue = Post.postUserImage(editedImage, withCaption: captionText!)
        if(successValue)
        {
            // Hide HUD once the network request comes back (must be done on main UI thread)
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            self.alert("Success")
            captionTextField.text = ""
        }
        else
        {
            self.alert("Error")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func alert (type: String) {
        if(type == "Success")
        {
            let alertController = UIAlertController(title: "Success", message: "Posted to instaG", preferredStyle: .Alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                
            }
            alertController.addAction(OKAction)
            
            self.presentViewController(alertController, animated: true) {
                
            }
            
        }
        else
        {
            let alertController = UIAlertController(title: "Error", message: "Try again later", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
                
            }
            alertController.addAction(cancelAction)
            
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                
            }
            alertController.addAction(OKAction)
            
            self.presentViewController(alertController, animated: true) {
                
            }
            
        }
        
    }

    
    

}
