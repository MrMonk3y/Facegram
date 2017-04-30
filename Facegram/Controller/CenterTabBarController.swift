//
//  CenterTabBarController.swift
//  Facegram
//
//  Created by Sascha Jecklin on 17.07.16.
//  Copyright © 2016 Sascha Jecklin. All rights reserved.
//

import UIKit

class CenterTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = UIColor.white
        tabBar.barTintColor = UIColor(white: 0.25, alpha: 1)
        tabBar.isTranslucent = false
        
        for (index, viewController) in self.viewControllers!.enumerated() {
            viewController.title = nil
            viewController.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
            if index == self.viewControllers!.count / 2 {
                viewController.tabBarItem.isEnabled = false
            }
        }
        let centerButton = UIButton(type: .custom)
        let buttonImage = UIImage(named: "camera")
        let numTabs = self.viewControllers!.count
        
        if buttonImage != nil {
            let screenWidth = UIScreen.main.bounds.size.width
            centerButton.frame = CGRect(x: 0, y: 0, width: screenWidth / CGFloat(numTabs), height: self.tabBar.frame.size.height)
            centerButton.setImage(buttonImage, for: UIControlState())
            centerButton.tintColor = UIColor.white
            centerButton.backgroundColor = UIColor(red: 18/255.0, green: 86/255.0, blue: 136/255.0, alpha: 1.0)
            
            centerButton.center = self.tabBar.center
            
            centerButton.addTarget(self, action: #selector(CenterTabBarController.showCamera(_:)), for: .touchUpInside) // anderst als video 4.2
            self.view.addSubview(centerButton)
        }
    }
    
    func showCamera(_ sender: UIButton!) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let cameraPicker = mainStoryboard.instantiateViewController(withIdentifier: "CameraPopup")
        self.present(cameraPicker, animated: true, completion: nil)
    }
}
