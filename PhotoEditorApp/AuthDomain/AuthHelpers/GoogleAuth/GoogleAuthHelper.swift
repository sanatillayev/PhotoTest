//
//  GoogleAuthHelper.swift
//  PhotoEditorApp
//
//  Created by Bilol Sanatillayev on 30/07/24.
//

import Foundation
import GoogleSignIn

// MARK: - SignInWithGoogleError
enum SignInWithGoogleError: LocalizedError {
    case noPreviousSignIn
    case emptyTokenError
    case invalidAuth(String)
}

// MARK: - SignInWithGoogleConstants
enum SignInWithGoogleConstants {
    static let googleClientId = "369442553132-80ikm8m61140efmh192k1870v53rf32l.apps.googleusercontent.com"
    static let googleserverClientId = "369442553132-80ikm8m61140efmh192k1870v53rf32l.apps.googleusercontent.com"
}


// MARK: - GoogleAuthHelper
final class GoogleAuthHelper {
    
    //MARK: - Initialization
    
    init() { }
    
    // MARK: - Public Methods
    
    public func restoreAuthorization() async throws -> String? {
        guard GIDSignIn.sharedInstance.hasPreviousSignIn() else {
            throw SignInWithGoogleError.noPreviousSignIn
        }
        
        let user = try await GIDSignIn.sharedInstance.restorePreviousSignIn()
        return user.idToken?.tokenString
    }
    
    public func authorize() async throws -> User {
        let configuration = GIDConfiguration(clientID: SignInWithGoogleConstants.googleClientId)
        
        GIDSignIn.sharedInstance.configuration = configuration
        let gidUser = try await showGoogleWindow()
        guard let token = gidUser.idToken?.tokenString else {
            throw SignInWithGoogleError.emptyTokenError
        }
        let user = User(id: token, email: gidUser.profile?.email, name: gidUser.profile?.name, picture: gidUser.profile?.imageURL(withDimension: .min)?.absoluteString)
    
        return user
    }
    
    func signOut() async {
        GIDSignIn.sharedInstance.signOut()
    }
    
    // MARK: - Private Methods
    
    @MainActor private func showGoogleWindow() async throws -> GIDGoogleUser {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let keyWindow = windowScene?.windows.first
        guard let controller = keyWindow?.rootViewController else {
            assert(false)
            throw SignInWithGoogleError.invalidAuth("Can't find key window")
        }
        let signInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: controller)
        return signInResult.user
    }
}
