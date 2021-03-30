//
//  AddNasabah.swift
//  MahkotaMotor
//
//  Created by Athanasius Aryatyasto Pranamya on 24/07/20.
//  Copyright © 2020 Athanasius Arya. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import CodableFirebase

class AddNasabah: UIViewController {
    
    let db = Firestore.firestore()
    var nasabahList = nasabah()
    var temp_nomor = ""
    var idList = id()
    
    @IBOutlet weak var namaField: UITextField!
    @IBOutlet weak var nomorField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readId()
    }
    
    func readId() {
        
        db.collection("id").addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                if let nasabah = querySnapshot?.documents {
                    if nasabah.isEmpty {
                            debugPrint("Empty")
                    } else {
                        for data in nasabah {
                            let myId = try! FirebaseDecoder().decode(Id.self, from: data.data())
                            self.idList.append(myId)
                        }
                        
                        for i in 0..<self.idList.count {
                            self.temp_nomor = self.idList[i].nomor_id!
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func selesaiBtn(_ sender: Any) {
        
        if (namaField.text != "" && nomorField.text != ""){
            
            var docReference: DocumentReference? = nil
            
            let currentDate = Date()
            let formatter = DateFormatter()
            
            formatter.timeStyle = .medium
            formatter.dateStyle = .long
            
            let dateTimeString = formatter.string(from: currentDate)
            
            let data = ["nama_nasabah": namaField.text!,
                        "nomor_nasabah": "\(Int(temp_nomor)!+1)",
                        "nomor_telepon": nomorField.text!,
                        "CREATED_AT": dateTimeString]
            
            docReference = db.collection("nasabah1").addDocument(data: data)
            
            let data2 = ["nomor_id": "\(Int(temp_nomor)!+1)"]
            db.collection("id").document("AMyxjLFFH9ZZ97GKEND6").updateData(data2)
            
            let update = ["nasabah_id": docReference?.documentID ?? ""]
            docReference?.updateData(update)
            
            let alert = UIAlertController(title: "Alert!", message: "Tambah nasabah, Sukses!", preferredStyle: UIAlertController.Style.alert)
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
