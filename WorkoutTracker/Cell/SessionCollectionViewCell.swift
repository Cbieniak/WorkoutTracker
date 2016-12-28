//
//  SessionCollectionViewCell.swift
//  WorkoutTracker
//
//  Created by ChristianBieniak on 14/12/16.
//  Copyright © 2016 Bieniapps. All rights reserved.
//

import UIKit

class SessionCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    let orange =  UIColor(colorLiteralRed: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 1.0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .white
        
        self.layer.borderWidth = 1.0
        self.layer.borderColor = orange.cgColor
        
        self.titleLabel.textColor = orange
        
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
