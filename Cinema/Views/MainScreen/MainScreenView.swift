//
//  MainScreenView.swift
//  Cinema
//
//  Created by Елена on 03.04.2023.
//

import UIKit

class MainScreenView: UIView {
    
    //- MARK: Private properties
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.alwaysBounceVertical = true
        view.frame = self.bounds
        view.contentInsetAdjustmentBehavior = .never

        return view
    }()
    
    private lazy var imageFilmCover: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "FilmCover")
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    private lazy var watchButton: UIButton = {
        let view = UIButton()
        view.layer.cornerRadius = 4
        view.backgroundColor = .accentColorApplication
        view.setTitle("Смотреть", for: .normal)
        view.titleLabel?.font = UIFont(name: "SFProText-Bold", size: 14)
        view.setTitleColor(.white, for: .normal)
        view.contentEdgeInsets = UIEdgeInsets(top: 13, left: 32, bottom: 13, right: 32)
        
        return view
    }()
    
    private lazy var titleTrendsBlock: UILabel = {
        let view = UILabel()
        view.text = "В тренде"
        view.font = UIFont(name: "SFProText-Bold", size: 24)
        view.textColor = .accentColorApplication
        view.textAlignment = .left
        
        return view
    }()
    
    private lazy var listTrendFilms: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = CGFLOAT_MAX
        
        var view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        view.register(TrendMovieCollectionViewCell.self, forCellWithReuseIdentifier: TrendMovieCollectionViewCell.reuseIdentifier)
        
        view.backgroundColor = .blue
        view.contentInsetAdjustmentBehavior = .never
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var views: UIView = {
        let view = UIView()
        
        return view
    }()
    
    let trendBlock = TrendMoviesBlockView()
    let watchBlock = LastWatchMovieBlockView()
    let newBlock = NewMoviesBlockView()
    let recomendationBlock = RecomendationMoviesBlockView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(scrollView)

        scrollView.addSubview(imageFilmCover)
        scrollView.addSubview(watchButton)
        
        scrollView.addSubview(views)
        
        views.addSubview(trendBlock)
        views.addSubview(watchBlock)
        views.addSubview(newBlock)
        views.addSubview(recomendationBlock)
        
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension MainScreenView {
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

        imageFilmCover.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(scrollView.frameLayoutGuide)
            make.top.equalToSuperview()
        }
        
        watchButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(imageFilmCover.snp.horizontalEdges).inset(120)
            make.bottom.equalTo(imageFilmCover.snp.bottom).inset(64)
        }
        
        views.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(scrollView.frameLayoutGuide)
            make.top.equalTo(imageFilmCover.snp.bottom).inset(-32)
            make.bottom.equalTo(scrollView.contentLayoutGuide.snp.bottom).inset(10)
        }
        
        trendBlock.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview()
            make.top.equalTo(imageFilmCover.snp.bottom).inset(-32)
            make.height.greaterThanOrEqualTo(145)
        }

        watchBlock.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(trendBlock.snp.bottom).inset(-32)
            make.height.greaterThanOrEqualTo(240)
        }

        newBlock.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview()
            make.top.equalTo(watchBlock.snp.bottom).inset(-32)
            make.height.greaterThanOrEqualTo(189)
        }
        
        recomendationBlock.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview()
            make.top.equalTo(newBlock.snp.bottom).inset(-32)
            make.bottom.equalToSuperview().inset(44)
            make.height.greaterThanOrEqualTo(145)
        }
    }
}
