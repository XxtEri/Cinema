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
    
    private lazy var content: UIView = {
        let view = UIView()
        
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
    
    lazy var videoPlayerView = VideoPlayerView()
    
    var buttonBackGoToLastScreenPressed: (() -> Void)?

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
    
    func configureUIData(movie: Movie, episode: Episode) {
        self.videoPlayerView.configureURLVideo(urlEpisode: episode.filePath)
        
        self.titleEpisode.text = episode.name
        
        self.informationMovie.configureUIData(movie: movie, episode: episode)
        
        self.descriptionText.text = episode.description
    }
}

extension EpisodeScreenView {
    func setup() {
        configureUI()
        configureConstraints()
        configureActions()
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
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(16)
        }
        
        informationMovie.snp.makeConstraints { make in
            make.leading.equalTo(titleEpisode.snp.leading)
            make.trailing.equalToSuperview().inset(18.02)
            make.top.equalTo(titleEpisode.snp.bottom).inset(-16)
        }

        descriptionTitle.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(informationMovie.snp.bottom).inset(-32)
        }
        
        descriptionText.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(descriptionTitle.snp.bottom).inset(-8)
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
    func configureActions() {

    }
    
    func handler() {
        self.videoPlayerView.buttonBackGoToLastScreenPressed = { [ weak self ] in
            guard let self = self else { return }
            
            self.buttonBackGoToLastScreenPressed?()
        }
    }
}
