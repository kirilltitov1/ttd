//
//  File.swift
//  
//
//  Created by Kirill Titov on 06.05.2021.
//

import Fluent

struct CreateFilm: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Film.schema)
            .id()
            .field("name", .string, .required)
            .field("age_rating", .int, .required)
            .field("box_office", .int, .required)
            .field("date", .date, .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Film.schema).delete()
    }
}
