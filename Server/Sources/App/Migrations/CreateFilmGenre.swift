//
//  File.swift
//  
//
//  Created by Kirill Titov on 07.05.2021.
//

import Fluent

struct CreateFilmGenre: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(FilmGenre.schema)
            .id()
            .field("film_id",
                   .uuid,
                   .required,
                   .references(Film.schema, "id"))
            .field("genre_id",
                   .uuid,
                   .required,
                   .references(Genre.schema, "id"))
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(FilmGenre.schema).delete()
    }
}
