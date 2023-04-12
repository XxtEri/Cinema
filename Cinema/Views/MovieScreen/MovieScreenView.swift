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

    private lazy var informationMovie: InformationMovieBlockView = {
        let view = InformationMovieBlockView()
        
        return view
    }()
    
    private lazy var descriptionMovie: TitleWithTextView = {
        let view = TitleWithTextView()
        
        view.setTitle("Описание")
        
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

    var widthAllCells: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(scrollView)

        scrollView.addSubview(coverMovieImage)
        coverMovieImage.addSubview(watchButton)
        scrollView.addSubview(content)
        
        content.addSubview(ageRestriction)
        content.addSubview(discussions)
        content.addSubview(informationMovie)
        content.addSubview(descriptionMovie)
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
        informationMovie.setTagList(tags: movie.tags)
        descriptionMovie.setText(movie.description)
        footagesMovie.setFootagesMovie(footages: movie.imageUrls)
    }
    
    func setEpisodes(episodes: [Episode]) {
        episodesMovie.setArrayEpisodes(episodes)
    }
}

private extension MovieScreenView {
    func setup() {
        configureUI()
        configureConstraints()
    }
    
    func configureUI() {
        self.backgroundColor = .backgroundApplication
    }
    
    func configureConstraints() {
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
            make.height.equalTo(informationMovie.getHeightView(w: informationMovie.bounds.size.width))
        }
        
        descriptionMovie.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(informationMovie.snp.bottom).inset(-32)
            make.height.equalTo(155)
        }
        
        footagesMovie.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(descriptionMovie.snp.bottom).inset(-32)
            make.height.equalTo(117)
        }
        
        episodesMovie.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(footagesMovie.snp.bottom).inset(-32)
            make.bottom.equalToSuperview()
            make.height.equalTo(250)
        }
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
