//
//  ViewControllerPegawai.swift
//  MahkotaMotor
//
//  Created by Athanasius Aryatyasto Pranamya on 14/08/20.
//  Copyright © 2020 Athanasius Arya. All rights reserved.
//

import Foundation
import UIKit

class HomePegawai: UIViewController {
    
    @IBOutlet weak var productIcon: UIImageView!
    @IBOutlet weak var customerIcon: UIImageView!
    @IBOutlet weak var logoutIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productIcon.isUserInteractionEnabled = true
        customerIcon.isUserInteractionEnabled = true
        logoutIcon.isUserInteractionEnabled = true
        
        let tapProduct = UITapGestureRecognizer(target: self, action: #selector(self.tapProduct))
        productIcon.addGestureRecognizer(tapProduct)
        
        let tapCustomer = UITapGestureRecognizer(target: self, action: #selector(self.tapNasabah))
        customerIcon.addGestureRecognizer(tapCustomer)
        
        let tapLogout = UITapGestureRecognizer(target: self, action: #selector(self.tapLogout))
        logoutIcon.addGestureRecognizer(tapLogout)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func tapProduct() {
        self.performSegue(withIdentifier: "produkTapped", sender: Any.self)
    }
    
    @objc func tapNasabah() {
        self.performSegue(withIdentifier: "nasabahTapped", sender: Any.self)
    }
    
    @objc func tapLogout() {
        let alert = UIAlertController(title: "Alert", message: "Apakah anda ingin Logout?", preferredStyle: UIAlertController.Style.alert)

        let update = UIAlertAction(title: "Ya", style: .destructive) { (alertAction) in
            
            let alert = UIAlertController(title: "Berhasil!", message: "Sampai jumpa!", preferredStyle: UIAlertController.Style.alert)
            let close = UIAlertAction(title: "Tutup", style: .cancel) { (alertAction) in
            
                self.performSegue(withIdentifier: "logoutTapped", sender: Any.self)
                
            }
            
            alert.addAction(close)
            self.present(alert, animated: true, completion: nil)
            
        }
        
        let close = UIAlertAction(title: "Batal", style: .cancel) { (alertAction) in
            self.viewWillAppear(true)
        }

        alert.addAction(close)
        alert.addAction(update)
        self.present(alert, animated: true, completion: nil)
    }
    
}
