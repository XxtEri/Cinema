//
//  TitleWithTextView.swift
//  Cinema
//
//  Created by Елена on 01.04.2023.
//

import UIKit
import SnapKit

class TitleWithTextView: UIView {

    private lazy var title: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "SFProText-Bold", size: 24)
        view.textColor = .white
        view.textAlignment = .left
        view.bounds.size.height = 29
        
        return view
    }()
    
    private lazy var text: UILabel = {
        let view = UILabel()
        view.attributedText = NSAttributedString(string: "", attributes: [.kern: -0.17])
        view.font = UIFont(name: "SFProText-Regular", size: 14)
        view.textColor = .white
        view.numberOfLines = .max
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 16 - 18, height: 0)
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(title)
        self.addSubview(text)
        
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(_ title: String) {
        self.title.text = title
    }
    
    func setText(_ text: String) {
        self.text.text = text
        
        self.text.sizeToFit()
    }
    
    func getHeightView() -> CGFloat {
        let titleHeight = title.bounds.size.height
        
        let maxSize = CGSize(width: 200, height: CGFloat.greatestFiniteMagnitude) // Задайте максимальные размеры, в пределах которых будет производиться расчет
        let labelSize = text.sizeThatFits(maxSize)
        let labelHeight = labelSize.height
        
        return titleHeight + labelHeight + 8
    }
}

private extension TitleWithTextView {
    func setup() {
        configureConstraints()
    }
    
    func configureConstraints() {
        title.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        text.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(title.snp.bottom).inset(-8)
            make.bottom.equalToSuperview()
        }
    }
}
