//
//  EpisodeScreenTableViewCell.swift
//  Cinema
//
//  Created by Елена on 05.04.2023.
//

import UIKit

class EpisodeScreenTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "EpisodeScreenTableViewCell"
    
    private lazy var posterEpisode: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    private lazy var posterViewEpisode: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        
        return view
    }()
    
    private lazy var titleEpisode: UILabel = {
        let view = UILabel()
        view.attributedText = NSAttributedString(string: "bla", attributes: [.kern: -0.17])
        view.textColor = .white
        view.font = UIFont(name: "SFProText-Bold", size: 14)
        view.textAlignment = .left
        
        return view
    }()
    
    private lazy var descriptionEpisode: UILabel = {
        let view = UILabel()
        view.numberOfLines = 2
        view.attributedText = NSAttributedString(string: "bla", attributes: [.kern: -0.17])
        view.textColor = .white
        view.font = UIFont(name: "SFProText-Regular", size: 12)
        view.textAlignment = .left
        
        return view
    }()
    
    private lazy var yearEpisode: UILabel = {
        let view = UILabel()
        view.attributedText = NSAttributedString(string: "bla", attributes: [.kern: -0.17])
        view.textColor = .white
        view.font = UIFont(name: "SFProText-Regular", size: 12)
        view.textAlignment = .left
        
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .backgroundApplication
        contentView.addSubview(posterViewEpisode)
        contentView.addSubview(titleEpisode)
        contentView.addSubview(descriptionEpisode)
        contentView.addSubview(yearEpisode)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func congifure(imageName: String, titleEpisode: String, descriptionEpisode: String, yearEpisode: String) {
        
        self.posterEpisode.image = UIImage(named: imageName)
        self.titleEpisode.text = titleEpisode
        self.descriptionEpisode.text = descriptionEpisode
        self.yearEpisode.text = yearEpisode
    }
}

private extension EpisodeScreenTableViewCell {
    func setup() {
        configureConstraints()
    }
    
    func configureConstraints() {
        posterViewEpisode.snp.makeConstraints { make in
            make.leading.verticalEdges.equalToSuperview()
            make.verticalEdges.equalToSuperview().inset(16)
            make.width.equalTo(128)
        }
        
        titleEpisode.snp.makeConstraints { make in
            make.top.equalTo(posterViewEpisode.snp.top)
            make.trailing.equalToSuperview()
            make.leading.equalTo(posterViewEpisode.snp.trailing).inset(-16)
        }
        
        descriptionEpisode.snp.makeConstraints { make in
            make.leading.equalTo(titleEpisode.snp.leading)
            make.top.equalTo(titleEpisode.snp.bottom).inset(-12)
            make.trailing.equalToSuperview()
        }
        
        yearEpisode.snp.makeConstraints { make in
            make.leading.equalTo(descriptionEpisode.snp.leading)
            make.top.equalTo(descriptionEpisode.snp.bottom).inset(-6)
            make.trailing.equalToSuperview()
            make.bottom.equalTo(posterViewEpisode.snp.bottom)
        }
    }
}
