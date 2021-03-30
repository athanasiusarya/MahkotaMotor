//
//  Cicilan.swift
//  MahkotaMotor
//
//  Created by Athanasius Aryatyasto Pranamya on 05/08/20.
//  Copyright © 2020 Athanasius Arya. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import CodableFirebase

class Cicilan: UIViewController {
    
    let db = Firestore.firestore()
    var bulanList = bulan()
    var bulanListDelete = bulan()
    var transaksiList = transaksi()
    var productList = product()
    var nasabahList = nasabah()
    var temp_status = ""
    
    @IBOutlet weak var tableView: UITableView!
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
        readTransaksi()
        readBulan()
    }
    
    func readBulan() {
        
        db.collection("transaksi").document(TransaksiController.temp_id).collection("bulan").addSnapshotListener { (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                if let transaksi = querySnapshot?.documents {
                    if transaksi.isEmpty {
                        debugPrint("Empty")
                    } else {
                        for data in transaksi {
                            let myBulan = try! FirebaseDecoder().decode(Bulan.self, from: data.data())
                            self.bulanList.append(myBulan)
                        }
                        
                        DispatchQueue.main.async(execute : {
                            
                            self.bulanList = self.bulanList.sorted(by: { (Bulan1, Bulan2) -> Bool in
                                return Bulan1.index! < Bulan2.index!
                            })
                            
                            if self.bulanList[self.bulanList.count-1].status == "lunas" {
                                
                                self.db.collection("transaksi").document(TransaksiController.temp_id).collection("bulan").addSnapshotListener { (querySnapshot, err) in
                                    if let err = err {
                                        print("Error getting documents: \(err)")
                                    } else {
                                        if let nasabah = querySnapshot?.documents {
                                            if nasabah.isEmpty {
                                                    debugPrint("Empty")
                                            } else {
                                                for data in nasabah {
                                                    let myProduk = try! FirebaseDecoder().decode(Bulan.self, from: data.data())
                                                    self.bulanListDelete.append(myProduk)
                                                }
                                                
                                                for i in 0..<self.bulanListDelete.count {
                                                    
                                                    let a = self.bulanListDelete[i].bulan_id
                                                    
                                                    self.db.collection("transaksi").document(TransaksiController.temp_id).collection("bulan").document(a!).delete { err in
                                                        if let err = err {
                                                            print("Error removing document: \(err)")
                                                        } else {
                                                            print("Document successfully removed!")
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                self.db.collection("transaksi").document(TransaksiController.temp_id).delete { err in
                                    if let err = err {
                                        print("Error removing document: \(err)")
                                    } else {
                                        print("Document successfully removed!")
                                    }
                                }
                                
                                let alert = UIAlertController(title: "Lunas!", message: "Transaksi Lunas telah dipindahkan ke Laporan Bulanan!", preferredStyle: UIAlertController.Style.alert)
                                let close = UIAlertAction(title: "Tutup", style: .cancel) { (alertAction) in
                                    
                                    self.performSegue(withIdentifier: "cicilanLunas", sender: Any.self)
                                }
                                
                                alert.addAction(close)
                                self.present(alert, animated: true, completion: nil)
                                
                            }
                            
                            self.tableView?.reloadData()
                        })
                        
                    }
                }
            }
        }
        
    }
    
    func readTransaksi() {
        
        db.collection("transaksi").addSnapshotListener { (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                if let transaksi = querySnapshot?.documents {
                    if transaksi.isEmpty {
                        debugPrint("Empty")
                    } else {
                        for data in transaksi {
                            let myTransaksi = try! FirebaseDecoder().decode(Transaksi.self, from: data.data())
                            self.transaksiList.append(myTransaksi)
                        }
                        
                        let formatter = NumberFormatter()
                        formatter.locale = Locale(identifier: "id_ID")
                        formatter.groupingSeparator = "."
                        formatter.numberStyle = .decimal
                        
                        for i in 0..<self.transaksiList.count {
                            if TransaksiController.temp_id == self.transaksiList[i].transaksi_id  {
                                
                                self.temp_status = self.transaksiList[i].status_cicilan!
                                
                                let uang_muka = Int(self.transaksiList[i].uang_muka!)!
                                if let formattedTipAmount = formatter.string(from: uang_muka as NSNumber) {
                                    self.uangMukaLabel.text = "Rp " + formattedTipAmount
                                }
                                
                                let sisa_hutang = Int(self.transaksiList[i].sisa_hutang!)!
                                if let formattedTipAmount = formatter.string(from: sisa_hutang as NSNumber) {
                                     self.sisaHutangLabel.text = "Rp " + formattedTipAmount
                                }
                                
                                let angsuran = Int(self.transaksiList[i].total_cicilan!)!
                                if let formattedTipAmount = formatter.string(from: angsuran as NSNumber) {
                                     self.angsuranLabel.text = "Rp " + formattedTipAmount
                                }
                                
                                self.tenorLabel.text = "\(self.transaksiList[i].lama_cicil!) bulan"
                                self.jatuhTempoLabel.text = self.transaksiList[i].jatuh_tempo
                                
                                for j in 0..<self.nasabahList.count {
                                    if self.transaksiList[i].nasabah_id == self.nasabahList[j].nasabah_id {
                                        self.nasabahLabel.text = self.nasabahList[j].nama_nasabah
                                        break
                                    }
                                }
                                
                                for k in 0..<self.productList.count {
                                    if self.transaksiList[i].unit_id == self.productList[k].unit_id {
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

extension Cicilan: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
            return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bulanList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cicilanViewCell", for: indexPath) as? CicilanViewCell else {
            fatalError("The dequeued cell is not an instance")
        }
            
        cell.tittle.text = bulanList[indexPath.row].format
        cell.detail.text = bulanList[indexPath.row].status
        if bulanList[indexPath.row].status == "lunas" {
            cell.detail.textColor = UIColor.init(red: 87/255.0, green: 177/255.0, blue: 159/255.0, alpha: 1)
        } else {
            cell.detail.textColor = UIColor.init(red: 236/255.0, green: 122/255.0, blue: 118/255.0, alpha: 1)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if bulanList[indexPath.row].status == "lunas" {
            
            let alert = UIAlertController(title: "Alet!", message: "Cicilan bulan \(self.bulanList[indexPath.row].format!), Sudah Lunas!", preferredStyle: UIAlertController.Style.alert)
            let close = UIAlertAction(title: "Tutup", style: .cancel) { (alertAction) in
                print("Sudah lunas")
            }
            
            alert.addAction(close)
            self.present(alert, animated: true, completion: nil)
            
        } else if TransaksiController.temp_index == bulanList[indexPath.row].index {
        
            let alert = UIAlertController(title: "Alert", message: "Apakah anda ingin merubah status bulan \(bulanList[indexPath.row].format!) menjadi Lunas?", preferredStyle: UIAlertController.Style.alert)

            let update = UIAlertAction(title: "Ya", style: .destructive) { (alertAction) in
                
                let alert = UIAlertController(title: "Berhasil!", message: "Cicilan bulan \(self.bulanList[indexPath.row].format!), Lunas!", preferredStyle: UIAlertController.Style.alert)
                let close = UIAlertAction(title: "Tutup", style: .cancel) { (alertAction) in
                    
                    let datanya = [ "status": "lunas"]
                    let updateData = ["index_transaksi": "\(Int(TransaksiController.temp_index)!+1)"]
                    
                    TransaksiController.temp_index = "\(Int(TransaksiController.temp_index)!+1)"
                    
                    if self.temp_status == "tunggak" {

                        self.db.collection("transaksi").document(TunggakanController.temp_id).updateData(updateData)
                        
                        self.db.collection("transaksi").document(TunggakanController.temp_id).collection("bulan").document(self.bulanList[indexPath.row].bulan_id!).updateData(datanya)
                        
                        
                    } else {
                        
                        self.db.collection("transaksi").document(TransaksiController.temp_id).updateData(updateData)
                        
                        self.db.collection("transaksi").document(TransaksiController.temp_id).collection("bulan").document(self.bulanList[indexPath.row].bulan_id!).updateData(datanya)
                        
                    }
                    
                    self.bulanList = []
                    
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
        } else {
            
            let alert = UIAlertController(title: "Alert!", message: "Silakan lakukan pelunasan pada bulan sebelumnya terlebih dahulu!", preferredStyle: UIAlertController.Style.alert)
            let close = UIAlertAction(title: "Tutup", style: .cancel) { (alertAction) in
                
            }
            
            alert.addAction(close)
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    
}
