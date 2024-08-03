//
//  AuthConstants.swift
//  PhotoEditorApp
//
//  Created by Bilol Sanatillayev on 02/08/24.
//

import Foundation

// MARK: - AuthState
public enum AuthState: Equatable {
    case loggedIn
    case loading
    case notAuthorize
}

// MARK: - AuthType
public enum AuthType: String, Codable {
    case google
    case email
}

// MARK: - AuthError
enum AuthError: Error {
    case invalidAuth(String)
    case emptyGoogleToken
}

