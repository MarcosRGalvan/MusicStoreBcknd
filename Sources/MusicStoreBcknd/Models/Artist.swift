//
//  Artist.swift
//  MusicStoreBcknd
//
//  Created by Marco Ramirez on 11/01/26.
//
import Fluent
import Vapor

final class Artist: Model, Content, @unchecked Sendable {
    static let schema = "Artist"
    
    @ID(custom: "ArtistId", generatedBy: .database)
    var id: Int?
    
    @Field(key: "Name")
    var name: String?
    
    init() { }
    
}
