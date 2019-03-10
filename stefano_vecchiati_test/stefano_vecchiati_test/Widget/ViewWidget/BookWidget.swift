//
//  Created by stefano vecchiati.
//  Copyright © 2018 co.eggon. All rights reserved.
//

import UIKit
import Stevia
import Cosmos

class BookWidget: BaseCollectionViewCell, ConfigurableCell {

    typealias DataType = BookModel
    
    private let view = UIView()
    private let rateView = CosmosView()
    
    private var bookImageView : UIImageView = UIImageView(image: R.image.placeholder() ?? UIImage()) {
        didSet {
            bookImageView.style { imageView in
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = false
            }
        }
    }
    
    
    private let bookTitleLabel : UILabel = UILabel()
    private let bookDescriptionLabel : UILabel = UILabel()
    
    @objc func injected() {
       
    }
    
    func configure(data: BookModel) {
        
        addElementsToSuperView()
        
        bookTitleLabel.style { label in
            label.numberOfLines = 0
            label.font = UIFont.boldSystemFont(ofSize: 18)
            label.text = data.title.uppercased()
        }
        
        bookDescriptionLabel.style { label in
            label.numberOfLines = 0
            label.textColor = .gray
            label.font = UIFont.systemFont(ofSize: 14)
            label.text = data.description
        }
        
        bookImageView.image = UIImage(named: data.imageName) ?? R.image.placeholder() ?? UIImage()
        
        rateView.style { rate in
            
            let colorStarEmpty : UIColor = .lightGray
            let colortStarFull : UIColor = .orange
            
            rate.settings.fillMode = .half
            rate.settings.filledColor = colortStarFull
            rate.settings.filledBorderColor = colortStarFull
            rate.settings.emptyColor = colorStarEmpty
            rate.settings.emptyBorderColor = colorStarEmpty
            rate.rating = data.rate
            rate.text = "(\(data.rate))"
        }
        
        rateView.didFinishTouchingCosmos = { rating in
            CellAction.custom(.Rate).invoke(cell: self, value: rating)
        }
        
        rateView.didTouchCosmos = { rating in
            self.rateView.text = "(\(rating))"
        }
        
    }
    
    func addElementsToSuperView() {
        sv(
            view.sv(
                bookImageView,
                bookTitleLabel,
                rateView,
                bookDescriptionLabel
            )
        
        )
        
        setConstraint()
    }
    
    func setConstraint() {
        
        view.Width == UIScreen.main.bounds.width
        view.top(0).bottom(0).left(0).right(0)
        
        bookImageView.top(5).bottom(5).height(150).width(100)
        bookImageView.Leading == 15
        
        bookTitleLabel.Leading == bookImageView.Trailing + 10
        bookTitleLabel.Trailing == -10

        align(tops: bookImageView, bookTitleLabel)
        
        rateView.Top == bookTitleLabel.Bottom + 5
        rateView.Trailing == -10
        rateView.Height == 20
        
        bookDescriptionLabel.Trailing == -10
        bookDescriptionLabel.Top == rateView.Bottom + 5

        align(lefts: bookTitleLabel, bookDescriptionLabel, rateView)
        align(bottoms: bookImageView, bookDescriptionLabel)
        
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        
        
//        setConstraint()
        
    }

}
