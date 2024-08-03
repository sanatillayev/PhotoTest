//
//  AnyAuthStateManager.swift
//  PhotoEditorApp
//
//  Created by Bilol Sanatillayev on 02/08/24.
//

import Foundation

public protocol AnyAuthStateManager: AnyObject {
    @MainActor func authorizationInProgress()
    @MainActor func notAuthorized()
    @MainActor func startSession(user: User, with authType: AuthType)
    @MainActor func performLogout()
}
