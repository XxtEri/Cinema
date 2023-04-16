//
//  AuthViewModel.swift
//  Cinema
//
//  Created by Елена on 28.03.2023.
//

import Foundation

<<<<<<<< HEAD:Cinema/ViewModels/SignScreenViewModel.swift~HEAD_0
class SignScreenViewModel {
    private var api: IApiRepositoryAuthScreen
========
class AuthViewModel {
    private var api: IApiRepositoryAuth
>>>>>>>> feature/home-screen:Cinema/ViewModels/AuthViewModel.swift
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

<<<<<<<< HEAD:Cinema/ViewModels/SignScreenViewModel.swift~HEAD_0
extension SignScreenViewModel: ISignInViewModel {
========
extension AuthViewModel: ISignInViewModel {
>>>>>>>> feature/home-screen:Cinema/ViewModels/AuthViewModel.swift
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

<<<<<<<< HEAD:Cinema/ViewModels/SignScreenViewModel.swift~HEAD_0
private extension SignScreenViewModel {
========
private extension AuthViewModel {
>>>>>>>> feature/home-screen:Cinema/ViewModels/AuthViewModel.swift
    func failureLoadingHandle(with error: Error) {
        print(error.localizedDescription)
    }
}
