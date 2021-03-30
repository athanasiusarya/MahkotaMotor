//
//  LaporanBulan.swift
//  MahkotaMotor
//
//  Created by Athanasius Aryatyasto Pranamya on 13/08/20.
//  Copyright © 2020 Athanasius Arya. All rights reserved.
//

import Foundation

typealias laporanBulan = [LaporanBulan]

struct LaporanBulan: Codable {
    
    var laporan_id: String?
    var nama_bulan: String?
    var index: String?
    
}
