//
//  AttributeCollectionViewCell.swift
//  WorkoutTracker
//
//  Created by ChristianBieniak on 1/2/17.
//  Copyright © 2017 Bieniapps. All rights reserved.
//

import UIKit

class AttributeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var suffixLabel: UILabel!
    @IBOutlet weak var wholeNumberLabel: UILabel!
    @IBOutlet weak var decendingLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(_ denomination: Denomination) {
        
        self.titleLabel.text = denomination.name
        self.decendingLabel.text = denomination.ascending ? "asc" : "dec"
        self.wholeNumberLabel.text = denomination.incrementWholeNumber ? "Whole" : "Decimal"
        self.suffixLabel.text = denomination.suffix
        
    }

}
