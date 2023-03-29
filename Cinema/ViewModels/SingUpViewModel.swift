//
//  SingUpViewModel.swift
//  Cinema
//
//  Created by Елена on 28.03.2023.
//

import Foundation

class SignUpViewModel {
    private let api: ApiRepository
    weak var navigation: SignUpNavigation?
    
    init(navigation: SignUpNavigation) {
        self.navigation = navigation
        self.api = ApiRepository()
    }
    
    func goToSingIn() {
        navigation?.goToSignInScreen()
    }
}

extension SignUpViewModel: ISignUpViewModel {
    func signUp(user: RegisterCredential) {
        self.api.signUp(user: user) { [ self ] result in
            switch result {
            case .success(let token):
                print("Value: \(token)")
            case .failure(let error):
                self.failureLoadingHandle(with: error)
            }
        }
    }

}

private extension SignUpViewModel {
    func failureLoadingHandle(with error: Error) {
        print(error.localizedDescription)
    }
}
