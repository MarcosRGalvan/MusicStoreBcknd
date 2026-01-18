//
//  CustomerController.swift
//  MusicStoreBcknd
//
//  Created by Marco Ramirez on 16/01/26.
//

import Fluent
import Vapor

struct CustomerController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        
        let customers = routes.grouped("customers")
        
        customers.get(use: getCustomers)        //GET /customers
        customers.post(use: addCustomer)       //POST /customers
        customers.group(":customerID") { customers in
            customers.get(use: getCustomerById)         //GET /customers/id
            customers.put(use: updateCustomer)          //PUT /customers/id
            customers.delete(use: deleteCustomerById)       //DELETE /customers/id
        }
    }
    
    // Obtener todos los Customers
    func getCustomers(req: Request) async throws -> [CustomerDTO] {
        let results = try await Customer.query(on: req.db)
            .join(Employee.self, on: \Customer.$supportRepId == \Employee.$id)
            .all()
        
        return try results.map { customer in
            let supportRep = try customer.joined(Employee.self)
            let supportRepFullName = [supportRep.firstName, supportRep.lastName].compactMap { $0 }.joined(separator: " ")
            
            return CustomerDTO(
                id: customer.id,
                firstName: customer.firstName,
                lastName: customer.lastName,
                company: customer.company,
                address: customer.address,
                city: customer.city,
                state: customer.state,
                country: customer.country,
                postalCode: customer.postalCode,
                phone: customer.phone,
                fax: customer.fax,
                email: customer.email,
                supportRep: supportRepFullName
            )
        }
    }
    
    // Agrgar un nuevo cliente
    func addCustomer(req: Request) async throws -> Customer {
        let customer = try req.content.decode(Customer.self)
        try await customer.save(on: req.db)
        return customer
    }
    
    //Obtener un cliente por su ID
    func getCustomerById(req: Request) async throws -> CustomerDTO {
        guard let customerID = req.parameters.get("customerID", as: Int.self) else {
            throw Abort(.badRequest, reason: "El ID debe ser un numero entero.")
        }
        
        let results = try await Customer.query(on: req.db)
            .join(Employee.self, on: \Customer.$supportRepId == \Employee.$id)
            .filter(\Customer.$id == customerID)
            .first()
        
        guard let customer = results else {
            throw Abort(.notFound)
        }
        
        let supportRep = try customer.joined(Employee.self)
        let supportRepFullName = [supportRep.firstName, supportRep.lastName].compactMap { $0 }.joined(separator: " ")
        
        return CustomerDTO(
            id: customer.id,
            firstName: customer.firstName,
            lastName: customer.lastName,
            company: customer.company,
            address: customer.address,
            city: customer.city,
            state: customer.state,
            country: customer.country,
            postalCode: customer.postalCode,
            phone: customer.phone,
            fax: customer.fax,
            email: customer.email,
            supportRep: supportRepFullName
        )
    }
    
    // Actualizar un cliente
    func updateCustomer(req: Request) async throws -> Customer {
        let updateCustomer = try req.content.decode(Customer.self)
        guard let customer = try await Customer.find(req.parameters.get("customerID"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        customer.firstName = updateCustomer.firstName
        customer.lastName = updateCustomer.lastName
        customer.company = updateCustomer.company
        customer.address = updateCustomer.address
        customer.city = updateCustomer.city
        customer.state = updateCustomer.state
        customer.country = updateCustomer.country
        customer.postalCode = updateCustomer.postalCode
        customer.phone = updateCustomer.phone
        customer.fax = updateCustomer.fax
        customer.email = updateCustomer.email
        customer.supportRepId = updateCustomer.supportRepId
        
        try await customer.save(on: req.db)
        return customer
    }
    
    // Eliminar un cliente
    func deleteCustomerById(req: Request) async throws -> HTTPStatus {
        guard let customer = try await Customer.find(req.parameters.get("customerID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await customer.delete(on: req.db)
        return .ok
    }
}
