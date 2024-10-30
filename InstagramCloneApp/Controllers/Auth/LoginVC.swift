//
//  ViewController.swift
//  InstagramCloneApp
//
//  Created by Bayram Yeleç on 24.10.2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class LoginVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var sifreTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func girisYapButton(_ sender: UIButton) {
        loginUser()
    }
    
    func loginUser(){
        
        guard let email = emailTextField.text, !email.isEmpty,
              let password = sifreTextField.text, !password.isEmpty else {
            alertShow(message: "Lütfen tüm alanları doldurun!")
            return
        }
        guard email.contains("@"), email.contains(".") else {
            alertShow(message: "Lütfen geçerli bir mail giriniz!")
            return
        }
        guard password.count >= 6 else {
            alertShow(message: "Şifre en az 6 karakterden oluşmalıdır!")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Giriş Hatası: \(error.localizedDescription)")
                return
            }
            self.navigateToHome()
        }
        
    }
    
    private func navigateToHome() {
        if let homeVC = storyboard?.instantiateViewController(withIdentifier: "tabbar") {
            homeVC.modalPresentationStyle = .fullScreen
            homeVC.modalTransitionStyle = .crossDissolve
            self.present(homeVC, animated: true, completion: nil)
        }
    }
    
    
    private func alertShow(message: String) {
        let alert = UIAlertController(title: "HATA", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
}

