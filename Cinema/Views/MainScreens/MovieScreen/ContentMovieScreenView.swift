//
//  ContentMovieScreenView.swift
//  Cinema
//
//  Created by Елена on 18.04.2023.
//

import UIKit
import SnapKit

class ContentMovieScreenView: UIView {
    private var contentStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 32
        
        return view
    }()
    
    private lazy var ageRestriction: UILabel = {
        let view = UILabel()
        view.attributedText = NSAttributedString(string: "", attributes: [.kern: -0.17])
        view.font = UIFont(name: "SFProText-Bold", size: 14)
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
        view.font = UIFont(name: "SFProText-Bold", size: 24)
        view.textColor = .white
        view.text = "Описание"
        view.textAlignment = .left
        view.bounds.size.height = 29
        
        return view
    }()
    
    private lazy var descriptionText: UILabel = {
        let view = UILabel()
        view.attributedText = NSAttributedString(string: "", attributes: [.kern: -0.17])
        view.font = UIFont(name: "SFProText-Regular", size: 14)
        view.textColor = .white
        view.numberOfLines = .max
        
        return view
    }()
    
    let footagesMovie = FootageMovieView()
    let episodesMovie = EpisodesMovieView()
    
    var discussionsImagePressed: (() -> Void)?
    
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
    
    func setMovie(movie: Movie) {
        self.setLabelAgeMovie(age: movie.age)
        informationMovie.tagNames = movie.tags
        descriptionText.text = movie.description
    }
    
    func setEpisodesMovie(episodes: [Episode]) {
        self.setEpisodeMovieBlock(with: episodes)
        
        episodesMovie.snp.updateConstraints { make in
            make.height.equalTo((episodes.count + 1) * 72 + episodes.count * 16)
        }
    }
}

private extension ContentMovieScreenView {
    func setup() {
        configureConstraints()
        configureActions()
    }
    
    func configureConstraints() {
        ageRestriction.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(-20)
            make.trailing.equalTo(discussionsButton.snp.leading).inset(-17.99)
            make.centerY.equalTo(discussionsButton.snp.centerY)
        }
        
        discussionsButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(19)
            make.top.equalTo(ageRestriction.snp.top)
        }
        
        informationMovie.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(ageRestriction.snp.bottom).inset(-25)
        }
        
        descriptionTitle.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(informationMovie.snp.bottom).inset(-32)
        }
        
        descriptionText.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(descriptionTitle.snp.bottom).inset(-8)
            make.bottom.equalTo(contentStack.snp.top).inset(-32)
        }
        
        contentStack.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(37)
        }
        
        footagesMovie.snp.makeConstraints { make in
            make.height.equalTo(footagesMovie.getHeightView())
        }
        
        episodesMovie.snp.makeConstraints { make in
            make.height.equalTo(0)
        }
    }
    
    func configureActions() {
        discussionsButton.addTarget(self, action: #selector(goToChatCurrentMovie), for: .touchUpInside)
    }
    
    @objc
    func goToChatCurrentMovie() {
        discussionsImagePressed?()
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
