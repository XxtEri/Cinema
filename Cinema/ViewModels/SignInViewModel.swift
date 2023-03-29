//
//  AuthViewModel.swift
//  Cinema
//
//  Created by Елена on 28.03.2023.
//

import Foundation

class SignInViewModel {
    private var api: ApiRepository
    weak var navigation: SignInNavigation?
    
    init(navigation: SignInNavigation) {
        self.navigation = navigation
        self.api = ApiRepository()
    }
    
    func goToSignUp() {
        navigation?.goToSignUpScreen()
    }
    
}

extension SignInViewModel: ISignInViewModel {
    func signIn(user: LoginCredential) {
        self.api.signIn(user: user) { [ self ] result in
            switch result {
            case .success(let token):
                print("Value: \(token)")
            case .failure(let error):
                self.failureLoadingHandle(with: error)
            }
        }
    }

}

private extension SignInViewModel {
    func failureLoadingHandle(with error: Error) {
        print(error.localizedDescription)
    }
}
