//
//  DisscusionScreenCollectionViewCell.swift
//  Cinema
//
//  Created by Елена on 05.04.2023.
//

import UIKit
import SnapKit

class DisscusionScreenCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "DisscusionScreenCollectionViewCell"
    
    private lazy var avatarChat: CircleImageView = {
        let view = CircleImageView()
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    private lazy var titleChat: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "SFProText-Bold", size: 14)
        view.attributedText = NSAttributedString(string: "", attributes: [.kern: -0.17])
        view.textColor = .white
        view.numberOfLines = 1
        view.textAlignment = .left
        
        return view
    }()
    
    
    private lazy var lastMessage: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "SFProText-Bold", size: 14)
        view.attributedText = NSAttributedString(string: "", attributes: [.kern: -0.17])
        view.textColor = .white
        view.numberOfLines = 2
        view.textAlignment = .left
        
        return view
    }()
    
    private lazy var line: UIButton = {
         let view = UIButton()
        view.backgroundColor = .lineDisscusionScreen
         
         return view
     }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(avatarChat)
        self.addSubview(titleChat)
        self.addSubview(lastMessage)
        self.addSubview(line)
        
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(modelChat: Chat, modelLastMessage: Message) {
        titleChat.text = modelChat.chatName
        let authorName = modelLastMessage.authorName + ":"
        let message = modelLastMessage.text
        let authorAndMessage = authorName + " " + message

        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: authorAndMessage)
        attributedString.setColorForText(textForAttribute: authorName, withColor: UIColor.authorNameDisscusionScreen)
        attributedString.setColorForText(textForAttribute: message, withColor: UIColor.white)

        lastMessage.attributedText = attributedString
        
        avatarChat.backgroundColor = .accentColorApplication
        
        let label = UILabel()
        label.text = "ИП"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont(name: "SFProText-Bold", size: 24)
        
        avatarChat.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
    }
    
    private func configureConstraints() {
        avatarChat.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.height.width.equalTo(64)
        }
        
        titleChat.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
            make.leading.equalTo(avatarChat.snp.trailing).inset(-16)
        }
        
        lastMessage.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(titleChat.snp.horizontalEdges)
            make.top.equalTo(titleChat.snp.bottom).inset(-4)
        }
        
        line.snp.makeConstraints { make in
            make.leading.equalTo(lastMessage.snp.leading)
            make.trailing.equalToSuperview()
            make.top.equalTo(lastMessage.snp.bottom).inset(-11)
            make.top.equalTo(avatarChat.snp.bottom).inset(-8)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}

extension NSMutableAttributedString {

    func setColorForText(textForAttribute: String, withColor color: UIColor) {
        let range: NSRange = self.mutableString.range(of: textForAttribute, options: .caseInsensitive)

        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }

}
