//
//  CardCVCell.swift
//  SwiftIntro
//
//  Created by Alexander Georgii-Hemming Cyon on 01/06/16.
//  Copyright © 2016 SwiftIntro. All rights reserved.
//

import UIKit
import AlamofireImage

class CardCVCell: UICollectionViewCell {
    @IBOutlet weak var cardFrontImageView: UIImageView!
    @IBOutlet weak var cardBackImageView: UIImageView!

    private var flipped: Bool = false {
        didSet {
            cardFrontImageView.visible = flipped
            cardBackImageView.hidden = flipped
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        cardBackImageView.backgroundColor = UIColor.brownColor()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        cardFrontImageView.image = nil
        flipped = false
    }

    func flipCard(cardModel: Card) {
        let flipped = cardModel.flipped
        let fromView = flipped ? cardFrontImageView : cardBackImageView
        let toView = flipped ? cardBackImageView : cardFrontImageView
        let flipDirection: UIViewAnimationOptions = flipped ? .TransitionFlipFromRight : .TransitionFlipFromLeft
        let options: UIViewAnimationOptions = [flipDirection, .ShowHideTransitionViews]
        UIView.transitionFromView(fromView, toView: toView, duration: 0.6, options: options) {
            finished in
            cardModel.flipped = !flipped
        }
    }
}

//MARK: CellProtocol Methods
extension CardCVCell: CellProtocol {

    static var nib: UINib {
        return UINib(nibName: className, bundle: nil)
    }

    static var cellIdentifier: String {
        return className
    }

    func updateWithModel(model: Model, image: UIImage?) {
        guard let card = model as? Card else { return }
        cardFrontImageView.image = image
        flipped = card.flipped
    }
}