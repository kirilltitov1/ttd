//
//  File.swift
//  
//
//  Created by Kirill Titov on 06.05.2021.
//

import Fluent

struct CreateReview: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Review.schema)
            .id()
            .field("user_id",
                   .uuid,
                   .required,
                   .references(User.schema, "id"))
            .field("film_id",
                   .uuid,
                   .required,
                   .references(Film.schema, "id"))
            .field("text", .string)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Review.schema).delete()
    }
}
