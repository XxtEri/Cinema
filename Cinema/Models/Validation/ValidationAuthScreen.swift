//
//  ValidationAuthScreen.swift
//  Cinema
//
//  Created by Елена on 05.04.2023.
//

class ValidationAuthScreen {
    enum ResultValidation {
        case susccess
        case fieldsEmpty
        case notCorrectEmail
        case isNotMatchPassword
    }
    
    private let userLogin: LoginCredentialDTO?
    private let userRegister: RegisterCredentialDTO?
    
    
    init(user: LoginCredentialDTO) {
        self.userLogin = user
        self.userRegister = nil
    }
    
    init(user: RegisterCredentialDTO) {
        self.userRegister = user
        self.userLogin = nil
    }
    
    private func isFieldsNotEmpty() -> Bool {
        if let user = userLogin {
            if user.email.isEmpty || user.password.isEmpty {
                return false
            }
        }
        
        if let user = userRegister {
            if user.firstName.isEmpty || user.lastName.isEmpty
                || user.email.isEmpty || user.password.isEmpty
                || user.confirmPassword.isEmpty {
                 return false
            }
        }
        
        return true
    }
    
    private func isValidateEmail() -> Bool {
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", "[0-9a-z]+@[0-9a-z]+\.[A-Za-z]{2,64}")

        if !emailPredicate.evaluate(with: email) || email.isEmpty {
            return false
        }

        return true
    }
    
    private func isPasswordsMatch(password: String, confirmPassword: String) -> Bool {
        if password != confirmPassword {
            return false
        }
        
        return true
    }
    
    func isvalidateDataUserLogin() -> ResultValidation {
        if !isFieldsNotEmpty() {
            return ResultValidation.fieldsEmpty
        }
        
        if !validateEmail() {
            return ResultValidation.notCorrectEmail
        }
        
        return ResultValidation.susccess
    }
    
    func isvalidateDataUserRegister() -> ResultValidation {
        if !isFieldsNotEmpty(isLogin: false) {
            return ResultValidation.fieldsEmpty
        }
        
        if !validateEmail() {
            return ResultValidation.notCorrectEmail
        }
        
        if !isPasswordsMatch() {
            return ResultValidation.isNotMatchPassword
        }
        
        return ResultValidation.susccess
    }
}
