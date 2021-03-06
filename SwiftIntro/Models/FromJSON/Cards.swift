//
//  Cards.swift
//  SwiftIntro
//
//  Created by Alexander Georgii-Hemming Cyon on 01/06/16.
//  Copyright © 2016 SwiftIntro. All rights reserved.
//

import Foundation

struct Cards {
    var singles: [Card]
    var memoryCards: [Card]

    init(_ singles: [Card], cardCount: Int) {
        self.singles = singles
        self.memoryCards = memoryCardsFromSingles(singles, cardCount: cardCount)
    }

    init(_ singles: [Card], config: GameConfiguration) {
        self.init(singles, cardCount: config.level.cardCount)
    }
}

extension Cards {
    var count: Int {
        return memoryCards.count
    }

    func unflip() {
        for card in memoryCards {
            card.flipped = false
        }
    }

    func unmatch() {
        for card in memoryCards {
            card.matched = false
        }
    }

    func unflipped() -> Cards {
        unflip()
        return self
    }

    subscript(index: Int) -> Card {
        return memoryCards[index]
    }
}

extension Cards: Model {
    init?(response: NSHTTPURLResponse, representation: AnyObject) {
        guard let jsonForCards = representation.valueForKeyPath("items") as? [JSON] else { return nil }
        let cards = Card.collection(response: response, representation: jsonForCards)
        self.singles = cards
        memoryCards = []
    }

    static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [Cards] {
        fatalError("Not needed")
    }
}

private func memoryCardsFromSingles(singles: [Card], cardCount: Int) -> [Card] {
    let cardCount = min(singles.count, cardCount)
    var cards = singles
    cards.shuffle()
    cards = cards.choose(cardCount/2)
    var duplicated = duplicatedMemoryCards(cards)
    duplicated.shuffle()
    return duplicated
}

private func duplicatedMemoryCards(cards: [Card]) -> [Card] {
    var duplicated: [Card] = []
    for memoryCard in cards {
        let duplicate = Card(imageUrl: memoryCard.imageUrl)
        duplicated.append(duplicate)
        duplicated.append(memoryCard)
    }
    return duplicated
}

