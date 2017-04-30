//
//  TranslucentTextFile.swift
//  Facegram
//
//  Created by Sascha Jecklin on 23.07.16.
//  Copyright © 2016 Sascha Jecklin. All rights reserved.
//

import UIKit

class TranslucentTextField: UITextField {
    required init?(coder aDecoder: NSCoder) {
        placeholderText = ""
        super.init(coder: aDecoder)
        tintColor = UIColor.white
        layer.cornerRadius = 3
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 16, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 16, dy: 0)
    }
    
    var placeholderText: String {
        didSet {
            attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSForegroundColorAttributeName: UIColor(white: 1.0, alpha: 0.7)])
        }
    }
}
