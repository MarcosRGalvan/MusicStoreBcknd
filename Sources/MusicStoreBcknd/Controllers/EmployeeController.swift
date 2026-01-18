//
//  EmployeeController.swift
//  MusicStoreBcknd
//
//  Created by Marco Ramirez on 18/01/26.
//

import Fluent
import Vapor

struct EmployeeController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        
        let employees = routes.grouped("employees")
        
        employees.get(use: getEmployees)            //GET /employees
        employees.post(use: addEmployee)
        employees.group(":employeeID") { employees in
            employees.get(use: getEmployeeById)             //GET /employees/id
            employees.put(use: updateEmployeeById)          //PUT /employees/id
            employees.delete(use: deleteEmployeeById)       //DELETE /employees/id
        }
        
    }
    
    // Obtener todos los empleados
    func getEmployees(req: Request) async throws -> [EmployeeDTO] {
        let employees = try await Employee.query(on: req.db)
            .with(\.$manager)
            .all()
        
        return employees.map { employee in
            let managerName = [
                employee.manager?.firstName,
                employee.manager?.lastName
            ]
                .compactMap { $0 }
                .joined(separator: " ")
            
            return EmployeeDTO(
                id: employee.id,
                firstName: employee.firstName,
                lastName: employee.lastName,
                title: employee.title,
                reportsTo: managerName.isEmpty ? nil : managerName,
                birthDate: employee.birthDate,
                hireDate: employee.hireDate,
                address: employee.address,
                city: employee.city,
                state: employee.state,
                country: employee.country,
                postalCode: employee.postalCode,
                phone: employee.phone,
                fax: employee.fax,
                email: employee.email
            )
        }
    }
    
    
    func addEmployee(req: Request) async throws -> Employee {
        let employee = try req.content.decode(Employee.self)
        try await employee.save(on: req.db)
        return employee
    }

    
    //Obtener un employee por su ID
    func getEmployeeById(req: Request) async throws -> EmployeeDTO {
        guard let employeeID = req.parameters.get("employeeID", as: Int.self) else {
            throw Abort(.badRequest, reason: "El ID debe ser un número entero.")
        }
        
        let results = try await Employee.query(on: req.db)
            .with(\.$manager)
            .filter(\.$id == employeeID)
            .first()
        
        guard let employee = results else {
            throw Abort(.notFound)
        }
        
        let reportsTo = try employee.joined(Employee.self)
        let reportsToFullName = [
            employee.manager?.firstName,
            employee.manager?.lastName
        ].compactMap { $0 }.joined(separator: " ")
        
        return EmployeeDTO (
            id: employee.id,
            firstName: employee.firstName,
            lastName: employee.lastName,
            title: employee.title,
            reportsTo: reportsToFullName.isEmpty ? nil : reportsToFullName,
            birthDate: employee.birthDate,
            hireDate: employee.hireDate,
            address: employee.address,
            city: employee.city,
            state: employee.state,
            country: employee.country,
            postalCode: employee.postalCode,
            phone: employee.phone,
            fax: employee.fax,
            email: employee.email
        )
    }
    
    
    // Actualizar un employee
    func updateEmployeeById(req: Request) async throws -> Employee {
        let updateEmployee = try req.content.decode(Employee.self)
        guard let employee = try await Employee.find(req.parameters.get("employeeID"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        employee.firstName = updateEmployee.firstName
        employee.lastName = updateEmployee.lastName
        employee.title = updateEmployee.title
        employee.$manager.id = updateEmployee.$manager.id
        employee.birthDate = updateEmployee.birthDate
        employee.hireDate = updateEmployee.hireDate
        employee.address = updateEmployee.address
        employee.city = updateEmployee.city
        employee.state = updateEmployee.state
        employee.country = updateEmployee.country
        employee.postalCode = updateEmployee.postalCode
        employee.phone = updateEmployee.phone
        employee.fax = updateEmployee.fax
        employee.email = updateEmployee.email
        
        try await employee.save(on: req.db)
        return employee
    }
    
    
    // Eliminar un cliente
    func deleteEmployeeById(req: Request) async throws -> HTTPStatus {
        guard let employee = try await Employee.find(req.parameters.get("employeeID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await employee.delete(on: req.db)
        return .ok
    }
}
