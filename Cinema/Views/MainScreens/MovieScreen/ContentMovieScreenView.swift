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
        
        static let descriptionTitleTextSize: CGFloat = 24
        static let descriptionTitleSizeHeight: CGFloat = 29
        
        static let descriptionTextKern: CGFloat = -0.17
        static let descriptionTextTextSize: CGFloat = 14
        
        static let cellHeight = 72
        static let cellSpacing = 16
        
        static let informationMovieHorizontalInset: CGFloat = 16
        static let informationMovieTopInset: CGFloat = 25
        
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
    
    
    //- MARK: Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
    }
    
    func configureConstraints() {
        informationMovie.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Metrics.informationMovieHorizontalInset)
            make.top.equalToSuperview().inset(Metrics.informationMovieTopInset)
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
}
