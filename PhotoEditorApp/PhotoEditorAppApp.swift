//
//  PhotoEditorAppApp.swift
//  PhotoEditorApp
//
//  Created by Bilol Sanatillayev on 30/07/24.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct PhotoEditorApp: App {
    
    private let modules: AnyModules
    @ObservedObject private var appStateManager: AppStateManager
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init() {
        self.modules = Modules()
        self.appStateManager = modules.appStateManager
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if appStateManager.authState.state == .loggedIn {
                    ImageEditBuilder.createImageEditorScreen(with: modules, presentationType: .constant(true))
                } else if appStateManager.authState.state == .notAuthorize {
                    AuthScreenBuilder.createSignInScreen(with: modules, presentationType: .constant(true))
                    .onOpenURL(perform: { url in
                        GIDSignIn.sharedInstance.handle(url)
                    })
                    .onAppear {
                        GIDSignIn.sharedInstance.restorePreviousSignIn { gidUser, error in
                            let user = User(id: gidUser?.idToken?.tokenString, email: gidUser?.profile?.email, name: gidUser?.profile?.name, picture: gidUser?.profile?.imageURL(withDimension: .min)?.absoluteString)
                            appStateManager.startSession(user: user, with: .google)
                        }
                    }
                }
            }
            .overlay {
                appLoadingView
            }
        }
    }
    
    @ViewBuilder
    private var appLoadingView: some View {
        if appStateManager.authState.state == .loading {
            LinearGradient.baseGradient
                .blur(radius: 4)
                .overlay {
                    LoadingView(text: "Loading...")
                }
                .ignoresSafeArea()
        }
    }
}
