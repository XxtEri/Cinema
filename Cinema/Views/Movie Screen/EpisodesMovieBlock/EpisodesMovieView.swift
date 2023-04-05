//
//  EpisodesMovieView.swift
//  Cinema
//
//  Created by Елена on 01.04.2023.
//

import UIKit

class EpisodesMovieView: UIView {

    private lazy var titleFootageBlock: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.attributedText = NSAttributedString(string: "Эпизоды", attributes: [.kern: -0.17])
        view.font = UIFont(name: "SFProText-Bold", size: 24)
        
        return view
    }()

    
    private lazy var footageMovieList: UITableView = {
        var view = UITableView(frame: .zero)

        view.register(EpisodeScreenTableViewCell.self, forCellReuseIdentifier: EpisodeScreenTableViewCell.reuseIdentifier)
        view.delegate = self
        view.dataSource = self

        view.backgroundColor = UIColor(named: "BackgroundApplication")
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false

        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(titleFootageBlock)
        self.addSubview(footageMovieList)
        
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension EpisodesMovieView {
    func setup() {
        configureConstraints()
    }
    
    func configureConstraints() {
        titleFootageBlock.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        footageMovieList.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(titleFootageBlock.snp.horizontalEdges)
            make.top.equalTo(titleFootageBlock.snp.bottom).inset(-16)
            make.bottom.equalToSuperview()
        }
    }
}

extension EpisodesMovieView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EpisodeScreenTableViewCell.reuseIdentifier, for: indexPath) as? EpisodeScreenTableViewCell else {
            return UITableViewCell()
        }
        
        cell.congifure(imageName: "Footage", titleEpisode: "Нелегальная магия", descriptionEpisode: "Квентин и Джулия приглашены на тест их волшебных навыков Квентин и Джулия приглашены на тест их волшебных навыков", yearEpisode: "2015")

        return cell
    }
}
