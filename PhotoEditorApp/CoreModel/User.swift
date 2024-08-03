//
//  User.swift
//  PhotoEditorApp
//
//  Created by Bilol Sanatillayev on 02/08/24.
//

import Foundation

public struct User: Codable {

    public init(
        id: String?,
        email: String?,
        name: String?,
        picture: String?
    ) {
        self.id = id
        self.email = email
        self.name = name
        self.picture = picture
    }

    public let id: String?
    public let email: String?
    public let name: String?
    public let picture: String?
}

public extension User {
    
    static let initial = User(
        id: nil,
        email: "",
        name: nil,
        picture: nil
    )
}
