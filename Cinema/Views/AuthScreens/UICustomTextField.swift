//
//  UICustomTextField.swift
//  Cinema
//
//  Created by Елена on 28.03.2023.
//

import UIKit

class UICustomTextField: UITextField {
    let padding = UIEdgeInsets(top: 13, left: 16, bottom: 13, right: 16)
    
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
        view.textColor = UIColor(named: "GrayTextColor")
        view.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        view.isSecureTextEntry = isSecured
        
        if let color = UIColor(named: "GrayTextColor") {
            view.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : color])
        }
        
        view.layer.cornerRadius = 4
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(named: "BorderColor")?.cgColor
        
        view.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        return view
    }
    
    @objc
    func textFieldDidChange(sender: UITextField) {
        sender.text = sender.text?.lowercased()
    }
}
