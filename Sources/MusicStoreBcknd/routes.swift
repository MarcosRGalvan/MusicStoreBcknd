import Fluent
import Vapor

func routes(_ app: Application) throws {
    
    // Controlador de Artistas
    try app.register(collection: ArtistController())
    
    // Controlador de Tracks
    try app.register(collection: TrackController())
    
    // Controlador de Albums
    try app.register(collection: AlbumController())
}
