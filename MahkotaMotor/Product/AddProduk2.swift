//
//  AddProduk2.swift
//  MahkotaMotor
//
//  Created by Athanasius Aryatyasto Pranamya on 24/07/20.
//  Copyright © 2020 Athanasius Arya. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class AddProduct2: UIViewController {
    
    let db = Firestore.firestore()
    
    static var harga_beli = ""
    static var pembenahan = ""
    static var harga_jual = ""
    static var total_modal = ""
    static var prediksi_untung = ""
    static var CREATED_AT = ""
    
    @IBOutlet weak var hargaBeliField: UITextField!
    @IBOutlet weak var pembenahanField: UITextField!
    @IBOutlet weak var hargaJualField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func selesaiBtn(_ sender: Any) {
        
        if (hargaJualField.text != "" && hargaBeliField.text != "" && pembenahanField.text != ""){
            
            let harga_beli: Int? = Int(hargaBeliField.text!)
            let pembenahan: Int? = Int(pembenahanField.text!)
            let ans = harga_beli! + pembenahan!
            
            let untung = Int(hargaJualField.text!)! - ans
            
            let currentDate = Date()
            let formatter = DateFormatter()
            
            formatter.timeStyle = .medium
            formatter.dateStyle = .long
            
            let dateTimeString = formatter.string(from: currentDate)
            
            AddProduct2.harga_beli = hargaBeliField.text!
            AddProduct2.pembenahan = pembenahanField.text!
            AddProduct2.harga_jual = hargaJualField.text!
            AddProduct2.total_modal = "\(ans)"
            AddProduct2.prediksi_untung = "\(untung)"
            AddProduct2.CREATED_AT = dateTimeString
           
       } else {
           self.showAlert(text: "Tolong, isi semua field!")
       }
        
    }
    
}
