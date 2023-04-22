//
//  InformationMovieView.swift
//  Cinema
//
//  Created by Елена on 11.04.2023.
//

import UIKit
import SnapKit

class InformationMovieView: UIView {
    
    //- MARK: Private properties
    
    private enum Metrics {
        static let stackInformationSpacing: CGFloat = 2
        
        static let textSize: CGFloat = 12
        static let textKern: CGFloat = -0.17
        
        static let stackButtonsSpacing: CGFloat = 22
        
        static let posterHeight: CGFloat = 64
        static let posterWidth: CGFloat = 44
        
        static let stackInformationLeadingInset: CGFloat = -16
        
        static let stackButtonsLeadingInset: CGFloat = -20
    }
    
    private lazy var poster: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    private lazy var stackInformation: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = Metrics.stackInformationSpacing
        
        return view
    }()
    
    private lazy var titleMovie: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "SFProText-Bold", size: Metrics.textSize)
        view.textAlignment = .left
        view.textColor = .white
        view.numberOfLines = .max
        view.attributedText = NSAttributedString(string: "", attributes: [.kern: Metrics.textKern])
        
        return view
    }()
    
    private lazy var numberSeason: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "SFProText-Regular", size: Metrics.textSize)
        view.textAlignment = .left
        view.textColor = .textEpisodeScreen
        view.numberOfLines = .max
        view.attributedText = NSAttributedString(string: "", attributes: [.kern: Metrics.textKern])
        
        return view
    }()
    
    private lazy var releaseYears: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "SFProText-Regular", size: Metrics.textSize)
        view.textAlignment = .left
        view.textColor = .textEpisodeScreen
        view.numberOfLines = .max
        view.attributedText = NSAttributedString(string: "", attributes: [.kern: Metrics.textKern])
        
        return view
    }()
    
    private lazy var stackButtons: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = Metrics.stackButtonsSpacing
        
        return view
    }()
    
    private lazy var chatIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Discussions")
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    private lazy var plusIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "PlusIcon")
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    private lazy var likeIcon: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = true
        view.image = UIImage(named: "Like")
        
        return view
    }()
    
    
    //- MARK: Public properties
    
    var chatIconPressed: (() -> Void)?
    var plusIconPressed: (() -> Void)?
    var likeIconPressed: (() -> Void)?
    
    
    //- MARK: Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(poster)
        self.addSubview(stackInformation)
        
        stackInformation.addArrangedSubview(titleMovie)
        stackInformation.addArrangedSubview(numberSeason)
        stackInformation.addArrangedSubview(releaseYears)
        
        self.addSubview(stackButtons)
        
        stackButtons.addArrangedSubview(chatIcon)
        stackButtons.addArrangedSubview(plusIcon)
        stackButtons.addArrangedSubview(likeIcon)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //- MARK: Public methods
    
    func configureUIData(movie: Movie, episode: Episode) {
        titleMovie.text = movie.name
        poster.downloaded(from: movie.poster, contentMode: poster.contentMode)
    }
    
    func setYearsMovie(years: String) {
        releaseYears.text = years
    }
    
    func updateLikeIcon(isFavoriteMovie: Bool) {
        if isFavoriteMovie {
            likeIcon.image = UIImage(named: "LikeFilledIcon")
            
        } else {
            likeIcon.image = UIImage(named: "Like")
        }
    }
}


//- MARK: Private extensions

private extension InformationMovieView {
    
    //- MARK: Setup
    
    func setup() {
        configureConstraints()
        configureActions()
    }
    
    func configureConstraints() {
        poster.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.verticalEdges.equalToSuperview()
            make.centerY.equalTo(stackInformation.snp.centerY)
            make.height.lessThanOrEqualTo(Metrics.posterHeight)
            make.width.lessThanOrEqualTo(Metrics.posterWidth)
        }
        
        stackInformation.snp.makeConstraints { make in
            make.leading.equalTo(poster.snp.trailing).inset(Metrics.stackInformationLeadingInset)
            make.verticalEdges.equalToSuperview()
        }
        
        stackButtons.snp.makeConstraints { make in
            make.verticalEdges.equalTo(poster.snp.verticalEdges)
            make.trailing.equalToSuperview()
            make.leading.greaterThanOrEqualTo(stackInformation.snp.trailing).inset(Metrics.stackButtonsLeadingInset)
            make.centerY.equalTo(stackInformation.snp.centerY)
        }
    }
    
    func configureActions() {
        chatIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToChatMovieScreen)))
        
        plusIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addToCollection)))
        
        likeIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addOrDeleteInFavoriteCollection)))
    }
    
    
    //- MARK: Actions
    
    @objc
    func goToChatMovieScreen() {
        chatIconPressed?()
    }
    
    @objc
    func addToCollection() {
        plusIconPressed?()
    }
    
    @objc
    func addOrDeleteInFavoriteCollection() {
        likeIconPressed?()
    }
}
