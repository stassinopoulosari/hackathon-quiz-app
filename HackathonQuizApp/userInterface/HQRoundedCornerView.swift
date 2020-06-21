//
//  HQRoundedCornerView.swift
//  HackathonQuizApp
//
//  Created by Ari Stassinopoulos on 6/20/20.
//  Copyright © 2020 Ari Stassinopoulos. All rights reserved.
//

import UIKit

@IBDesignable public class HQRoundedCornerView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}
