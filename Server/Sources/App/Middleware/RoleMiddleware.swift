////
////  File.swift
////
////
////  Created by Kirill Titov on 10.06.2021.
////
//
import Foundation
import Fluent
import Vapor

//final class Auth {
//    static func auth(req: Request) -> EventLoopFuture<BaseRepo> {
//        guard let email = req.parameters.get("userEmail") else { return req.eventLoop.makeSucceededFuture(BaseRepo(db: req.db(.guest))) }
//        guard let password = req.parameters.get("userPassword") else { return req.eventLoop.makeSucceededFuture(BaseRepo(db: req.db(.guest))) }
//        
//        return User.query(on: req.db(.admin))
//            .filter(\.$email == email)
//            .filter(\.$passwordHash == password)
//            .first()
//            .flatMap { user -> EventLoopFuture<BaseRepo> in
//                if user == nil {
//                    return req.eventLoop.makeSucceededFuture(BaseRepo(db: req.db(.guest)))
//                } else {
//                    guard let userRights = user?.userRights else { return req.eventLoop.makeSucceededFuture(BaseRepo(db: req.db(.guest))) }
//                    
//                    if userRights.rawValue == 2 {
//                        return req.eventLoop.makeSucceededFuture(BaseRepo(db: req.db(.admin)))
//                    } else if userRights.rawValue == 1 {
//                        return req.eventLoop.makeSucceededFuture(BaseRepo(db: req.db(.user)))
//                    } else {
//                        return req.eventLoop.makeSucceededFuture(BaseRepo(db: req.db(.guest)))
//                    }
//                }
//            }
//    }
//}
