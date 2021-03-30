//
//  Laporan.swift
//  MahkotaMotor
//
//  Created by Athanasius Aryatyasto Pranamya on 13/08/20.
//  Copyright © 2020 Athanasius Arya. All rights reserved.
//

import Foundation

typealias laporan = [Laporan]

struct Laporan: Codable {
    
    var transaksi_id: String?
    var nomor_idTransaksi: String?
    var nasabah_id: String?
    var nama_nasabah: String?
    var unit_id: String?
    var lama_cicil: String?
    var total_cicilan: String?
    var CREATED_AT: String?
    var uang_muka: String?
    var sisa_hutang: String?
    var jatuh_tempo: String?
    var jatuh_tempo_iso: String?
    var status_cicilan: String?
    var terjual: String?
    var untung: String?
    var nama_unit: String?
    var index_transaksi: String?
    var kondite: String?
    
}
