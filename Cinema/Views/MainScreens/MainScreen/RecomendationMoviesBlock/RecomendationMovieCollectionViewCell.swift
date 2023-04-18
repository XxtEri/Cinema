//
//  RecomendationMovieCollectionViewCell.swift
//  Cinema
//
//  Created by Елена on 03.04.2023.
//

import UIKit
import SnapKit

class RecomendationMovieCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "RecomendationMovieCollectionViewCell"
    
    private lazy var imageFilm: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Film")
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(imageFilm)
        
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: Movie) {
        imageFilm.downloaded(from: model.poster, contentMode: imageFilm.contentMode)
    }
}

private extension RecomendationMovieCollectionViewCell {
    func setup() {
        configureConstraints()
    }
    
    func configureConstraints() {
        imageFilm.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}


