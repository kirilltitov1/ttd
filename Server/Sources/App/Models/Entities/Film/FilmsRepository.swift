//
//  File.swift
//
//
//  Created by Kirill Titov on 09.05.2021.
//

import Vapor
import Fluent
import FluentPostgresDriver
import RxSwift
import ServiceManagement

struct FilmsRepositoryFactory {
    var make: ((Request) -> EventLoopFuture<FilmsRepository>)?
    mutating func use(_ make: @escaping ((Request) -> EventLoopFuture<FilmsRepository>)) {
        self.make = make
    }
}

class PostgresFilmsRepository: BaseRepo, FilmsRepository {
    
    func all() -> EventLoopFuture<[Film]> {
        return db.withConnection { conn in
            return Film.query(on: conn).all()
        }
    }
    
    func getFilmGenres(_ req: Request) -> EventLoopFuture<[Genre]> {
        return db.withConnection { conn in
            return Film.find(req.parameters.get("filmID"), on: conn)
                .unwrap(or: Abort(.notFound))
                .flatMap { film in
                    film.$genres.query(on: conn).all()
                }
        }
    }
    
    func getFilmActors(_ req: Request) -> EventLoopFuture<[Actor]> {
        return db.withConnection { conn in
            return Film.find(req.parameters.get("filmID"), on: conn)
                .unwrap(or: Abort(.notFound))
                .flatMap { film in
                    film.$actors.query(on: conn).all()
                }
        }
    }
    
    func addReview(_ review: Review) -> EventLoopFuture<Review> {
        return db.withConnection { conn in
            return review.save(on: conn).map { review }
        }
    }
    
    func getFilmLike(_ req: Request) -> EventLoopFuture<[Film]> {
        return db.withConnection { conn in
            return Film.query(on: conn)
                .filter(\.$name =~ "\((req.parameters.get("filmLike")) ?? "")")
                .all()
                
                
        }
    }
    
    func findReviews(_ req: Request) -> EventLoopFuture<[Review]> {
        return db.withConnection { conn in
            return Film.find(req.parameters.get("filmID"), on: conn)
                .unwrap(or: Abort(.notFound))
                .flatMap { film in
                    film.$reviews.query(on: conn).all()
                }
        }
    }
    
}

extension Application {
    private struct FilmsRepositoryKey: StorageKey {
        typealias Value = FilmsRepositoryFactory
    }
    
    var films: FilmsRepositoryFactory {
        get {
            self.storage[FilmsRepositoryKey.self] ?? .init()
        }
        set {
            self.storage[FilmsRepositoryKey.self] = newValue
        }
    }
}

extension Request {
    var films: EventLoopFuture<FilmsRepository> {
        self.application.films.make!(self)
    }
}
