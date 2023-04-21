//
//  NewMovieCollectionViewCell.swift
//  Cinema
//
//  Created by Елена on 03.04.2023.
//

import UIKit
import SnapKit

class NewMovieCollectionViewCell: UICollectionViewCell {
    
    //- MARK: Private properties
    
    private enum Metrics {
        static let imageMovieEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    private lazy var imageMovie: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "NewFilm")?.withAlignmentRectInsets(Metrics.imageMovieEdgeInsets)
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    
    //- MARK: Public static properties
    
    static let reuseIdentifier = "NewMovieCollectionViewCell"
    
    
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

private extension NewMovieCollectionViewCell {
    
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


