//
//  File.swift
//  
//
//  Created by Kirill Titov on 06.05.2021.
//

import Fluent
import Vapor

final class Film: Model, Content {
    
    static var schema: String = "films"
    
    @ID
    var id: UUID?
    
    @Children(for: \.$film)
    var reviews: [Review]
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "age_rating")
    var age_rating: Int
    
    @Field(key: "box_office")
    var box_office: Int
    
    @Field(key: "date")
    var date: Date
    
    @Siblings(through: Filmography.self, from: \.$film, to: \.$actor)
    public var actors: [Actor]
    
    @Siblings(through: FilmGenre.self, from: \.$film, to: \.$genre)
    public var genres: [Genre]
    
    required init() {}
    
    init(
        id: UUID? = nil,
        name: String,
        age_rating: Int,
        box_office: Int,
        date: Date
    ) {
        self.id = id
        self.name = name
        self.age_rating = age_rating
        self.box_office = box_office
        self.date = date
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
    }
}
