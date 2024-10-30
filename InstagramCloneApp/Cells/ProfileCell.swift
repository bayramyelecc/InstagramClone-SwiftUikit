//
//  ProfileCell.swift
//  InstagramCloneApp
//
//  Created by Bayram Yeleç on 25.10.2024.
//

import UIKit
import Kingfisher

class ProfileCell: UICollectionViewCell {
    
    @IBOutlet weak var customImageView: UIImageView!
    
    var items: Post?
    
    func setup(){
        
        
        if let imageUrl = URL(string: items!.imageUrl) {
            customImageView.kf.setImage(with: imageUrl)
        } else {
            print("Geçersiz profil resmi URL: \(items!.imageUrl)")
        }
        
    }
}
