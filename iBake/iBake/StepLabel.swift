//
//  StepLabel.swift
//  iBake
//
//  Created by iGuest on 5/31/16.
//  Copyright © 2016 Jennifer Kang. All rights reserved.
//

import UIKit

class StepLabel:UILabel {
    override func drawTextInRect(rect: CGRect) {
        let inset = UIEdgeInsets(top:3.0, left:10.0, bottom:3.0, right:3.0)
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, inset))
    }
}
