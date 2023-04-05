//
//  MovieScreenView.swift
//  Cinema
//
//  Created by Елена on 01.04.2023.
//

import UIKit
import SnapKit

class MovieScreenView: UIView {
    
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
        view.image = UIImage(named: "FilmMovieScreen")
        view.contentMode = .scaleAspectFill

        return view
    }()

    private lazy var watchButton: UIButton = {
        let view = UIButton()
        view.layer.cornerRadius = 4
        view.backgroundColor = UIColor(named: "AccentColor")
        view.setTitle("Смотреть", for: .normal)
        view.titleLabel?.font = UIFont(name: "SFProText-Bold", size: 14)
        view.setTitleColor(.white, for: .normal)
        view.contentEdgeInsets = UIEdgeInsets(top: 13, left: 32, bottom: 13, right: 32)

        return view
    }()
    
    private lazy var content: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private lazy var ageRestriction: UILabel = {
        let view = UILabel()
        view.attributedText = NSAttributedString(string: "18+", attributes: [.kern: -0.17])
        view.font = UIFont(name: "SFProText-Bold", size: 14)
        view.textColor = .accentColorApplication
        
        return view
    }()
    
    private lazy var discussions: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Discussions")
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    private lazy var informationMovie: InformationMovieView = {
        let view = InformationMovieView()
        
        return view
    }()
    
    private lazy var descriptionMovie: TitleWithTextView = {
        let view = TitleWithTextView()
        
        view.setTitle("Описание")
        view.setText("Eliot is in his happy place, unaware that he is being possessed by the Monster. To have control over his body, Eliot must travel to the place that contains his greatest regret: turning down Quentin when he suggests he and Eliot should be together after their memories are restored of their life in past-Fillory, happily living together and raising a family.")
        
        return view
    }()
    
    private lazy var footagesMovie: FootageMovieView = {
        let view = FootageMovieView()
        
        return view
    }()
    
    private lazy var episodesMovie: EpisodesMovieView = {
        let view = EpisodesMovieView()
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(scrollView)

        scrollView.addSubview(imageFilmCover)
        imageFilmCover.addSubview(watchButton)
        scrollView.addSubview(content)
        
        content.addSubview(ageRestriction)
        content.addSubview(discussions)
        content.addSubview(informationMovie)
        content.addSubview(descriptionMovie)
        content.addSubview(footagesMovie)
        content.addSubview(episodesMovie)
        
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MovieScreenView {
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
            make.horizontalEdges.equalToSuperview().inset(120)
            make.bottom.equalToSuperview().inset(32)
        }
        
        content.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(scrollView.frameLayoutGuide)
            make.top.equalTo(imageFilmCover.snp.bottom)
            make.bottom.equalTo(scrollView.contentLayoutGuide.snp.bottom)
        }
        
        ageRestriction.snp.makeConstraints { make in
            make.top.equalTo(imageFilmCover.snp.bottom).inset(-20)
            make.trailing.equalTo(discussions.snp.leading).inset(-17.99)
            make.centerY.equalTo(discussions.snp.centerY)
        }
        
        discussions.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(19)
            make.top.equalTo(ageRestriction.snp.top)
        }
        
        informationMovie.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(ageRestriction.snp.bottom).inset(-25)
            make.height.greaterThanOrEqualTo(120)
        }
        
        descriptionMovie.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(informationMovie.snp.bottom).inset(-32)
            make.height.equalTo(155)
        }
        
        footagesMovie.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(descriptionMovie.snp.bottom).inset(-32)
            make.height.equalTo(117)
        }
        
        episodesMovie.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(footagesMovie.snp.bottom).inset(-32)
            make.bottom.equalToSuperview()
            make.height.equalTo(250)
        }
    }
}
