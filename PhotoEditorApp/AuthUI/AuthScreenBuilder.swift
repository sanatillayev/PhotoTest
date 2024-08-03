//
//  AuthScreenBuilder.swift
//  PhotoEditorApp
//
//  Created by Bilol Sanatillayev on 03/08/24.
//

import SwiftUI

final class AuthScreenBuilder {
    static func createSignInScreen(
        with modules: AnyModules,
        presentationType: Binding<Bool>
    ) -> SignInView {
        let worker = AuthWorker(modules: modules)
        var viewModel = NewAuthViewModel(worker: worker)
        let router = AuthRouter(modules: modules, presentationType: presentationType)
        let scene = SignInView(viewModel: viewModel, router: router)
        return scene
    }
    
    static func createSignUpScreen(
        with modules: AnyModules,
        presentationType: Binding<Bool>,
        onDismiss: @escaping () -> Void
    ) -> SignUpView {
        let worker = AuthWorker(modules: modules)
        let viewModel = NewAuthViewModel(worker: worker)
        let router = AuthRouter(modules: modules, presentationType: presentationType)
        let scene = SignUpView(viewModel: viewModel, router: router)
        return scene

    }
    
    static func createPasswordRecoveryScreen(
        with modules: AnyModules,
        presentationType: Binding<Bool>,
        onDismiss: @escaping () -> Void
    ) -> PasswordRecoveryView {
        let worker = AuthWorker(modules: modules)
        let viewModel = NewAuthViewModel(worker: worker)
        let router = AuthRouter(modules: modules, presentationType: presentationType)
        let scene = PasswordRecoveryView(viewModel: viewModel, router: router)
        return scene

    }
}
