//
//  File.swift
//
//
//  Created by Kirill Titov on 09.05.2021.
//

import Vapor
import FluentPostgresDriver
import FluentMySQLDriver
import RxSwift
import ServiceManagement
import Foundation
import JWT

struct ReviewRepositoryFactory {
	var make: ((Request) -> EventLoopFuture<ReviewRepository>)?
	mutating func use(_ make: @escaping ((Request) -> EventLoopFuture<ReviewRepository>)) {
		self.make = make
	}
}

struct DeleteResponse: Content {
	let name: String
}

class PostgresReviewRepository: BaseRepo, ReviewRepository {
	
	func create(req: Request) -> EventLoopFuture<Review> {
		guard let text = req.parameters.get("text") else {
			return req.eventLoop.makeFailedFuture(Abort(.badRequest, reason: "text not found..."))
		}
		
		guard let id = UUID(uuidString: UUID().uuidString) else { return req.eventLoop.makeFailedFuture(Abort(.badRequest)) }
		
		return db.withConnection { conn in
			do {
				let payload = try req.jwt.verify(as: UserJWTPayload.self)
				return User.find(payload.id, on: conn).flatMap { user in
					Film.find(req.parameters.get("film_id"), on: conn).flatMap { film in
						guard let review = try? Review(id: id, user: user!, film: film!, text: text) else {
							return req.eventLoop.makeFailedFuture(Abort(.badRequest))
						}
						return review.save(on: conn).map { review }
					}
				}
			} catch {
				return req.eventLoop.makeFailedFuture(Abort(.notFound))
			}
		}
	}
	
	func update_review(req: Request) -> EventLoopFuture<Bool> {
		return db.withConnection { conn in
			let reviewId = UUID(uuidString: req.parameters.get("review_id") ?? "") ?? UUID()
			let text = req.parameters.get("new_review") ?? ""
			return Review.query(on: conn)
				.filter(\.$id == reviewId)
				.set(\.$text, to: text)
				.update()
				.map { _ in
					return true
				}
		}
	}
	
	func delete(id: UUID) -> EventLoopFuture<DeleteResponse> {
		return db.withConnection { conn in
			Review.query(on: conn)
				.filter(\.$id == id)
				.delete()
				.map {
					return DeleteResponse(name: "Success")
				}
		}
	}
}

extension Application {
	private struct ReviewRepositoryKey: StorageKey {
		typealias Value = ReviewRepositoryFactory
	}
	
	var reviews: ReviewRepositoryFactory {
		get {
			self.storage[ReviewRepositoryKey.self] ?? .init()
		}
		set {
			self.storage[ReviewRepositoryKey.self] = newValue
		}
	}
}

extension Request {
	var reviews: EventLoopFuture<ReviewRepository> {
		self.application.reviews.make!(self)
	}
}
