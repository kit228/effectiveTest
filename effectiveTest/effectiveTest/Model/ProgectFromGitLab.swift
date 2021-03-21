//
//  ProgectFromGitLab.swift
//  effectiveTest
//
//  Created by Вениамин Китченко on 05.07.2020.
//  Copyright © 2020 Вениамин Китченко. All rights reserved.
//

import Foundation
import UIKit

class ProjectFromGitlab { // класс проекта
    
    let name: String
    let description: String?
    let web_url: String
    let avatar_url: String?
    //var avatarImage: UIImage? // картинка
    let forks_count: Int?
    let star_count: Int?
    let ownerName: String?
    
    init(name: String, description: String?, web_url: String, avatar_url: String?, forks_count: Int?, star_count: Int?, ownerName: String?) {
        self.name = name
        self.description = description
        self.web_url = web_url
        self.avatar_url = avatar_url
        self.forks_count = forks_count
        self.star_count = star_count
        self.ownerName = ownerName
    }
    
}
