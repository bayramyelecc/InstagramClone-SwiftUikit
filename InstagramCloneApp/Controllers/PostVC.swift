//
//  PostVC.swift
//  InstagramCloneApp
//
//  Created by Bayram Yeleç on 26.10.2024.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

class PostVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var photoSecView: UIView!
    @IBOutlet weak var customImageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    let currentUser = Auth.auth().currentUser
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gorselSecme = UITapGestureRecognizer(target: self, action: #selector(gorselSec))
        photoSecView.addGestureRecognizer(gorselSecme)
        
        
    }
    
    
    @objc func gorselSec() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.editedImage] as? UIImage {
            customImageView.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func paylasButton(_ sender: UIButton) {
        
        guard let image = customImageView.image,
              let description = textView.text,
              let imageData = image.jpegData(compressionQuality: 0.75),
              let userId = Auth.auth().currentUser?.uid else { return }
        
        let storageRef = Storage.storage().reference().child("post_images/\(UUID().uuidString).jpg")
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Post Yükleme Hatası: \(error.localizedDescription)")
                return
            }
            storageRef.downloadURL { url, error in
                guard let downloadURL = url else { return }
                self.savePostData(description: description, imageUrl: downloadURL.absoluteString, userId: userId)
            }
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    private func savePostData(description: String, imageUrl: String, userId: String) {
        let db = Firestore.firestore()
        db.collection("users").document(userId).getDocument { (snapshot, error) in
            guard let data = snapshot?.data(),
                  let username = data["username"] as? String,
                  let profileImageUrl = data["profileImageUrl"] as? String else { return }
            
            db.collection("posts").addDocument(data: [
                "username": username,
                "profileImageUrl": profileImageUrl,
                "description": description,
                "imageUrl": imageUrl,
                "userId": userId,
                "timestamp": Date()
            ]) { error in
                if let error = error {
                    print("Post Kaydetme Hatası: \(error.localizedDescription)")
                }
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func navigateToHome() {
        if let vc = storyboard?.instantiateViewController(identifier: "tabbar") {
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    private func alertShow(message: String) {
        let alert = UIAlertController(title: "HATA", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}

