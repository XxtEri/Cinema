//
//  LastWatchMovieBlockView.swift
//  Cinema
//
//  Created by Елена on 03.04.2023.
//

import UIKit
import SnapKit

class LastWatchMovieBlockView: UIStackView {
    
    //- MARK: Private properties
    
    private enum Metrics {
        static let titleBlockTextSize: CGFloat = 24
        static let titleBlockSizeHeight: CGFloat = 29
        
        static let movieImageSizeHeight: CGFloat = 230
        
        static let titleMovieTextSize: CGFloat = 14
        
        static let stackSpacing: CGFloat = 16
        
        static let titleMovieLeadingBottomInset: CGFloat = 16
    }
    
    private lazy var titleBlock: UILabel = {
        let view = UILabel()
        view.text = "Вы смотрели"
        view.font = UIFont(name: "SFProText-Bold", size: Metrics.titleBlockTextSize)
        view.textColor = .accentColorApplication
        view.textAlignment = .left
        view.frame.size.height = Metrics.titleBlockSizeHeight
        
        return view
    }()
    
    private lazy var movieImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "WatchFilm")
        view.contentMode = .scaleAspectFill
        view.frame.size.height = Metrics.movieImageSizeHeight
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    private lazy var titleMovie: UILabel = {
        let view = UILabel()
        view.text = "Altered Carbon"
        view.font = UIFont(name: "SFProText-Bold", size: Metrics.titleMovieTextSize)
        view.textColor = .white
        view.textAlignment = .left
        
        return view
    }()
    
    private lazy var imagePlay: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "PlayLastWatchVideo")
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    private var lastWatchEpisode: EpisodeView?
    
    
    //- MARK: Public properties
    
    var lastWatchMovieEpisodePressed: ((EpisodeView) -> Void)?
    
    
    //- MARK: Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addArrangedSubview(titleBlock)
        self.addArrangedSubview(movieImage)
        
        movieImage.addSubview(titleMovie)
        movieImage.addSubview(imagePlay)
        
        setup()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //- MARK: Public methods
    
    func getHeightView() -> CGFloat {
        let titleHeight = titleBlock.frame.size.height
        let filmImageHeight = movieImage.frame.size.height
        let spacing = self.spacing
        
        return titleHeight + filmImageHeight + spacing
    }
    
    func setLastWatchMovie(with model: EpisodeView) {
        movieImage.downloaded(from: model.preview, contentMode: movieImage.contentMode)
        
        lastWatchEpisode = model
    }
    
    func setTitleMovie(title: String) {
        titleMovie.text = title
    }
}


//- MARK: Private extensions

private extension LastWatchMovieBlockView {
    
    //- MARK: Setup
    
    func setup() {
        configureConstraints()
        configureStack()
        configureAction()
    }
    
    func configureStack() {
        self.axis = .vertical
        self.spacing = Metrics.stackSpacing
    }
    
    func configureConstraints() {
        imagePlay.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        titleMovie.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(Metrics.titleMovieLeadingBottomInset)
        }
        
        movieImage.snp.makeConstraints { make in
            make.leading.equalToSuperview()
        }
    }
    
    func configureAction() {
        movieImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showLastWatchMovieScreen)))
    }
    
    
    //- MARK: Actions
    
    @objc
    func showLastWatchMovieScreen() {
        if let episode = lastWatchEpisode {
            lastWatchMovieEpisodePressed?(episode)
        }
    }
}

