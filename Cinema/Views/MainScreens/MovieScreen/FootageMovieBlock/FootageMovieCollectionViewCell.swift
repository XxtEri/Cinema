//
//  FootageMovieCollectionViewCell.swift
//  Cinema
//
//  Created by Елена on 01.04.2023.
//

import UIKit
import SnapKit

class FootageMovieCollectionViewCell: UICollectionViewCell {
    
    //- MARK: Private properties

    private lazy var posterFootage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        
        return view
    }()
    
    
    //- MARK: Public state properties
    
    static let reuseIdentifier = "FootageMovieCollectionViewCell"
    
    
    //- MARK: Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(posterFootage)
        
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //- MARK: Public methods
    
    func congifure(imageUrl: String) {
        posterFootage.downloaded(from: imageUrl, contentMode: posterFootage.contentMode)
    }
}


//- MARK: Private extensions

private extension FootageMovieCollectionViewCell {
    
    //- MARK: Setup
    
    func setup() {
        configureConstraints()
    }
    
    func configureConstraints() {
        posterFootage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
