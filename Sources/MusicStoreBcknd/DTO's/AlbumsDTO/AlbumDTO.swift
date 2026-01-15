//
//  AlbumDTO.swift
//  MusicStoreBcknd
//
//  Created by Marco Ramirez on 12/01/26.
//

import Fluent
import Vapor

struct AlbumDTO: Content {
    var id: Int?
    var title: String
    var artist: String
}
