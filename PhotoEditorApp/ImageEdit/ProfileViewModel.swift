//
//  ProfileViewModel.swift
//  PhotoEditorApp
//
//  Created by Bilol Sanatillayev on 03/08/24.
//

import SwiftUI
import Combine

final class ProfileViewModel: ObservableObject {
    
    // MARK: Public Properties
    
    @Published var state = State()
    let action = PassthroughSubject<Action, Never>()
    
    // MARK: Private properties

    private let worker: AnyProfileWorker
    private var subscriptions = Set<AnyCancellable>()

    // MARK: Init

    init(worker: AnyProfileWorker) {
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
        case .setImage(let image):
            state.image = image
        case .logOut:
            performLogOut()
        }
    }
    
    private func performLogOut() {
        Task.detached(priority: .high) { [weak self] in
            do {
                await self?.worker.logOut()
            }
        }
    }
}

// MARK: - ViewModel Actions & State

extension ProfileViewModel {

    enum Action {
        case logOut
        case setImage(String)
    }

    struct State {
        var isLoading = false
        var image: String = ""
    }
}
