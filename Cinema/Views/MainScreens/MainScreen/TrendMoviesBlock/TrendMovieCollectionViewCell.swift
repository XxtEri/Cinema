//
//  TrendMovieCollectionViewCell.swift
//  Cinema
//
//  Created by Елена on 03.04.2023.
//

import UIKit
import SnapKit

class TrendMovieCollectionViewCell: UICollectionViewCell {
    
    //- MARK: Private properties
    
    private lazy var imageMovie: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Film")
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    
    //- MARK: Public static properties
    
    static let reuseIdentifier = "TrendMovieCollectionViewCell"
    
    
    //- MARK: Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(imageMovie)
        
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //- MARK: Public methods
    
    func configure(with model: Movie) {
        imageMovie.downloaded(from: model.poster, contentMode: imageMovie.contentMode)
    }
    
}


//- MARK: Private extensions

private extension TrendMovieCollectionViewCell {
    
    //- MARK: Setup
    
    func setup() {
        configureConstraints()
    }
    
    func configureConstraints() {
        imageMovie.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

