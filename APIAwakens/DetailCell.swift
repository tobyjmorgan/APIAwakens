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
                leftToggleButton.setTitleColor(.white, for: .normal)
                rightToggleButton.setTitleColor(.gray, for: .normal)
            } else if button == rightToggleButton {
                leftToggleButton.setTitleColor(.gray, for: .normal)
                rightToggleButton.setTitleColor(.white, for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
