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
        view.frame.size.height = 29
        
        return view
    }()
    
    
    lazy var episodesMovie: UITableView = {
        var view = UITableView(frame: .zero)
        
        view.register(EpisodeScreenTableViewCell.self, forCellReuseIdentifier: EpisodeScreenTableViewCell.reuseIdentifier)
        view.delegate = self
        view.dataSource = self
        
        view.backgroundColor = UIColor(named: "BackgroundApplication")
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.isScrollEnabled = false
        
        return view
    }()
    
    var episodes = [Episode]()
    
    var episodePressed: ((Episode, [Episode]) -> Void)?
    
    var tableViewHeight: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(titleFootageBlock)
        self.addSubview(episodesMovie)
        
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setArrayEpisodes(_ episodes: [Episode]) {
        self.episodes = episodes
        
        episodesMovie.reloadData()
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
        
        episodesMovie.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(titleFootageBlock.snp.horizontalEdges)
            make.top.equalTo(titleFootageBlock.snp.bottom).inset(-16)
            make.bottom.equalToSuperview()
        }
    }
}

extension EpisodesMovieView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        episodes.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        72
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EpisodeScreenTableViewCell.reuseIdentifier, for: indexPath) as? EpisodeScreenTableViewCell else {
            return UITableViewCell()
        }
        
        cell.congifure(with: episodes[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        episodePressed?(episodes[indexPath.row], episodes)
    }
    
}

//class MyCustomUITableView: UITableView {
//    override var intrinsicContentSize: CGSize {
//        self.layoutIfNeeded()
//        return self.contentSize
//    }
//    
//    override var contentSize: CGSize {
//        didSet{
//            self.invalidateIntrinsicContentSize()
//        }
//    }
//    
//    override func reloadData() {
//        super.reloadData()
//        self.invalidateIntrinsicContentSize()
//    }
//}
