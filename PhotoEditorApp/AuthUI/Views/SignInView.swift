//
//  SignInView.swift
//  PhotoEditorApp
//
//  Created by Bilol Sanatillayev on 30/07/24.
//

import SwiftUI
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

private enum Constants {
    static let buttonTitle: String = "Sign In"
}
struct SignInView: View {
    @StateObject var viewModel: NewAuthViewModel
    @StateObject var router: AuthRouter
    
    var body: some View {
        VStack {
            FieldView(
                title: "Email",
                text: emailBinding,
                placeholder: "Enter your email"
            )
            .autocapitalization(.none)
            .keyboardType(.emailAddress)
            
            SecureField("Password", text: passwordBinding)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            ActionButton(title: Constants.buttonTitle) {
                viewModel.action.send(.loginWithEmail)
            }
            .padding(.vertical)

            GoogleSignInButton(action: {
                viewModel.action.send(.openGoogleForm)
            })
            .padding(.horizontal)
            .padding(.vertical)

            Text("Don't have an account? Sign Up")
                .padding()
                .onTapGesture {
                    router.openSignUp()
                }
                .padding(.vertical)

            Text("Forgot Password?")
                .padding()
                .onTapGesture {
                    router.presentPasswordRecovery()
                }
                .padding(.vertical)
        }
        .navigationTitle("Sign In")
        .navigation(router)
        .sheet(router)
        .onAppear(perform: {
            viewModel.action.send(.checkAppState)
        })
        .alert("Error", isPresented: .constant(false), actions: {
        }, message: {
            Text(viewModel.state.alerMessage)
        })
        .background(ignoresSafeAreaEdges: .all)
        .background(content: { Color.secondary })
    }
}

// MARK: - Bindings
extension SignInView {
    var emailBinding: Binding<String> {
        Binding {
            viewModel.state.email
        } set: { newValue in
            viewModel.action.send(.setEmail(newValue))
        }
    }
    
    var passwordBinding: Binding<String> {
        Binding {
            viewModel.state.password
        } set: { newValue in
            viewModel.action.send(.setPassword(newValue))
        }
    }
}

