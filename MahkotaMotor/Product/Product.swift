//
//  Product.swift
//  MahkotaMotor
//
//  Created by Athanasius Aryatyasto Pranamya on 25/07/20.
//  Copyright © 2020 Athanasius Arya. All rights reserved.
//

import Foundation

typealias product = [Product]

struct Product: Codable {
    
    var unit_id: String?
    var nama_unit: String?
    var nomor_plat: String?
    var tahun_unit: String?
    var harga_beli: String?
    var tanggal_beli: String?
    var pembenahan: String?
    var harga_jual: String?
    var total_modal: String?
    var prediksi_untung: String?
    var detail_pembenahan: String?
    var status: String?
    var CREATED_AT: String?
    
}
