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
        
        var movie = Movie(movieId: "1", name: "BlaBlaBla Bla Bla", description: "Eliot is in his happy place, unaware that he is being possessed by the Monster. To have control over his body, Eliot must travel to the place that contains his greatest regret: turning down Quentin when he suggests he and Eliot should be together after their memories are restored of their life in past-Fillory, happily living together and raising a family. Iris tasks Julia to trap the Monster and will kill her if she fails. Alice sends Plover to the Poison Room and reunites with Quentin. At the park, Eliot takes over his body and tells Quentin that he is alive. The Monster takes control back. Iris appears and kills Shoshana. Before she can kill Julia for failing, the Monster kills her. Alice diverts the plan to save Quentin. Meanwhile, Fillory is having new problems. Penny-23 is kidnapped.", age: .sixteen, chatInfo: Chat(chatId: "1", chatName: "Name Chat"), imageUrls: [], poster: "https://ucarecdn.com/99f90019-fd02-47a8-bd6b-694fecd19710/", tags: [])
        
        var episode = Episode(episodeId: "1", name: "Escape From The Happy Place", description: "Eliot is in his happy place, unaware that he is being possessed by the Monster. To have control over his body, Eliot must travel to the place that contains his greatest regret: turning down Quentin when he suggests he and Eliot should be together after their memories are restored of their life in past-Fillory, happily living together and raising a family. Iris tasks Julia to trap the Monster and will kill her if she fails. Alice sends Plover to the Poison Room and reunites with Quentin. At the park, Eliot takes over his body and tells Quentin that he is alive. The Monster takes control back. Iris appears and kills Shoshana. Before she can kill Julia for failing, the Monster kills her. Alice diverts the plan to save Quentin. Meanwhile, Fillory is having new problems. Penny-23 is kidnapped.", director: "Bla bla", stars: [], year: 2018, images: [], runtime: 1234, preview: "", filePath: "https://drive.google.com/uc?export=view&id=1VHZO8ggicv1yBOrPLW-OB-Jw2_K_wAQb")

        self.ui.configureUIData(movie: movie, episode: episode)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.ui.videoPlayerView.player?.play()
    }

    override func viewDidLayoutSubviews() {
        self.ui.videoPlayerView.playerLayer?.frame = self.ui.videoPlayerView.videoView.bounds
    }
}
