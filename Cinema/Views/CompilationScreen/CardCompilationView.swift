//
//  CardCompilationView.swift
//  Cinema
//
//  Created by Елена on 06.04.2023.
//

import UIKit
import SnapKit

class CardCompilationView: UIView {
    
    private lazy var titleCard: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.font = UIFont(name: "SFProText-Bold", size: 24)
        view.text = "Name"
        view.numberOfLines = .max
        view.textAlignment = .center
        
        return view
    }()
    
    private lazy var card: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.layer.cornerRadius = 16
        
        return view
    }()
    
    private lazy var imageCard: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 16
        view.contentMode = .scaleToFill
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        
        return view
    }()
    
    private lazy var reactionImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    private var initialCenter: CGPoint = .zero
    
    var disappearedCard: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(titleCard)
        self.addSubview(card)
        card.addSubview(imageCard)
        imageCard.addSubview(reactionImage)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        card.addGestureRecognizer(panGestureRecognizer)
        
        setup()
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
        
            reactionImage.alpha = abs(xFromCenter) * 3 / self.center.x

        case .ended, .cancelled:
            if card.center.x < 75 {
                //move off to the left side
                UIView.animate(withDuration: 0.3) {
                    self.card.center = CGPoint(x: self.card.center.x - 200, y: self.card.center.y + 75)
                    self.card.alpha = 0
                }

                self.disappearedCard?()
                
                return

            } else if card.center.x > (self.frame.width - 75) {
                //move off to the right side
                UIView.animate(withDuration: 0.3) {
                    self.card.center = CGPoint(x: self.card.center.x + 200, y: self.card.center.y + 75)
                    self.card.alpha = 0
                }
                
                self.disappearedCard?()

                return
            }

            resetCard()
            
        default:
            break
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setInfoCard(card: Movie) {
        self.imageCard.downloaded(from: card.poster, contentMode: imageCard.contentMode)
        self.titleCard.text = card.name
    }
    
    func resetCard() {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [.curveEaseOut]) {
            self.card.center = self.initialCenter
            self.reactionImage.alpha = 0
            self.card.transform = .identity
            self.card.alpha = 1
        }
    }
    
}

extension CardCompilationView {
    func setup() {
        configureConstraints()
    }
    
    func configureConstraints() {
        titleCard.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        card.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(titleCard.snp.bottom).inset(-24)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        imageCard.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        reactionImage.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(112)
        }
    }
}
