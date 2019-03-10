//
//  Created by stefano vecchiati.
//  Copyright © 2018 co.eggon. All rights reserved.
//

import UIKit
import Stevia
import Cosmos

class BookWidget: UICollectionViewCell, ConfigurableCell {

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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addElementsToSuperView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // load the view
    func configure(data: BookModel) {
        
        bookTitleLabel.style { label in
            label.numberOfLines = 0
            label.font = UIFont.boldSystemFont(ofSize: 18)
        }
        
        bookTitleLabel.text = data.title.uppercased()
        
        bookDescriptionLabel.style { label in
            label.numberOfLines = 0
            label.textColor = .gray
            label.font = UIFont.systemFont(ofSize: 14)
            
        }
        
        bookDescriptionLabel.text = data.description
        
        bookImageView.image = UIImage(named: data.imageName) ?? R.image.placeholder() ?? UIImage()
        
        rateView.style { rate in
            
            let colorStarEmpty : UIColor = .lightGray
            let colortStarFull : UIColor = .orange
            
            rate.settings.fillMode = .half
            rate.settings.filledColor = colortStarFull
            rate.settings.filledBorderColor = colortStarFull
            rate.settings.emptyColor = colorStarEmpty
            rate.settings.emptyBorderColor = colorStarEmpty
            
            
        }
        
        rateView.rating = data.rate
        rateView.text = "(\(data.rate.roundToDecimal(1)))"
        
        // change the value when finished to touch
        rateView.didFinishTouchingCosmos = { rating in
            CellAction.custom(.Rate).invoke(cell: self, value: rating)
        }
        
        // change the text value for show at the user the value taht will change
        rateView.didTouchCosmos = { rating in
            self.rateView.text = "(\(rating.roundToDecimal(1)))"
        }
        
    }
    
    // add the elements as subviews (I use Stevia)
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
    //Set the constraint of the views (Stevia)
    func setConstraint() {
        
        // view container contraint
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            view.Width == UIScreen.main.bounds.width
        default:
            view.Width == (UIScreen.main.bounds.width - BaseColletcionView.minimumInteritemSpacing) / 2
        }
        
        view.top(0).bottom(0).left(0).right(0)
        
        // imageView constraint
        bookImageView.top(5).bottom(5).height(150).width(100)
        bookImageView.Leading == 15

        // titleLabel constraint
        bookTitleLabel.Leading == bookImageView.Trailing + 10
        bookTitleLabel.Trailing == -10
        
//        bookTitleLabel.height(50)

        align(tops: bookImageView, bookTitleLabel)

        // rateView constraint
        rateView.Top == bookTitleLabel.Bottom + 5
        rateView.Trailing == -10
        rateView.Height == 20

        // descriptionLabel constraint
        bookDescriptionLabel.Trailing == -10
        bookDescriptionLabel.Top == rateView.Bottom + 5

        align(lefts: bookTitleLabel, bookDescriptionLabel, rateView)
        align(bottoms: bookImageView, bookDescriptionLabel)
        
        
    }
    
    

}