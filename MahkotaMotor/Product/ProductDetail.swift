//
//  ProductDetail.swift
//  MahkotaMotor
//
//  Created by Athanasius Aryatyasto Pranamya on 25/07/20.
//  Copyright © 2020 Athanasius Arya. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import CodableFirebase

class ProductDetail: UIViewController {
   
    @IBOutlet weak var namaLabel: UILabel!
    @IBOutlet weak var platLabel: UILabel!
    @IBOutlet weak var tahunLabel: UILabel!
    @IBOutlet weak var tahunBeliLabel: UILabel!
    @IBOutlet weak var hargaBeliLabel: UILabel!
    @IBOutlet weak var pembenahanLabel: UILabel!
    @IBOutlet weak var totalModalLabel: UILabel!
    @IBOutlet weak var hargaJualLabel: UILabel!
    @IBOutlet weak var prediksiUntungLabel: UILabel!
    @IBOutlet weak var textViewLabel: UITextView!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        let harga_beli = Int(ProductController.harga_beli)!
        let pembenahan = Int(ProductController.pembenahan)!
        let total_modal = Int(ProductController.total_modal)!
        let harga_jual = Int(ProductController.harga_jual)!
        let prediksi_untung = Int(ProductController.prediksi_untung)!
        
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.groupingSeparator = "."
        formatter.numberStyle = .decimal
        
        if let formattedTipAmount = formatter.string(from: harga_beli as NSNumber) {
            self.hargaBeliLabel.text = "Rp " + formattedTipAmount
        }
        
        if let formattedTipAmount = formatter.string(from: pembenahan as NSNumber) {
            self.pembenahanLabel.text = "Rp " + formattedTipAmount
        }
        
        if let formattedTipAmount = formatter.string(from: total_modal as NSNumber) {
            self.totalModalLabel.text = "Rp " + formattedTipAmount
        }
        
        if let formattedTipAmount = formatter.string(from: harga_jual as NSNumber) {
            self.hargaJualLabel.text = "Rp " + formattedTipAmount
        }
        
        if let formattedTipAmount = formatter.string(from: prediksi_untung as NSNumber) {
            self.prediksiUntungLabel.text = "Rp " + formattedTipAmount
        }
        
        self.namaLabel.text = ProductController.nama_unit
        self.platLabel.text = ProductController.nomor_plat
        self.tahunLabel.text = ProductController.tahun_unit
        self.tahunBeliLabel.text = ProductController.tanggal_beli
        self.textViewLabel.text = ProductController.detail_pembenahan
        self.statusLabel.text = ProductController.status
        
        if self.statusLabel.text == "tersedia" {
            self.statusLabel.textColor = UIColor.init(red: 87/255.0, green: 177/255.0, blue: 159/255.0, alpha: 1)
        } else {
            self.statusLabel.textColor = UIColor.init(red: 236/255.0, green: 122/255.0, blue: 118/255.0, alpha: 1)
        }
    }
    
}
