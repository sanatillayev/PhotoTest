//
//  NewAuthViewModel.swift
//  PhotoEditorApp
//
//  Created by Bilol Sanatillayev on 03/08/24.
//

import Foundation
import SwiftUI
import Combine

final class NewAuthViewModel: ObservableObject {
    
    // MARK: Public Properties
    
    @Published var state = State()
    let action = PassthroughSubject<Action, Never>()
    
    // MARK: Private properties

    private let worker: AnyAuthWorker
    private var subscriptions = Set<AnyCancellable>()

    // MARK: Init

    init(worker: AnyAuthWorker) {
        self.worker = worker
        
        action
            .sink(receiveValue: { [unowned self] in
                self.didChange($0)
            })
            .store(in: &subscriptions)
    }

    // MARK: Private Methods

    private func didChange(_ action: Action) {
        switch action {
        case .registerWithEmail:
            authorizeWithEmail(email: state.email, password: state.password)
        case .loginWithEmail:
            signInWithEmail(email: state.email, password: state.password)
        case .openGoogleForm:
            authorizeUserWithGoogleForm()
        case .checkAppState:
            state.isLoading = (worker.authState == .loading)
        case .setEmail(let newEmail):
            state.email = newEmail
        case .setPassword(let newPassword):
            state.password = newPassword
        case .resetPassword:
            resetPasswordRequest()
        
        }
    }

    private func authorizeUserWithGoogleForm() {
        Task.detached(priority: .high) { [weak self] in
            do {
                try await self?.worker.authorizeWithGoogle()
            } catch {
                self?.handle(error)
            }
        }
    }
    
    private func authorizeWithEmail(email: String, password: String) {
        Task.detached(priority: .high) { [weak self] in
            do {
                try await self?.worker.authorizeWithEmail(email: email, password: password)
            } catch {
                self?.handle(error)
            }
        }
    }
    
    private func signInWithEmail(email: String, password: String) {
        Task.detached(priority: .high) { [weak self] in
            do {
                try await self?.worker.signInWithEmail(email: email, password: password)
            } catch {
                self?.handle(error)
            }
        }
    }
    
    private func resetPasswordRequest() {
        Task.detached(priority: .high) { [weak self] in
            do {
                let email = self?.state.email
                try await self?.worker.resetPassword(email: email ?? "")
            } catch {
                self?.handle(error)
            }
        }
    }
    
    
    private func handle(_ error: Error) {
        //TODO: - Show Alert
        print("AUTH_ERROR \(error)")
        state.alerMessage = error.localizedDescription
    }
}

// MARK: - ViewModel Actions & State

extension NewAuthViewModel {

    enum Action {
        case loginWithEmail
        case registerWithEmail
        case openGoogleForm
        case checkAppState
        case setEmail(String)
        case setPassword(String)
        case resetPassword
    }

    struct State {
        var isLoading = false
        var email: String = ""
        var password: String = ""
        var alerMessage: String = ""
    }
}
