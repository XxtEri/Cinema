//
//  ValidationChatScreen.swift
//  Cinema
//
//  Created by Елена on 19.04.2023.
//

import Foundation

enum ResultValidationChatScreen: String {
    case susccess
    case fieldsEmpty = "Необходимо заполнить поле для ввода сообщение перед отправкой"
    case error = "Неизвестная ошибка."
}


class ValidationChatScreen {
    var message: String?
        
    init() { }
    
    private func isFieldsNotEmpty() -> Bool {
        if let message = self.message {
            if !message.isEmpty {
                return true
            }
        }
        
        return false
    }
    
    func isValidateDataCollection() -> ResultValidationChatScreen {
        if !isFieldsNotEmpty() {
            return ResultValidationChatScreen.fieldsEmpty
        }
        
        return ResultValidationChatScreen.susccess
    }

}
