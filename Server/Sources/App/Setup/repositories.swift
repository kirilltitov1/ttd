//
//  File.swift
//  
//
//  Created by Kirill Titov on 08.05.2021.
//

import Vapor
import FluentPostgresDriver
import Foundation
import RxSwift
import ServiceManagement


protocol Repo {
    var db: Database { get set }
}

class BaseRepo: Repo {
    var db: Database
    
    init(db: Database) {
        self.db = db
    }
}


protocol UserRepository: BaseRepo {
    func all() -> EventLoopFuture<[User]>
    func create(user: User) -> EventLoopFuture<User>
    func getUserBy(user: User) -> EventLoopFuture<User>
	func email_password(app: Application, email: String, password: String) -> EventLoopFuture<TokensID>
	
}


protocol FilmsRepository: BaseRepo {
    func all() -> EventLoopFuture<[Film]>
    func getFilmGenres(_ reg: Request) -> EventLoopFuture<[Genre]>
    func getFilmActors(_ req: Request) -> EventLoopFuture<[Actor]>
    func getFilmLike(_ req: Request) -> EventLoopFuture<[Film]>
    func addReview(_ review: Review) -> EventLoopFuture<Review>
    func findReviews(_ req: Request) -> EventLoopFuture<[Review]>
}


protocol ReviewRepository: BaseRepo {
    func create(req: Request) -> EventLoopFuture<Review>
	func update_review(req: Request) -> EventLoopFuture<Bool>
    func delete(id: UUID) -> EventLoopFuture<DeleteResponse>
}
