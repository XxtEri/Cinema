//
//  ContentMainScreenView.swift
//  Cinema
//
//  Created by Елена on 03.04.2023.
//

import UIKit
import SnapKit

class ContentMainScreenView: UIView {
    private var contentStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 32
        
        return view
    }()
    
    private lazy var specifyInterests: UIButton = {
        let view = UIButton()
        view.layer.cornerRadius = 4
        view.backgroundColor = .accentColorApplication
        view.titleLabel?.font = UIFont(name: "SFProText-Bold", size: 14)
        view.setAttributedTitle(NSAttributedString(string: "Указать интересы", attributes: [.kern: -0.17]), for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.contentEdgeInsets = UIEdgeInsets(top: 13, left: 32, bottom: 13, right: 32)
        
        return view
    }()
    
    let trendBlock = TrendMoviesBlockView()
    let lastWatchBlock = LastWatchMovieBlockView()
    let newBlock = NewMoviesBlockView()
    let recomendationBlock = RecomendationMoviesBlockView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(contentStack)
        contentStack.addArrangedSubview(trendBlock)
        contentStack.addArrangedSubview(lastWatchBlock)
        contentStack.addArrangedSubview(newBlock)
        contentStack.addArrangedSubview(recomendationBlock)
        contentStack.addArrangedSubview(specifyInterests)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ContentMainScreenView {
    func setup() {
        configureConstraints()
    }
    
    func configureConstraints() {
        contentStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        trendBlock.snp.makeConstraints { make in
            make.height.equalTo(trendBlock.getHeightView())
        }
        
        lastWatchBlock.snp.makeConstraints { make in
            make.height.equalTo(lastWatchBlock.getHeightView())
        }
        
        newBlock.snp.makeConstraints { make in
            make.height.equalTo(newBlock.getHeightView())
        }
        
        recomendationBlock.snp.makeConstraints { make in
            make.height.equalTo(recomendationBlock.getHeightView())
        }
        
        specifyInterests.snp.makeConstraints { make in
            make.height.lessThanOrEqualTo(44)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}

extension ContentMainScreenView {
    func setMovieImageInTrendBlock(with model: [Movie]) {
        if model.isEmpty {
            contentStack.removeArrangedSubview(trendBlock)
            trendBlock.removeFromSuperview()
            
            return
        }
        
        model.forEach { movie in
            trendBlock.addNewMovie(movie: movie)
        }
    }
    
    func setLastWatchMovie(with model: EpisodeView?) {
        guard let movie = model else {
            contentStack.removeArrangedSubview(lastWatchBlock)
            lastWatchBlock.removeFromSuperview()
            
            return
        }
        
        self.lastWatchBlock.setLastWatchMovie(with: movie)
        self.lastWatchBlock.setTitleMovie(title: movie.episodeName)
    }
    
    func setMovieImageInNewBlock(with model: [Movie]) {
        if model.isEmpty {
            contentStack.removeArrangedSubview(newBlock)
            newBlock.removeFromSuperview()
            
            return
        }
        
        model.forEach { movie in
            newBlock.addNewMovie(movie: movie)
        }
    }
    
    func setMovieImageRecomendationBlock(with model: [Movie]) {
        if model.isEmpty {
            contentStack.removeArrangedSubview(recomendationBlock)
            recomendationBlock.removeFromSuperview()
            
            return
        }
        
        model.forEach { movie in
            recomendationBlock.addNewMovie(movie: movie)
        }
    }
}
