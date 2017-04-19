//
//  CustomInfoView.swift
//  Pensive
//
//  Created by Assel Kashkenbayeva on 14/04/2017.
//  Copyright © 2017 Assel Kashkenbayeva. All rights reserved.
//

import UIKit

class CustomInfoView: UIView {

    @IBOutlet var viewInfoWindow: UIView!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //UINib(nibName: "CustomInfoView", bundle: nil).instantiate(withOwner: self, options: nil)
       // addSubview(viewInfoWindow)
    }

}
