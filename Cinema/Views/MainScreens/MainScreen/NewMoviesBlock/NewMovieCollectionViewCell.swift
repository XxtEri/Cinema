//
//  NewMovieCollectionViewCell.swift
//  Cinema
//
//  Created by Елена on 03.04.2023.
//

import UIKit
import SnapKit

class NewMovieCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "NewMovieCollectionViewCell"
    
    private lazy var imageMovie: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "NewFilm")?.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(imageMovie)
        
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: Movie) {
        imageMovie.downloaded(from: model.poster, contentMode: imageMovie.contentMode)
    }
    
}

private extension NewMovieCollectionViewCell {
    func setup() {
        configureConstraints()
    }
    
    func configureConstraints() {
        imageMovie.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

