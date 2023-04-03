//
//  CustomButton.swift
//  Cinema
//
//  Created by Елена on 03.04.2023.
//

import UIKit

class CustomButton: UIButton {
    override init(frame: CGRect) {
        super .init(frame: frame)

        self.clipsToBounds = true
        layer.masksToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 28

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
