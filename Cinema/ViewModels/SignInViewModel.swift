//
//  AuthViewModel.swift
//  Cinema
//
//  Created by Елена on 28.03.2023.
//

import Foundation

class SignViewModel {
    private var api: ApiRepository
    weak var navigation: SignNavigation?
    
    init(navigation: SignNavigation) {
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

extension SignViewModel: ISignInViewModel {
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

private extension SignViewModel {
    func failureLoadingHandle(with error: Error) {
        print(error.localizedDescription)
    }
}
