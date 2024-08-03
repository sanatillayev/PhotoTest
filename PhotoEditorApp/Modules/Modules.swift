//
//  Modules.swift
//  PhotoEditorApp
//
//  Created by Bilol Sanatillayev on 02/08/24.
//

import Foundation
import Combine

public protocol AnyModules {
    var appStateManager: AppStateManager { get }
    var authManager: AnyAuthManager { get }
}

public final class Modules: AnyModules {
    
    // MARK: - All Services
    public var appStateManager: AppStateManager
    public lazy var authManager: AnyAuthManager = AuthManager(authStateManager: appStateManager)

    
    // MARK: - Life Cycle
    private var cancellables = Set<AnyCancellable>()
    
    public init() {
        self.appStateManager = AppStateManager()
        
        appStateManager.$authState
            .sink { authState in
                print("did change authState: \(authState)")
            }
            .store(in: &cancellables)
    }
    
    deinit {
        
    }
}

