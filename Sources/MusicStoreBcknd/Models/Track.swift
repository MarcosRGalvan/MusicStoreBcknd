//
//  Track.swift
//  MusicStoreBcknd
//
//  Created by Marco Ramirez on 11/01/26.
//

import Fluent
import Vapor

final class Track: Model, Content, @unchecked Sendable {
    static let schema = "Track"
    
    @ID(custom: "TrackId", generatedBy: .database)
    var id: Int?
    
    @Field(key: "Name")
    var name: String
    
    @Field(key: "AlbumId")
    var albumId: Int?
    
    @Field(key: "MediaTypeId")
    var mediaTypeId: Int
    
    @Field(key: "GenreId")
    var genreId: Int?
    
    @Field(key: "Composer")
    var composer: String?
    
    @Field(key: "Milliseconds")
    var milliseconds: Int
    
    @Field(key: "Bytes")
    var bytes: Int?
    
    @Field(key: "UnitPrice")
    var unitPrice: Double
    
    init() { }
}
