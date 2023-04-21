//
//  EpisodesMovieView.swift
//  Cinema
//
//  Created by Елена on 01.04.2023.
//

import UIKit
import SnapKit

class EpisodesMovieView: UIView {
    
    //- MARK: Private properties
    
    private enum Metrics {
        static let titleFootageBlockKern: CGFloat = -0.17
        static let titleFootageBlockTextSize: CGFloat = 24
        static let titleFootageBlockSizeHeight: CGFloat = 29
        static let titleFootageBlockHorizontalInset: CGFloat = 16
        
        static let episodesMovieTopInset: CGFloat = -16
        
        static let cellEstimatedHeight: CGFloat = 72
    }
    
    private lazy var titleFootageBlock: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.attributedText = NSAttributedString(string: "Эпизоды", attributes: [.kern: Metrics.titleFootageBlockKern])
        view.font = UIFont(name: "SFProText-Bold", size: Metrics.titleFootageBlockTextSize)
        view.frame.size.height = Metrics.titleFootageBlockSizeHeight
        
        return view
    }()
    
    
    //- MARK: Public properties
    
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
    
    
    //- MARK: Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(titleFootageBlock)
        self.addSubview(episodesMovie)
        
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //- MARK: Public methods
    
    func setArrayEpisodes(_ episodes: [Episode]) {
        self.episodes = episodes
        
        episodesMovie.reloadData()
    }
}


//- MARK: Private extensions

private extension EpisodesMovieView {
    func setup() {
        configureConstraints()
    }
    
    func configureConstraints() {
        titleFootageBlock.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Metrics.titleFootageBlockHorizontalInset)
            make.top.equalToSuperview()
        }
        
        episodesMovie.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(titleFootageBlock.snp.horizontalEdges)
            make.top.equalTo(titleFootageBlock.snp.bottom).inset(Metrics.episodesMovieTopInset)
            make.bottom.equalToSuperview()
        }
    }
}


//- MARK: UITableViewDataSource

extension EpisodesMovieView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        episodes.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        Metrics.cellEstimatedHeight
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
    
}


//- MARK: UITableViewDelegate

extension EpisodesMovieView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        episodePressed?(episodes[indexPath.row], episodes)
    }
}
