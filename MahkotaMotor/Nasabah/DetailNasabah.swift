//
//  DetailNasabah.swift
//  MahkotaMotor
//
//  Created by Athanasius Aryatyasto Pranamya on 17/08/20.
//  Copyright © 2020 Athanasius Arya. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import CodableFirebase

class DetailNasabah: UIViewController {
    
    let db = Firestore.firestore()
    
    var historyList = history()
    var productList = product()
    
    static var temp_id = ""
    
    @IBOutlet weak var namaLabel: UILabel!
    @IBOutlet weak var noTelpLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        namaLabel.text = NasabahController.temp_nama
        noTelpLabel.text = NasabahController.temp_no
        
        readProduk()
        readHistory()
        
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
    
    func readHistory() {
        
        db.collection("nasabah1").document(NasabahController.temp_id).collection("history").addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                if let nasabah = querySnapshot?.documents {
                    if nasabah.isEmpty {
                        let alert = UIAlertController(title: "Alert!", message: "History kosong!", preferredStyle: UIAlertController.Style.alert)
                        let close = UIAlertAction(title: "Tutup", style: .cancel) { (alertAction) in
                            debugPrint("Empty")
                        }
                        alert.addAction(close)
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        for data in nasabah {
                            let myProduk = try! FirebaseDecoder().decode(History.self, from: data.data())
                            self.historyList.append(myProduk)
                        }
                        
                        DispatchQueue.main.async(execute : {
                            self.tableView?.reloadData()
                        })
                    }
                }
            }
        }
    }
    
}

extension DetailNasabah: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "historyViewCell", for: indexPath) as? HistoryViewCell else {
            fatalError("The dequeued cell is not an instance")
        }
            
        for i in 0..<productList.count {
            
            if historyList[indexPath.row].unit_id == productList[i].unit_id {
                
                cell.tittle.text = productList[i].nama_unit
                cell.detail.text = historyList[indexPath.row].kondite
                
                if historyList[indexPath.row].kondite == "baik" {
                    cell.detail.textColor = UIColor.init(red: 87/255.0, green: 177/255.0, blue: 159/255.0, alpha: 1)
                } else {
                    cell.detail.textColor = UIColor.init(red: 236/255.0, green: 122/255.0, blue: 118/255.0, alpha: 1)
                }
            }
            
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        DetailNasabah.temp_id = historyList[indexPath.row].transaksi_id!
        self.performSegue(withIdentifier: "detailTapped", sender: Any.self)
    }
    
}
