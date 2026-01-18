//
//  EmployeeDTO.swift
//  MusicStoreBcknd
//
//  Created by Marco Ramirez on 18/01/26.
//

import Fluent
import Vapor

struct EmployeeDTO : Content {
    var id: Int?
    var firstName: String
    var lastName: String
    var title: String?
    var reportsTo: String?
    var birthDate: Date?
    var hireDate: Date?
    var address: String?
    var city: String?
    var state: String?
    var country: String?
    var postalCode: String?
    var phone: String?
    var fax: String?
    var email: String?
}
