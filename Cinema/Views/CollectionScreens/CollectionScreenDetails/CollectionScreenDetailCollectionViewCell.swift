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
    
    private lazy var infoMovie: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 8
        
        view.backgroundColor = .clear
        
        return view
    }()
    
    private lazy var titleMovie: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "SFProText-Bold", size: 14)
        view.attributedText = NSAttributedString(string: "", attributes: [.kern: -0.17])
        view.textColor = .white
        view.numberOfLines = 0
        
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
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(posterImage)
        self.addSubview(infoMovie)
        infoMovie.addArrangedSubview(titleMovie)
        infoMovie.addArrangedSubview(descriptionMovie)
        self.addSubview(imageArrowNext)
        
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureConstraints() {
        posterImage.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.equalTo(80)
            make.width.equalTo(56)
        }
        
        infoMovie.snp.makeConstraints { make in
            make.verticalEdges.equalTo(posterImage.snp.verticalEdges)
            make.leading.equalTo(posterImage.snp.trailing).inset(-18)
        }
        
        imageArrowNext.snp.makeConstraints { make in
            make.leading.equalTo(infoMovie.snp.trailing).inset(-16)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(12)
            make.height.equalTo(20.5)
        }
    }
    
    func configure(movie: Movie) {
        posterImage.downloaded(from: movie.poster, contentMode: posterImage.contentMode)
        titleMovie.text = movie.name
        descriptionMovie.text = movie.description
    }
}
