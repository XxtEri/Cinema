//
//  EpisodeScreenViewController.swift
//  Cinema
//
//  Created by Елена on 04.04.2023.
//

import UIKit

class EpisodeScreenViewController: UIViewController {
    
    private let ui: EpisodeScreenView
    
    init() {
        self.ui = EpisodeScreenView()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = ui
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.ui.player.play()
    }
    
    override func viewDidLayoutSubviews() {
        self.ui.playerLayer.frame = self.ui.videoView.bounds
    }
}
