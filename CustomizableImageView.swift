//
//  CustomizableImageView.swift
//  GOT
//
//  Created by Kenneth Okereke on 4/1/17.
//  Copyright © 2017 Mexonis. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class CustomizableImageView: UIImageView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        didSet{
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    
}
