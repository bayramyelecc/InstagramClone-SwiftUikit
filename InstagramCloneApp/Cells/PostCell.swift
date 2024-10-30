//
//  PostCell.swift
//  InstagramCloneApp
//
//  Created by Bayram Yeleç on 30.10.2024.
//

import UIKit
import Kingfisher

class PostCell: UICollectionViewCell {
    

    @IBOutlet weak var profileView: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var postView: UIImageView!
    @IBOutlet weak var profileNameAlt: UILabel!
    @IBOutlet weak var postAciklama: UILabel!
    
    var items: Post?
    
    func setup() {
        profileView.layer.cornerRadius = 20

        print("Username: \(items!.username)")
        print("Profile Image URL: \(items!.profileImageUrl)")
        print("Post Image URL: \(items!.imageUrl)")
        print("Description: \(items!.description)")
        
        profileName.text = items!.username
        profileNameAlt.text = items!.username
        postAciklama.text = items!.description
        
        if let profileUrl = URL(string: items!.profileImageUrl) {
            profileView.kf.setImage(with: profileUrl)
        } else {
            print("Geçersiz profil resmi URL: \(items!.profileImageUrl)")
        }

        if let postUrl = URL(string: items!.imageUrl) {
            postView.kf.setImage(with: postUrl)
        } else {
            print("Geçersiz post resmi URL: \(items!.imageUrl)")
        }
    }


}
