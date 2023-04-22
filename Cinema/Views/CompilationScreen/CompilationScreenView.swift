//
//  CompilationScreenView.swift
//  Cinema
//
//  Created by Елена on 03.04.2023.
//

import UIKit
import SnapKit

class CompilationScreenView: UIView {
    
    //- MARK: Private properties
    
    private enum Metrics {
        static let stubAlpha: CGFloat = 0
        
        static let textSize: CGFloat = 24
        static let textKern: CGFloat = -0.17
        
        static let cardCompilationHorizontalInset: CGFloat = 24
        
        static let buttonsTopInset: CGFloat = -32
        static let buttonsHorizontalInset: CGFloat = 36
        static let buttonsBottomInset: CGFloat = 32
        static let buttonsHeight: CGFloat = 56
        
        static let dislikeButtonWidth: CGFloat = 56
        
        static let playButtonLeadingInset: CGFloat = -44
        static let playButtonWidth: CGFloat = 56
        
        static let likeButtonLeadingInset: CGFloat = -44
        static let likeButtonWidth: CGFloat = 56
        
        static let stubTopInset: CGFloat = 247
        static let stubBottomInset: CGFloat = 177
        
        static let imageStubHorizontalInset: CGFloat = 81
        
        static let textStubTopInset: CGFloat = -32
        static let textStubHorizontalInset: CGFloat = 44
        static let textStubBottomInset: CGFloat = 20
    }
    
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
        view.alpha = Metrics.stubAlpha
        
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
        view.font = UIFont(name: "SFProText-Regular", size: Metrics.textSize)
        view.textAlignment = .center
        view.textColor = .textStub
        view.numberOfLines = .max
        view.attributedText = NSAttributedString(string: "Новые фильмы в подборке закончились", attributes: [.kern: Metrics.textKern])
        
        return view
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        
        indicator.color = .accentColorApplication
        indicator.hidesWhenStopped = true
        
        return indicator
    }()
    
    
    //- MARK: Public properties
    
    lazy var cardCompilation: CardCompilationView = {
        let view = CardCompilationView()
        
        return view
    }()
    
    var arrayCompilation = [Movie]()
    
    var likeToMovieButtonPressed: ((Movie) -> Void)?
    var dislikeToMovieButtonPressed: ((Movie) -> Void)?
    var playMovieButtonPressed: ((Movie) -> Void)?
    
    
    //- MARK: Inits

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(cardCompilation)
        self.addSubview(buttons)
        self.addSubview(stub)
        self.addSubview(activityIndicator)
        
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
    
    
    //- MARK: Public methods
    
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
    
    func startAnumateIndicator() {
        activityIndicator.startAnimating()
        activityIndicator.alpha = 1
    }
    
    func stopAnimateIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.alpha = 0
    }
}


//- MARK: Private extensions

private extension CompilationScreenView {
    
    //- MARK: Setup
    
    func setup() {
        configureUI()
        configureConstraints()
        configureActions()
    }
    
    func configureUI() {
        self.backgroundColor = .backgroundApplication
    }
    
    func configureConstraints() {
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        cardCompilation.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.equalToSuperview().inset(Metrics.cardCompilationHorizontalInset)
        }
        
        buttons.snp.makeConstraints { make in
            make.top.equalTo(cardCompilation.snp.bottom).inset(Metrics.buttonsTopInset)
            make.horizontalEdges.equalTo(cardCompilation.snp.horizontalEdges).inset(Metrics.buttonsHorizontalInset)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).inset(Metrics.buttonsBottomInset)
            make.height.equalTo(Metrics.buttonsHeight)
        }
        
        dislikeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.verticalEdges.equalToSuperview()
            make.width.equalTo(Metrics.dislikeButtonWidth)
        }
        
        playButton.snp.makeConstraints { make in
            make.leading.equalTo(dislikeButton.snp.trailing).inset(Metrics.playButtonLeadingInset)
            make.verticalEdges.equalToSuperview()
            make.width.equalTo(Metrics.playButtonWidth)
        }
        
        likeButton.snp.makeConstraints { make in
            make.leading.equalTo(playButton.snp.trailing).inset(Metrics.likeButtonLeadingInset)
            make.verticalEdges.equalToSuperview()
            make.width.equalTo(Metrics.likeButtonWidth)
        }
        
        stub.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.lessThanOrEqualTo(Metrics.stubTopInset)
            make.centerY.equalToSuperview()
            make.bottom.lessThanOrEqualTo(self.safeAreaLayoutGuide.snp.bottom).inset(Metrics.stubBottomInset)
        }
        
        imageStub.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(Metrics.imageStubHorizontalInset)
        }
        
        textStub.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(imageStub.snp.bottom).inset(Metrics.textStubTopInset)
            make.horizontalEdges.equalToSuperview().inset(Metrics.textStubHorizontalInset)
            make.bottom.greaterThanOrEqualToSuperview().inset(Metrics.textStubBottomInset)
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
    
    
    //- MARK: Actions
    
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

