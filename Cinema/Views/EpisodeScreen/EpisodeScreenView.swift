//
//  EpisodeScreenView.swift
//  Cinema
//
//  Created by Елена on 04.04.2023.
//

import UIKit
import SnapKit
import AVFoundation
import AVKit

class EpisodeScreenView: UIView {
    
    let videoView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    let controlVideoView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    let pauseVideo: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "PlayVideo")
        view.contentMode = .scaleAspectFit
        view.layer.opacity = 0
        
        return view
    }()
    
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    
    var isVideoPlaying = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(videoView)
        
        configureVideo()
        configureConstraints()
        configureActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureVideo() {
        let url = URL(string:"https://firebasestorage.googleapis.com/v0/b/gameofchats-762ca.appspot.com/o/message_movies%2F12323439-9729-4941-BA07-2BAE970967C7.mov?alt=media&token=3e37a093-3bc8-410f-84d3-38332af9c726")!
        
        player = AVPlayer(url: url)
        
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resize
        
        videoView.layer.addSublayer(playerLayer)
        videoView.addSubview(pauseVideo)
    }
    
    func configureConstraints() {
        videoView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(250)
        }
        
        pauseVideo.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    func configureActions() {
//        self.pauseVideo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPauseVideo(_:))))
//        self.videoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPauseVideo(_:))))

    }
    
    @objc
    func onPauseVideo(_ sender: AnyObject) {
        if isVideoPlaying {
            player.pause()
            self.pauseVideo.layer.opacity = 1
        } else {
            player.play()
            self.pauseVideo.layer.opacity = 0
        }
    }
    
//    func startVideo() {
//        let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/gameofchats-762ca.appspot.com/o/message_movies%2F12323439-9729-4941-BA07-2BAE970967C7.mov?alt=media&token=3e37a093-3bc8-410f-84d3-38332af9c726")
//
//        player = AVPlayer(url: url!)
//
//        avpController.player = player
//        avpController.view.frame.size.height = videoView.frame.size.height
//        avpController.view.frame.size.width = videoView.frame.size.width
//
//        self.videoView.addSubview(avpController.view)
//
//        player.play()
//    }
}
