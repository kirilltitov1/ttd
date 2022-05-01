//
//  File.swift
//  
//
//  Created by Kirill Titov on 03.05.2021.
//

import Fluent

struct CreateUser: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(User.schema)
            .id()
            .field("FIO",
                   .string,
                   .required)
            .field("email",
                   .string,
                   .required)
            .unique(on: "email")
            .field("password_hash",
                   .string,
                   .required)
            .field("user_rights",
                   .int)
            .create()
    }
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(User.schema).delete()
    }
}
