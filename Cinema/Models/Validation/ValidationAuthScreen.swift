//
//  ValidationAuthScreen.swift
//  Cinema
//
//  Created by Елена on 05.04.2023.
//

import Foundation

enum ResultValidationAuthScreen: String {
    case susccess
    case fieldsEmpty = "Не все поля заполнены данными. Заполните и повторите попытку"
    case notCorrectEmail = "Некорретно введена почта. Попробуйте еще раз. Почта должна быть размером от 2 до 64 символов. Имя и доменное имя должно состоять только из маленьких букв и цифр."
    case isNotMatchPassword = "Пароли не совпадают. Проверьте и попробуйте снова"
    case error = "Неизвестная ошибка."
}

class ValidationAuthScreen {
    var userLogin: LoginCredentialDTO?
    var userRegister: RegisterCredentialDTO?
    
    init() { }
    
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
    
    private func isValidateEmail(_ email: String) -> Bool {
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", "[0-9a-z]+@[0-9a-z]+\\.[A-Za-z]{2,64}")

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
    
    func isValidateDataUserLogin() -> ResultValidationAuthScreen {
        guard let user = userLogin else { return ResultValidationAuthScreen.error}
        
        if !isFieldsNotEmpty() {
            return ResultValidationAuthScreen.fieldsEmpty
        }
        
        if !isValidateEmail(user.email) {
            return ResultValidationAuthScreen.notCorrectEmail
        }
        
        return ResultValidationAuthScreen.susccess
    }
    
    func isValidateDataUserRegister() -> ResultValidationAuthScreen {
        guard let user = userRegister else { return ResultValidationAuthScreen.error}
        
        if !isFieldsNotEmpty() {
            return ResultValidationAuthScreen.fieldsEmpty
        }
        
        if !isValidateEmail(user.email) {
            return ResultValidationAuthScreen.notCorrectEmail
        }
        
        if !isPasswordsMatch(password: user.password, confirmPassword: user.confirmPassword) {
            return ResultValidationAuthScreen.isNotMatchPassword
        }
        
        return ResultValidationAuthScreen.susccess
    }
}
