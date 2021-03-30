//
//  EditProduct.swift
//  MahkotaMotor
//
//  Created by Athanasius Aryatyasto Pranamya on 27/07/20.
//  Copyright © 2020 Athanasius Arya. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import CodableFirebase

class EditProduct: UIViewController {
    
    static var namaUnitTemp : String!
    static var nomorPlatTemp : String!
    static var tahunUnitTemp : String!
    static var tanggalBeliTemp : String!
    
    @IBOutlet weak var namaUnitField: UITextField!
    @IBOutlet weak var nomorPlatField: UITextField!
    @IBOutlet weak var tahunUnitField: UITextField!
    @IBOutlet weak var tanggalBeliField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        namaUnitField.text = ProductController.nama_unit
        nomorPlatField.text = ProductController.nomor_plat
        tahunUnitField.text = ProductController.tahun_unit
        tanggalBeliField.text = ProductController.tanggal_beli
        
    }
    
    @IBAction func lanjutkanBtn(_ sender: Any) {
        if (namaUnitField.text != "" && nomorPlatField.text != "" && tahunUnitField.text != "" && tanggalBeliField.text != ""){
                 
            EditProduct.namaUnitTemp = namaUnitField.text
            EditProduct.nomorPlatTemp = nomorPlatField.text
            EditProduct.tahunUnitTemp = tahunUnitField.text
            EditProduct.tanggalBeliTemp = tanggalBeliField.text
                
        } else {
            self.showAlert(text: "Tolong, isi semua field!")
        }
    }
    
}
