//
//  LastWatchMovieBlockView.swift
//  Cinema
//
//  Created by Елена on 03.04.2023.
//

import UIKit
import SnapKit

class LastWatchMovieBlockView: UIStackView {
    private lazy var titleBlock: UILabel = {
        let view = UILabel()
        view.text = "Вы смотрели"
        view.font = UIFont(name: "SFProText-Bold", size: 24)
        view.textColor = .accentColorApplication
        view.textAlignment = .left
        view.frame.size.height = 29
        
        return view
    }()
    
    private lazy var movieImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "WatchFilm")
        view.contentMode = .scaleAspectFill
        view.frame.size.height = 230
        
        return view
    }()
    
    private lazy var titleMovie: UILabel = {
        let view = UILabel()
        view.text = "Altered Carbon"
        view.font = UIFont(name: "SFProText-Bold", size: 14)
        view.textColor = .white
        view.textAlignment = .left
        
        return view
    }()
    
    private lazy var imagePlay: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Play")
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    private var lastWatchMovie: EpisodeView?
    
    var lastWatchMoviePressed: ((EpisodeView) -> Void)?
    
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
    
    func getHeightView() -> CGFloat {
        let titleHeight = titleBlock.frame.size.height
        let filmImageHeight = movieImage.frame.size.height
        let spacing = self.spacing
        
        return titleHeight + filmImageHeight + spacing
    }
    
    func setLastWatchMovie(with model: EpisodeView) {
        movieImage.downloaded(from: model.preview, contentMode: movieImage.contentMode)
        
        lastWatchMovie = model
    }
    
    func setTitleMovie(title: String) {
        titleMovie.text = title
    }
}

private extension LastWatchMovieBlockView {
    func setup() {
        configureConstraints()
        configureStack()
    }
    
    func configureStack() {
        self.axis = .vertical
        self.spacing = 16
    }
    
    func configureConstraints() {
        imagePlay.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.verticalEdges.lessThanOrEqualToSuperview().inset(50)
        }
        
        titleMovie.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(16)
        }
        
        movieImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(0)
        }
    }
    
    func configureAction() {
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showLastWatchMovieScreen)))
    }
    
    @objc
    func showLastWatchMovieScreen() {
        if let movie = lastWatchMovie {
            lastWatchMoviePressed?(movie)
        }
    }
}

