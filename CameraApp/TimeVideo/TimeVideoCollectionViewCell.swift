//
//  TimeVideoCollectionViewCell.swift
//  CameraApp
//
//  Created by Tin/Perry/ServiceDev on 22/11/2023.
//

import UIKit

class TimeVideoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var viewLabel: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func labelSetUp(of selected: Bool){
        
        self.timeLabel.layer.cornerRadius = 14
        self.timeLabel.backgroundColor = selected ? .black.withAlphaComponent(0.7) : .clear
        self.timeLabel.clipsToBounds = true
    }

}
