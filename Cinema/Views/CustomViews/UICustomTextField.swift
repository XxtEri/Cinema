//
//  UICustomTextField.swift
//  Cinema
//
//  Created by Елена on 28.03.2023.
//

import UIKit

class UICustomTextField: UITextField {
    
    var padding = UIEdgeInsets(top: 13, left: 16, bottom: 13, right: 16)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    func getCustomTextField(placeholder: String, isSecured: Bool) -> UICustomTextField {
        
        let view = UICustomTextField()
        view.textColor = .textTextField
        view.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        view.isSecureTextEntry = isSecured
        
        view.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.textTextField])
        
        view.layer.cornerRadius = 4
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.borderTextField.cgColor
        
        return view
    }
}
