import Fluent
import Vapor

func routes(_ app: Application) throws {
    try app.register(collection: UserController(app: app))
    try app.register(collection: FilmController(app: app))
    try app.register(collection: ReviewController(app: app))
}

