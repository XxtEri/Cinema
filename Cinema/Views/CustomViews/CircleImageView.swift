//
//  CircleImageView.swift
//  Cinema
//
//  Created by Елена on 03.04.2023.
//

import UIKit

class CircleImageView: UIImageView {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
    }

}
