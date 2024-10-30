//
//  RegisterVC.swift
//  InstagramCloneApp
//
//  Created by Bayram Yeleç on 25.10.2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class RegisterVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var sifreTextField: UITextField!
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(gorselSec))
        profileImage.isUserInteractionEnabled = true // Kullanıcı etkileşimini etkinleştir
        profileImage.addGestureRecognizer(imageTap)
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
            profileImage.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func kayitOlButton(_ sender: Any) {
        createUser()
    }
    
    func createUser() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = sifreTextField.text, !password.isEmpty,
              let fullname = fullName.text, !fullname.isEmpty else {
            alertShow(message: "Lütfen tüm alanları doldurun!")
            return
        }
        guard email.contains("@"), email.contains(".") else {
            alertShow(message: "Geçerli bir email giriniz!")
            return
        }
        guard password.count >= 6 else {
            alertShow(message: "Şifre en az 6 karakter olmalıdır!")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Kayıt Hatası: \(error.localizedDescription)")
                return
            }
            self.uploadProfileImage(username: fullname)
        }
    }
    
    private func uploadProfileImage(username: String) {
        guard let image = profileImage.image,
              let imageData = image.jpegData(compressionQuality: 0.75),
              let userId = Auth.auth().currentUser?.uid else { return }
        
        let storageRef = Storage.storage().reference().child("profile_images/\(userId).jpg")
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Fotoğraf Yükleme Hatası: \(error.localizedDescription)")
                return
            }
            storageRef.downloadURL { url, error in
                guard let downloadURL = url else { return }
                self.saveUserInfo(username: username, profileImageUrl: downloadURL.absoluteString)
            }
        }
    }
    
    private func saveUserInfo(username: String, profileImageUrl: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(userId).setData([
            "username": username,
            "profileImageUrl": profileImageUrl
        ]) { error in
            if let error = error {
                print("Bilgi Kaydetme Hatası: \(error.localizedDescription)")
                return
            }
            self.navigateToHome()
        }
    }

    private func alertShow(message: String) {
        let alert = UIAlertController(title: "HATA", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func navigateToHome() {
        if let homeVC = storyboard?.instantiateViewController(withIdentifier: "tabbar") {
            homeVC.modalPresentationStyle = .fullScreen
            homeVC.modalTransitionStyle = .crossDissolve
            self.present(homeVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func geriDonButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
