//
//  HikayeCell.swift
//  InstagramCloneApp
//
//  Created by Bayram Yeleç on 25.10.2024.
//

import UIKit

class HikayeCell: UICollectionViewCell {
    
    @IBOutlet weak var customImageView: UIImageView!
    
    
    func setup(){
        customImageView.layer.cornerRadius = 40
        customImageView.layer.borderWidth = 3
        customImageView.layer.borderColor = UIColor.systemPurple.cgColor.copy(alpha: 0.5)
    }
}
