//
//  LoginPage.swift
//  MahkotaMotor
//
//  Created by Athanasius Aryatyasto Pranamya on 22/07/20.
//  Copyright © 2020 Athanasius Arya. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginPage: UIViewController {
    
    static var temp = ""
    
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func LoginBtn(_ sender: Any) {
        
        if (usernameTF.text != "" && passwordTF.text != ""){
        
            Auth.auth().signIn(withEmail: usernameTF.text!, password: passwordTF.text!) { (result, error) in
                
                if error != nil {
                    
                    self.showAlert(text: "Username atau Password Anda salah!")
                    
                }
                    
                else {
                    
                    let alert = UIAlertController(title: "Berhasil!", message: "Selamat datang!", preferredStyle: UIAlertController.Style.alert)
                    let close = UIAlertAction(title: "Tutup", style: .cancel) { (alertAction) in
                        
                        if self.usernameTF.text == "owner@gmail.com" {
                            LoginPage.temp = "A"
                            self.performSegue(withIdentifier: "loginOwner", sender: Any.self)
                        } else {
                            LoginPage.temp = "B"
                            self.performSegue(withIdentifier: "loginPegawai", sender: Any.self)
                        }
                        
                    }
                    
                    alert.addAction(close)
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }
            
        } else {
            
            self.showAlert(text: "Tolong, isi Id dan Password Anda!")
            
        }
        
    }
    
}
