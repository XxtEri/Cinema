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
    
//    private lazy var ageRestriction: UILabel = {
//        let view = UILabel()
//        view.attributedText = NSAttributedString(string: "", attributes: [.kern: -0.17])
//        view.font = UIFont(name: "SFProText-Bold", size: 14)
//        view.textColor = .accentColorApplication
//        
//        return view
//    }()
//    
//    private lazy var discussionsImage: UIImageView = {
//        let view = UIImageView()
//        view.image = UIImage(named: "Discussions")
//        view.contentMode = .scaleAspectFit
//        view.isUserInteractionEnabled = true
//        
//        return view
//    }()

//    private lazy var informationMovie: TagLabelsView = {
//        let view = TagLabelsView()
//        
//        return view
//    }()
    
//    private lazy var descriptionTitle: UILabel = {
//        let view = UILabel()
//        view.font = UIFont(name: "SFProText-Bold", size: 24)
//        view.textColor = .white
//        view.text = "Описание"
//        view.textAlignment = .left
//        view.bounds.size.height = 29
//        
//        return view
//    }()
//    
//    private lazy var descriptionText: UILabel = {
//        let view = UILabel()
//        view.attributedText = NSAttributedString(string: "", attributes: [.kern: -0.17])
//        view.font = UIFont(name: "SFProText-Regular", size: 14)
//        view.textColor = .white
//        view.numberOfLines = .max
//        
//        return view
//    }()
    lazy var contentView: UIView = {
        let view = UIView()

        return view
    }()

    lazy var content: ContentMovieScreenView = {
        let view = ContentMovieScreenView()

        return view
    }()

//    private lazy var footagesMovie: FootageMovieView = {
//        let view = FootageMovieView()
//
//        return view
//    }()
//
//    lazy var episodesMovie: EpisodesMovieView = {
//        let view = EpisodesMovieView()
//
//        return view
//    }()
    
    var barBackButtonPressed: (() -> Void)?
//    var discussionsImagePressed: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(scrollView)
        self.addSubview(barBackButton)

        scrollView.addSubview(contentView)
        
        contentView.addSubview(coverMovieImage)
        contentView.addSubview(content)
        
        coverMovieImage.addSubview(watchButton)
        
//        contentView.addSubview(ageRestriction)
//        contentView.addSubview(discussionsImage)
//        contentView.addSubview(informationMovie)
//        contentView.addSubview(descriptionTitle)
//        contentView.addSubview(descriptionText)
        
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setMovie(movie: Movie) {
        coverMovieImage.downloaded(from: movie.poster, contentMode: coverMovieImage.contentMode)
        
        self.content.setMovie(movie: movie)
        self.content.setFootageMovieBlock(with: movie.imageUrls)
    }
    
    func setEpisodes(episodes: [Episode]) {
        self.content.setEpisodesMovie(episodes: episodes)
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
        
        contentView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(scrollView.frameLayoutGuide)
            make.top.equalToSuperview()
            make.bottom.equalTo(scrollView.contentLayoutGuide.snp.bottom)
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
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(coverMovieImage.snp.bottom).inset(-32)
            make.bottom.equalToSuperview()
        }
    }
    
    func configureActions() {
        barBackButton.addTarget(self, action: #selector(backGoToMainScreen), for: .touchUpInside)
    }
    
    @objc
    func backGoToMainScreen() {
        barBackButtonPressed?()
    }
}
