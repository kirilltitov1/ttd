//
//  File.swift
//  
//
//  Created by Kirill Titov on 03.05.2021.
//

import Fluent
import Vapor
import JWT
import Foundation

final class User: Model, Content, Hashable {
    
    static var schema = "users"
    
    @ID
    var id: UUID?
    
    @Children(for: \.$user)
    var reviews: [Review]
    
    @Field(key: "FIO")
    var fio: String

    @Field(key: "email")
    var email: String
    
    @Field(key: "password_hash")
    var passwordHash: String
    
    @Field(key: "user_rights")
    var userRights: UserRights?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    required init() {}

    init(
        id: UUID? = nil,
        fio: String = "default",
        email: String,
        passwordHash: String,
        userRights: UserRights = .superAdmin
    ) {
        self.id = id
        self.fio = fio
        self.email = email
        self.passwordHash = passwordHash
		self.userRights = .superAdmin
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
    
    enum CodingKeys: String, CodingKey {
        case fio = "FIO"
        case passwordHash = "password_hash"
        case userRights = "user_rights"
    }
}

// MARK: JWT

extension User: ModelAuthenticatable {
	static var usernameKey: KeyPath<User, Field<String>> = \User.$fio
	
	static var passwordHashKey: KeyPath<User, Field<String>> = \User.$passwordHash
	
	func verify(password: String) throws -> Bool {
		return try Bcrypt.verify(password, created: self.passwordHash)
	}
}

struct JWTBearerAuthenticator: JWTAuthenticator {
	typealias Payload = UserJWTPayload
	
	func authenticate(jwt: Payload, for request: Request) -> EventLoopFuture<Void> {
		do {
			try jwt.verify(using: request.application.jwt.signers.get()!)
			return User.find(jwt.id, on: request.db)
				.unwrap(or: Abort(.notFound))
				.map { user in
					request.auth.login(user)
				}
		} catch {
			return request.eventLoop.makeFailedFuture(Abort(.notFound))
		}
	}
	
	func findUser(jwt: Payload, for request: Request) -> EventLoopFuture<User> {
		User.find(jwt.id, on: request.db)
			.unwrap(or: Abort(.notFound))
	}
}

extension User {
	func generateToken(_ app: Application) throws -> String {
		let expDate = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
		let exp = ExpirationClaim(value: expDate)
		
		return try app.jwt.signers.get(kid: .private)!.sign(UserJWTPayload(id: self.id ?? UUID(), fio: self.fio, exp: exp))
	}
}
