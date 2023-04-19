//
//  CompilationScreenView.swift
//  Cinema
//
//  Created by Елена on 03.04.2023.
//

import UIKit
import SnapKit

class CompilationScreenView: UIView {
    
    private lazy var buttons: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var dislikeButton: CustomButton = {
        let view = CustomButton()
        view.backgroundColor = .white
        view.setImage(UIImage(named: "Cross"), for: .normal)
        
        return view
    }()
    
    private lazy var playButton: CustomButton = {
        let view = CustomButton()
        view.backgroundColor = .accentColorApplication
        view.setImage(UIImage(named: "Play"), for: .normal)
        
        return view
    }()
    
    private lazy var likeButton: CustomButton = {
        let view = CustomButton()
        view.backgroundColor = .white
        view.setImage(UIImage(named: "LikeButton"), for: .normal)
        
        return view
    }()
    
    private lazy var stub: UIView = {
        let view = UIView()
        view.alpha = 0
        
        return view
    }()
    
    private lazy var imageStub: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "EmptyArrayCompilation")
        
        return view
    }()
    
    private lazy var textStub: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "SFProText-Regular", size: 24)
        view.textAlignment = .center
        view.textColor = .textStub
        view.numberOfLines = .max
        view.attributedText = NSAttributedString(string: "Новые фильмы в подборке закончились", attributes: [.kern: -0.17])
        
        return view
    }()
    
    lazy var cardCompilation: CardCompilationView = {
        let view = CardCompilationView()
        
        return view
    }()
    
    var arrayCompilation = [Movie]()
    
    var likeToMovieButtonPressed: ((Movie) -> Void)?
    var dislikeToMovieButtonPressed: ((Movie) -> Void)?
    var playMovieButtonPressed: ((Movie) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(cardCompilation)
        self.addSubview(buttons)
        self.addSubview(stub)
        
        buttons.addSubview(dislikeButton)
        buttons.addSubview(playButton)
        buttons.addSubview(likeButton)
        
        stub.addSubview(imageStub)
        stub.addSubview(textStub)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateArrayCardsMovie(cards: [Movie]) {
        arrayCompilation = cards
        
        if arrayCompilation.isEmpty {
            showStub()
            return
        }
        
        cardCompilation.setInfoCard(card: cards[cards.startIndex])
    }
    
    func updateCard() {
        arrayCompilation.removeFirst()
        
        if arrayCompilation.isEmpty {
            showStub()
            return
        }
        
        cardCompilation.setInfoCard(card: arrayCompilation[arrayCompilation.startIndex])
        cardCompilation.resetCard()
    }
}

private extension CompilationScreenView {
    func setup() {
        configureUI()
        configureConstraints()
        configureActions()
    }
    
    func configureUI() {
        self.backgroundColor = .backgroundApplication
    }
    
    func configureConstraints() {
        cardCompilation.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        buttons.snp.makeConstraints { make in
            make.top.equalTo(cardCompilation.snp.bottom).inset(-32)
            make.horizontalEdges.equalTo(cardCompilation.snp.horizontalEdges).inset(36)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).inset(32)
            make.height.equalTo(56)
        }
        
        dislikeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.verticalEdges.equalToSuperview()
            make.width.equalTo(56)
        }
        
        playButton.snp.makeConstraints { make in
            make.leading.equalTo(dislikeButton.snp.trailing).inset(-44)
            make.verticalEdges.equalToSuperview()
            make.width.equalTo(56)
        }
        
        likeButton.snp.makeConstraints { make in
            make.leading.equalTo(playButton.snp.trailing).inset(-44)
            make.verticalEdges.equalToSuperview()
            make.width.equalTo(56)
        }
        
        stub.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.lessThanOrEqualTo(247)
            make.centerY.equalToSuperview()
            make.bottom.lessThanOrEqualTo(self.safeAreaLayoutGuide.snp.bottom).inset(177)
        }
        
        imageStub.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalTo(textStub.snp.horizontalEdges).inset(37)
        }
        
        textStub.snp.makeConstraints { make in
            make.top.lessThanOrEqualTo(imageStub.snp.bottom).inset(-32)
            make.horizontalEdges.bottom.equalToSuperview().inset(44)
        }
    }
    
    func showStub() {
        cardCompilation.alpha = 0
        buttons.alpha = 0
        stub.alpha = 1
    }
    
    func configureActions() {
        dislikeButton.addTarget(self, action: #selector(setDislikeToMovie), for: .touchUpInside)
        playButton.addTarget(self, action: #selector(playMovie), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(setLikeToMovie), for: .touchUpInside)
    }
    
    @objc
    func setDislikeToMovie() {
        if let movie = self.cardCompilation.currentMovie {
            dislikeToMovieButtonPressed?(movie)
            self.cardCompilation.startAnimation()
            self.updateCard()
        }
    }
    
    @objc
    func playMovie() {
        if let movie = self.cardCompilation.currentMovie {
            playMovieButtonPressed?(movie)
        }
    }
    
    @objc
    func setLikeToMovie() {
        if let movie = self.cardCompilation.currentMovie {
            likeToMovieButtonPressed?(movie)
            self.cardCompilation.startAnimation()
            self.updateCard()
        }
    }
}

