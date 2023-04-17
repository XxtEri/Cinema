//
//  ValidationCollectionScreen.swift
//  Cinema
//
//  Created by Елена on 17.04.2023.
//

import Foundation

enum ResultValidationCollectionScreen: String {
    case susccess
    case fieldsEmpty = "Поле с названием коллекции не должно быть пустым"
    case error = "Неизвестная ошибка."
}

class ValidationCollectionScreen {
    var collection: Collection?
    
    init() { }
    
    private func isFieldsNotEmpty() -> Bool {
        if let name = collection?.name {
            if !name.isEmpty {
                return true
            }
        }
        
        return false
    }

    func isValidateDataCollection() -> ResultValidationCollectionScreen {
        if !isFieldsNotEmpty() {
            return ResultValidationCollectionScreen.fieldsEmpty
        }
        
        return ResultValidationCollectionScreen.susccess
    }
}
