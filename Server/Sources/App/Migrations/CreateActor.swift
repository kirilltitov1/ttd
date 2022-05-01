//
//  File.swift
//  
//
//  Created by Kirill Titov on 06.05.2021.
//

import Fluent

struct CreateActor: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Actor.schema)
            .id()
            .field("fio", .string, .required)
            .create()
    }
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Actor.schema).delete()
    }
}
