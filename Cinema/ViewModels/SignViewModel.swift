//
//  AuthViewModel.swift
//  Cinema
//
//  Created by Елена on 28.03.2023.
//

import Foundation

class SignViewModel {
    private var api: ApiRepository
    private var validation: ValidationAuthScreen
    weak var navigation: SignNavigation?
    
    var isNotValidData: ((ResultValidation, String) -> Void)?
    
    init(navigation: SignNavigation) {
        self.navigation = navigation
        self.api = ApiRepository()
        self.validation = ValidationAuthScreen()
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
    func signIn(userDTO: LoginCredentialDTO) {
        validation.userLogin = userDTO
        let result = validation.isValidateDataUserLogin()
        
        if !checkResultValidData(resultValid: result) {
            isNotValidData?(result, "signIn")
            return
        }
        
        let user =  LoginCredential(email: userDTO.email, password: userDTO.password)
        
        self.api.signIn(user: user) { [ self ] result in
            switch result {
            case .success(_):
                goToHome()
            case .failure(let error):
                self.failureLoadingHandle(with: error)
            }
        }
    }

    func signUp(userDTO: RegisterCredentialDTO) {
        validation.userRegister = userDTO
        let result = validation.isValidateDataUserRegister()
        
        if !checkResultValidData(resultValid: result) {
            isNotValidData?(result, "signUp")
            return
        }
        
        let user = RegisterCredential(firstName: userDTO.firstName, lastName: userDTO.lastName, email: userDTO.email, password: userDTO.password)
        
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
    func checkResultValidData(resultValid: ResultValidation) -> Bool {
        switch resultValid {
        case .susccess:
            return true
        default:
            return false
        }
        
        return true
    }

    func failureLoadingHandle(with error: Error) {
        print(error.localizedDescription)
    }
}
