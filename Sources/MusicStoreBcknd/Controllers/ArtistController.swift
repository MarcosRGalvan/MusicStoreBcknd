//
//  ArtistController.swift
//  MusicStoreBcknd
//
//  Created by Marco Ramirez on 11/01/26.
//

import Fluent
import Vapor

struct ArtistController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        
        let artists = routes.grouped("artists")
        
        artists.get(use: getAll)            //GET /artists
        artists.post(use: create)           //POST /artists
        artists.group(":artistID") { artists in
            artists.get(use: getArtistById)     //GET /artists/ID
            artists.put(use: updateArtist)      //PUT /artists/ID
            artists.delete(use: deleteArtist)   //DELETE /artists/ID
        }
    }
    
    // Obtener todos los artistas
    func getAll(req: Request) async throws -> [Artist] {
        try await Artist.query(on: req.db).all()
    }
    
    // Agregar un nuevo artista
    func create(req: Request) async throws -> Artist {
        let artist = try req.content.decode(Artist.self)
        try await artist.save(on: req.db)
        return artist
    }
    
    // Obtener un solo artista por su ID
    func getArtistById(req: Request) async throws -> Artist {
        guard let artis = try await Artist.find(req.parameters.get("artistID"), on: req.db) else {
            throw Abort(.notFound)
        }
        return artis
    }
    
    // Actualizar un artista
    func updateArtist(req: Request) async throws -> Artist {
        let updateArtist = try req.content.decode(Artist.self)
        guard let artist = try await Artist.find(req.parameters.get("artistID"), on: req.db) else {
            throw Abort(.notFound)
        }
        artist.name = updateArtist.name
        try await artist.save(on: req.db)
        return artist
    }
    
    // Borrar un artista
    func deleteArtist(req: Request) async throws -> HTTPStatus {
        guard let artist = try await Artist.find(req.parameters.get("artistID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await artist.delete(on: req.db)
        return .noContent
    }
}
