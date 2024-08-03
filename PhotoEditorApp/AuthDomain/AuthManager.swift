//
//  AuthManager.swift
//  PhotoEditorApp
//
//  Created by Bilol Sanatillayev on 02/08/24.
//

import Foundation

public protocol AnyAuthManager {
    func register(with email: String, password: String) async throws
    func signIn(with email: String, password: String) async throws
    func authorize() async throws
    func resetPassword(email: String) async throws
    func logout() async
}

final public class AuthManager: AnyAuthManager {
    //MARK: - Private properties
    
    private let authStateManager: AnyAuthStateManager
    private let googleAuthHelper = GoogleAuthHelper()
    private let firebaseAuthHelper = FirebaseAuthHelper()

    //MARK: - Initialization
    
    public init(authStateManager: AnyAuthStateManager) {
        self.authStateManager = authStateManager
    }
    
    //MARK: - Public methods
    
    public func authorize() async throws {
        await authStateManager.authorizationInProgress()
        do {
            let user = try await googleAuthHelper.authorize()
            await authStateManager.startSession(user: user, with: .google)
        } catch {
            await authStateManager.notAuthorized()
        }
    }
    
    public func register(with email: String, password: String) async throws {
        await authStateManager.authorizationInProgress()
        do {
            let user = try await firebaseAuthHelper.register(email: email, password: password)
            await authStateManager.startSession(user: user, with: .email)
        } catch {
            await authStateManager.notAuthorized()
        }
    }
    
    public func signIn(with email: String, password: String) async throws {
        await authStateManager.authorizationInProgress()
        do {
            let user = try await firebaseAuthHelper.signIn(email: email, password: password)
            await authStateManager.startSession(user: user, with: .email)
        } catch {
            print(error)
            await authStateManager.notAuthorized()
        }
    }
    
    public func resetPassword(email: String) async throws {
        do {
            try await firebaseAuthHelper.resetPassword(email: email)
        } catch {
            print("Failed to send password reset email: \(error.localizedDescription)")
        }
    }
    
    public func logout() async {
        await MainActor.run {
            authStateManager.performLogout()
        }
    }
}

