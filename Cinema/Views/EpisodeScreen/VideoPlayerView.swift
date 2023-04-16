//
//  VideoPlayerView.swift
//  Cinema
//
//  Created by Елена on 11.04.2023.
//

import UIKit
import SnapKit
import AVFoundation
import AVKit

class VideoPlayerView: UIView {

    lazy var videoView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private lazy var pauseVideoImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "PlayVideo")
        view.contentMode = .scaleAspectFit
        view.layer.opacity = 0
        
        return view
    }()
    
    private lazy var videoManagement: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private lazy var currentDuration: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "SFProText-Regular", size: 10)
        view.textAlignment = .center
        view.textColor = .white
        view.numberOfLines = 1
        view.attributedText = NSAttributedString(string: "00:00", attributes: [.kern: -0.17])
        
        return view
    }()
    
    private lazy var endDuration: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "SFProText-Regular", size: 10)
        view.textAlignment = .center
        view.textColor = .white
        view.numberOfLines = 1
        view.attributedText = NSAttributedString(string: "00:00", attributes: [.kern: -0.17])
        
        return view
    }()
    
    private lazy var playbackSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.isContinuous = false
        slider.minimumTrackTintColor = .accentColorApplication
        slider.maximumTrackTintColor = .inactiveSlider
        slider.setThumbImage(UIImage(named: "CircleSlider"), for: .normal)
        
        return slider
    }()
    
    private lazy var soundVideoImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "ActiveSoundVideo")
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    private lazy var barBackButton: UIButton = {
        let view = UIButton()
        view.setBackgroundImage(UIImage(named: "ArrowNavigation"), for: .normal)
        
        return view
    }()
    
    private var url: URL?
    
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    
    var isVideoPlaying = true
    
    var buttonBackGoToLastScreenPressed: ((EpisodeTime) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(videoView)
        self.addSubview(pauseVideoImage)
        self.addSubview(videoManagement)
        
        self.addSubview(barBackButton)
        self.addSubview(currentDuration)
        self.addSubview(endDuration)
        self.addSubview(playbackSlider)
        self.addSubview(soundVideoImage)
        
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
    
    private func changeTimeEpisode(seconds: Int64) {
        let targetTime: CMTime = CMTimeMake(value: seconds, timescale: 1)
        
        player?.seek(to: targetTime)
        
        if player?.rate == 0
        {
            if !isVideoPlaying {
                player?.pause()
                
            } else {
                player?.play()
            }
        }
    }
    
    func configurePlayer() {
        guard let urlEpisode = url else { return }
        
        let playerItem: AVPlayerItem = AVPlayerItem(url: urlEpisode)
        player = AVPlayer(playerItem: playerItem)

        let duration: CMTime = playerItem.asset.duration
        let seconds: Int = Int((CMTimeGetSeconds(duration)))
        
        playbackSlider.maximumValue = Float(seconds)
        setEndDuration(allSecondsVideo: seconds)
        
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resize

        if playerLayer != nil {
            videoView.layer.addSublayer(playerLayer!)
        }
        
        player?.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { (CMTime) -> Void in
            if self.player?.currentItem?.status == .readyToPlay {
                let time : Int = Int(CMTimeGetSeconds(self.player!.currentTime()));
                self.playbackSlider.value = Float (time);

                self.setCurrentDuration(allSecondsVideo: time)
            }
        }
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
    
    func configureURLVideo(urlEpisode: String) {
        if let url = URL(string: urlEpisode) {
            self.url = url
            
            configurePlayer()
        }
    }
    
    func setValueSecond(time: EpisodeTime) {
        changeTimeEpisode(seconds: Int64(time.timeInSeconds))
    }
    
    func getCurrentTimeVideo() -> Int {
        let seconds : Int = Int(playbackSlider.value)
        
        return seconds
    }
}

private extension VideoPlayerView {
    func setup() {
        configureConstraints()
        configureActions()
    }
    
    func configureConstraints() {
        videoView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.verticalEdges.equalToSuperview()
            make.height.greaterThanOrEqualTo(210)
        }
        
        barBackButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(8.5)
            make.top.equalToSuperview().inset(11.5)
            
        }
        
        pauseVideoImage.snp.makeConstraints { make in
            make.centerX.equalTo(videoView.snp.centerX)
            make.centerY.equalTo(videoView.snp.centerY)
        }
        
        videoManagement.snp.makeConstraints { make in
            make.bottom.equalTo(playbackSlider.snp.top)
            make.horizontalEdges.top.equalToSuperview()
        }
        
        currentDuration.snp.makeConstraints { make in
            make.bottom.equalTo(videoView.snp.bottom).inset(8)
            make.leading.equalTo(videoView.snp.leading).inset(8)
        }
        
        endDuration.snp.makeConstraints { make in
            make.centerY.equalTo(currentDuration.snp.centerY)
            make.bottom.equalTo(videoView.snp.bottom).inset(8)
        }
        
        playbackSlider.snp.makeConstraints { make in
            make.centerY.equalTo(currentDuration.snp.centerY)
            make.leading.equalTo(currentDuration.snp.trailing).inset(-8)
            make.trailing.equalTo(endDuration.snp.leading).inset(-8)
            make.height.equalTo(20)
        }
        
        soundVideoImage.snp.makeConstraints { make in
            make.centerY.equalTo(endDuration.snp.centerY)
            make.leading.equalTo(endDuration.snp.trailing).inset(-10.67)
            make.trailing.equalTo(videoView.snp.trailing).inset(8)
        }
    }
    
    func configureActions() {
        videoManagement.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPauseVideo(_:))))
        playbackSlider.addTarget(self, action: #selector(self.playbackSliderValueChanged(_:)), for: .valueChanged)
        soundVideoImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(configureSound(sender:))))
        barBackButton.addTarget(self, action: #selector(backGoToLastScreen), for: .touchUpInside)
    }
    
    @objc
    func onPauseVideo(_ sender: AnyObject) {
        if isVideoPlaying {
            player?.pause()
            self.pauseVideoImage.layer.opacity = 1
            
            isVideoPlaying = false
            
        } else {
            player?.play()
            self.pauseVideoImage.layer.opacity = 0
            
            isVideoPlaying = true
        }
    }
    
    @objc
    func playbackSliderValueChanged(_ playbackSlider: UISlider) {
        let seconds : Int64 = Int64(playbackSlider.value)
        changeTimeEpisode(seconds: seconds)
    }
    
    @objc
    func configureSound(sender: AnyObject) {
        if let turnOnSound = player?.isMuted {
            player?.isMuted = turnOnSound ? false : true
            
            soundVideoImage.image = UIImage(named: turnOnSound ? "ActiveSoundVideo" : "InactiveSoundVideo")
        }
    }
    
    @objc
    func backGoToLastScreen() {
        var time = getCurrentTimeVideo()
        if time == Int(playbackSlider.maximumValue) {
            time = 0
        }
        
        buttonBackGoToLastScreenPressed?(EpisodeTime(timeInSeconds: time))
    }
}
