//
//  AlbumController.swift
//  MusicStoreBcknd
//
//  Created by Marco Ramirez on 12/01/26.
//

import Fluent
import Vapor

struct AlbumController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        
        let albums = routes.grouped("albums")
        
        albums.get(use: getAlbums)         //GET /albums
        albums.post(use: addAlbum)         //POST /albums
        albums.group(":albumID") { albums in
            albums.get(use: getAlbumById)
            albums.put(use: updateAlbum)
            albums.delete(use: deleteAlbumById)
        }
        
    }
    
    // Obtener todos los albums
    func getAlbums(req: Request) async throws -> [AlbumDTO] {
        let results = try await Album.query(on: req.db)
            .join(Artist.self, on: \Album.$artistId == \Artist.$id)
            .all()
        
        return try results.map { album in
            let artist = try album.joined(Artist.self)
            
            return AlbumDTO(
                id: album.id,
                title: album.title,
                artist: artist.name ?? "Unknown Artist"
            )
        }
    }
    
    // Agregar un nuevo album
    func addAlbum(req: Request) async throws -> Album {
        let album = try req.content.decode(Album.self)
        try await album.save(on: req.db)
        return album
    }
    
    // Obtener un album por su ID
    func getAlbumById(req: Request) async throws -> AlbumDTO {
        guard let albumID = req.parameters.get("albumID", as: Int.self) else {
            throw Abort(.badRequest, reason: "El ID debe ser un número entero.")
        }
        
        let results = try await Album.query(on: req.db)
            .join(Artist.self, on: \Album.$artistId == \Artist.$id)
            .filter(\Album.$id == albumID)
            .first()
        
        guard let album = results else {
            throw Abort(.notFound)
        }
        
        let artist = try album.joined(Artist.self)
        
        return AlbumDTO(
            id: album.id,
            title: album.title,
            artist: artist.name ?? "Unknown Artist"
        )
    }
    
    
    // Actualizar un album
    func updateAlbum(req: Request) async throws -> Album {
        let updateAlbum = try req.content.decode(Album.self)
        guard let album = try await Album.find(req.parameters.get("albumID"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        album.title = updateAlbum.title
        album.artistId = updateAlbum.artistId
        
        try await album.save(on: req.db)
        return album
    }
    
    // Borrar un album
    func deleteAlbumById(req: Request) async throws -> HTTPStatus {
        guard let album = try await Album.find(req.parameters.get("albumID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await album.delete(on: req.db)
        return .ok
    }
}
