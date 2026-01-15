//
//  TrackController.swift
//  MusicStoreBcknd
//
//  Created by Marco Ramirez on 11/01/26.
//

import Fluent
import Vapor

struct TrackController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        
        let tracks = routes.grouped("tracks")
        
        tracks.get(use: getTracks)         //GET /tracks
        tracks.post(use: addTrack)         //POST /tracks
        tracks.group(":trackID") { tracks in
            tracks.get(use: getTrackById)       //GET /tracks/ID
            tracks.put(use: updateTrack)        //PUT /tracks/ID
            tracks.delete(use: deleteTrack)     //DELETE /tracks/ID
        }
    }
    
    // Obtener todos los track
    func getTracks(req: Request) async throws -> [TrackDTO] {
        let results = try await Track.query(on: req.db)
            .join(Album.self, on: \Track.$albumId == \Album.$id)
            .join(MediaType.self, on: \Track.$mediaTypeId == \MediaType.$id)
            .join(Genre.self, on: \Track.$genreId == \Genre.$id)
            .all()
        
        return try results.map { track in
            let album = try track.joined(Album.self)
            let mediaType = try track.joined(MediaType.self)
            let genre = try track.joined(Genre.self)
            
            return TrackDTO(
                id: track.id,
                name: track.name,
                album: album.title,
                mediaType: mediaType.name,
                genre: genre.name,
                composer: track.name,
                milliseconds: track.milliseconds,
                bytes: track.bytes ?? 0,
                unitPrice: track.unitPrice
            )
        }
    }
    
    // Agregar un nuevo track
    func addTrack(req: Request) async throws -> Track {
        let track = try req.content.decode(Track.self)
        try await track.save(on: req.db)
        return track
    }
        
    // Obtener un solo track por su ID
    func getTrackById(req: Request) async throws -> TrackDTO {
        guard let trackID = req.parameters.get("trackID", as: Int.self) else {
            throw Abort(.badRequest, reason: "El ID debe ser un número entero.")
        }
        
        let results = try await Track.query(on: req.db)
            .join(Album.self, on: \Track.$albumId == \Album.$id)
            .join(MediaType.self, on: \Track.$mediaTypeId == \MediaType.$id)
            .join(Genre.self, on: \Track.$genreId == \Genre.$id)
            .filter(\Track.$id == trackID)
            .first()
        
        guard let track = results else {
            throw Abort(.notFound)
        }
        
        let album = try track.joined(Album.self)
        let mediaType = try track.joined(MediaType.self)
        let genre = try track.joined(Genre.self)
            
        return TrackDTO(
            id: track.id,
            name: track.name,
            album: album.title,
            mediaType: mediaType.name,
            genre: genre.name,
            composer: track.name,
            milliseconds: track.milliseconds,
            bytes: track.bytes ?? 0,
            unitPrice: track.unitPrice
        )
    }
    
    // Actualizar un track
    func updateTrack(req: Request) async throws -> Track {
        let updateTrack = try req.content.decode(Track.self)
        guard let track = try await Track.find(req.parameters.get("trackID"), on: req.db) else {
            throw Abort(.notFound)
        }
        track.name = updateTrack.name
        track.albumId = updateTrack.albumId
        track.mediaTypeId = updateTrack.mediaTypeId
        track.genreId = updateTrack.genreId
        track.composer = updateTrack.composer
        track.milliseconds = updateTrack.milliseconds
        track.bytes = updateTrack.bytes
        track.unitPrice = updateTrack.unitPrice
        
        try await track.save(on: req.db)
        return track
    }
    
    // Borrar un track
    func deleteTrack(req: Request) async throws -> HTTPStatus {
        guard let track = try await Track.find(req.parameters.get("trackID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await track.delete(on: req.db)
        return .ok
    }
}
