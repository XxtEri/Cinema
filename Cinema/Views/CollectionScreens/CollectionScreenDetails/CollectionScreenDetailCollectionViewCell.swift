//
//  CollectionScreenDetailCollectionViewCell.swift
//  Cinema
//
//  Created by Елена on 15.04.2023.
//

import UIKit

class CollectionScreenDetailCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "CollectionScreenDetailCollectionViewCell"
    
    private lazy var posterImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    private lazy var titleMovie: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "SFProText-Bold", size: 14)
        view.attributedText = NSAttributedString(string: "", attributes: [.kern: -0.17])
        view.textColor = .white
        
        return view
    }()
    
    private lazy var descriptionMovie: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "SFProText-Bold", size: 14)
        view.attributedText = NSAttributedString(string: "", attributes: [.kern: -0.17])
        view.textColor = .white
        view.numberOfLines = 3
        
        return view
    }()
    
    private lazy var imageArrowNext: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "ArrowNext")
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(posterImage)
        self.addSubview(titleMovie)
        self.addSubview(descriptionMovie)
        self.addSubview(imageArrowNext)
        
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
       
    }
}

private extension CollectionScreenDetailCollectionViewCell {
    func configureConstraints() {
        posterImage.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.equalTo(80)
            make.width.equalTo(56)
        }
        
        titleMovie.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(posterImage.snp.trailing).inset(-18)
        }
        
        descriptionMovie.snp.makeConstraints { make in
            make.top.equalTo(titleMovie.snp.bottom).inset(-8)
            make.leading.equalTo(titleMovie.snp.leading)
            make.bottom.equalToSuperview()
        }
        
        imageArrowNext.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalTo(descriptionMovie.snp.trailing).inset(-16)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}
