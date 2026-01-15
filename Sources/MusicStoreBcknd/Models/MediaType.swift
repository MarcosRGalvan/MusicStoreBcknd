//
//  MediaType.swift
//  MusicStoreBcknd
//
//  Created by Marco Ramirez on 12/01/26.
//

import Fluent
import Vapor

final class MediaType: Model, Content, @unchecked Sendable {
    static let schema = "MediaType"
    
    @ID(custom: "MediaTypeId", generatedBy: .database)
    var id: Int?
    
    @Field(key: "Name")
    var name: String
    
    init() { }
}
