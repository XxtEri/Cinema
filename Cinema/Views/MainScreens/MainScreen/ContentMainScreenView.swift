//
//  ContentMainScreenView.swift
//  Cinema
//
//  Created by Елена on 03.04.2023.
//

import UIKit
import SnapKit

class ContentMainScreenView: UIView {
    
    //- MARK: Private properties
    
    private enum Metrics {
        static let contentStackSpacing: CGFloat = 32
        
        static let specifyInterestsCornerRadius: CGFloat = 4
        static let specifyInterestsTextSize: CGFloat = 14
        static let specifyInterestsKern: CGFloat = -0.17
        static let specifyInterestsEdgeInsets = UIEdgeInsets(top: 13, left: 32, bottom: 13, right: 32)
        static let specifyInterestsHorizontalInset: CGFloat = 16
        static let specifyInterestsTopInset: CGFloat = -44
    }
    
    private var contentStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = Metrics.contentStackSpacing
        
        return view
    }()
    
    private lazy var specifyInterests: UIButton = {
        let view = UIButton()
        view.layer.cornerRadius = Metrics.specifyInterestsCornerRadius
        view.backgroundColor = .accentColorApplication
        view.titleLabel?.font = UIFont(name: "SFProText-Bold", size: Metrics.specifyInterestsTextSize)
        view.setAttributedTitle(NSAttributedString(string: "Указать интересы", attributes: [.kern: Metrics.specifyInterestsKern]), for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.contentEdgeInsets = Metrics.specifyInterestsEdgeInsets
        
        return view
    }()
    
    
    //- MARK: Public properties
    
    let trendBlock = TrendMoviesBlockView()
    let lastWatchBlock = LastWatchMovieBlockView()
    let newBlock = NewMoviesBlockView()
    let recomendationBlock = RecomendationMoviesBlockView()
    
    
    //- MARK: Inits

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(contentStack)
        contentStack.addArrangedSubview(trendBlock)
        contentStack.addArrangedSubview(lastWatchBlock)
        contentStack.addArrangedSubview(newBlock)
        contentStack.addArrangedSubview(recomendationBlock)
        self.addSubview(specifyInterests)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//- MARK: Private extensions

private extension ContentMainScreenView {
    
    //- MARK: Setup
    
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
            make.horizontalEdges.equalToSuperview().inset(Metrics.specifyInterestsHorizontalInset)
            make.top.equalTo(contentStack.snp.bottom).inset(Metrics.specifyInterestsTopInset)
        }
    }
}


//- MARK: Public extensions

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
