//
//  EditProduct2.swift
//  MahkotaMotor
//
//  Created by Athanasius Aryatyasto Pranamya on 27/07/20.
//  Copyright © 2020 Athanasius Arya. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import CodableFirebase

class EditProduct2: UIViewController {
    
    let db = Firestore.firestore()
    var myProduct = product()
    
    static var hargaBeliTemp : String!
    static var pembenahanTemp : String!
    static var hargaJualTemp : String!
    static var prediksiUntungTemp : String!
    static var totalModalTemp : String!
    
    @IBOutlet weak var hargaBeliField: UITextField!
    @IBOutlet weak var pembenahanField: UITextField!
    @IBOutlet weak var hargaJualField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hargaBeliField.text = ProductController.harga_beli
        self.pembenahanField.text = ProductController.pembenahan
        self.hargaJualField.text = ProductController.harga_jual
        
    }

    @IBAction func selesaiBtn(_ sender: Any) {
        
    if (hargaJualField.text != "" && hargaBeliField.text != "" && pembenahanField.text != ""){
             
            let harga_beli: Int? = Int(hargaBeliField.text!)
            let pembenahan: Int? = Int(pembenahanField.text!)
            let ans = harga_beli! + pembenahan!

            let untung = Int(hargaJualField.text!)! - ans
             
            EditProduct2.hargaBeliTemp = hargaBeliField.text!
            EditProduct2.pembenahanTemp = pembenahanField.text!
            EditProduct2.hargaJualTemp = hargaJualField.text!
            EditProduct2.totalModalTemp = "\(ans)"
            EditProduct2.prediksiUntungTemp = "\(untung)"
            
        } else {
            self.showAlert(text: "Tolong, isi semua field!")
        }
    }
    
}
