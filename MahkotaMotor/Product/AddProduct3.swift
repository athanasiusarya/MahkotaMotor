//
//  AddProduct3.swift
//  MahkotaMotor
//
//  Created by Athanasius Aryatyasto Pranamya on 04/08/20.
//  Copyright © 2020 Athanasius Arya. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class AddProduct3: UIViewController {
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var inputText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func selesaiBtn(_ sender: Any) {
        
        if inputText.text != "" {
            
            var docReference: DocumentReference? = nil
            
            let data = ["nama_unit": AddProduct.namaUnitTemp!,
                        "detail_pembenahan": inputText.text!,
                        "nomor_plat": AddProduct.nomorPlatTemp!,
                        "tahun_unit": AddProduct.tahunUnitTemp!,
                        "tanggal_beli": AddProduct.tanggalBeliTemp!,
                        "harga_beli": AddProduct2.harga_beli,
                        "pembenahan": AddProduct2.pembenahan,
                        "harga_jual": AddProduct2.harga_jual,
                        "total_modal": AddProduct2.total_modal,
                        "prediksi_untung": AddProduct2.prediksi_untung,
                        "status": "tersedia",
                        "CREATED_AT": AddProduct2.CREATED_AT]
            
            docReference = db.collection("product").addDocument(data: data)
            
            let update = ["unit_id": docReference?.documentID ?? ""]
            
            docReference?.updateData(update)
            
            let alert = UIAlertController(title: "Alert!", message: "Tambah unit, Sukses!", preferredStyle: UIAlertController.Style.alert)
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
