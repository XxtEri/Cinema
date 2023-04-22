//
//  DateTableViewCell.swift
//  Cinema
//
//  Created by Елена on 15.04.2023.
//

import UIKit
import SnapKit

class DateTableViewCell: UITableViewCell {
    
    //- MARK: Private properties
    
    private enum Metrics {
        static let cornerRadius: CGFloat = 8
        
        static let textSize: CGFloat = 14
        static let textKern: CGFloat = -0.17
        
        static let dateVerticalInset: CGFloat = 7
        static let dateHorizontalInset: CGFloat = 16
        
        static let emptyViewForIndentHeight: CGFloat = 24
    }
    
    private lazy var viewDate: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Metrics.cornerRadius
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        return view
    }()
    
    private lazy var viewDateBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .dateInChat
        view.layer.cornerRadius = Metrics.cornerRadius
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        return view
    }()
    
    private lazy var date: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "SFProText-Regular", size: Metrics.textSize)
        view.attributedText = NSAttributedString(string: "", attributes: [.kern: Metrics.textKern])
        view.textColor = .white
        view.textAlignment = .center
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        return view
    }()
    
    private lazy var emptyViewForIndent = {
        let view = UIView()
        
        return view
    }()
    
    
    //- MARK: Public properties
    
    static let reuseIdentifier = "DateTableViewCell"
    
    
    //- MARK: Inits
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height + 24)
        
        self.addSubview(viewDate)
        
        viewDate.addSubview(viewDateBackground)
        viewDate.addSubview(emptyViewForIndent)
        
        viewDateBackground.addSubview(date)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //- MARK: Public methods
    
    func configureCell(date: String) {
        self.date.text = date
    }
}


//- MARK: Private extensions

private extension DateTableViewCell {
    
    //- MARK: Setup
    
    func setup() {
        configureConstraints()
        configureUI()
    }
    
    func configureUI() {
        self.backgroundColor = .backgroundApplication
    }
    
    func configureConstraints() {
        viewDate.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset((UIScreen.main.bounds.width - self.bounds.width) * 2)
            make.centerX.equalToSuperview()
        }
        
        viewDateBackground.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        date.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(Metrics.dateVerticalInset)
            make.horizontalEdges.equalToSuperview().inset(Metrics.dateHorizontalInset)
        }
        
        emptyViewForIndent.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(viewDateBackground.snp.bottom)
            make.bottom.equalToSuperview()
            make.height.equalTo(Metrics.emptyViewForIndentHeight)
        }
    }
}
