//
//  DateCollectionViewCell.swift
//  Cinema
//
//  Created by Елена on 09.04.2023.
//

import UIKit

class DateCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "DateCollectionViewCell"
    
    private lazy var viewDate: UIView = {
        let view = UIView()
        view.backgroundColor = .dateInChat
        view.layer.cornerRadius = 8
        
        return view
    }()
    
    private lazy var date: UILabel = {
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
                
        self.addSubview(viewDate)
        viewDate.addSubview(date)
        
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(modelChat: Chat, modelLastMessage: MessageServer) {
//        titleChat.text = modelChat.chatName
//        let authorName = modelLastMessage.authorName + ":"
//        let message = modelLastMessage.text
//        let authorAndMessage = authorName + " " + message
//
//        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: authorAndMessage)
//        attributedString.setColorForText(textForAttribute: authorName, withColor: UIColor.authorNameDisscusionScreen)
//        attributedString.setColorForText(textForAttribute: message, withColor: UIColor.white)
//
//        lastMessage.attributedText = attributedString
//
//        avatarChat.backgroundColor = .accentColorApplication
//
//        let label = UILabel()
//        label.text = "ИП"
//        label.textAlignment = .center
//        label.textColor = .white
//        label.font = UIFont(name: "SFProText-Bold", size: 24)
//
//        avatarChat.addSubview(label)
//
//        label.snp.makeConstraints { make in
//            make.centerY.centerX.equalToSuperview()
//        }
    }
    
    private func configureConstraints() {
        viewDate.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.verticalEdges.equalToSuperview()
        }
        
        date.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.verticalEdges.equalToSuperview().inset(7)
        }
    }
}
