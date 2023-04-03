//
//  CompilationScreenView.swift
//  Cinema
//
//  Created by Елена on 03.04.2023.
//

import UIKit

class CompilationScreenView: UIView {
    
    private lazy var titleCard: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.font = UIFont(name: "SFProText-Bold", size: 24)
        view.text = "Name"
        view.textAlignment = .center
        
        return view
    }()
    
    private lazy var card: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.layer.cornerRadius = 16
        
        return view
    }()
    
    private lazy var reactionImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
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
        view.setImage(UIImage(named: "Like"), for: .normal)
        
        return view
    }()
    
    private var initialCenter: CGPoint = .zero

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(titleCard)
        self.addSubview(card)
        self.addSubview(buttons)
        
        card.addSubview(reactionImage)
        
        buttons.addSubview(dislikeButton)
        buttons.addSubview(playButton)
        buttons.addSubview(likeButton)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        card.addGestureRecognizer(panGestureRecognizer)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func didPan(_ sender: UIPanGestureRecognizer) {
        let xFromCenter = card.center.x - self.center.x
        
        switch sender.state {
        case .began:
            initialCenter = card.center
        case .changed:
            let translation = sender.translation(in: self)

            card.center = CGPoint(
                x: initialCenter.x + translation.x,
                y: initialCenter.y + translation.y
            )

            let scale = min(50 / abs(xFromCenter), 1)

            card.transform  = CGAffineTransform(rotationAngle: xFromCenter / self.frame.width / 0.61).scaledBy(x: scale, y: scale)
            
            if xFromCenter > 0 {
                reactionImage.image = UIImage(named: "Like")
            } else if xFromCenter < 0 {
                reactionImage.image = UIImage(named: "Cross")
            }
        
            reactionImage.alpha = abs(xFromCenter) / self.center.x

        case .ended, .cancelled:
            if card.center.x < 75 {
                //move off to the left side
                UIView.animate(withDuration: 0.3) {
                    self.card.center = CGPoint(x: self.card.center.x - 200, y: self.card.center.y + 75)
                    self.card.alpha = 0
                }

                return

            } else if card.center.x > (self.frame.width - 75) {
                //move off to the right side
                UIView.animate(withDuration: 0.3) {
                    self.card.center = CGPoint(x: self.card.center.x + 200, y: self.card.center.y + 75)
                    self.card.alpha = 0
                }

                return
            }

            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [.curveEaseOut]) {
                self.card.center = self.initialCenter
                self.reactionImage.alpha = 0
                self.card.transform = .identity
            }
        default:
            break
        }
    }
}

private extension CompilationScreenView {
    func setup() {
        configureUI()
        configureConstraints()
    }
    
    func configureUI() {
        self.backgroundColor = .backgroundApplication
    }
    
    func configureConstraints() {
        titleCard.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(36)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        card.snp.makeConstraints { make in
            make.top.equalTo(titleCard.snp.bottom).inset(-24)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        reactionImage.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(112)
        }
        
        buttons.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(card.snp.horizontalEdges).inset(36)
            make.top.equalTo(card.snp.bottom).inset(-32)
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
    
    }
}

