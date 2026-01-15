import NIOSSL
import Fluent
import FluentSQLiteDriver
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    let path = "/Users/marcoramirez/Library/DBeaverData/workspace6/.metadata/sample-database-sqlite-1/Chinook.db"
    app.databases.use(.sqlite(.file(path)), as : .sqlite)

    // register routes
    try routes(app)
}
