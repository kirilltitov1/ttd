////
////  File.swift
//
//
//  Created by Kirill Titov on 08.05.2021.
//

import Fluent
import Vapor
import Foundation

extension Bool: Content {}


struct UserController: RouteCollection {
	
	var app: Application
	
	init(app: Application) {
		self.app = app
	}
	
	func boot(routes: RoutesBuilder) throws {
		let user = routes.grouped("")
		user.get(":userEmail", ":userPassword", "allUsers", use: all)
		user.post("createUser", use: create)
		user.get(":userEmail", ":userPassword", "findUser", use: find)
		
		let v2 = routes.grouped("api", "v2")
		
		routes.grouped("api", "v2").post("reg", use: create)
		
		v2.grouped(JWTBearerAuthenticator())
			.group("jwt") { user in
				user.post("check_jwt", use: auth_token)
			}
		v2.post("email_reg", use: create)
		v2.post("login", use: login)
	}
	
	func auth_token(req: Request) throws -> EventLoopFuture<Bool> {
		return req.eventLoop.makeSucceededFuture(true)
	}
	
	func login(req: Request) throws -> EventLoopFuture<TokensID> {
		let user = try req.content.decode(UserReg.self)
		return req.users.flatMap {
			$0.email_password(app: app, email: user.email, password: user.password)
		}
	}
	
	////////////
	
	func all(req: Request) throws -> EventLoopFuture<[User]> {
		return req.users.flatMap {
			$0.all()
		}
	}
	
	func create(req: Request) throws -> EventLoopFuture<User> {
		let user: User = try req.content.decode(User.self)
		return req.users.flatMap {
			$0.create(user: user)
		}
	}
	
	func find(req: Request) throws -> EventLoopFuture<User> {
		let user = User(email: req.parameters.get("userEmail")!, passwordHash: req.parameters.get("userPassword")!)
		return req.users.flatMap {
			$0.getUserBy(user: user)
		}
	}
}
