//
//  TrendMovieCollectionViewCell.swift
//  Cinema
//
//  Created by Елена on 03.04.2023.
//

import UIKit
import SnapKit

class TrendMovieCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "TrendMovieCollectionViewCell"
    
    private lazy var imageFilm: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Film")
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    private lazy var viewB: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        self.addSubview(imageFilm)
        self.contentView.addSubview(viewB)
        
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension TrendMovieCollectionViewCell {
    func setup() {
        configureConstraints()
    }
    
    func configureConstraints() {
        viewB.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

