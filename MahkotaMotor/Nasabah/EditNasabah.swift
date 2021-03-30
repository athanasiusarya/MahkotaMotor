//
//  EditNasabah.swift
//  MahkotaMotor
//
//  Created by Athanasius Aryatyasto Pranamya on 28/07/20.
//  Copyright © 2020 Athanasius Arya. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import CodableFirebase

class EditNasabah: UIViewController {
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var namaField: UITextField!
    @IBOutlet weak var nomorField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        namaField.text = NasabahController.temp_nama
        nomorField.text = NasabahController.temp_no
        
    }
    
    @IBAction func selesaiBtn(_ sender: Any) {
        
        if (namaField.text != "" && nomorField.text != ""){
             
            let data = ["nama_nasabah": namaField.text!,
                        "nomor_telepon": nomorField.text!]
            db.collection("nasabah1").document(NasabahController.temp_id).updateData(data)
             
            let alert = UIAlertController(title: "Alert!", message: "Edit nasabah, Sukses!", preferredStyle: UIAlertController.Style.alert)
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
