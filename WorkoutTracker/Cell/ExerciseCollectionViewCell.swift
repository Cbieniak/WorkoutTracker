//
//  ExerciseCollectionViewCell.swift
//  WorkoutTracker
//
//  Created by ChristianBieniak on 25/10/16.
//  Copyright © 2016 Bieniapps. All rights reserved.
//

import UIKit

class ExerciseCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var flipButton: UIButton!
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var latestValueLabel: UILabel!
    @IBOutlet weak var latestDateLabel: UILabel!
    @IBOutlet weak var topValueLabel: UILabel!
    @IBOutlet weak var topDateLabel: UILabel!
    @IBOutlet weak var frontView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        self.flipButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                self.titleLabel.textColor = .white
            } else {
                self.titleLabel.textColor = .black
            }
        }
    }

    @IBAction func flipButtonTouchedUpInside(_ sender: Any) {
    
        UIView.transition(with: self.cardView, duration: 0.3, options: .transitionFlipFromLeft, animations: {
            let makeBackViewVisible = self.backView.isHidden
            
            self.frontView.isHidden = makeBackViewVisible ? true : false
            self.backView.isHidden = makeBackViewVisible ? false : true
        }) { (finished) in
            
        }
        
        
    }
}
