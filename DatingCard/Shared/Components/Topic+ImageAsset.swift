//
//  Topic+ImageAsset.swift
//  DatingCard
//
//  Created by Made Vidyatma Adhi Krisna on 12/08/26.
//

import SwiftUI

enum TopicImageContext {
    case questionCard
    case wouldYouRather
}

extension Topics {
    static func name(for topicID: Int) -> String {
        all.first { $0.id == topicID }?.name ?? "Topic \(topicID)"
    }

    // Contoh: id 1 (About Me) -> "About Me" (questionCard) / "About Me_topic" (wouldYouRather)
    static func imageAssetName(for topicID: Int, context: TopicImageContext) -> String {
        let baseName = name(for: topicID)
        switch context {
        case .questionCard:
            return baseName
        case .wouldYouRather:
            return baseName + "_topic"
        }
    }
}

extension Image {
    // Inisialisasi Image dari asset topic, otomatis pilih folder QuestionCard atau WouldYouRather.
    init(topicID: Int, context: TopicImageContext) {
        self.init(Topics.imageAssetName(for: topicID, context: context))
    }
}
