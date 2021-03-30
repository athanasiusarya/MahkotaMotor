//
//  AddTransaksi.swift
//  MahkotaMotor
//
//  Created by Athanasius Aryatyasto Pranamya on 28/07/20.
//  Copyright © 2020 Athanasius Arya. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import CodableFirebase

class AddTransaksi: UIViewController {
    
    let db = Firestore.firestore()
    
    var pickerUnit = UIPickerView()
    var pickerNasabah = UIPickerView()
    var pickerLama = UIPickerView()
    
    static var temp_id = ""
    
    var tempUnit_id = ""
    var tempNasabah_id = ""
    var tempNama = ""
    var tempHarga = ""
    var tempCicilan = ""
    var tempSisa = ""
    var temp_nomor = ""
    var temp_untung = ""
    var temp_namaUnit = ""
    
    var productList = product()
    var productListNotDeleted = product()
    var nasabahList = nasabah()
    var idList = idTransaksi()
    var lamaList = [3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24]
    
    @IBOutlet weak var namaUnitField: UITextField!
    @IBOutlet weak var namaNasabahField: UITextField!
    @IBOutlet weak var lamaCicilanField: UITextField!
    @IBOutlet weak var uangMukaField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerUnit.delegate = self
        pickerUnit.dataSource = self
        
        pickerNasabah.delegate = self
        pickerNasabah.dataSource = self
        
        pickerLama.delegate = self
        pickerLama.dataSource = self
        
        namaUnitField.inputView = pickerUnit
        namaNasabahField.inputView = pickerNasabah
        lamaCicilanField.inputView = pickerLama
        
        readId()
        readProduk()
        readNasabah()
        
    }
    
    func readId() {
        
        db.collection("idTransaksi").addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                if let nasabah = querySnapshot?.documents {
                    if nasabah.isEmpty {
                            debugPrint("Empty")
                    } else {
                        for data in nasabah {
                            let myId = try! FirebaseDecoder().decode(IdTransaksi.self, from: data.data())
                            self.idList.append(myId)
                        }
                        
                        for i in 0..<self.idList.count {
                            self.temp_nomor = self.idList[i].nomor_idTransaksi!
                        }
                    }
                }
            }
        }
    }
    
    func readNasabah() {
        
        print(lamaList)
        db.collection("nasabah1").addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if let nasabah = querySnapshot?.documents {
                    if nasabah.isEmpty {
                            debugPrint("Empty")
                    } else {
                        for data in nasabah {
                            let myNasabah = try! FirebaseDecoder().decode(Nasabah.self, from: data.data())
                            self.nasabahList.append(myNasabah)
                        }
                        
                        self.nasabahList = self.nasabahList.sorted(by: { (Nasabah1, Nasabah2) -> Bool in
                            return Nasabah1.nomor_nasabah! < Nasabah2.nomor_nasabah!
                        })
                    }
                }
            }
        }
    }
    
    func readProduk() {
        db.collection("product").addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if let nasabah = querySnapshot?.documents {
                    if nasabah.isEmpty {
                            debugPrint("Empty")
                    } else {
                        for data in nasabah {
                            let myProduk = try! FirebaseDecoder().decode(Product.self, from: data.data())
                            self.productList.append(myProduk)
                        }
                        
                        for i in 0..<self.productList.count {
                            if self.productList[i].status == "tersedia" {
                                let addKe = self.productList[i]
                                self.productListNotDeleted.append(addKe)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func addBtn(_ sender: Any) {
        
        if (namaNasabahField.text != "" && namaUnitField.text != "" && lamaCicilanField.text != "" && uangMukaField.text != ""){
            
            var docReference: DocumentReference? = nil
            var docReferenceBulan: DocumentReference? = nil
            
            let currentDate = Date()
            let formatter = DateFormatter()

            formatter.timeStyle = .medium
            formatter.dateStyle = .long
            
            let previousMonth = Calendar.current.date(byAdding: .month, value: +1, to: Date())
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            
            let laporanFormatter = DateFormatter()
            laporanFormatter.dateFormat = "MMMM yyyy"
            
            let dateISO = DateFormatter()
            dateISO.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
            
            let laporanISO = DateFormatter()
            laporanISO.dateFormat = "yyyy-MM"
            
            let indexFormat = DateFormatter()
            indexFormat.dateFormat = "yyMM"

            for i in 0..<productList.count {
                
                if tempUnit_id == productList[i].unit_id {
                    
                    temp_untung = productList[i].prediksi_untung!
                    temp_namaUnit = productList[i].nama_unit!
                    
                }
                
            }
            
            let data = ["nasabah_id": tempNasabah_id,
                        "nomor_idTransaksi": "\(Int(temp_nomor)!+1)",
                        "jatuh_tempo": "\(dateFormatter.string(from: previousMonth!))",
                        "jatuh_tempo_iso": "\(dateISO.string(from: previousMonth!))",
                        "sisa_hutang": tempSisa,
                        "uang_muka": uangMukaField.text!,
                        "unit_id": tempUnit_id,
                        "nama_nasabah": tempNama,
                        "lama_cicil": "\(lamaCicilanField.text!)",
                        "total_cicilan": "\(tempCicilan)",
                        "untung": temp_untung,
                        "status_cicilan": "aman",
                        "index_transaksi": "0",
                        "kondite": "baik",
                        "terjual": "\(dateFormatter.string(from: currentDate))",
                        "CREATED_AT": "\(laporanISO.string(from: currentDate))"]

            docReference = db.collection("transaksi").addDocument(data: data)
            
            let data2 = ["nomor_idTransaksi": "\(Int(temp_nomor)!+1)"]
            db.collection("idTransaksi").document("6T5BqMsgK2YCAU8b8XnH").updateData(data2)
            
            AddTransaksi.temp_id = docReference?.documentID ?? ""
             
            let update = ["transaksi_id": docReference?.documentID ?? ""]
            docReference?.updateData(update)
            
            let bulanLaporan = ["nama_bulan": "\(laporanFormatter.string(from: currentDate))",
                                "laporan_id": "\(laporanISO.string(from: currentDate))",
                                "index": "\(indexFormat.string(from: currentDate))"]
            db.collection("laporan").document("\(laporanISO.string(from: currentDate))").setData(bulanLaporan)
            
            self.db.collection("laporan").document("\(laporanISO.string(from: currentDate))").collection("Unit").document(docReference?.documentID ?? "").setData(data)
            
            let updateData = [  "transaksi_id": docReference?.documentID ?? "",
                                "nama_unit": temp_namaUnit]
            self.db.collection("laporan").document("\(laporanISO.string(from: currentDate))").collection("Unit").document(docReference?.documentID ?? "").updateData(updateData)
            
            self.db.collection("nasabah1").document(tempNasabah_id).collection("history").document(docReference?.documentID ?? "").setData(data)
            self.db.collection("nasabah1").document(tempNasabah_id).collection("history").document(docReference?.documentID ?? "").updateData(update)
            
            for i in 0..<Int(lamaCicilanField.text!)! {
                
                let previousMonth = Calendar.current.date(byAdding: .month, value: +(i+1), to: Date())
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "LLLL yyyy"
                
                let dateISO = DateFormatter()
                dateISO.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
                
                let addBulan = ["format": "\(dateFormatter.string(from: previousMonth!))",
                                "iso": "\(dateISO.string(from: previousMonth!))",
                                "index": "\(i)",
                                "transaksi_id": docReference?.documentID ?? "",
                                "status": "belum"]
                
                docReferenceBulan = db.collection("transaksi").document(docReference?.documentID ?? "").collection("bulan").addDocument(data: addBulan)
                
                let updateBulan = ["bulan_id": docReferenceBulan?.documentID ?? ""]
                docReferenceBulan?.updateData(updateBulan)
            }
            
            let updateUnit = ["status": "terjual"]
            db.collection("product").document(tempUnit_id).updateData(updateUnit)

            let alert = UIAlertController(title: "Alert!", message: "Tambah transaksi, Sukses!", preferredStyle: UIAlertController.Style.alert)
            let close = UIAlertAction(title: "Tutup", style: .cancel) { (alertAction) in
             self.performSegue(withIdentifier: "lanjutkanTapped", sender: Any.self)
        }

            alert.addAction(close)
            self.present(alert, animated: true, completion: nil)

        } else {
            self.showAlert(text: "Tolong, isi semua field!")
        }
    }
    
}

extension AddTransaksi: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerUnit {
            return productListNotDeleted.count
        } else if pickerView == pickerNasabah {
            return nasabahList.count
        } else {
            return lamaList.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerUnit {
            return "\(productListNotDeleted[row].nama_unit!) - \(productListNotDeleted[row].nomor_plat!)"
        } else if pickerView == pickerNasabah {
            return "\(nasabahList[row].nomor_nasabah!). \(nasabahList[row].nama_nasabah!)"
        } else {
            return "\(lamaList[row])"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerUnit {
            namaUnitField.text = productListNotDeleted[row].nama_unit
            
            let harga_jual = Int(self.productListNotDeleted[row].harga_jual!)!
            tempHarga = "\(harga_jual)"
            
            tempUnit_id = productListNotDeleted[row].unit_id!
            self.view.endEditing(false)
            
        } else if pickerView == pickerNasabah {
            
            namaNasabahField.text = nasabahList[row].nama_nasabah
            tempNasabah_id = nasabahList[row].nasabah_id!
            tempNama = nasabahList[row].nama_nasabah!
            self.view.endEditing(false)
            
        } else {
            
            lamaCicilanField.text = "\(lamaList[row])"
            tempSisa = "\(Int(tempHarga)! - Int(uangMukaField.text!)!)"
            let totalCicilan = Int(tempSisa)! / Int(lamaCicilanField.text!)!
            tempCicilan = "\(totalCicilan)"
            
            self.view.endEditing(false)
        }
    }
    
}
