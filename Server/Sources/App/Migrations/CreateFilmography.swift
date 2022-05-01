//
//  File.swift
//  
//
//  Created by Kirill Titov on 07.05.2021.
//

import Fluent

struct CreateFilmography: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Filmography.schema)
            .id()
            .field("actor_id",
                   .uuid,
                   .required,
                   .references(Actor.schema, "id"))
            .field("film_id",
                   .uuid,
                   .required,
                   .references(Film.schema, "id"))
            .create()
    }
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Filmography.schema).delete()
    }
}
