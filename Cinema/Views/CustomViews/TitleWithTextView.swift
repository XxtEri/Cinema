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
        
        return view
    }()
    
    private lazy var text: UILabel = {
        let view = UILabel()
        view.attributedText = NSAttributedString(string: "", attributes: [.kern: -0.17])
        view.font = UIFont(name: "SFProText-Bold", size: 14)
        view.textColor = .white
        view.numberOfLines = .max
        
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
    }
}

private extension TitleWithTextView {
    func setup() {
        configureConstraints()
    }
    
    func configureConstraints() {
        title.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        text.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(title.snp.bottom).inset(-8)
            make.bottom.equalToSuperview()
        }
    }
}
