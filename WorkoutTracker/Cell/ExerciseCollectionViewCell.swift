//
//  ExerciseCollectionViewCell.swift
//  WorkoutTracker
//
//  Created by ChristianBieniak on 25/10/16.
//  Copyright © 2016 Bieniapps. All rights reserved.
//

import UIKit

class ExerciseCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .white
        
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.black.cgColor
        
        self.titleLabel.textColor = .black
        
        self.layer.cornerRadius = 10.0
        
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                self.backgroundColor = .black
                self.titleLabel.textColor = .white
            } else {
                self.backgroundColor = .white
                self.titleLabel.textColor = .black
            }
        }
    }

}
