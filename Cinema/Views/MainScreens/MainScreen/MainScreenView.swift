//
//  MainScreenView.swift
//  Cinema
//
//  Created by Елена on 03.04.2023.
//

import UIKit
import SnapKit

class MainScreenView: UIView {
    
    //- MARK: Private properties
    
    private enum Metrics {
        static let watchButtonCornerRadius: CGFloat = 4
        
        static let watchButtonTextSize: CGFloat = 14
        static let watchButtonEdgeInsets = UIEdgeInsets(top: 13, left: 32, bottom: 13, right: 32)

        static let contentViewBottomInset: CGFloat = 100
        
        static let imageFilmCoverHeight: CGFloat = UIScreen.main.bounds.height * 58 / 100
        
        static let watchButtonHorizontalInset: CGFloat = 120
        static let watchButtonBottomInset: CGFloat = 64
        
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
    
    private lazy var imageFilmCover: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "FilmCover")
        view.contentMode = .scaleToFill
        
        return view
    }()
    
    private lazy var watchButton: UIButton = {
        let view = UIButton()
        view.layer.cornerRadius = Metrics.watchButtonCornerRadius
        view.backgroundColor = .accentColorApplication
        view.setTitle("Смотреть", for: .normal)
        view.titleLabel?.font = UIFont(name: "SFProText-Bold", size: Metrics.watchButtonTextSize)
        view.setTitleColor(.white, for: .normal)
        view.contentEdgeInsets = Metrics.watchButtonEdgeInsets
        
        return view
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private var coverMovie: CoverMovie?
    
    
    //- MARK: Public properties
    
    lazy var content: ContentMainScreenView = {
        let view = ContentMainScreenView()
        
        return view
    }()
    
    
    //- MARK: Inits

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        contentView.addSubview(imageFilmCover)
     
        imageFilmCover.addSubview(watchButton)
        contentView.addSubview(content)
        
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//- MARK: Private extensions

private extension MainScreenView {
    
    //- MARK: Setup
    
    func setup() {
        configureUI()
        configureConstraints()
    }
    
    func configureUI() {
        self.backgroundColor = .backgroundApplication
    }
    
    func configureConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(scrollView.frameLayoutGuide)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(Metrics.contentViewBottomInset)
        }

        imageFilmCover.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(scrollView.contentLayoutGuide.snp.top)
            make.height.lessThanOrEqualTo(Metrics.imageFilmCoverHeight)
        }
        
        watchButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Metrics.watchButtonHorizontalInset)
            make.bottom.equalToSuperview().inset(Metrics.watchButtonBottomInset)
        }

        content.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(imageFilmCover.snp.bottom).inset(Metrics.contentTopInset)
            make.bottom.equalToSuperview()
        }
    }
}


//- MARK: Public extensions

extension MainScreenView {
    func setCoverImageMoview(with model: CoverMovie) {
        imageFilmCover.downloaded(from: model.backgroundImage, contentMode: imageFilmCover.contentMode)
        
        coverMovie = model
    }
}
