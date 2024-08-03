//
//  SignUpView.swift
//  PhotoEditorApp
//
//  Created by Bilol Sanatillayev on 30/07/24.
//

import SwiftUI

struct SignUpView: View {
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
            ActionButton(title: "Sign Up") {
                viewModel.action.send(.loginWithEmail)
            }
            .padding(.vertical)
        }
        .navigationTitle("Sign Up")
        //        .alert("Error", isPresented: .constant(false)) {
        //            Text(viewModel.error ?? "")
        //        }
        //        .alert(item: $viewModel.error) { error in
        //            Alert(title: Text("Error"), message: Text(error))
        //        }
    }
}

extension SignUpView {
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

