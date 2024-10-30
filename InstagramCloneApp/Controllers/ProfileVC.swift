//
//  ProfileVC.swift
//  InstagramCloneApp
//
//  Created by Bayram Yeleç on 25.10.2024.
//

import UIKit
import FirebaseAuth
import Kingfisher
import FirebaseStorage
import FirebaseFirestore

class ProfileVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    
    var models = [Post]()
    var users: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchPosts()
        fetchCurrentUser()    
    }
    
    func setupUI(){
        collectionView.delegate = self
        collectionView.dataSource = self
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        collectionView.collectionViewLayout = layout
        editButton.layer.borderWidth = 1
        editButton.layer.borderColor = UIColor.lightGray.cgColor
        editButton.layer.cornerRadius = 10
        profileImage.layer.borderWidth = 2
        profileImage.layer.borderColor = UIColor.black.cgColor.copy(alpha: 0.1)
        profileImage.layer.cornerRadius = 50
    }
    
    func fetchCurrentUser() {
            guard let currentUser = Auth.auth().currentUser else { return }

            let db = Firestore.firestore()
            db.collection("users").document(currentUser.uid).getDocument { (snapshot, error) in
                guard let data = snapshot?.data(),
                      let username = data["username"] as? String,
                      let profileImageUrl = data["profileImageUrl"] as? String else {
                    print("Kullanıcı bilgileri alınamadı")
                    return
                }

                self.profileName.text = username
                
                if let url = URL(string: profileImageUrl) {
                    self.profileImage.kf.setImage(with: url)
                }
            }
        }
    
    func fetchPosts() {
        guard let currentUser = Auth.auth().currentUser else {
            print("Kullanıcı oturum açmamış.")
            return
        }
        
        let db = Firestore.firestore()
        db.collection("posts").whereField("userId", isEqualTo: currentUser.uid).getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else {
                print("No documents")
                return
            }
            
            self.models = documents.compactMap { doc -> Post? in
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
            
           
            self.models.sort { $0.timestamp > $1.timestamp }
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProfileCell
        let model = models[indexPath.row]
        cell.items = model
        cell.setup()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width / 3) - 10, height: view.frame.height / 6)
    }
    
    
    @IBAction func profiliDuzenleButton(_ sender: UIButton) {
        
    }
    @IBAction func logoutButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Uyarı", message: "Çıkış yapmak istediğinden emin misin?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Çıkış yap", style: .destructive, handler: { _ in
            do {
                try Auth.auth().signOut()
                let vc = self.storyboard?.instantiateViewController(identifier: "navbar")
                vc!.modalTransitionStyle = .crossDissolve
                vc!.modalPresentationStyle = .fullScreen
                self.present(vc!, animated: true, completion: nil)
            } catch {
                print("cıkıs yapma hatası")
            }
        }))
        alert.addAction(UIAlertAction(title: "İptal", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
