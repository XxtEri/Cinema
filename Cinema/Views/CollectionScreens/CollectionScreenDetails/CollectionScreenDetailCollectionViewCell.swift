//
//  CollectionScreenDetailCollectionViewCell.swift
//  Cinema
//
//  Created by Елена on 15.04.2023.
//

import UIKit
import SnapKit

class CollectionScreenDetailCollectionViewCell: UICollectionViewCell {
    
    //- MARK: Private properties
    
    private enum Metrics {
        static let infoMovieSpacing: CGFloat = 8
        
        static let textSize: CGFloat = 14
        static let textKern: CGFloat = -0.17
        
        static let titleMovieNumberLine = 0
        
        static let descriptionMovieNumberLine = 3
        
        static let posterImageHeight: CGFloat = 80
        static let posterImageWidth: CGFloat = 56
        
        static let infoMovieLeadingInset: CGFloat = -18
        
        static let imageArrowNextLeadingInset: CGFloat = -16
        static let imageArrowNextWidth: CGFloat = 12
        static let imageArrowNextHeight: CGFloat = 20.5
    }
    
    private lazy var posterImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    private lazy var infoMovie: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = Metrics.infoMovieSpacing
        
        view.backgroundColor = .clear
        
        return view
    }()
    
    private lazy var titleMovie: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "SFProText-Bold", size: Metrics.textSize)
        view.attributedText = NSAttributedString(string: "", attributes: [.kern: Metrics.textKern])
        view.textColor = .white
        view.numberOfLines = Metrics.titleMovieNumberLine
        
        return view
    }()
    
    private lazy var descriptionMovie: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "SFProText-Bold", size: Metrics.textSize)
        view.attributedText = NSAttributedString(string: "", attributes: [.kern: Metrics.textKern])
        view.textColor = .white
        view.numberOfLines = Metrics.descriptionMovieNumberLine
        
        return view
    }()
    
    private lazy var imageArrowNext: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "ArrowNext")
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    
    
    //- MARK: Public static properties
    
    static let reuseIdentifier = "CollectionScreenDetailCollectionViewCell"

    
    //- MARK: Inits
    
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
    
    
    //- MARK: Public methods
    
    func configure(movie: Movie) {
        posterImage.downloaded(from: movie.poster, contentMode: posterImage.contentMode)
        titleMovie.text = movie.name
        descriptionMovie.text = movie.description
    }
}


//- MARK: Private extensions

private extension CollectionScreenDetailCollectionViewCell {
    
    //- MARK: Setup
    
    func setup() {
        configureConstraints()
    }
    
    func configureConstraints() {
        posterImage.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.equalTo(Metrics.posterImageHeight)
            make.width.equalTo(Metrics.posterImageWidth)
        }
        
        infoMovie.snp.makeConstraints { make in
            make.verticalEdges.equalTo(posterImage.snp.verticalEdges)
            make.leading.equalTo(posterImage.snp.trailing).inset(Metrics.infoMovieLeadingInset)
        }
        
        imageArrowNext.snp.makeConstraints { make in
            make.leading.equalTo(infoMovie.snp.trailing).inset(Metrics.imageArrowNextLeadingInset)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(Metrics.imageArrowNextWidth)
            make.height.equalTo(Metrics.imageArrowNextHeight)
        }
    }
}
