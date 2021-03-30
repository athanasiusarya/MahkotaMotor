//
//  Home.swift
//  MahkotaMotor
//
//  Created by Athanasius Aryatyasto Pranamya on 23/07/20.
//  Copyright © 2020 Athanasius Arya. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import CodableFirebase

class Home: UIViewController {
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var productIcon: UIImageView!
    @IBOutlet weak var customerIcon: UIImageView!
    @IBOutlet weak var cashierIcon: UIImageView!
    @IBOutlet weak var tunggakanIcon: UIImageView!
    @IBOutlet weak var logoutIcon: UIImageView!
    @IBOutlet weak var laporanIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productIcon.isUserInteractionEnabled = true
        customerIcon.isUserInteractionEnabled = true
        cashierIcon.isUserInteractionEnabled = true
        tunggakanIcon.isUserInteractionEnabled = true
        laporanIcon.isUserInteractionEnabled = true
        logoutIcon.isUserInteractionEnabled = true
        
        let tapProduct = UITapGestureRecognizer(target: self, action: #selector(self.tapProduct))
        productIcon.addGestureRecognizer(tapProduct)
        
        let tapCustomer = UITapGestureRecognizer(target: self, action: #selector(self.tapNasabah))
        customerIcon.addGestureRecognizer(tapCustomer)
        
        let tapCashier = UITapGestureRecognizer(target: self, action: #selector(self.tapCashier))
        cashierIcon.addGestureRecognizer(tapCashier)
        
        let tapTunggakan = UITapGestureRecognizer(target: self, action: #selector(self.tapTunggakan))
        tunggakanIcon.addGestureRecognizer(tapTunggakan)
        
        let tapLaporan = UITapGestureRecognizer(target: self, action: #selector(self.tapLaporan))
        laporanIcon.addGestureRecognizer(tapLaporan)
        
        let tapLogout = UITapGestureRecognizer(target: self, action: #selector(self.tapLogout))
        logoutIcon.addGestureRecognizer(tapLogout)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func tapProduct() {
        self.performSegue(withIdentifier: "productTapped", sender: Any.self)
    }
    
    @objc func tapNasabah() {
        self.performSegue(withIdentifier: "nasabahTapped", sender: Any.self)
    }
    
    @objc func tapCashier() {
        self.performSegue(withIdentifier: "transaksiTapped", sender: Any.self)
    }
    
    @objc func tapTunggakan() {
            
        db.collection("transaksi").addSnapshotListener { (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                if let transaksi = querySnapshot?.documents {
                    if transaksi.isEmpty {
                        let alert = UIAlertController(title: "Alert!", message: "Belum ada transaksi!", preferredStyle: UIAlertController.Style.alert)
                        let close = UIAlertAction(title: "Tutup", style: .cancel) { (alertAction) in
                            debugPrint("Empty")
                        }
                        alert.addAction(close)
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        
                        self.performSegue(withIdentifier: "tunggakanTapped", sender: Any.self)
                        
                    }
                }
            }
        }
        
    }
    
    @objc func tapLaporan() {
        self.performSegue(withIdentifier: "laporanTapped", sender: Any.self)
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
