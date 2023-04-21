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
    
    private enum Metrics {
        static let buttonCornerRadius: CGFloat = 4
        static let buttonTextSize: CGFloat = 14
        static let buttonEdgeInsets = UIEdgeInsets(top: 13, left: 32, bottom: 13, right: 32)
        
        static let barBackButtonLeading: CGFloat = 8.5
        static let barBackButtonTop: CGFloat = 18.5
        
        static let coverMovieImageHeight: CGFloat = UIScreen.main.bounds.height * 58 / 100
        
        static let watchButtonHorizontalInset: CGFloat = 120
        static let watchButtonBottomInset: CGFloat = 32
        
        static let contentTopInset: CGFloat = -32
    }
    
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
        view.layer.cornerRadius = Metrics.buttonCornerRadius
        view.backgroundColor = UIColor(named: "AccentColor")
        view.setTitle("Смотреть", for: .normal)
        view.titleLabel?.font = UIFont(name: "SFProText-Bold", size: Metrics.buttonTextSize)
        view.setTitleColor(.white, for: .normal)
        view.contentEdgeInsets = Metrics.buttonEdgeInsets

        return view
    }()
    
    
    //- MARK: Public properties
    
    lazy var contentView: UIView = {
        let view = UIView()

        return view
    }()

    lazy var content: ContentMovieScreenView = {
        let view = ContentMovieScreenView()

        return view
    }()
    
    var barBackButtonPressed: (() -> Void)?
    
    
    //- MARK: Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(scrollView)
        self.addSubview(barBackButton)

        scrollView.addSubview(contentView)
        
        contentView.addSubview(coverMovieImage)
        contentView.addSubview(content)
        
        coverMovieImage.addSubview(watchButton)
        
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //- MARK: Public methods
    
    func setMovie(movie: Movie) {
        coverMovieImage.downloaded(from: movie.poster, contentMode: coverMovieImage.contentMode)
        
        self.content.setMovie(movie: movie)
        self.content.setFootageMovieBlock(with: movie.imageUrls)
    }
    
    func setEpisodes(episodes: [Episode]) {
        self.content.setEpisodesMovie(episodes: episodes)
    }
}


//- MARK: Private extensions

private extension MovieScreenView {
    
    //- MARK: Setup
    
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
            make.leading.equalToSuperview().inset(Metrics.barBackButtonLeading)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(Metrics.barBackButtonTop)
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
            make.height.lessThanOrEqualTo(Metrics.coverMovieImageHeight)
        }
        
        watchButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Metrics.watchButtonHorizontalInset)
            make.bottom.equalToSuperview().inset(Metrics.watchButtonBottomInset)
        }
        
        content.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(coverMovieImage.snp.bottom).inset(Metrics.contentTopInset)
            make.bottom.equalToSuperview()
        }
    }
    
    func configureActions() {
        barBackButton.addTarget(self, action: #selector(backGoToMainScreen), for: .touchUpInside)
    }
    
    
    //- MARK: Actions
    
    @objc
    func backGoToMainScreen() {
        barBackButtonPressed?()
    }
}
