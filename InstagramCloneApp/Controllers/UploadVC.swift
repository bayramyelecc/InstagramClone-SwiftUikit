//
//  UploadVC.swift
//  InstagramCloneApp
//
//  Created by Bayram Yeleç on 25.10.2024.
//

import UIKit


class UploadVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showAlert()
    }
    
    func showAlert(){
        let alert = UIAlertController(title: "Hangisini yapmak istiyorsun?", message: "Birini Seç", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Hikaye", style: .default, handler: { _ in
            let vc = self.storyboard?.instantiateViewController(identifier: "hikaye")
            vc!.modalPresentationStyle = .fullScreen
            vc!.modalTransitionStyle = .crossDissolve
            self.present(vc!, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Post", style: .default, handler: { _ in
            let vc = self.storyboard?.instantiateViewController(identifier: "post")
            vc!.modalPresentationStyle = .fullScreen
            vc!.modalTransitionStyle = .crossDissolve
            self.present(vc!, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: { _ in
            let vc = self.storyboard?.instantiateViewController(identifier: "tabbar")
            vc!.modalPresentationStyle = .fullScreen
            vc!.modalTransitionStyle = .crossDissolve
            self.present(vc!, animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    

}
