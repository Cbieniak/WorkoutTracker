//
//  TrackedSessionCollectionViewCell.swift
//  WorkoutTracker
//
//  Created by ChristianBieniak on 5/2/17.
//  Copyright © 2017 Bieniapps. All rights reserved.
//

import UIKit

class TrackedSessionCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var upperTrackView: UIView!
    @IBOutlet weak var lowerTrackView: UIView!
    @IBOutlet weak var centerTrackView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        upperTrackView.alpha = 1.0
        lowerTrackView.alpha = 1.0
        
        centerTrackView.backgroundColor = UIColor(colorLiteralRed: 216/255, green: 216/255, blue: 216/255, alpha: 1)
        upperTrackView.backgroundColor = UIColor(colorLiteralRed: 216/255, green: 216/255, blue: 216/255, alpha: 1)
        lowerTrackView.backgroundColor = UIColor(colorLiteralRed: 216/255, green: 216/255, blue: 216/255, alpha: 1)
    }

}
