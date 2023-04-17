//
//  FootageMovieCollectionViewCell.swift
//  Cinema
//
//  Created by Елена on 01.04.2023.
//

import UIKit

class FootageMovieCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "FootageMovieCollectionViewCell"
    
    private lazy var posterFootage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(posterFootage)
        
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func congifure(imageUrl: String) {
        posterFootage.downloaded(from: imageUrl, contentMode: posterFootage.contentMode)
    }
}

private extension FootageMovieCollectionViewCell {
    func setup() {
        configureConstraints()
    }
    
    func configureConstraints() {
        posterFootage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
