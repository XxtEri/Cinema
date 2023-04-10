//
//  EpisodeScreenView.swift
//  Cinema
//
//  Created by Елена on 04.04.2023.
//

import UIKit
import SnapKit

class EpisodeScreenView: UIView {
    
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
    
    private lazy var titleDescription: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "SFProText-Bold", size: 29)
        view.textAlignment = .left
        view.textColor = .white
        view.attributedText = NSAttributedString(string: "Описание", attributes: [.kern: -0.17])
        
        return view
    }()
    
    private lazy var descriptionText: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "SFProText-Regular", size: 14)
        view.textAlignment = .left
        view.textColor = .white
        view.numberOfLines = .max
        view.attributedText = NSAttributedString(string: "", attributes: [.kern: -0.17])
        
        return view
    }()
    
    lazy var videoPlayerView = VideoPlayerView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(videoPlayerView)
        self.addSubview(titleEpisode)
        self.addSubview(informationMovie)
        self.addSubview(titleDescription)
        self.addSubview(descriptionText)
        
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
    }
    
    func configureUI() {
        self.backgroundColor = .backgroundApplication
    }
    
    func configureConstraints() {
        videoPlayerView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.equalToSuperview()
        }
        
        titleEpisode.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(videoPlayerView.snp.bottom).inset(-16)
        }
        
        informationMovie.snp.makeConstraints { make in
            make.leading.equalTo(titleEpisode.snp.leading)
            make.trailing.equalToSuperview().inset(18.02)
            make.top.equalTo(titleEpisode.snp.bottom).inset(-16)
        }
        
        titleDescription.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(informationMovie.snp.bottom).inset(-32)
        }
        
        descriptionText.snp.makeConstraints { make in
            make.leading.equalTo(titleDescription.snp.leading)
            make.trailing.equalToSuperview().inset(18)
            make.top.equalTo(titleDescription.snp.bottom).inset(-8)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).inset(10)
        }
    }
    
    func configureActions() {
        
    }
}
