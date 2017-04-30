//
//  CameraController.swift
//  Facegram
//
//  Created by Sascha Jecklin on 17.07.16.
//  Copyright © 2016 Sascha Jecklin. All rights reserved.
//

import UIKit

class CameraController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CaptionDelegate {
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var sourceLabel: UILabel!
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sourceLabel.text = "No Image Selected"
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        selectedImage = info[UIImagePickerControllerEditedImage] as? UIImage
        self.selectedImageView.image = selectedImage
        if picker.sourceType == .camera {
            sourceLabel.text = "PHOTO"
        } else if picker.sourceType == .photoLibrary {
            sourceLabel.text = "LIBRARY"
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func captionCotnroller(_ controller: CaptionController, didFinishWithCaption caption: String) {
        controller.dismiss(animated: true, completion: nil)
        guard let postImage = selectedImage else {
            print("No image selected")
            return
        }
        let newPost = Post.init(id: nil, creator: Profile.currentUser!.username, image: postImage, caption: caption)
        let uniquePostRef = postRef.childByAutoId() // Creates unique time.sesitive post id
        uniquePostRef.setValue(newPost.dictValue())
        
        let tabBarController = self.presentingViewController as? UITabBarController
        tabBarController!.selectedIndex = 0 // Goes back to feed tab!
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! CaptionController
        destinationVC.selectedImage = selectedImage
        destinationVC.delegate = self
    }
    
    @IBAction func takePhoto(_ sender: UIButton!) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.sourceType = .camera
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
        
    }
    
    @IBAction func selectPhoto(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func dismissPhotoPicker(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
