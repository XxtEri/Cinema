//
//  EpisodeScreenView.swift
//  Cinema
//
//  Created by Елена on 04.04.2023.
//

import UIKit
import SnapKit

class EpisodeScreenView: UIView {
    
    //- MARK: Private properties
    
    private enum Metrics {
        static let textSize: CGFloat = 24
        static let textKern: CGFloat = -0.17
        
        static let descriptionTextTextSize: CGFloat = 14
        
        static let descriptionTitleSizeHeight: CGFloat = 29
        
        static let titleEpisodeHorizontalInset: CGFloat = 16
        static let titleEpisodeTopInset: CGFloat = 16
        
        static let informationMovieTrailingInset: CGFloat = 18.02
        static let informationMovieTopInset: CGFloat = -16
        
        static let descriptionTitleHorizontalInset: CGFloat = 16
        static let descriptionTitleTopInset: CGFloat = -32
        
        static let descriptionTextHorizontalInset: CGFloat = 16
        static let descriptionTextTopInset: CGFloat = -8
        static let descriptionTextBottomInset: CGFloat = 10
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
    
    private lazy var content: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private lazy var titleEpisode: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "SFProText-Bold", size: Metrics.textSize)
        view.textAlignment = .left
        view.textColor = .white
        view.numberOfLines = .max
        view.attributedText = NSAttributedString(string: "", attributes: [.kern: Metrics.textKern])
        
        return view
    }()
    
    private lazy var descriptionTitle: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "SFProText-Bold", size: Metrics.textSize)
        view.textColor = .white
        view.text = "Описание"
        view.textAlignment = .left
        view.bounds.size.height = Metrics.descriptionTitleSizeHeight
        
        return view
    }()
    
    private lazy var descriptionText: UILabel = {
        let view = UILabel()
        view.attributedText = NSAttributedString(string: "", attributes: [.kern: Metrics.textKern])
        view.font = UIFont(name: "SFProText-Regular", size: Metrics.descriptionTextTextSize)
        view.textColor = .white
        view.numberOfLines = .max
        
        return view
    }()
    
    
    //- MARK: Public properties
    
    lazy var informationMovie = InformationMovieView()
    
    lazy var videoPlayerView = VideoPlayerView()
    
    var buttonBackGoToLastScreenPressed: ((EpisodeTime) -> Void)?

    
    //- MARK: Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(scrollView)
    
        scrollView.addSubview(videoPlayerView)
        scrollView.addSubview(content)
        
        content.addSubview(titleEpisode)
        content.addSubview(informationMovie)
        content.addSubview(descriptionTitle)
        content.addSubview(descriptionText)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //- MARK: Public methods
    
    func configureUIData(movie: Movie, episode: Episode) {
        self.videoPlayerView.configureURLVideo(urlEpisode: episode.filePath)
        
        self.titleEpisode.text = episode.name
        
        self.informationMovie.configureUIData(movie: movie, episode: episode)
        
        self.descriptionText.text = episode.description
    }
    
    func setYearsMovie(episodes: [Episode]) {
        var years = [Int]()
        
        episodes.forEach { episode in
            years.append(episode.year)
        }
        
        if let firstYear = years.min() {
            if let lasYear = years.max() {
                if firstYear == lasYear {
                    informationMovie.setYearsMovie(years: "\(firstYear)")
                    
                } else {
                    informationMovie.setYearsMovie(years: "\(firstYear) - \(lasYear)")
                }
            }
        }
    }
    
    func setTimeVideo(time: EpisodeTime) {
        videoPlayerView.setValueSecond(time: time)
    }
    
    func stopVideo() {
        videoPlayerView.player?.pause()
    }
}


//- MARK: Private extensions

private extension EpisodeScreenView {
    
    //- MARK: Setup
    
    func setup() {
        configureUI()
        configureConstraints()
        handler()
    }
    
    func configureUI() {
        self.backgroundColor = .backgroundApplication
    }
    
    func configureConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        videoPlayerView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.equalTo(scrollView.frameLayoutGuide)
        }
        
        content.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(scrollView.frameLayoutGuide)
            make.top.equalTo(videoPlayerView.snp.bottom)
            make.bottom.equalTo(scrollView.contentLayoutGuide.snp.bottom)
        }
        
        titleEpisode.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Metrics.titleEpisodeHorizontalInset)
            make.top.equalToSuperview().inset(Metrics.titleEpisodeTopInset)
        }
        
        informationMovie.snp.makeConstraints { make in
            make.leading.equalTo(titleEpisode.snp.leading)
            make.trailing.equalToSuperview().inset(Metrics.informationMovieTrailingInset)
            make.top.equalTo(titleEpisode.snp.bottom).inset(Metrics.informationMovieTopInset)
        }

        descriptionTitle.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Metrics.descriptionTitleHorizontalInset)
            make.top.equalTo(informationMovie.snp.bottom).inset(Metrics.descriptionTitleTopInset)
        }
        
        descriptionText.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Metrics.descriptionTextHorizontalInset)
            make.top.equalTo(descriptionTitle.snp.bottom).inset(Metrics.descriptionTextTopInset)
            make.bottom.equalToSuperview().inset(Metrics.descriptionTextBottomInset)
        }
    }
    
    func handler() {
        self.videoPlayerView.buttonBackGoToLastScreenPressed = { [ weak self ] time in
            guard let self = self else { return }
            
            self.buttonBackGoToLastScreenPressed?(time)
        }
    }
}
