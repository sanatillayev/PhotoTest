//
//  FirebaseAuthHelper.swift
//  PhotoEditorApp
//
//  Created by Bilol Sanatillayev on 02/08/24.
//

import Foundation
import FirebaseAuth

// MARK: - SignInWithFirebaseError
enum SignInWithFirebaseError: LocalizedError {
    case noPreviousSignIn
    case emptyEmailOrPassword
    case invalidAuth(String)
    case passwordResetFailed(String)
}

// MARK: - FirebaseAuthHelper
final class FirebaseAuthHelper {

    // MARK: - Initialization

    init() { }

    // MARK: - Public Methods

    public func restoreAuthorization() async throws -> User? {
        guard let user = Auth.auth().currentUser else {
            throw SignInWithFirebaseError.noPreviousSignIn
        }
        
        return User(id: user.uid, email: user.email, name: user.displayName, picture: user.photoURL?.absoluteString)
    }

    public func signIn(email: String, password: String) async throws -> User {
        guard !email.isEmpty, !password.isEmpty else {
            throw SignInWithFirebaseError.emptyEmailOrPassword
        }

        let user = try await Auth.auth().signIn(withEmail: email, password: password).user
        return User(id: user.uid, email: user.email, name: user.displayName, picture: user.photoURL?.absoluteString)
    }

    public func signOut() async throws {
        do {
            try Auth.auth().signOut()
        } catch {
            throw SignInWithFirebaseError.invalidAuth("Failed to sign out")
        }
    }

    public func register(email: String, password: String) async throws -> User {
        guard !email.isEmpty, !password.isEmpty else {
            throw SignInWithFirebaseError.emptyEmailOrPassword
        }

        let user = try await Auth.auth().createUser(withEmail: email, password: password).user
        return User(id: user.uid, email: user.email, name: user.displayName, picture: user.photoURL?.absoluteString)
    }
    
    public func resetPassword(email: String) async throws {
        guard !email.isEmpty else {
            throw SignInWithFirebaseError.emptyEmailOrPassword
        }
        
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
        } catch {
            throw SignInWithFirebaseError.passwordResetFailed("Failed to send password reset email \(error)")
        }
    }
}
