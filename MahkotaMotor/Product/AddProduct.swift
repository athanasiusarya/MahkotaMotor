//
//  AddProduct.swift
//  MahkotaMotor
//
//  Created by Athanasius Aryatyasto Pranamya on 24/07/20.
//  Copyright © 2020 Athanasius Arya. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class AddProduct: UIViewController {
    
    let db = Firestore.firestore()
    
    var datePicker = UIDatePicker()
    
    static var namaUnitTemp : String!
    static var nomorPlatTemp : String!
    static var tahunUnitTemp : String!
    static var tanggalBeliTemp : String!
    
    @IBOutlet weak var namaUnitField: UITextField!
    @IBOutlet weak var nomorPlatField: UITextField!
    @IBOutlet weak var tahunUnitField: UITextField!
    @IBOutlet weak var tanggalBeliField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.datePickerMode = .date
        tanggalBeliField.inputView = datePicker
        createDatePicker()
        
        AddProduct.namaUnitTemp = ""
        AddProduct.nomorPlatTemp = ""
        AddProduct.tahunUnitTemp = ""
    }
    
    func createDatePicker() {
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneTapped))
        toolbar.setItems([doneBtn], animated: true)
        
        tanggalBeliField.inputAccessoryView = toolbar
        tanggalBeliField.inputView = datePicker
        datePicker.datePickerMode = .date
        
    }
    
    @objc func doneTapped() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        tanggalBeliField.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
        
    }
    
    @IBAction func lanjutBtn(_ sender: Any) {
        
        if (namaUnitField.text != "" && nomorPlatField.text != "" && tahunUnitField.text != "" && tanggalBeliField.text != "") {
        
            AddProduct.namaUnitTemp = namaUnitField.text!
            AddProduct.nomorPlatTemp = nomorPlatField.text!
            AddProduct.tahunUnitTemp = tahunUnitField.text!
            AddProduct.tanggalBeliTemp = tanggalBeliField.text!
            
            self.performSegue(withIdentifier: "lanjutkanUnit", sender: Any.self)
            
        } else {
            
            self.showAlert(text: "Tolong, isi semua field!")
            
        }
    }
    
}
