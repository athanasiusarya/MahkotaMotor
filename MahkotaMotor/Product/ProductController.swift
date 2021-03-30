//
//  ProductController.swift
//  MahkotaMotor
//
//  Created by Athanasius Aryatyasto Pranamya on 23/07/20.
//  Copyright © 2020 Athanasius Arya. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import CodableFirebase

class ProductController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let db = Firestore.firestore()
    var productList = product()
    var searchingProduct = product()
    var searching = false
    static var temp_id = ""
    static var nama_unit = ""
    static var nomor_plat = ""
    static var tahun_unit = ""
    static var harga_beli = ""
    static var tanggal_beli = ""
    static var pembenahan = ""
    static var harga_jual = ""
    static var total_modal = ""
    static var prediksi_untung = ""
    static var detail_pembenahan = ""
    static var status = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readProduct()
    }
    
    func readProduct() {
        
        db.collection("product").addSnapshotListener { (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                if let produk = querySnapshot?.documents {
                    if produk.isEmpty {
                        let alert = UIAlertController(title: "Alert!", message: "Data kosong!", preferredStyle: UIAlertController.Style.alert)
                        let close = UIAlertAction(title: "Tutup", style: .cancel) { (alertAction) in
                            debugPrint("Empty")
                        }
                        alert.addAction(close)
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        for data in produk {
                            let myProduk = try! FirebaseDecoder().decode(Product.self, from: data.data())
                            self.productList.append(myProduk)
                        }
                        
                        DispatchQueue.main.async(execute : {
                            
                            self.productList = self.productList.sorted(by: { (produk1, produk2) -> Bool in
                                let nama1 = produk1.status!
                                let nama2 = produk2.status!
                                return(nama1.localizedCaseInsensitiveCompare(nama2) == .orderedDescending)
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
        
        actionsheet.addAction(UIAlertAction(title: "Tambah Unit", style: .default, handler: {(action:UIAlertAction) in
            self.performSegue(withIdentifier: "addProduk", sender: Any.self)
        }))
        
        actionsheet.addAction(UIAlertAction(title: "Home", style: .default, handler: {(action:UIAlertAction) in
            
            if LoginPage.temp == "A" {
                self.performSegue(withIdentifier: "produkToHome", sender: Any.self)
            } else {
                self.performSegue(withIdentifier: "produkToHomePegawai", sender: Any.self)
            }
            
        }))
        
        actionsheet.addAction(UIAlertAction(title: "Batal", style: .cancel, handler: nil))
        self.present(actionsheet, animated: true, completion: nil)
    }
    
}

extension ProductController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchingProduct.count
        } else {
            return productList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "productViewCell", for: indexPath) as? ProductViewCell else {
            fatalError("The dequeued cell is not an instance")
        }
        
        if searching {
            let data = searchingProduct[indexPath.row]
            
            cell.tittle.text = data.nama_unit
            cell.subtittle.text = data.nomor_plat
            cell.status.text = data.status
            if data.status == "tersedia" {
                cell.status.textColor = UIColor.init(red: 87/255.0, green: 177/255.0, blue: 159/255.0, alpha: 1)
            } else {
                cell.status.textColor = UIColor.init(red: 236/255.0, green: 122/255.0, blue: 118/255.0, alpha: 1)
            }
            
        } else {
            
            let data = productList[indexPath.row]
            
            cell.tittle.text = data.nama_unit
            cell.subtittle.text = data.nomor_plat
            cell.status.text = data.status
            if data.status == "tersedia" {
                cell.status.textColor = UIColor.init(red: 87/255.0, green: 177/255.0, blue: 159/255.0, alpha: 1)
            } else {
                cell.status.textColor = UIColor.init(red: 236/255.0, green: 122/255.0, blue: 118/255.0, alpha: 1)
            }
            
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        ProductController.temp_id = productList[indexPath.row].unit_id!
        ProductController.nama_unit = productList[indexPath.row].nama_unit!
        ProductController.nomor_plat = productList[indexPath.row].nomor_plat!
        ProductController.tahun_unit = productList[indexPath.row].tahun_unit!
        ProductController.harga_beli = productList[indexPath.row].harga_beli!
        ProductController.tanggal_beli = productList[indexPath.row].tanggal_beli!
        ProductController.pembenahan = productList[indexPath.row].pembenahan!
        ProductController.harga_jual = productList[indexPath.row].harga_jual!
        ProductController.total_modal = productList[indexPath.row].total_modal!
        ProductController.prediksi_untung = productList[indexPath.row].prediksi_untung!
        ProductController.detail_pembenahan = productList[indexPath.row].detail_pembenahan!
        ProductController.status = productList[indexPath.row].status!
        
        self.performSegue(withIdentifier: "detailUnit", sender: Any.self)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let id = productList[indexPath.row].unit_id!
            
            productList.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .bottom)
            
            self.productList = []
            
            db.collection("product").document(id).delete(){ err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                }
            }
        }
        
    }
    
}

extension ProductController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchingProduct = productList.filter({$0.nama_unit!.lowercased().prefix(searchText.count) == searchText.lowercased() })
        searching = true
        tableView.reloadData()
    }
}

