//
//  RecomendationMovieCollectionViewCell.swift
//  Cinema
//
//  Created by Елена on 03.04.2023.
//

import UIKit
import SnapKit

class RecomendationMovieCollectionViewCell: UICollectionViewCell {
    
    //- MARK: Private properties
    
    private lazy var imageFilm: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Film")
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    
    //- MARK: Public static properties
    
    static let reuseIdentifier = "RecomendationMovieCollectionViewCell"
    
    
    //- MARK: Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(imageFilm)
        
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //- MARK: Public methods
    
    func configure(with model: Movie) {
        imageFilm.downloaded(from: model.poster, contentMode: imageFilm.contentMode)
    }
}


//- MARK: Private extensions

private extension RecomendationMovieCollectionViewCell {
    
    //- MARK: Setup()
    
    func setup() {
        configureConstraints()
    }
    
    func configureConstraints() {
        imageFilm.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}


