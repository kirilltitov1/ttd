//
//  File.swift
//  
//
//  Created by Kirill Titov on 07.06.2021.
//

import Fluent
import Vapor
import Foundation
import Leaf

struct FilmController: RouteCollection {
    
    var app: Application
    
    init(app: Application) {
        self.app = app
    }
    
    func boot(routes: RoutesBuilder) throws {
        let films = routes.grouped("")
        films.get(":userEmail", ":userPassword", "allFilms", use: all)
        films.get(":userEmail", ":userPassword", "filmLike", ":filmLike", use: findFilmLike)
        films.get(":userEmail", ":userPassword", ":filmID", "filmGenres", use: findGenres)
        films.get(":userEmail", ":userPassword", ":filmID", "filmActors", use: findActors)
        films.get(":userEmail", ":userPassword", ":filmID", "filmReviews", use: findReviews)
		
		let v2 = routes.grouped("api", "v2")
		
		let filmsv2 = v2.grouped("films")
		
		filmsv2.get(use: all)
		filmsv2.get("filtering_param", ":filmLike", use: findFilmLike)
		filmsv2.get("reviews", ":filmsID", use: findReviews)
		
//
//
//
		
		
		filmsv2.get("hello") { req -> EventLoopFuture<View> in
			return req.view.render("hello", ["name": "Leaf"])
		}
		filmsv2.get("api","image_test") { request -> EventLoopFuture<View> in
			return request.view.render("image", ["imgname":"/img.jpg"])
		}
    }
    
    func all(req: Request) throws -> EventLoopFuture<[Film]> {
        return req.films.flatMap { repo in
            repo.all()
        }
    }
    
    func findGenres(_ req: Request) throws -> EventLoopFuture<[Genre]> {
        return req.films.flatMap {
            $0.getFilmGenres(req)
        }
    }
	
	func image_test(_ req: Request) throws -> EventLoopFuture<ImageDTO> {
		do {
			let image = try ImageDTO()
			print(image)
			return req.eventLoop.makeSucceededFuture(image)
		} catch {
			print("/n/nerror!!!!!!!!/n/n")
			return req.eventLoop.makeFailedFuture(Abort(.notFound))
		}
	}
    
    func findActors(_ req: Request) throws -> EventLoopFuture<[Actor]> {
        return req.films.flatMap {
            $0.getFilmActors(req)
        }
    }
    
    func findFilmLike(_ req: Request) throws -> EventLoopFuture<[Film]> {
        return req.films.flatMap {
            $0.getFilmLike(req)
        }
    }
    
    func findReviews(_ req: Request) throws -> EventLoopFuture<[Review]> {
        return req.films.flatMap {
            $0.findReviews(req)
        }
    }
}
