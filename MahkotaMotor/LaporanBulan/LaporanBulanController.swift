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

class LaporanBulanController: UIViewController {
    
    let db = Firestore.firestore()
    var laporanBulanList = laporanBulan()
    var searchingLaporanBulanList = laporanBulan()
    var searching = false
    static var temp_id = ""
    static var temp_text = ""
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        readLaporanBulan()
        
    }
    
    func readLaporanBulan() {
        
        db.collection("laporan").addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if let nasabah = querySnapshot?.documents {
                    if nasabah.isEmpty {
                            debugPrint("Empty")
                    } else {
                        for data in nasabah {
                            let myNasabah = try! FirebaseDecoder().decode(LaporanBulan.self, from: data.data())
                            self.laporanBulanList.append(myNasabah)
                        }
                        
                        self.laporanBulanList = self.laporanBulanList.sorted(by: { (Bulan1, Bulan2) -> Bool in
                            return Int(Bulan1.index!)! < Int(Bulan2.index!)!
                        })
                        
                        self.tableView.reloadData()
                    }
                }
            }
        }
        
    }
    
    @IBAction func menuTapped(_ sender: Any) {
        
        let actionsheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionsheet.addAction(UIAlertAction(title: "Home", style: .default, handler: {(action:UIAlertAction) in
            self.performSegue(withIdentifier: "laporanToHome", sender: Any.self)
        }))
        
        actionsheet.addAction(UIAlertAction(title: "Batal", style: .cancel, handler: nil))
        self.present(actionsheet, animated: true, completion: nil)
    }
    
}

extension LaporanBulanController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchingLaporanBulanList.count
        } else {
            return laporanBulanList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "laporanBulanViewCell", for: indexPath) as? LaporanBulananViewCell else {
            fatalError("The dequeued cell is not an instance")
        }
        
        if searching {
            
            let data = searchingLaporanBulanList[indexPath.row]
            cell.tittle.text = data.nama_bulan!
            
        } else {
            
            let data = laporanBulanList[indexPath.row]
            cell.tittle.text = data.nama_bulan!
            
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        LaporanBulanController.temp_id = laporanBulanList[indexPath.row].laporan_id!
        LaporanBulanController.temp_text = laporanBulanList[indexPath.row].nama_bulan!
        self.performSegue(withIdentifier: "detailTapped", sender: Any.self)
    }
    
}

extension LaporanBulanController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchingLaporanBulanList = laporanBulanList.filter({$0.nama_bulan!.lowercased().prefix(searchText.count) == searchText.lowercased() })
        searching = true
        tableView.reloadData()
    }
}
