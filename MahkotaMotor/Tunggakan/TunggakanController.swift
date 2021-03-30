//
//  TunggakanController.swift
//  MahkotaMotor
//
//  Created by Athanasius Aryatyasto Pranamya on 07/08/20.
//  Copyright © 2020 Athanasius Arya. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import CodableFirebase

class TunggakanController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let db = Firestore.firestore()

    var transaksiList = transaksi()
    var tunggakanList = tunggakan()
    var nasabahList = nasabah()
    var productList = product()
    var bulanList = bulan()
    var searchingTunggakan = tunggakan()
    let currentDate = Date()
    var currentDay = ""
    var currentMonth = ""
    var currentYear = ""
    var searching = false
    var temp = 0
    
    static var temp_id = ""

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MM"

        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yy"

        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "dd"

        currentDay = "\(dayFormatter.string(from: currentDate))"
        currentMonth = "\(monthFormatter.string(from: currentDate))"
        currentYear = "\(yearFormatter.string(from: currentDate))"
        
        readProduk()
        readNasabah()
        readTransaksi()
        readTunggakan()
        
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
                        self.transaksiList = []
                        for data in transaksi {
                            let myTransaksi = try! FirebaseDecoder().decode(Transaksi.self, from: data.data())
                            self.transaksiList.append(myTransaksi)
                        }

                        for i in 0..<self.transaksiList.count {
                            
                            if self.transaksiList[i].transaksi_id == nil {
                                print("NIL <<< NIL <<< NIL <<< NIL <<< NIL")
                                break
                            }
                            
                            print("i:\(i), Transaksi ID: \(self.transaksiList[i].transaksi_id!)")

                            self.db.collection("transaksi").document(self.transaksiList[i].transaksi_id!).collection("bulan").addSnapshotListener { (querySnapshot, errr) in
                                if let errr = errr {
                                    print("Error getting documents: \(errr)")
                                } else {
                                    if let transaksi = querySnapshot?.documents {
                                        if transaksi.isEmpty {
                                            debugPrint("Empty")
                                        } else {
                                            self.bulanList = []
                                            for data in transaksi {
                                                let myBulan = try! FirebaseDecoder().decode(Bulan.self, from: data.data())
                                                self.bulanList.append(myBulan)
                                            }
                                            
                                            self.bulanList = self.bulanList.sorted(by: { (Bulan1, Bulan2) -> Bool in
                                                return Bulan1.index! < Bulan2.index!
                                            })

                                            for j in 0..<self.bulanList.count {

                                                let dateFormatterIso = ISO8601DateFormatter()
                                                let lengkapIso = dateFormatterIso.date(from: self.bulanList[j].iso!)

                                                let dayFormatter = DateFormatter()
                                                dayFormatter.dateFormat = "dd"

                                                let monthFormatter = DateFormatter()
                                                monthFormatter.dateFormat = "MM"

                                                let yearFormatter = DateFormatter()
                                                yearFormatter.dateFormat = "yy"

                                                let hariIso = "\(dayFormatter.string(from: lengkapIso!))"
                                                let bulanIso = "\(monthFormatter.string(from: lengkapIso!))"
                                                let tahunIso = "\(yearFormatter.string(from: lengkapIso!))"

                                                if tahunIso < self.currentYear && self.bulanList[j].status != "lunas" {
                                                    print("Tunggak: Tahun, Transaksi ID: \(self.transaksiList[i].transaksi_id!), Bulan ID: \(self.bulanList[j].bulan_id!), ISO: \(self.bulanList[j].iso!)")
                                                    
                                                    let tunggak = ["status_cicilan": "tunggak"]
                                                    self.db.collection("transaksi").document(self.transaksiList[i].transaksi_id!).updateData(tunggak)
                                                    
                                                    let data = ["transaksi_id": self.transaksiList[i].transaksi_id!,
                                                                "nama_nasabah": self.transaksiList[i].nama_nasabah!,
                                                                "index": self.transaksiList[i].nomor_idTransaksi!,
                                                                "iso": self.bulanList[j].iso!]
                                                    self.db.collection("tunggakan").document(self.transaksiList[i].transaksi_id!).setData(data)
                                                    
                                                    break
                                                    
                                                } else if tahunIso == self.currentYear && bulanIso < self.currentMonth && self.bulanList[j].status != "lunas" {
                                                    print("Tunggak: Bulan, Transaksi ID: \(self.transaksiList[i].transaksi_id!), Bulan ID: \(self.bulanList[j].bulan_id!), ISO: \(self.bulanList[j].iso!)")
                                                    
                                                    let tunggak = ["status_cicilan": "tunggak"]
                                                    self.db.collection("transaksi").document(self.transaksiList[i].transaksi_id!).updateData(tunggak)
                                                    
                                                    let data = ["transaksi_id": self.transaksiList[i].transaksi_id!,
                                                                "nama_nasabah": self.transaksiList[i].nama_nasabah!,
                                                                "index": self.transaksiList[i].nomor_idTransaksi!,
                                                                "iso": self.bulanList[j].iso!]
                                                    self.db.collection("tunggakan").document(self.transaksiList[i].transaksi_id!).setData(data)
                                                    
                                                    break
                                                    
                                                } else if tahunIso == self.currentYear && bulanIso == self.currentMonth && hariIso < self.currentDay && self.bulanList[j].status != "lunas" {
                                                    print("Tunggak: Hari, Transaksi ID: \(self.transaksiList[i].transaksi_id!), Bulan ID: \(self.bulanList[j].bulan_id!), ISO: \(self.bulanList[j].iso!)")
                                                    
                                                    let tunggak = ["status_cicilan": "tunggak"]
                                                    self.db.collection("transaksi").document(self.transaksiList[i].transaksi_id!).updateData(tunggak)
                                                    
                                                    let data = ["transaksi_id": self.transaksiList[i].transaksi_id!,
                                                                "nama_nasabah": self.transaksiList[i].nama_nasabah!,
                                                                "index": self.transaksiList[i].nomor_idTransaksi!,
                                                                "iso": self.bulanList[j].iso!]
                                                    self.db.collection("tunggakan").document(self.transaksiList[i].transaksi_id!).setData(data)
                                                    
                                                    break
                                                    
                                                } else {
                                                    print("Aman <<< i:\(i), j:\(j)")
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            
                            if i == self.transaksiList.count {
                                break
                            }
                        } // for
                    }
                }
            }
        }
    }
    
    func readTunggakan() {
        
        db.collection("tunggakan").addSnapshotListener { (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                if let tunggakan = querySnapshot?.documents {
                    if tunggakan.isEmpty {
                        let alert = UIAlertController(title: "Alert!", message: "Data kosong!", preferredStyle: UIAlertController.Style.alert)
                        let close = UIAlertAction(title: "Tutup", style: .cancel) { (alertAction) in
                            debugPrint("Empty")
                        }
                        alert.addAction(close)
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        for data in tunggakan {
                            let myTunggakan = try! FirebaseDecoder().decode(Tunggakan.self, from: data.data())
                            self.tunggakanList.append(myTunggakan)
                        }
                        
                        DispatchQueue.main.async(execute : {
                            self.tableView?.reloadData()
                        })
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
                    }
                }
            }
        }
    }
    
    func readProduk() {
        db.collection("produk").addSnapshotListener { (querySnapshot, err) in
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
    
    @IBAction func menuTapped(_ sender: Any) {
        
        let actionsheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionsheet.addAction(UIAlertAction(title: "Home", style: .default, handler: {(action:UIAlertAction) in
            self.performSegue(withIdentifier: "tunggakanToHome", sender: Any.self)
        }))
        
        actionsheet.addAction(UIAlertAction(title: "Batal", style: .cancel, handler: nil))
        self.present(actionsheet, animated: true, completion: nil)
    }
    
}

extension TunggakanController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchingTunggakan.count
        } else {
            return tunggakanList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tunggakanViewCell", for: indexPath) as? TunggakanViewCell else {
            fatalError("The dequeued cell is not an instance")
        }
        
        if searching {
            
            for i in 0..<transaksiList.count {
                if searchingTunggakan[indexPath.row].transaksi_id == transaksiList[i].transaksi_id {
                    cell.tittle.text = transaksiList[i].nama_nasabah
                    
                    let formatter = NumberFormatter()
                    formatter.locale = Locale(identifier: "id_ID")
                    formatter.groupingSeparator = "."
                    formatter.numberStyle = .decimal
                    
                    let total_cicilan = Int(self.transaksiList[i].total_cicilan!)!
                    if let formattedTipAmount = formatter.string(from: total_cicilan as NSNumber) {
                        cell.detail.text = "Rp " + formattedTipAmount
                    }
                    
                    let aIso = ISO8601DateFormatter()
                    let bIso = aIso.date(from: self.searchingTunggakan[indexPath.row].iso!)

                    let cFormatter = DateFormatter()
                    cFormatter.dateFormat = "MMMM yyyy"
                    
                    cell.sub.text = "\(cFormatter.string(from: bIso!))"
                }
            }
            
        } else {
            
            for i in 0..<transaksiList.count {
                if tunggakanList[indexPath.row].transaksi_id == transaksiList[i].transaksi_id {
                    cell.tittle.text = transaksiList[i].nama_nasabah
                    
                    let formatter = NumberFormatter()
                    formatter.locale = Locale(identifier: "id_ID")
                    formatter.groupingSeparator = "."
                    formatter.numberStyle = .decimal
                    
                    let total_cicilan = Int(self.transaksiList[i].total_cicilan!)!
                    if let formattedTipAmount = formatter.string(from: total_cicilan as NSNumber) {
                        cell.detail.text = "Rp " + formattedTipAmount
                    }
                    
                    let aIso = ISO8601DateFormatter()
                    let bIso = aIso.date(from: self.tunggakanList[indexPath.row].iso!)

                    let cFormatter = DateFormatter()
                    cFormatter.dateFormat = "MMMM yyyy"
                    
                    cell.sub.text = "\(cFormatter.string(from: bIso!))"
                }
            }
            
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "Alert", message: "Apakah anda ingin membatalkan tunggakan?", preferredStyle: UIAlertController.Style.alert)

        let update = UIAlertAction(title: "Ya", style: .destructive) { (alertAction) in
            
            let alert = UIAlertController(title: "Berhasil!", message: "Data tunggakan telah dipindahkan ke transaksi!", preferredStyle: UIAlertController.Style.alert)
            let close = UIAlertAction(title: "Tutup", style: .cancel) { (alertAction) in
            
                let id = self.tunggakanList[indexPath.row].transaksi_id!
                
                self.tunggakanList.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .bottom)
                
                self.tunggakanList = []
                
                self.db.collection("tunggakan").document(id).delete(){ err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        print("Document successfully removed!")
                    }
                }
                
                TunggakanController.temp_id = id
                self.performSegue(withIdentifier: "toHome", sender: Any.self)
                
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
        
    }
    
}

extension TunggakanController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchingTunggakan = tunggakanList.filter({$0.nama_nasabah!.lowercased().prefix(searchText.count) == searchText.lowercased() })
        searching = true
        tableView.reloadData()
    }
}
