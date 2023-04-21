//
//  OtherMessageTableViewCell.swift
//  Cinema
//
//  Created by Елена on 15.04.2023.
//

import UIKit
import SnapKit

class OtherMessageTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "OtherMessageTableViewCell"

    private lazy var messageView: UIView = {
        let view = UIView()
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        return view
    }()
    
    private lazy var messageBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .otherMessageInChat
        view.layer.cornerRadius = 4
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
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
    
    private lazy var infoMessageStack: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 0
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.alignment = .leading
        
        return view
    }()
    
    private lazy var nameAuthor: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "SFProText-Regular", size: 12)
        view.attributedText = NSAttributedString(string: "", attributes: [.kern: -0.17])
        view.textColor = .informationAboutOtherMessage
        view.numberOfLines = 1
        view.textAlignment = .left
        
        return view
    }()
    
    private lazy var timePublish: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "SFProText-Regular", size: 12)
        view.attributedText = NSAttributedString(string: "", attributes: [.kern: -0.17])
        view.textColor = .informationAboutOtherMessage
        view.numberOfLines = 0
        view.textAlignment = .left
        
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
        messageView.addSubview(emptyViewForIndent)
        
        messageBackgroundView.addSubview(textMessage)
        messageBackgroundView.addSubview(infoMessageStack)
        
        infoMessageStack.addArrangedSubview(nameAuthor)
        infoMessageStack.addArrangedSubview(timePublish)
        
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
            timePublish.text = " • \(date.hour):\(date.minute)"
        }
        
        nameAuthor.text = message.authorName
    }
    
    func addEmptyViewForIndent(indent: CGFloat) {
        emptyViewForIndent.snp.updateConstraints { make in
            make.height.equalTo(indent)
        }
    }
}

private extension OtherMessageTableViewCell {
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
            make.trailing.equalToSuperview().inset(56)
            make.leading.equalToSuperview().inset(16)
        }
        
        avatar.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.height.width.equalTo(32)
            make.bottom.equalTo(emptyViewForIndent.snp.top)
        }

        messageBackgroundView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalTo(avatar.snp.trailing).inset(-8)
            make.bottom.equalTo(emptyViewForIndent.snp.top)
        }
        
        emptyViewForIndent.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(0)
        }

        textMessage.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(12)
        }
        
        infoMessageStack.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(textMessage.snp.horizontalEdges)
            make.top.equalTo(textMessage.snp.bottom).inset(-4)
            make.bottom.equalToSuperview().inset(4)
        }
    }
}

extension OtherMessageTableViewCell {
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
