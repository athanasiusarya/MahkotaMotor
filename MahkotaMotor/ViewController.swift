//
//  ViewController.swift
//  MahkotaMotor
//
//  Created by Athanasius Aryatyasto Pranamya on 22/07/20.
//  Copyright © 2020 Athanasius Arya. All rights reserved.
//

import UIKit
import Firebase
import CodableFirebase

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

extension UIViewController {

    func showAlert(text: String) {
        let alert = UIAlertController(title: "Alert", message: text, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
