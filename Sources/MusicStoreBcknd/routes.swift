import Fluent
import Vapor

func routes(_ app: Application) throws {
    
    // Ruta raiz (/)
    app.get { req async in
        return ["message": "Bienvenidos a MusicStore API", "Version": "1.0.0", "Status": "online"]
    }
    
    // Controlador de Artistas
    try app.register(collection: ArtistController())
    
    // Controlador de Tracks
    try app.register(collection: TrackController())
    
    // Controlador de Albums
    try app.register(collection: AlbumController())
    
    // Controlador de Customers
    try app.register(collection: CustomerController())
    
    // DEBUG: listar rutas
    app.routes.all.forEach { route in
        print("\(route.method) /\(route.path.map(\.description).joined(separator: "/"))")
    }
}
