//
//  PasswordRecoveryView.swift
//  PhotoEditorApp
//
//  Created by Bilol Sanatillayev on 30/07/24.
//

import SwiftUI

struct PasswordRecoveryView: View {
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
            
            ActionButton(title: "Reset Password") {
                viewModel.action.send(.resetPassword)
            }
            .padding(.vertical, 40)
        }
        .navigationTitle("Reset Password")
        .sheet(router)
//        .alert("Error", isPresented: .constant(false)) {
//            Text(viewModel.error ?? "")
//        }
//        .progressView(isShowing: $viewModel.isLoading)
    }
}

extension PasswordRecoveryView {
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
