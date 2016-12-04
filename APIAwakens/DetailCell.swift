//
//  DetailCell.swift
//  APIAwakens
//
//  Created by redBred LLC on 12/3/16.
//  Copyright © 2016 redBred. All rights reserved.
//

import UIKit

class DetailCell: UITableViewCell {

    @IBOutlet var descriptorLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    @IBOutlet var toggleButtonView: UIView!
    @IBOutlet var leftToggleButton: UIButton!
    @IBOutlet var rightToggleButton: UIButton!
    
    @IBAction func onToggle(_ sender: AnyObject) {
        
        if let button = sender as? UIButton {
            if button == leftToggleButton {
                highlightLeft()
            } else if button == rightToggleButton {
                highlightRight()
            }
        }
    }
    
    var valueWhenToggleIsLeft: String?
    var valueWhenToggleIsRight: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func highlightLeft() {
        leftToggleButton.setTitleColor(.white, for: .normal)
        rightToggleButton.setTitleColor(.gray, for: .normal)
        
        if let newValue = valueWhenToggleIsLeft {
            valueLabel.text = newValue
        }
    }
    
    func highlightRight() {
        leftToggleButton.setTitleColor(.gray, for: .normal)
        rightToggleButton.setTitleColor(.white, for: .normal)
        if let newValue = valueWhenToggleIsRight {
            valueLabel.text = newValue
        }
    }

}
