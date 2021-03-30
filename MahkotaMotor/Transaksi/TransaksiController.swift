//
//  TransaksiController.swift
//  MahkotaMotor
//
//  Created by Athanasius Aryatyasto Pranamya on 28/07/20.
//  Copyright © 2020 Athanasius Arya. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import CodableFirebase

class TransaksiController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let db = Firestore.firestore()
    var bulanList = bulan()
    var transaksiList = transaksi()
    var nasabahList = nasabah()
    var productList = product()
    var searchingTransaksi = transaksi()
    var searching = false
    static var temp_id = ""
    static var temp_index = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readTransaksi()
        readNasabah()
        readProduk()
    }
    
    func readTransaksi() {
        
        db.collection("transaksi").addSnapshotListener { (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
                
                if let transaksi = querySnapshot?.documents {
                    if transaksi.isEmpty {
                        let alert = UIAlertController(title: "Alert!", message: "Data kosong!", preferredStyle: UIAlertController.Style.alert)
                        let close = UIAlertAction(title: "Tutup", style: .cancel) { (alertAction) in
                            debugPrint("Empty")
                        }
                        alert.addAction(close)
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        for data in transaksi {
                            let myTransaksi = try! FirebaseDecoder().decode(Transaksi.self, from: data.data())
                            self.transaksiList.append(myTransaksi)
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
    
    @IBAction func menuTapped(_ sender: Any) {
        
        let actionsheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionsheet.addAction(UIAlertAction(title: "Tambah Transaksi", style: .default, handler: {(action:UIAlertAction) in
            self.performSegue(withIdentifier: "addTransaksi", sender: Any.self)
        }))
        
        actionsheet.addAction(UIAlertAction(title: "Home", style: .default, handler: {(action:UIAlertAction) in
            
            self.performSegue(withIdentifier: "transaksiToHome", sender: Any.self)
        }))
        
        actionsheet.addAction(UIAlertAction(title: "Batal", style: .cancel, handler: nil))
        self.present(actionsheet, animated: true, completion: nil)
    }
    
}

extension TransaksiController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if searching {
            
            if searchingTransaksi[indexPath.row].status_cicilan == "tunggak" {
                return 0
            }
        } else {
            if transaksiList[indexPath.row].status_cicilan == "tunggak" {
                return 0
            }
            
        }
        
        return tableView.rowHeight
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchingTransaksi.count
        } else {
            return transaksiList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "transaksiViewCell", for: indexPath) as? TransaksiViewCell else {
            fatalError("The dequeued cell is not an instance")
        }
        
        if searching {
            
            for i in 0..<nasabahList.count {
                if searchingTransaksi[indexPath.row].nasabah_id == nasabahList[i].nasabah_id {
                    cell.tittle.text = nasabahList[i].nama_nasabah
                }
            }
            
            for i in 0..<productList.count {
                if searchingTransaksi[indexPath.row].unit_id == productList[i].unit_id {
                    cell.detail.text = "ID Transaksi: " + searchingTransaksi[indexPath.row].nomor_idTransaksi!
                }
            }
            
        } else {
            
            for i in 0..<nasabahList.count {
                if transaksiList[indexPath.row].nasabah_id == nasabahList[i].nasabah_id {
                    cell.tittle.text = nasabahList[i].nama_nasabah
                }
            }
            
            for i in 0..<productList.count {
                if transaksiList[indexPath.row].unit_id == productList[i].unit_id {
                    cell.detail.text = "ID Transaksi: " + transaksiList[indexPath.row].nomor_idTransaksi!
                }
            }
            
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        TransaksiController.temp_id = transaksiList[indexPath.row].transaksi_id!
        TransaksiController.temp_index = transaksiList[indexPath.row].index_transaksi!
        self.performSegue(withIdentifier: "cicilan", sender: Any.self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let alert = UIAlertController(title: "Alert", message: "Apakah anda yakin ingin membatalkan transaksi?", preferredStyle: UIAlertController.Style.alert)

            let update = UIAlertAction(title: "Ya", style: .destructive) { (alertAction) in
                
                let alert = UIAlertController(title: "Berhasil!", message: "Transaksi telah dibatalkan!", preferredStyle: UIAlertController.Style.alert)
                let close = UIAlertAction(title: "Tutup", style: .cancel) { (alertAction) in
                
                    let id = self.transaksiList[indexPath.row].transaksi_id!
                    let nasabah = self.transaksiList[indexPath.row].nasabah_id!
                    let index = self.transaksiList[indexPath.row].CREATED_AT!
                    
                    self.transaksiList.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .bottom)
                    
                    self.transaksiList = []
                    
                    self.db.collection("transaksi").document(id).collection("bulan").addSnapshotListener { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            if let nasabah = querySnapshot?.documents {
                                if nasabah.isEmpty {
                                        debugPrint("Empty")
                                } else {
                                    for data in nasabah {
                                        let myProduk = try! FirebaseDecoder().decode(Bulan.self, from: data.data())
                                        self.bulanList.append(myProduk)
                                    }
                                    
                                    for i in 0..<self.bulanList.count {
                                        
                                        let a = self.bulanList[i].bulan_id
                                        
                                        self.db.collection("transaksi").document(id).collection("bulan").document(a!).delete { err in
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
                    
                    self.db.collection("transaksi").document(id).delete { err in
                        if let err = err {
                            print("Error removing document: \(err)")
                        } else {
                            print("Document successfully removed!")
                            print("DONE <<< DONE <<< DONE <<< DONE")
                        }
                    }
                    
                    self.db.collection("laporan").document(index).collection("Unit").document(id).delete()
                    self.db.collection("nasabah1").document(nasabah).collection("history").document(id).delete()
                    
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
    
}

extension TransaksiController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchingTransaksi = transaksiList.filter({$0.nama_nasabah!.lowercased().prefix(searchText.count) == searchText.lowercased() })
        searching = true
        tableView.reloadData()
    }
}
