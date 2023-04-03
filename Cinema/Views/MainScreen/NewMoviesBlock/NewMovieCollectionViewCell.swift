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
    
    private lazy var imageFilm: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "NewFilm")?.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
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
        
        self.addSubview(viewB)
        
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension NewMovieCollectionViewCell {
    func setup() {
        configureConstraints()
    }
    
    func configureConstraints() {
        viewB.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}


