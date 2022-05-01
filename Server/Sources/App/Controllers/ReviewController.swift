//
//  File.swift
//  
//
//  Created by Kirill Titov on 11.06.2021.
//

import Fluent
import Vapor
import Foundation

struct ReviewController: RouteCollection {
	
	var app: Application
	
	init(app: Application) {
		self.app = app
	}
	
	func boot(routes: RoutesBuilder) throws {
//		let review = routes.grouped("")
//		review.get(":userEmail", ":userPassword", ":filmID", ":userID", ":text", "addReview", use: addReview)
//		review.delete(":userEmail", ":userPassword", ":reviewID", use: deleteReview)
		
		let reviews = routes.grouped("api", "v2", "reviews")
		
		reviews.grouped(JWTBearerAuthenticator())
			.group("jwt") { route in
				route.delete("delete", ":reviewID", use: deleteReview)
				route.get("make", ":film_id", ":text",use: addReview)
				route.get("update", ":review_id", ":new_review", use: update_review)
			}
		
	}
	
	func addReview(_ req: Request) throws -> EventLoopFuture<Review> {
		return req.reviews.flatMap {
			$0.create(req: req)
		}
	}
	
	func update_review(_ req: Request) throws -> EventLoopFuture<Bool> {
		return req.reviews.flatMap {
			$0.update_review(req: req)
		}
	}
	
	func deleteReview(_ req: Request) throws -> EventLoopFuture<DeleteResponse> {
		let id = req.parameters.get("reviewID")
		return req.reviews.flatMap {
			if let id = id {
				return $0.delete(id: UUID(uuidString: id)!)
			} else {
				return req.eventLoop.makeFailedFuture(Abort(.notFound))
			}
		}
	}
}
