//
//  ValidationAuthScreen.swift
//  Cinema
//
//  Created by Елена on 05.04.2023.
//

import Foundation

enum ResultValidation: String {
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
    
    func isValidateDataUserLogin() -> ResultValidation {
        guard let user = userLogin else { return ResultValidation.error}
        
        if !isFieldsNotEmpty() {
            return ResultValidation.fieldsEmpty
        }
        
        if !isValidateEmail(user.email) {
            return ResultValidation.notCorrectEmail
        }
        
        return ResultValidation.susccess
    }
    
    func isValidateDataUserRegister() -> ResultValidation {
        guard let user = userRegister else { return ResultValidation.error}
        
        if !isFieldsNotEmpty() {
            return ResultValidation.fieldsEmpty
        }
        
        if !isValidateEmail(user.email) {
            return ResultValidation.notCorrectEmail
        }
        
        if !isPasswordsMatch(password: user.password, confirmPassword: user.confirmPassword) {
            return ResultValidation.isNotMatchPassword
        }
        
        return ResultValidation.susccess
    }
}
