//
//  MyMessageTableViewCell.swift
//  Cinema
//
//  Created by Елена on 15.04.2023.
//

import UIKit

class MyMessageTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "MyMessageTableViewCell"
    
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(avatar)
        self.addSubview(message)
        
        message.addSubview(textMessage)
        message.addSubview(infoMessage)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(message: MessageServer) {
        if let authorAvatar = message.authorAvatar {
            avatar.downloaded(from: authorAvatar, contentMode: avatar.contentMode)
        }
        
        textMessage.text = message.text
        infoMessage.text = message.authorName + "•" + message.creationDateTime
    }

}

private extension MyMessageTableViewCell {
    func setup() {
        configureConstraints()
        configureUI()
    }
    
    func configureUI() {
        self.backgroundColor = .backgroundApplication
    }
    
    func configureConstraints() {
        avatar.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.height.width.equalTo(32)
            make.bottom.equalTo(message.snp.bottom)
        }
        
        message.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(16)
            make.leading.equalToSuperview()
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
