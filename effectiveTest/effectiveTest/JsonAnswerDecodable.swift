//
//  JsonAnswerDecodable.swift
//  effectiveTest
//
//  Created by Вениамин Китченко on 05.07.2020.
//  Copyright © 2020 Вениамин Китченко. All rights reserved.
//

import Foundation

class JsonAnswerDecodable { // класс Decodable для парсинга json-ответа
    
//    struct ResponseFromGitLabStruct: Decodable {
//        let responseArray: [ResponseArrayStruct]
//    }
    
    struct ResponseArrayStruct: Decodable {
        let name: String
        let description: String?
        let web_url: String
        let avatar_url: String?
        let forks_count: Int?
        let star_count: Int?
        let owner: OwnerStruct?
        
        private enum CodingKeys: String, CodingKey {
            case name = "name"
            case description = "description"
            case web_url = "web_url"
            case avatar_url = "avatar_url"
            case forks_count = "forks_count"
            case star_count = "star_count"
            case owner = "owner"
        }
    }
    
    struct OwnerStruct: Decodable {
        let name: String?
        private enum CodingKeys: String, CodingKey {
            case name = "name"
        }
    }
}
