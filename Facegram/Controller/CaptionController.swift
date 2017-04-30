//
//  CaptionController.swift
//  Facegram
//
//  Created by Sascha Jecklin on 17.07.16.
//  Copyright © 2016 Sascha Jecklin. All rights reserved.
//

import UIKit

protocol CaptionDelegate {
    func captionCotnroller(_ controller: CaptionController, didFinishWithCaption caption: String)
}

class CaptionController : UIViewController {
    @IBOutlet weak var captionText: UITextView!
    @IBOutlet weak var imagePreview: UIImageView!
    var selectedImage: UIImage!
    var delegate: CaptionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePreview.image = selectedImage
    }
    
    @IBAction func tap(_ sender: UITapGestureRecognizer!) {
        captionText.resignFirstResponder()
    }
    
    @IBAction func submitPressed(_ sender: UIButton!) {
        if let CaptionDelegate = self.delegate {
            CaptionDelegate.captionCotnroller(self, didFinishWithCaption: captionText.text)
        }
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
