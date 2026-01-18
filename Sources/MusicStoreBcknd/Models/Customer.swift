//
//  Customer.swift
//  MusicStoreBcknd
//
//  Created by Marco Ramirez on 12/01/26.
//

import Fluent
import Vapor

final class Customer: Model, Content, @unchecked Sendable {
    static let schema = "Customer"
    
    @ID(custom: "CustomerId", generatedBy: .database)
    var id: Int?
    
    @Field(key: "FirstName")
    var firstName: String
    
    @Field(key: "LastName")
    var lastName: String
    
    @Field(key: "Company")
    var company: String?
    
    @Field(key: "Address")
    var address: String?
    
    @Field(key: "City")
    var city: String?
    
    @Field(key: "State")
    var state: String?
    
    @Field(key: "Country")
    var country: String?
    
    @Field(key: "PostalCode")
    var postalCode: String?
    
    @Field(key: "Phone")
    var phone: String?
    
    @Field(key: "Fax")
    var fax: String?
    
    @Field(key: "Email")
    var email: String
    
    @Field(key: "SupportRepId")
    var supportRepId: Int?
}
