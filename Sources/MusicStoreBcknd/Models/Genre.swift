//
//  Genre.swift
//  MusicStoreBcknd
//
//  Created by Marco Ramirez on 12/01/26.
//

import Fluent
import Vapor

final class Genre: Model, Content, @unchecked Sendable {
    static let schema = "Genre"
    
    @ID(custom: "GenreId", generatedBy: .database)
    var id: Int?
    
    @Field(key: "Name")
    var name: String
    
    init() { }
}
