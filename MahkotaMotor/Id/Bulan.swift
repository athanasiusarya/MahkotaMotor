//
//  Bulan.swift
//  MahkotaMotor
//
//  Created by Athanasius Aryatyasto Pranamya on 05/08/20.
//  Copyright © 2020 Athanasius Arya. All rights reserved.
//

import Foundation

typealias bulan = [Bulan]

struct Bulan: Codable {
    
    var format: String?
    var iso: String?
    var index: String?
    var transaksi_id: String?
    var status: String?
    var bulan_id: String?
    
}
