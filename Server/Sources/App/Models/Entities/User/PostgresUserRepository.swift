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

struct UserRepositoryFactory {
    var make: ((Request) -> EventLoopFuture<UserRepository>)?
    mutating func use(_ make: @escaping ((Request) -> EventLoopFuture<UserRepository>)) {
        self.make = make
    }
}

class PostgresUserRepository: BaseRepo, UserRepository {
    
    func all() -> EventLoopFuture<[User]> {
        return db.withConnection { conn in
            return User.query(on: conn).all()
        }
    }
    
    func create(user: User) -> EventLoopFuture<User> {
        return db.withConnection { conn in
			return user.save(on: conn).map { user }
        }
    }
	
	func email_password(app: Application, email: String, password: String) -> EventLoopFuture<TokensID> {
		return db.withConnection { conn in
			return User.query(on: conn)
				.filter(\.$email == email)
				.filter(\.$passwordHash == password)
				.first()
				.unwrap(or: Abort(.notFound))
				.flatMap { user in
					var userToken = TokensID(user_id: nil, access_token: "", refresh_token: "")
					do {
						userToken.access_token = try user.generateToken(app)
						userToken.user_id = user.id
					} catch {
						return conn.eventLoop.makeFailedFuture(Abort(.notFound))
					}
					return conn.eventLoop.makeSucceededFuture(userToken)
				}
		}
	}
    
    func getUserBy(user: User) -> EventLoopFuture<User> {
        return db.withConnection { conn in
            return User.query(on: conn)
                .filter(\.$email == user.email)
                .filter(\.$passwordHash == user.passwordHash)
                .first()
                .unwrap(or: Abort(.notFound))
        }
    }
	
//	func getUserByToken(token: UUID) -> EventLoopFuture<User> {
//		return db.withConnection { conn in
//			return User.query(on: conn)
//				.filter(<#T##filter: DatabaseQuery.Filter##DatabaseQuery.Filter#>)
//		}
//	}
}

extension Application {
    private struct UserRepositoryKey: StorageKey {
        typealias Value = UserRepositoryFactory
    }
    
    var users: UserRepositoryFactory {
        get {
            self.storage[UserRepositoryKey.self] ?? .init()
        }
        set {
            self.storage[UserRepositoryKey.self] = newValue
        }
    }
}

extension Request {
    var users: EventLoopFuture<UserRepository> {
        self.application.users.make!(self)
    }
}
