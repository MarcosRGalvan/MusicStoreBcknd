//
//  Employee.swift
//  MusicStoreBcknd
//
//  Created by Marco Ramirez on 12/01/26.
//

import Fluent
import Vapor

final class Employee: Model, Content, @unchecked Sendable {
    static let schema = "Employee"
    
    @ID(custom: "EmployeeId", generatedBy: .database)
    var id: Int?
    
    @Field(key: "LastName")
    var lastName: String
    
    @Field(key: "FirstName")
    var firstName: String
    
    @Field(key: "Title")
    var title: String
    
    @Field(key: "ReportsTo")
    var reportsTo: Int?
    
    @Field(key: "BirthDate")
    var birthDate: Date?
    
    @Field(key: "HireDate")
    var hireDate: Date?
    
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
    var email: String?
}
