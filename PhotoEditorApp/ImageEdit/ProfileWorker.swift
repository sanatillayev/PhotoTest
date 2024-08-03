//
//  ProfileWorker.swift
//  PhotoEditorApp
//
//  Created by Bilol Sanatillayev on 03/08/24.
//

import Foundation

protocol AnyProfileWorker {
    func logOut() async
}

final class ProfileWorker: AnyProfileWorker {

    // MARK: - Public Properties
    var authState: AuthState {
        appStateManager.authState.state
    }
    
    // MARK: - Private Properties
    private let authManager: AnyAuthManager
    private let appStateManager: AppStateManager

    init(modules: AnyModules) {
        self.appStateManager = modules.appStateManager
        self.authManager = modules.authManager
    }

    func logOut() async {
        await authManager.logout()
    }
}
