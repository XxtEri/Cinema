//
//  Video.swift
//  Cinema
//
//  Created by Елена on 04.04.2023.
//

import Foundation
import UIKit

struct Video {
    let url: URL

    static func localVideo() -> Video? {
        guard let urlPath = Bundle.main.path(forResource: "video", ofType: "mp4") else { return nil}
        let url = URL(fileURLWithPath: urlPath)
        
        return Video(url: url)
    }
}
