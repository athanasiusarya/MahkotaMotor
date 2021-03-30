//
//  EditProduct3.swift
//  MahkotaMotor
//
//  Created by Athanasius Aryatyasto Pranamya on 04/08/20.
//  Copyright © 2020 Athanasius Arya. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import CodableFirebase

class EditProduct3: UIViewController {
    
    let db = Firestore.firestore()
    var myProduct = product()
    var temp_id = ""
    var temp_create = ""

    @IBOutlet weak var textViewLabel: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textViewLabel.text = ProductController.detail_pembenahan
        
    }
    
    @IBAction func selesaiBtn(_ sender: Any) {
        
        if (textViewLabel.text != "") {
                
            let data = ["nama_unit": EditProduct.namaUnitTemp!,
                        "nomor_plat": EditProduct.nomorPlatTemp!,
                        "tahun_unit": EditProduct.tahunUnitTemp!,
                        "tanggal_beli": EditProduct.tanggalBeliTemp!,
                        "harga_beli": EditProduct2.hargaBeliTemp!,
                        "pembenahan": EditProduct2.pembenahanTemp!,
                        "detail_pembenahan": textViewLabel.text!,
                        "harga_jual": EditProduct2.hargaJualTemp!,
                        "total_modal": EditProduct2.totalModalTemp!,
                        "prediksi_untung": EditProduct2.prediksiUntungTemp!]

            db.collection("product").document(ProductController.temp_id).updateData(data)

            let alert = UIAlertController(title: "Alert!", message: "Edit unit, Sukses!", preferredStyle: UIAlertController.Style.alert)
            let close = UIAlertAction(title: "Tutup", style: .cancel) { (alertAction) in
                self.performSegue(withIdentifier: "selesaiTapped", sender: Any.self)
            }

            alert.addAction(close)
            self.present(alert, animated: true, completion: nil)
            
        } else {
            self.showAlert(text: "Tolong, isi semua field!")
        }
    }
    
}
