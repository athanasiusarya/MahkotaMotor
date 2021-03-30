
//
//  Nasabah.swift
//  MahkotaMotor
//
//  Created by Athanasius Aryatyasto Pranamya on 25/07/20.
//  Copyright © 2020 Athanasius Arya. All rights reserved.
//

import Foundation

typealias nasabah = [Nasabah]

struct Nasabah: Codable {
    
    var nasabah_id: String?
    var nama_nasabah: String?
    var nomor_nasabah: String?
    var nomor_telepon: String?
    var CREATED_AT: String?
    
}
