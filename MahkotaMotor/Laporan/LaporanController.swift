//
//  LaporanController.swift
//  MahkotaMotor
//
//  Created by Athanasius Aryatyasto Pranamya on 13/08/20.
//  Copyright © 2020 Athanasius Arya. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import CodableFirebase

class LaporanController: UIViewController {
    
    let db = Firestore.firestore()
    var laporanList = laporan()
    var searchingLaporanList = laporan()
    var productList = product()
    var searching = false
    static var temp_id = ""
    var temp_untung = 0
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var totalText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        laporanList = []
        titleText.text = LaporanBulanController.temp_text
        readLaporan()
        readProduk()
        
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
    
    func readLaporan() {
        
        db.collection("laporan").document(LaporanBulanController.temp_id).collection("Unit").addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if let nasabah = querySnapshot?.documents {
                    if nasabah.isEmpty {
                        let alert = UIAlertController(title: "Alert!", message: "Data kosong!", preferredStyle: UIAlertController.Style.alert)
                        let close = UIAlertAction(title: "Tutup", style: .cancel) { (alertAction) in
                            debugPrint("Empty")
                        }
                        alert.addAction(close)
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        self.laporanList = []
                        for data in nasabah {
                            let myNasabah = try! FirebaseDecoder().decode(Laporan.self, from: data.data())
                            self.laporanList.append(myNasabah)
                        }
                        
                        for i in 0..<self.laporanList.count {
                            
                            print("\(self.laporanList[i].untung!)")
                            self.temp_untung = self.temp_untung + Int(self.laporanList[i].untung!)!
                            
                        }
                        
                        let formatter = NumberFormatter()
                        formatter.locale = Locale(identifier: "id_ID")
                        formatter.groupingSeparator = "."
                        formatter.numberStyle = .decimal
                        
                        let uang_muka = self.temp_untung
                        if let formattedTipAmount = formatter.string(from: uang_muka as NSNumber) {
                            self.totalText.text = "Rp " + formattedTipAmount
                        }
                        
                        self.tableView.reloadData()
                    }
                }
            }
        }
        
    }
    
    @IBAction func menuTapped(_ sender: Any) {
        
        let actionsheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionsheet.addAction(UIAlertAction(title: "Kembali", style: .default, handler: {(action:UIAlertAction) in
            self.performSegue(withIdentifier: "kembali", sender: Any.self)
        }))
        
        actionsheet.addAction(UIAlertAction(title: "Batal", style: .cancel, handler: nil))
        self.present(actionsheet, animated: true, completion: nil)
    }
    
}

extension LaporanController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchingLaporanList.count
        } else {
            return laporanList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "laporanViewCell", for: indexPath) as? LaporanViewCell else {
            fatalError("The dequeued cell is not an instance")
        }
        
        if searching {
            
            for i in 0..<productList.count {
                
                if searchingLaporanList[indexPath.row].unit_id == productList[i].unit_id {
                    
                    cell.tittle.text = productList[i].nama_unit
                    cell.detail.text = productList[i].nomor_plat
                }
                
            }
            
        } else {
            
            for i in 0..<productList.count {
                
                if laporanList[indexPath.row].unit_id == productList[i].unit_id {
                    
                    cell.tittle.text = productList[i].nama_unit
                    cell.detail.text = productList[i].nomor_plat
                }
                
            }
            
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        LaporanController.temp_id = laporanList[indexPath.row].transaksi_id!
        self.performSegue(withIdentifier: "detailTapped", sender: Any.self)
        
    }
    
}

extension LaporanController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchingLaporanList = laporanList.filter({$0.nama_unit!.lowercased().prefix(searchText.count) == searchText.lowercased() })
        searching = true
        tableView.reloadData()
    }
}
