import NIOSSL
import Fluent
import FluentSQLiteDriver
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    let path = app.directory.workingDirectory + "Chinook.db"
    app.databases.use(.sqlite(.file(path)), as : .sqlite)

    // register routes
    try routes(app)
    
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy"
    
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .formatted(formatter)
    
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(formatter)
    
    ContentConfiguration.global.use(encoder: encoder, for: .json)
    ContentConfiguration.global.use(decoder: decoder, for: .json)
}
