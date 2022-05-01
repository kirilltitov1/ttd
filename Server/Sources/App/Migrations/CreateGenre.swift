//
//  File.swift
//  
//
//  Created by Kirill Titov on 06.05.2021.
//

import Fluent

struct CreateGenre: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Genre.schema)
            .id()
            .field("name", .string)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Genre.schema).delete()
    }
}
