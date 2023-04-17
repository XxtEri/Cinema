//
//  AuthViewModel.swift
//  Cinema
//
//  Created by Елена on 28.03.2023.
//

import Foundation


class AuthViewModel {
    private var api: ApiRepository
    private var validation: ValidationAuthScreen
    private var service: CollectionService
    
    weak var navigation: AuthNavigation?

    var isNotValidData: ((ResultValidationAuthScreen, String) -> Void)?
    var errorReceivedFromServer: ((RequestStatus) -> Void)?
    
    init(navigation: AuthNavigation) {
        self.navigation = navigation
        self.api = ApiRepository()
        self.service = CollectionService()
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


extension AuthViewModel: ISignInViewModel {
    func signIn(userDTO: LoginCredentialDTO) {
        validation.userLogin = userDTO
        let result = validation.isValidateDataUserLogin()
        
        if !checkResultValidData(resultValid: result) {
            isNotValidData?(result, "signIn")
            return
        }
        
        let user = LoginCredential(email: userDTO.email, password: userDTO.password)
        
        self.api.signIn(user: user) { [ self ] result in
            switch result {
            case .success(let status):
                switch status {
                case RequestStatus.success:
                    goToHome()
                case RequestStatus.notAuthorized:
                    errorReceivedFromServer?(status)
                default:
                    print("error")
                }
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
            case .success(let status):
                switch status {
                case RequestStatus.success:
                    createFavoriteCollection()
                    goToHome()
                default:
                    print("error")
                }
            case .failure(let error):
                self.failureLoadingHandle(with: error)
            }
        }
    }
}

private extension AuthViewModel {
    func checkResultValidData(resultValid: ResultValidationAuthScreen) -> Bool {
        switch resultValid {
        case .susccess:
            return true
        default:
            return false
        }
    }
    
    func createFavoriteCollection() {
        let collectionForm = CollectionForm(name: "Избранное")
        
        self.api.addNewCollection(collection: collectionForm) { [ self ] result in
            switch result {
            case .success(let newColletion):
                let collectionDatabase = CollectionList()
                collectionDatabase.collectionName = newColletion.name
                collectionDatabase.collectionId = newColletion.collectionId
                collectionDatabase.nameImageCollection = "Group 1"
                
                self.service.addNewCollection(collection: collectionDatabase) { [ self ] result in
                    switch result {
                    case .success(_):
                        print("Add successfully")
                    case .failure(let error):
                        failureLoadingHandle(with: error)
                    }
                }
            case .failure(let error):
                failureLoadingHandle(with: error)
                print(error.localizedDescription)
            }
        }
    }
    
    func failureLoadingHandle(with error: Error) {
        print(error.localizedDescription)
    }
    
}
