//
//  NasabahController.swift
//  MahkotaMotor
//
//  Created by Athanasius Aryatyasto Pranamya on 23/07/20.
//  Copyright © 2020 Athanasius Arya. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import CodableFirebase

class NasabahController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let db = Firestore.firestore()
    var nasabahList = nasabah()
    var searchingNasabah = nasabah()
    var searching = false
    static var temp_id = ""
    static var temp_nama = ""
    static var temp_no = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readNasabah()
    }
    
    func readNasabah() {
        
        db.collection("nasabah1").addSnapshotListener { (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => NasabahController \(document.data())")
                }
                
                if let nasabah = querySnapshot?.documents {
                    if nasabah.isEmpty {
                        let alert = UIAlertController(title: "Alert!", message: "Data kosong!", preferredStyle: UIAlertController.Style.alert)
                        let close = UIAlertAction(title: "Tutup", style: .cancel) { (alertAction) in
                            debugPrint("Empty")
                        }
                        alert.addAction(close)
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        for data in nasabah {
                            let myProduk = try! FirebaseDecoder().decode(Nasabah.self, from: data.data())
                            self.nasabahList.append(myProduk)
                        }
                        
                        DispatchQueue.main.async(execute : {
                            
                            self.nasabahList = self.nasabahList.sorted(by: { (Nasabah1, Nasabah2) -> Bool in
                                return Int(Nasabah1.nomor_nasabah!)! < Int(Nasabah2.nomor_nasabah!)!
                            })
                            
                            self.tableView?.reloadData()
                        })
                    }
                }
            }
        }
    }
    
    @IBAction func menuTapped(_ sender: Any) {
        
        let actionsheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionsheet.addAction(UIAlertAction(title: "Tambah Nasabah", style: .default, handler: {(action:UIAlertAction) in
            self.performSegue(withIdentifier: "addNasabah", sender: Any.self)
        }))
        
        actionsheet.addAction(UIAlertAction(title: "Home", style: .default, handler: {(action:UIAlertAction) in
            if LoginPage.temp == "A" {
                self.performSegue(withIdentifier: "nasabahToHome", sender: Any.self)
            } else {
                self.performSegue(withIdentifier: "nasabahToHomePegawai", sender: Any.self)
            }
        }))
        
        actionsheet.addAction(UIAlertAction(title: "Batal", style: .cancel, handler: nil))
        self.present(actionsheet, animated: true, completion: nil)
    }
    
}

extension NasabahController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchingNasabah.count
        } else {
            return nasabahList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "nasabahViewCell", for: indexPath) as? NasabahViewCell else {
            fatalError("The dequeued cell is not an instance")
        }
        
        if searching {
            
            let data = searchingNasabah[indexPath.row]
            cell.tittle.text = data.nomor_nasabah! + ". " + data.nama_nasabah!
            
        } else {
            
            let data = nasabahList[indexPath.row]
            cell.tittle.text = data.nomor_nasabah! + ". " + data.nama_nasabah!
            
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        NasabahController.temp_id = nasabahList[indexPath.row].nasabah_id!
        NasabahController.temp_nama = nasabahList[indexPath.row].nama_nasabah!
        NasabahController.temp_no = nasabahList[indexPath.row].nomor_telepon!
        self.performSegue(withIdentifier: "detailTapped", sender: Any.self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let id = nasabahList[indexPath.row].nasabah_id!
            
            nasabahList.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .bottom)
            
            self.nasabahList = []
            
            db.collection("nasabah1").document(id).delete(){ err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                }
            }
        }
        
    }
    
}

extension NasabahController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchingNasabah = nasabahList.filter({$0.nama_nasabah!.lowercased().prefix(searchText.count) == searchText.lowercased() })
        searching = true
        tableView.reloadData()
    }
}

