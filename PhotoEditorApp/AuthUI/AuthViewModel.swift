//
//  AuthViewModel.swift
//  PhotoEditorApp
//
//  Created by Bilol Sanatillayev on 30/07/24.
//

import SwiftUI
import FirebaseAuth
import GoogleSignIn
import FirebaseCore

class AuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var error: String?
    
    func signIn() {
        isLoading = true
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            self?.isLoading = false
            if let error = error {
                self?.error = error.localizedDescription
            } else {
                // handle successful sign-in
                print("success sign in")
            }
        }
    }
    
    func signUp() {
        isLoading = true
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            self?.isLoading = false
            if let error = error {
                self?.error = error.localizedDescription
            } else {
                self?.sendEmailVerification()
                print("success send email verification")
            }
        }
    }
    
    func resetPassword() {
        isLoading = true
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            self?.isLoading = false
            if let error = error {
                self?.error = error.localizedDescription
            }
        }
    }
    
    func handleGoogleSignIn() {
        isLoading = true
        let configuration = GIDConfiguration(clientID: SignInWithGoogleConstants.googleClientId)
        GIDSignIn.sharedInstance.configuration = configuration

        GIDSignIn.sharedInstance.signIn(withPresenting: UIApplication.shared.windows.first!.rootViewController!) { [weak self] signInResult, error in
            self?.isLoading = false
            guard let result = signInResult else {
                self?.error = error?.localizedDescription
                return
            }
            print("Success in google sign in")
        }
    }
    
    private func sendEmailVerification() {
        Auth.auth().currentUser?.sendEmailVerification { [weak self] error in
            if let error = error {
                self?.error = error.localizedDescription
            } else {
                // handle successful email verification
                print("send email verfication")
            }
        }
    }
}

