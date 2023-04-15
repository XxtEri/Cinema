//
//  DateTableViewCell.swift
//  Cinema
//
//  Created by Елена on 15.04.2023.
//

import UIKit

class DateTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "DateTableViewCell"
    
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(viewDate)
        viewDate.addSubview(date)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(message: MessageServer) {
        date.text = message.creationDateTime
    }
}

private extension DateTableViewCell {
    func setup() {
        configureConstraints()
        configureUI()
    }
    
    func configureUI() {
        self.backgroundColor = .backgroundApplication
    }
    
    func configureConstraints() {
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
