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
    
    let currentDuration: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "SFProText-Regular", size: 10)
        view.textAlignment = .center
        view.textColor = .white
        view.numberOfLines = 1
        view.attributedText = NSAttributedString(string: "00:00", attributes: [.kern: -0.17])
        
        return view
    }()
    
    let endDuration: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "SFProText-Regular", size: 10)
        view.textAlignment = .center
        view.textColor = .white
        view.numberOfLines = 1
        view.attributedText = NSAttributedString(string: "00:00", attributes: [.kern: -0.17])
        
        return view
    }()
    
    let url = URL(string:"https://drive.google.com/uc?export=view&id=1-EUBpRnIyJNwXLC3sAxVOtkrL0JdnZ5A")!
    
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var playbackSlider: UISlider?
    
    var isVideoPlaying = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(videoView)
        
        let playerItem: AVPlayerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        
        print(playerItem)

        playbackSlider = UISlider(frame:CGRect(x: 0, y: 300, width: UIScreen.main.bounds.width, height: 20))
        playbackSlider?.minimumValue = 0

        let duration: CMTime = playerItem.asset.duration
        let seconds: Int = Int((CMTimeGetSeconds(duration)))
        
        setEndDuration(allSecondsVideo: seconds)
        
        playbackSlider?.maximumValue = Float(seconds)
        playbackSlider?.isContinuous = false
        playbackSlider?.tintColor = UIColor.green
        
        if let slider = playbackSlider {
            self.addSubview(slider)
        }
        
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resize

        if playerLayer != nil {
            videoView.layer.addSublayer(playerLayer!)
        }
        
//        videoView.addSubview(pauseVideo)
        
        player?.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { (CMTime) -> Void in
            if self.player?.currentItem?.status == .readyToPlay {
                let time : Int = Int(CMTimeGetSeconds(self.player!.currentTime()));
                self.playbackSlider?.value = Float (time);

                self.setCurrentDuration(allSecondsVideo: time)
            }
        }
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setCurrentDuration(allSecondsVideo: Int) {
        currentDuration.text = "\(getMinutesVideo(allSecondsVideo: allSecondsVideo)):\(getSecondsVideo(allSecondsVideo: allSecondsVideo))"
    }
    
    private func setEndDuration(allSecondsVideo: Int) {
        endDuration.text = "\(getMinutesVideo(allSecondsVideo: allSecondsVideo)):\(getSecondsVideo(allSecondsVideo: allSecondsVideo))"
    }
    
    func getMinutesVideo(allSecondsVideo: Int) -> String {
        if allSecondsVideo / 60 < 10 {
            return "0\(allSecondsVideo / 60)"
        }
        
        return "\(allSecondsVideo / 60)"
    }
    
    func getSecondsVideo(allSecondsVideo: Int) -> String {
        if allSecondsVideo % 60 < 10 {
            return "0\(allSecondsVideo % 60)"
        }
        
        return "\(allSecondsVideo % 60)"
    }
}

extension EpisodeScreenView {
    func setup() {
        configureConstraints()
        configureActions()
    }
    
    func configureConstraints() {
        videoView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(250)
        }
        
//        pauseVideo.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.centerY.equalToSuperview()
//        }
    }
    
    func configureActions() {
//        self.pauseVideo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPauseVideo(_:))))
//        self.videoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPauseVideo(_:))))
        playbackSlider?.addTarget(self, action: #selector(self.playbackSliderValueChanged(_:)), for: .valueChanged)
    }
    
    @objc
    func onPauseVideo(_ sender: AnyObject) {
        if isVideoPlaying {
            player?.pause()
            self.pauseVideo.layer.opacity = 1
        } else {
            player?.play()
            self.pauseVideo.layer.opacity = 0
        }
    }
    
    @objc
    func playbackSliderValueChanged(_ playbackSlider:UISlider)
    {
        
        let seconds : Int64 = Int64(playbackSlider.value)
        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
        
        player?.seek(to: targetTime)
        
        if player?.rate == 0
        {
            player?.play()
        }
    }
}
