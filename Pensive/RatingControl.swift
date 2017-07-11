//
//  RatingControl.swift
//  Pensive
//
//  Created by Assel Kashkenbayeva on 11/12/2016.
//  Copyright © 2016 Assel Kashkenbayeva. All rights reserved.
//
/*
import UIKit

class RatingControl: UIView {

    //MARK: Properties
    
    var rating: Int = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    var ratingbuttons = [UIButton]()
    let spacing = 5
    let starCount = 5
    

    
    //MARK: Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let filledStarImage = UIImage(named: "filledStar")
        let emptyStarImage = UIImage(named: "emptyStar")
        for _ in 0..<5 {
        let button = UIButton()
            
            button.setImage(emptyStarImage, for: .normal)
            button.setImage(filledStarImage, for: .selected)
            button.setImage(filledStarImage, for: [.highlighted, .selected])
            
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchDown)
            ratingbuttons += [button]
            
            button.adjustsImageWhenHighlighted = false
        addSubview(button)
        }
    }

    override public var intrinsicContentSize: CGSize {
        get {
            let buttonSize = Int(frame.size.height)
            let width = (buttonSize * starCount) + (spacing * (starCount - 1))
            return CGSize(width: width, height: buttonSize)
        }
    }
    
    override func layoutSubviews() {
        let buttonSize = Int(frame.size.height)
        var buttonframe =  CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        for (index, button) in ratingbuttons.enumerated() {
            buttonframe.origin.x = CGFloat(index * (buttonSize + 5))
            button.frame = buttonframe
        }
        updateButtonSelectionStates()
    }
    
    //MARK:Button Action
    func ratingButtonTapped(button: UIButton) {
       rating = ratingbuttons.index(of: button)! + 1
        
        updateButtonSelectionStates()
    }
    
    func updateButtonSelectionStates() {
        for (index,button) in ratingbuttons.enumerated() {
            button.isSelected = index < rating
        }
    }

}
*/
