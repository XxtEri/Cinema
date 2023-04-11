//
//  AuthViewModel.swift
//  Cinema
//
//  Created by Елена on 28.03.2023.
//

import Foundation

class AuthViewModel {
    private var api: IApiRepositoryAuth
    weak var navigation: SignScreenNavigation?
    
    init(navigation: SignScreenNavigation) {
        self.navigation = navigation
        self.api = ApiRepository()
    }
    
    func goToSingIn() {
        navigation?.goToSignInScreen()
    }
    
    func goToSignUp() {
        navigation?.goToSignUpScreen()
    }
    
    func goToHome() {
        navigation?.goToHomeScreen()
    }
}

extension AuthViewModel: ISignInViewModel {
    func signIn(user: LoginCredential) {
        self.api.signIn(user: user) { [ self ] result in
            switch result {
            case .success(_):
                goToHome()
            case .failure(let error):
                self.failureLoadingHandle(with: error)
            }
        }
    }

    func signUp(user: RegisterCredential) {
        self.api.signUp(user: user) { [ self ] result in
            switch result {
            case .success(_):
                goToHome()
            case .failure(let error):
                self.failureLoadingHandle(with: error)
            }
        }
    }
}

private extension AuthViewModel {
    func failureLoadingHandle(with error: Error) {
        print(error.localizedDescription)
    }
}
