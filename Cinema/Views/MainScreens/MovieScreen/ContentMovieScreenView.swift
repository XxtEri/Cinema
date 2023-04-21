//
//  ContentMovieScreenView.swift
//  Cinema
//
//  Created by Елена on 18.04.2023.
//

import UIKit
import SnapKit

class ContentMovieScreenView: UIView {
    
    //- MARK: Private properties
    
    private enum Metrics {
        static let contentStackSpacing: CGFloat = 32
        static let ageRestrictionKern: CGFloat = -0.17
        static let ageRestrictionTextsize: CGFloat = 14
        
        static let descriptionTitleTextSize: CGFloat = 24
        static let descriptionTitleSizeHeight: CGFloat = 29
        
        static let descriptionTextKern: CGFloat = -0.17
        static let descriptionTextTextSize: CGFloat = 14
        
        static let cellHeight = 72
        static let cellSpacing = 16
        
        static let ageRestrictionTopInset: CGFloat = -20
        static let ageRestrictionTrailingInset: CGFloat = -17.99
        
        static let discussionsButtonTrailingInset: CGFloat = 19
        
        static let informationMovieHorizontalInset: CGFloat = 16
        static let informationMovieTopInset: CGFloat = -25
        
        static let descriptionTitleHorizontalInset: CGFloat = 16
        static let descriptionTitleTopInset: CGFloat = -32
        
        static let descriptionTextHorizontalInset: CGFloat = 16
        static let descriptionTextTopInset: CGFloat = -8
        static let descriptionTextBottomInset: CGFloat = -32
        
        static let contentStackBottomInset: CGFloat = 37
        
        static let episodeMovieDefaultHeight = 0
    }
    
    private var contentStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = Metrics.contentStackSpacing
        
        return view
    }()
    
    private lazy var ageRestriction: UILabel = {
        let view = UILabel()
        view.attributedText = NSAttributedString(string: "", attributes: [.kern: Metrics.ageRestrictionKern])
        view.font = UIFont(name: "SFProText-Bold", size: Metrics.ageRestrictionTextsize)
        view.textColor = .accentColorApplication
        
        return view
    }()
    
    private lazy var discussionsButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "Discussions"), for: .normal)
        
        return view
    }()
    
    private lazy var informationMovie: TagLabelsView = {
        let view = TagLabelsView()
        
        return view
    }()
    
    private lazy var descriptionTitle: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "SFProText-Bold", size: Metrics.descriptionTitleTextSize)
        view.textColor = .white
        view.text = "Описание"
        view.textAlignment = .left
        view.bounds.size.height = Metrics.descriptionTitleSizeHeight
        
        return view
    }()
    
    private lazy var descriptionText: UILabel = {
        let view = UILabel()
        view.attributedText = NSAttributedString(string: "", attributes: [.kern: Metrics.descriptionTextKern])
        view.font = UIFont(name: "SFProText-Regular", size: Metrics.descriptionTextTextSize)
        view.textColor = .white
        view.numberOfLines = .max
        
        return view
    }()
    
    
    //- MARK: Public properties
    
    let footagesMovie = FootageMovieView()
    let episodesMovie = EpisodesMovieView()
    
    var discussionsImagePressed: (() -> Void)?
    
    
    //- MARK: Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(ageRestriction)
        self.addSubview(discussionsButton)
        self.addSubview(informationMovie)
        self.addSubview(descriptionTitle)
        self.addSubview(descriptionText)
        self.addSubview(contentStack)
        
        contentStack.addArrangedSubview(footagesMovie)
        contentStack.addArrangedSubview(episodesMovie)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //- MARK: Public methods
    
    func setMovie(movie: Movie) {
        self.setLabelAgeMovie(age: movie.age)
        informationMovie.tagNames = movie.tags
        descriptionText.text = movie.description
    }
    
    func setEpisodesMovie(episodes: [Episode]) {
        self.setEpisodeMovieBlock(with: episodes)
        
        episodesMovie.snp.updateConstraints { make in
            make.height.equalTo((episodes.count + 1) * Metrics.cellHeight + episodes.count * Metrics.cellSpacing)
        }
    }
}


//- MARK: Private extensions

private extension ContentMovieScreenView {
    
    //- MARK: Setup
    
    func setup() {
        configureConstraints()
        configureActions()
    }
    
    func configureConstraints() {
        ageRestriction.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Metrics.ageRestrictionTopInset)
            make.trailing.equalTo(discussionsButton.snp.leading).inset(Metrics.ageRestrictionTrailingInset)
            make.centerY.equalTo(discussionsButton.snp.centerY)
        }
        
        discussionsButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(Metrics.discussionsButtonTrailingInset)
            make.top.equalTo(ageRestriction.snp.top)
        }
        
        informationMovie.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Metrics.informationMovieHorizontalInset)
            make.top.equalTo(ageRestriction.snp.bottom).inset(Metrics.informationMovieTopInset)
        }
        
        descriptionTitle.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Metrics.descriptionTitleHorizontalInset)
            make.top.equalTo(informationMovie.snp.bottom).inset(Metrics.descriptionTitleTopInset)
        }
        
        descriptionText.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Metrics.descriptionTextHorizontalInset)
            make.top.equalTo(descriptionTitle.snp.bottom).inset(Metrics.descriptionTextTopInset)
            make.bottom.equalTo(contentStack.snp.top).inset(Metrics.descriptionTextBottomInset)
        }
        
        contentStack.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(Metrics.contentStackBottomInset)
        }
        
        footagesMovie.snp.makeConstraints { make in
            make.height.equalTo(footagesMovie.getHeightView())
        }
        
        episodesMovie.snp.makeConstraints { make in
            make.height.equalTo(Metrics.episodeMovieDefaultHeight)
        }
    }
    
    func configureActions() {
        discussionsButton.addTarget(self, action: #selector(goToChatCurrentMovie), for: .touchUpInside)
    }
    
    //- MARK: Actions
    
    @objc
    func goToChatCurrentMovie() {
        discussionsImagePressed?()
    }
}


//- MARK: Public extensions

extension ContentMovieScreenView {
    func setEpisodeMovieBlock(with model: [Episode]) {
        if model.isEmpty {
            contentStack.removeArrangedSubview(episodesMovie)
            episodesMovie.removeFromSuperview()
            
            return
        }

        episodesMovie.setArrayEpisodes(model)
    }
    
    func setFootageMovieBlock(with model: [String]) {
        if model.isEmpty {
            contentStack.removeArrangedSubview(footagesMovie)
            footagesMovie.removeFromSuperview()

            return
        }

        footagesMovie.setFootagesMovie(footages: model)
    }
    
    func setLabelAgeMovie(age: Age) {
        switch age {
        case .zero:
            ageRestriction.textColor = .white
        case .six:
            ageRestriction.textColor = .sixPlus
        case .twelve:
            ageRestriction.textColor = .twelvePlus
        case .sixteen:
            ageRestriction.textColor = .sixteenPlus
        case .eighteen:
            ageRestriction.textColor = .accentColorApplication
        }
        
        ageRestriction.text = age.rawValue
    }
}
