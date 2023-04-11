//
//  KeyboardExtension.swift
//  Cinema
//
//  Created by Елена on 11.04.2023.
//

import Foundation

func setupToHideKeyboardOnTapOnView() {
       let tap: UITapGestureRecognizer = UITapGestureRecognizer(
           target: self,
           action: #selector(dismissKeyboard(sender:)))

       tap.cancelsTouchesInView = false
       view.addGestureRecognizer(tap)
   }

@objc
func dismissKeyboard(sender: AnyObject) {
    view.endEditing(true)
}
