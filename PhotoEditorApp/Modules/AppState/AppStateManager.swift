//
//  AppStateManager.swift
//  PhotoEditorApp
//
//  Created by Bilol Sanatillayev on 02/08/24.
//

import SwiftUI

final public class AppStateManager: ObservableObject {
    
    // MARK: Public properties
    @Published public private(set) var appState = AppState()
    @Published public private(set) var authState = AuthorizationState()
    
}

// MARK: - AppState
extension AppStateManager {
    
    public struct AppState {
        @AppStorage("PhotoEditorUserID")
        public var userId: String?
    }
    
    public struct AuthorizationState {
        public var state: AuthState = .notAuthorize
        public var type: AuthType?
    }
}

// MARK: - AnyAuthStateManager
extension AppStateManager: AnyAuthStateManager {
    @MainActor
    public func authorizationInProgress() {
        self.authState.state = .loading
    }
    
    @MainActor
    public func notAuthorized() {
        self.authState.state = .notAuthorize
    }
    
    @MainActor
    public func authorizationRestored() {
        self.authState.state = .loggedIn
    }
    
    @MainActor
    public func startSession(user: User, with authType: AuthType) {
        appState.userId = user.id
        authState.state = .loggedIn
        authState.type = authType
    }
    
    @MainActor
    public func performLogout() {
        appState.userId = nil
        authState.type = nil
        authState.state = .notAuthorize
    }
 
}
