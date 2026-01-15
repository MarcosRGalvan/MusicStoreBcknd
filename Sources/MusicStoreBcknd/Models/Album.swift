//
//  Album.swift
//  MusicStoreBcknd
//
//  Created by Marco Ramirez on 12/01/26.
//

import Fluent
import Vapor

final class Album: Model, Content, @unchecked Sendable {
    static let schema: String = "Album"
    
    @ID(custom: "AlbumId", generatedBy: .database)
    var id: Int?
    
    @Field(key: "Title")
    var title: String
    
    @Field(key: "ArtistId")
    var artistId: Int
    
    init() { }
}
