//
//  File.swift
//  MusicStoreBcknd
//
//  Created by Marco Ramirez on 30/01/26.
//

import Vapor

struct PaginatedResponse<T: Content>: Content, AsyncResponseEncodable {
    let data: [T]
    let page: Int
    let perPage: Int
    let total: Int
}
