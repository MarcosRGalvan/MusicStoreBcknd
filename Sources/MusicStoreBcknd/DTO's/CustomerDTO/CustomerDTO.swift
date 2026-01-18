//
//  CustomerDTO.swift
//  MusicStoreBcknd
//
//  Created by Marco Ramirez on 16/01/26.
//

import Fluent
import Vapor

struct CustomerDTO : Content {
    var id: Int?
    var firstName: String
    var lastName: String
    var company: String?
    var address: String?
    var city: String?
    var state: String?
    var country: String?
    var postalCode: String?
    var phone: String?
    var fax: String?
    var email: String
    var supportRep: String?
}
