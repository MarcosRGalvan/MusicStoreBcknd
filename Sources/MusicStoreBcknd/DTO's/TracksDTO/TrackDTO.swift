//
//  TrackDTO.swift
//  MusicStoreBcknd
//
//  Created by Marco Ramirez on 12/01/26.
//
import Fluent
import Vapor

struct TrackDTO: Content {
    var id: Int?
    var name: String
    var album: String
    var mediaType: String
    var genre: String
    var composer: String
    var milliseconds: Int
    var bytes: Int
    var unitPrice: Double
}
