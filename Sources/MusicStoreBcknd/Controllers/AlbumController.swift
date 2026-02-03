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
            albums.get(use: getAlbumById)       //GET /albums/id
            albums.put(use: updateAlbum)        //PUT /albums/id
            albums.delete(use: deleteAlbumById)     //DELETE /albums/id
        }
        
    }
    
    // Obtener todos los albums
    func getAlbums(req: Request) async throws -> PaginatedResponse<AlbumDTO> {

        let page = req.query[Int.self, at: "page"] ?? 1
        let perPage = req.query[Int.self, at: "limit"] ?? 20

        let total = try await Album.query(on: req.db).count()

        let albumIDs = try await Album.query(on: req.db)
            .sort(\.$title, .ascending)
            .range((page - 1) * perPage..<(page * perPage))
            .all(\.$id)

        let albums = try await Album.query(on: req.db)
            .filter(\.$id ~~ albumIDs)
            .join(Artist.self, on: \Album.$artistId == \Artist.$id)
            .all()

        let data = try albums.map { album in
            let artist = try album.joined(Artist.self)
            return AlbumDTO(
                id: album.id,
                title: album.title,
                artist: artist.name ?? "Unknown Artist"
            )
        }

        return PaginatedResponse(
            data: data,
            page: page,
            perPage: perPage,
            total: total
        )
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
