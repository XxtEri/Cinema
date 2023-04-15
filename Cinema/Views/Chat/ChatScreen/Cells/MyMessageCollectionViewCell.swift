//
//  MyMessageCollectionViewCell.swift
//  Cinema
//
//  Created by Елена on 09.04.2023.
//

import UIKit

class MyMessageCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "MyMessageCollectionViewCell"
    
    private lazy var avatar: CircleImageView = {
        let view = CircleImageView()
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "ProfileAnonymous")
        
        return view
    }()
    
    private lazy var message: UIView = {
        let view = UIView()
        view.backgroundColor = .accentColorApplication
        view.roundCorners([.topLeft, .topRight, .bottomLeft], radius: 4)
        
        return view
    }()
    
    lazy var textMessage: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "SFProText-Bold", size: 14)
        view.attributedText = NSAttributedString(string: "", attributes: [.kern: -0.17])
        view.textColor = .white
        view.numberOfLines = .max
        view.textAlignment = .left
        
        return view
    }()
    
    lazy var infoMessage: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "SFProText-Bold", size: 14)
        view.attributedText = NSAttributedString(string: "", attributes: [.kern: -0.17])
        view.textColor = .white
        view.numberOfLines = .max
        view.textAlignment = .left
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        self.addSubview(avatar)
        self.addSubview(message)
        
        message.addSubview(textMessage)
        message.addSubview(infoMessage)
        
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(modelChat: Chat, modelLastMessage: MessageServer) {

    }
    
    private func configureConstraints() {
        avatar.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview()
            make.height.width.equalTo(32)
        }
        
        message.snp.makeConstraints { make in
            make.verticalEdges.leading.equalToSuperview()
            make.trailing.equalTo(avatar.snp.leading).inset(-8)
        }
        
        textMessage.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(12)
        }
        
        infoMessage.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(textMessage.snp.horizontalEdges)
            make.top.equalTo(textMessage.snp.bottom).inset(-4)
            make.bottom.equalToSuperview().inset(4)
        }
    }
}
