//
//  IconSelectionScreenCollectionViewCell.swift
//  Cinema
//
//  Created by Елена on 14.04.2023.
//

import UIKit

class IconSelectionScreenCollectionViewCell: UICollectionViewCell {
    
    private var imageIcon: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    static let reuseIdentifier = "IconSelectionScreenCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(imageIcon)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(imageName: String) {
        imageIcon.image = UIImage(named: imageName)
    }
}

private extension IconSelectionScreenCollectionViewCell {
    func setup() {
        configureConstraints()
    }
    
    func configureConstraints() {
        imageIcon.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.width.equalTo(74)
        }
    }
}
