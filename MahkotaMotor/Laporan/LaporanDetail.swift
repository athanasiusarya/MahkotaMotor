//
//  DetailLaporan.swift
//  MahkotaMotor
//
//  Created by Athanasius Aryatyasto Pranamya on 15/08/20.
//  Copyright © 2020 Athanasius Arya. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import CodableFirebase

class LaporanDetail: UIViewController {
    
    let db = Firestore.firestore()
    var myProduct = product()
    var laporanList = laporan()
    var productList = product()
    var nasabahList = nasabah()
    
    @IBOutlet weak var nasabahLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var hargaLabel: UILabel!
    @IBOutlet weak var uangMukaLabel: UILabel!
    @IBOutlet weak var sisaHutangLabel: UILabel!
    @IBOutlet weak var angsuranLabel: UILabel!
    @IBOutlet weak var tenorLabel: UILabel!
    @IBOutlet weak var jatuhTempoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        readNasabah()
        readProduk()
        readLaporan()
    }
    
    func readLaporan() {
        
        db.collection("laporan").document(LaporanBulanController.temp_id).collection("Unit").addSnapshotListener { (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                if let transaksi = querySnapshot?.documents {
                    if transaksi.isEmpty {
                        debugPrint("Empty")
                    } else {
                        for data in transaksi {
                            let myTransaksi = try! FirebaseDecoder().decode(Laporan.self, from: data.data())
                            self.laporanList.append(myTransaksi)
                        }
                        
                        let formatter = NumberFormatter()
                        formatter.locale = Locale(identifier: "id_ID")
                        formatter.groupingSeparator = "."
                        formatter.numberStyle = .decimal
                        
                        for i in 0..<self.laporanList.count {
                            if LaporanController.temp_id == self.laporanList[i].transaksi_id  {

                                let uang_muka = Int(self.laporanList[i].uang_muka!)!
                                if let formattedTipAmount = formatter.string(from: uang_muka as NSNumber) {
                                    self.uangMukaLabel.text = "Rp " + formattedTipAmount
                                }

                                let sisa_hutang = Int(self.laporanList[i].sisa_hutang!)!
                                if let formattedTipAmount = formatter.string(from: sisa_hutang as NSNumber) {
                                     self.sisaHutangLabel.text = "Rp " + formattedTipAmount
                                }

                                let angsuran = Int(self.laporanList[i].total_cicilan!)!
                                if let formattedTipAmount = formatter.string(from: angsuran as NSNumber) {
                                     self.angsuranLabel.text = "Rp " + formattedTipAmount
                                }

                                self.tenorLabel.text = "\(self.laporanList[i].lama_cicil!) bulan"
                                self.jatuhTempoLabel.text = self.laporanList[i].terjual

                                for j in 0..<self.nasabahList.count {
                                    if self.laporanList[i].nasabah_id == self.nasabahList[j].nasabah_id {
                                        self.nasabahLabel.text = self.nasabahList[j].nama_nasabah
                                    }
                                }

                                for k in 0..<self.productList.count {
                                    if self.laporanList[i].unit_id == self.productList[k].unit_id {
                                        self.unitLabel.text = self.productList[k].nama_unit

                                        let harga = Int(self.productList[k].harga_jual!)!
                                        if let formattedTipAmount = formatter.string(from: harga as NSNumber) {
                                            self.hargaLabel.text = "Rp " + formattedTipAmount
                                        }
                                    }
                                }
                                break
                            }
                        }
                    }
                }
            }
        }
    }
    
    func readNasabah() {
        
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
                    }
                }
            }
        }
    }

}
