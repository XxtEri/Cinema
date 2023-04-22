//
//  DisscusionScreenCollectionViewCell.swift
//  Cinema
//
//  Created by Елена on 05.04.2023.
//

import UIKit
import SnapKit

class ChatListScreenCollectionViewCell: UICollectionViewCell {
    
    //- MARK: Private properties
    private enum Metrics {
        static let textSize: CGFloat = 14
        static let textKern: CGFloat = -0.17
        
        static let titleChatNumberLine = 1
        static let titleChatTextSize: CGFloat = 24
        
        static let lastMessageNumberLine = 2
    
        static let avatarChatHeightWidth: CGFloat = 64
        
        static let titleChatLeadingInset: CGFloat = -16
        static let titleChatTrailingInset: CGFloat = 16
        
        static let lastMessageTopInset: CGFloat = -4
        
        static let lineTopInsetToLastMessage: CGFloat = -11
        static let lineTopInsetToAvatarChat: CGFloat = -8
        static let lineHeight: CGFloat = 1
    }
    
    private lazy var avatarChat: CircleImageView = {
        let view = CircleImageView()
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    private lazy var titleChat: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "SFProText-Bold", size: Metrics.textSize)
        view.attributedText = NSAttributedString(string: "", attributes: [.kern: Metrics.textKern])
        view.textColor = .white
        view.numberOfLines = Metrics.titleChatNumberLine
        view.textAlignment = .left
        
        return view
    }()
    
    private lazy var lastMessage: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "SFProText-Regular", size: Metrics.textSize)
        view.attributedText = NSAttributedString(string: "", attributes: [.kern: Metrics.textKern])
        view.textColor = .white
        view.numberOfLines = Metrics.lastMessageNumberLine
        view.textAlignment = .left
        
        return view
    }()
    
    private lazy var line: UIButton = {
         let view = UIButton()
        view.backgroundColor = .lineDisscusionScreen
         
         return view
     }()
    
    
    //- MARK: Public properties
    
    static let reuseIdentifier = "ChatListCollectionViewCell"
    
    
    //- MARK: Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(avatarChat)
        self.addSubview(titleChat)
        self.addSubview(lastMessage)
        self.addSubview(line)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //- MARK: Private methods
    
    private func getLabelTitleChatInList() -> UILabel {
        let label = UILabel()
        
        label.text = getAbbrevationChat()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont(name: "SFProText-Bold", size: Metrics.titleChatTextSize)
        
        return label
    }
    
    private func getAbbrevationChat() -> String {
        var abbrevationChat = String()
        
        guard let words = titleChat.text?.split(separator: " ") else { return "" }
        
        if words.count > 1 {
            if let firstLetter = words[0].first {
                if let secondLetter = words[1].first {
                    abbrevationChat = "\(firstLetter)\(secondLetter)"
                }
            }
        }
        
        if words.count == 1 {
            if let letters = words.first?.prefix(2) {
                abbrevationChat = "\(letters)"
            }
        }
       
        return abbrevationChat.uppercased()
    }
    
    
    //- MARK: Public methods
    
    func configureCell(modelChat: Chat) {
        titleChat.text = modelChat.chatName
        let authorName = (modelChat.lastMessage?.authorName ?? String()) + ":"
        let message = modelChat.lastMessage?.text
        let authorAndMessage = authorName + " " + (message ?? String())

        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: authorAndMessage)
        attributedString.setColorForText(textForAttribute: authorName, withColor: UIColor.authorNameDisscusionScreen)
        attributedString.setColorForText(textForAttribute: message ?? String(), withColor: UIColor.white)

        lastMessage.attributedText = attributedString
        
        avatarChat.backgroundColor = .accentColorApplication
        
        let label = getLabelTitleChatInList()
        avatarChat.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
    }
}


//- MARK: Private extensions

private extension ChatListScreenCollectionViewCell {
    
    //- MARK: Setup
    
    func setup() {
        configureConstraints()
    }
    
    func configureConstraints() {
        avatarChat.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.height.width.equalTo(Metrics.avatarChatHeightWidth)
        }
        
        titleChat.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(avatarChat.snp.trailing).inset(Metrics.titleChatLeadingInset)
            make.trailing.equalToSuperview().inset(Metrics.titleChatTrailingInset)
        }
        
        lastMessage.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(titleChat.snp.horizontalEdges)
            make.top.equalTo(titleChat.snp.bottom).inset(Metrics.lastMessageTopInset)
        }
        
        line.snp.makeConstraints { make in
            make.leading.equalTo(lastMessage.snp.leading)
            make.trailing.equalToSuperview()
            make.top.equalTo(lastMessage.snp.bottom).inset(Metrics.lineTopInsetToLastMessage)
            make.top.equalTo(avatarChat.snp.bottom).inset(Metrics.lineTopInsetToAvatarChat)
            make.bottom.equalToSuperview()
            make.height.equalTo(Metrics.lineHeight)
        }
    }
}
