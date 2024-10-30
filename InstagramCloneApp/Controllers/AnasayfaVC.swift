//
//  AnasayfaVC.swift
//  InstagramCloneApp
//
//  Created by Bayram Yeleç on 25.10.2024.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class AnasayfaVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView1: UICollectionView!
    @IBOutlet weak var collectionView2: UICollectionView!
    
    private var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupUI2()
        fetchPosts()
    }
    
    private func setupUI() {
        collectionView1.delegate = self
        collectionView1.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        collectionView1.collectionViewLayout = layout
    }
    
    private func setupUI2() {
        collectionView2.delegate = self
        collectionView2.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        collectionView2.collectionViewLayout = layout
    }
    
    func fetchPosts() {
        let db = Firestore.firestore()
        db.collection("posts").getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else {
                print("No documents")
                return
            }
            
            self.posts = documents.compactMap { doc -> Post? in
                let data = doc.data()
                guard let username = data["username"] as? String,
                      let profileImageUrl = data["profileImageUrl"] as? String,
                      let imageUrl = data["imageUrl"] as? String,
                      let description = data["description"] as? String,
                      let timestamp = data["timestamp"] as? Timestamp else {
                    return nil
                }
                
                
                let date = timestamp.dateValue()
                
                
                return Post(username: username, profileImageUrl: profileImageUrl, imageUrl: imageUrl, description: description, timestamp: date)
            }
            
            
            self.posts.sort { $0.timestamp > $1.timestamp }
            
            DispatchQueue.main.async {
                self.collectionView2.reloadData()
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionView1 {
            return 15
        } else {
            return posts.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionView1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HikayeCell
            cell.setup()
            return cell
        }
        else if collectionView == collectionView2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PostCell
            let post = posts[indexPath.row]
            cell.items = post
            cell.setup()
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionView1 {
            return CGSize(width: 80, height: 80)
        } else {
            return CGSize(width: collectionView.frame.width, height: 400)
        }
    }

}
