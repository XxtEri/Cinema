//
//  VideoLooperView.swift
//  Cinema
//
//  Created by Елена on 04.04.2023.
//

import UIKit

class VideoLooperView: UIView {

    let video: Video?
    let videoPlayerView = VideoPlayerView()
    
    init(video: Video?) {
        self.video = video
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
