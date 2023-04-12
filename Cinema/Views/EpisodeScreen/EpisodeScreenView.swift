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
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.alwaysBounceVertical = true
        view.frame = self.bounds
        view.contentInsetAdjustmentBehavior = .never
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false

        return view
    }()
    
    private lazy var titleEpisode: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "SFProText-Bold", size: 24)
        view.textAlignment = .left
        view.textColor = .white
        view.numberOfLines = .max
        view.attributedText = NSAttributedString(string: "", attributes: [.kern: -0.17])
        
        return view
    }()
    
    private lazy var informationMovie = InformationMovieView()
    
    private lazy var descriptionMovie: TitleWithTextView = {
        let view = TitleWithTextView()
        
        view.setTitle("Описание")
        
        return view
    }()
    
    lazy var videoPlayerView = VideoPlayerView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(scrollView)
        
        scrollView.addSubview(videoPlayerView)
        scrollView.addSubview(titleEpisode)
        scrollView.addSubview(informationMovie)
        scrollView.addSubview(descriptionMovie)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUIData(movie: Movie, episode: Episode) {
        self.videoPlayerView.configureURLVideo(urlEpisode: episode.filePath)
        
        self.titleEpisode.text = episode.name
        
        self.informationMovie.configureUIData(movie: movie, episode: episode)
        
        self.descriptionMovie.setText(episode.description)
    }
}

extension EpisodeScreenView {
    func setup() {
        configureUI()
        configureConstraints()
        configureActions()
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
        
        titleEpisode.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(scrollView.frameLayoutGuide).inset(16)
            make.top.equalTo(videoPlayerView.snp.bottom).inset(-16)
        }
        
        informationMovie.snp.makeConstraints { make in
            make.leading.equalTo(titleEpisode.snp.leading)
            make.trailing.equalTo(scrollView.frameLayoutGuide.snp.trailing).inset(18.02)
            make.top.equalTo(titleEpisode.snp.bottom).inset(-16)
        }

        descriptionMovie.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(scrollView.frameLayoutGuide).inset(16)
            make.top.equalTo(informationMovie.snp.bottom).inset(-32)
            make.bottom.equalTo(scrollView.contentLayoutGuide.snp.bottom).inset(10)
            make.height.greaterThanOrEqualTo(40)
        }
    }
    
    func configureActions() {
        
    }
}
