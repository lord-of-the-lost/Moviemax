//
//  PersonModel.swift
//  Moviemax
//
//  Created by Николай Игнатов on 30.03.2025.
//

import Foundation

// MARK: - MovieModel
struct PersonList: Decodable {
    let docs: [PersonModel]?
}

struct PersonModel: Decodable {
    let id: Int?
    let name: String?
    let enName: String?
    let photo: String?
    let profession: [Profession]?

    struct Profession: Decodable {
        let value: String?
    }
}
