//
//  MovieScreenView.swift
//  Cinema
//
//  Created by Елена on 01.04.2023.
//

import UIKit
import SnapKit

class MovieScreenView: UIView {
    
    //- MARK: Private properties
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.alwaysBounceVertical = true
        view.frame = self.bounds
        view.contentInsetAdjustmentBehavior = .never
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false

        return view
    }()
    
    private lazy var barBackButton: UIButton = {
        let view = UIButton()
        view.setBackgroundImage(UIImage(named: "ArrowBack"), for: .normal)
        
        return view
    }()
    
    private lazy var coverMovieImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "FilmMovieScreen")
        view.contentMode = .scaleToFill

        return view
    }()

    private lazy var watchButton: UIButton = {
        let view = UIButton()
        view.layer.cornerRadius = 4
        view.backgroundColor = UIColor(named: "AccentColor")
        view.setTitle("Смотреть", for: .normal)
        view.titleLabel?.font = UIFont(name: "SFProText-Bold", size: 14)
        view.setTitleColor(.white, for: .normal)
        view.contentEdgeInsets = UIEdgeInsets(top: 13, left: 32, bottom: 13, right: 32)

        return view
    }()
    
    private lazy var content: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private lazy var ageRestriction: UILabel = {
        let view = UILabel()
        view.attributedText = NSAttributedString(string: "", attributes: [.kern: -0.17])
        view.font = UIFont(name: "SFProText-Bold", size: 14)
        view.textColor = .accentColorApplication
        
        return view
    }()
    
    private lazy var discussions: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Discussions")
        view.contentMode = .scaleAspectFit
        
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
    
    private lazy var footagesMovie: FootageMovieView = {
        let view = FootageMovieView()
        
        return view
    }()
    
    lazy var episodesMovie: EpisodesMovieView = {
        let view = EpisodesMovieView()
        
        return view
    }()
    
    var backToGoMainScreen: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(scrollView)

        scrollView.addSubview(coverMovieImage)
        coverMovieImage.addSubview(watchButton)
        self.addSubview(barBackButton)
        scrollView.addSubview(content)
        
        content.addSubview(ageRestriction)
        content.addSubview(discussions)
        content.addSubview(informationMovie)
        content.addSubview(descriptionTitle)
        content.addSubview(descriptionText)
        content.addSubview(footagesMovie)
        content.addSubview(episodesMovie)
        
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setMovie(movie: Movie) {
        coverMovieImage.downloaded(from: movie.poster, contentMode: coverMovieImage.contentMode)
        self.setLabelAgeMovie(age: movie.age)
        informationMovie.tagNames = movie.tags
        descriptionText.text = movie.description
        footagesMovie.setFootagesMovie(footages: movie.imageUrls)
    }
    
    func setEpisodes(episodes: [Episode]) {
        self.episodesMovie.setArrayEpisodes(episodes)
    }
}

private extension MovieScreenView {
    func setup() {
        configureUI()
        configureConstraints()
        configureActions()
    }
    
    func configureUI() {
        self.backgroundColor = .backgroundApplication
    }
    
    func configureConstraints() {
        
        barBackButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(8.5)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(18.5)
        }
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        coverMovieImage.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(scrollView.frameLayoutGuide)
            make.top.equalToSuperview()
            make.height.lessThanOrEqualTo(UIScreen.main.bounds.height * 58 / 100)
        }
        
        watchButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(120)
            make.bottom.equalToSuperview().inset(32)
        }
        
        content.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(scrollView.frameLayoutGuide)
            make.top.equalTo(coverMovieImage.snp.bottom)
            make.bottom.equalTo(scrollView.contentLayoutGuide.snp.bottom)
        }
        
        ageRestriction.snp.makeConstraints { make in
            make.top.equalTo(coverMovieImage.snp.bottom).inset(-20)
            make.trailing.equalTo(discussions.snp.leading).inset(-17.99)
            make.centerY.equalTo(discussions.snp.centerY)
        }
        
        discussions.snp.makeConstraints { make in
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
            make.bottom.equalTo(footagesMovie.snp.top).inset(-32)
        }
        
        footagesMovie.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(117)
        }
        
        episodesMovie.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(footagesMovie.snp.bottom).inset(-32)
            make.bottom.equalToSuperview()
            make.height.equalTo(250)
        }
    }
    
    func configureActions() {
        barBackButton.addTarget(self, action: #selector(backGoToMainScreen), for: .touchUpInside)
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
    
    @objc
    func backGoToMainScreen() {
        backToGoMainScreen?()
    }
}