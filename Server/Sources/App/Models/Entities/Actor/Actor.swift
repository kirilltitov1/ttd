//
//  File.swift
//  
//
//  Created by Kirill Titov on 03.05.2021.
//

import Fluent
import Vapor

final class Actor: Model, Content {
    
    static var schema: String = "actors"
    
    @ID
    var id: UUID?
    
    @Field(key: "FIO")
    var fio: String
    
    @Siblings(through: Filmography.self, from: \.$actor, to: \.$film)
    public var films: [Film]
    
    required init() {}
    
    init(id: UUID? = nil, fio: String) {
        self.id = id
        self.fio = fio
    }
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case fio = "FIO"
    }
}
