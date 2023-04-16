//
//  MyMessageTableViewCell.swift
//  Cinema
//
//  Created by Елена on 15.04.2023.
//

import UIKit
import SnapKit

class MyMessageTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "MyMessageTableViewCell"
    
    private lazy var messageView: UIView = {
        let view = UIView()
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.layer.cornerRadius = 4
        
        return view
    }()
    
    private lazy var messageBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .accentColorApplication
        view.layer.cornerRadius = 4
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner]
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        return view
    }()
    
    lazy var avatar: CircleImageView = {
        let view = CircleImageView()
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "ProfileAnonymous")
        
        return view
    }()
    
    lazy var textMessage: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "SFProText-Regular", size: 14)
        view.attributedText = NSAttributedString(string: "", attributes: [.kern: -0.17])
        view.textColor = .white
        view.numberOfLines = 0
        view.textAlignment = .left
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        return view
    }()
    
    lazy var infoMessage: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "SFProText-Regular", size: 12)
        view.attributedText = NSAttributedString(string: "", attributes: [.kern: -0.17])
        view.textColor = .informationAboutMyMessage
        view.numberOfLines = .max
        view.textAlignment = .left
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        return view
    }()
    
    private lazy var emptyViewForIndent = {
        let view = UIView()
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = .clear
        
        contentView.addSubview(messageView)
        
        messageView.addSubview(avatar)
        messageView.addSubview(messageBackgroundView)
        
        messageBackgroundView.addSubview(textMessage)
        messageBackgroundView.addSubview(infoMessage)
        
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
        if let date = getDateMessage(date: message.creationDateTime){
            infoMessage.text = message.authorName + " • \(date.hour):\(date.minute)"
            
            return
        }
        
        infoMessage.text = message.authorName
    }
    
    func addEmptyViewForIndent(indent: CGFloat) {
        messageView.addSubview(emptyViewForIndent)
        
        emptyViewForIndent.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(indent)
        }
        
        avatar.snp.remakeConstraints { make in
            make.trailing.equalToSuperview()
            make.height.width.equalTo(32)
            make.bottom.equalTo(emptyViewForIndent.snp.top)
        }

        messageBackgroundView.snp.remakeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalTo(avatar.snp.leading).inset(-8)
            make.bottom.equalTo(emptyViewForIndent.snp.top)
        }
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
        messageView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview().inset(56)
            make.trailing.equalToSuperview().inset(16)
        }
        
        avatar.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.height.width.equalTo(32)
            make.bottom.equalToSuperview()
        }

        messageBackgroundView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
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

extension MyMessageTableViewCell {
    func getDateMessage(date: String) -> DateMessage? {
        let matchedYear = matches(for: "^\\d{4}", in: date)
        guard let year = Int(matchedYear[0]) else { return nil }
        
        var matchedMonth = matches(for: "-\\d{2}-", in: date)
        matchedMonth = matches(for: "\\d{2}", in: matchedMonth[0])
        guard let month = Int(matchedMonth[0]) else { return nil }
        
        var matchedDay = matches(for: "\\d{2}T", in: date)
        matchedDay = matches(for: "\\d{2}", in: matchedDay[0])
        guard let day = Int(matchedDay[0]) else { return nil }
        
        var matchedHour = matches(for: "T\\d{2}", in: date)
        matchedHour = matches(for: "\\d{2}", in: matchedHour[0])
        let hour = matchedHour[0]
        
        var matchedMinute = matches(for: ":\\d{2}:", in: date)
        matchedMinute = matches(for: "\\d{2}", in: matchedMinute[0])
        let minute = matchedMinute[0]
        
        var matchedSecond = matches(for: ":\\d+[.]*\\d*$", in: date)
        matchedSecond = matches(for: ":\\d{2}", in: matchedSecond[0])
        matchedSecond = matches(for: "\\d{2}", in: matchedSecond[0])
        let second = matchedSecond[0]
        
        return DateMessage(day: day, month: getNameMonth(numberMonth: String(month)), year: year, hour: hour, minute: minute, second: second)
    }
    
    func matches(for regex: String, in text: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    func getNameMonth(numberMonth: String) -> String {
        let month: String
        
        switch numberMonth {
        case "01":
            month = "Января"
        case "02":
            month = "Февраля"
        case "03":
            month = "Марта"
        case "04":
            month = "Апреля"
        case "05":
            month = "Мая"
        case "06":
            month = "Июня"
        case "07":
            month = "Июля"
        case "08":
            month = "Августа"
        case "09":
            month = "Сентября"
        case "10":
            month = "Октября"
        case "11":
            month = "Сентября"
        case "12":
            month = "Февраля"
        default:
            month = "Неизвестно"
        }
        
        return month
    }
}
