//
//  Created by stefano vecchiati.
//  Copyright © 2018 co.eggon. All rights reserved.
//

import UIKit
import Stevia

class BookWidget: BaseCollectionViewCell, ConfigurableCell {
    typealias DataType = BookModel
    
    private var view : UIView = UIView()
    
    private var bookImageView : UIImageView = UIImageView(image: R.image.placeholder() ?? UIImage()) {
        didSet {
            bookImageView.style { imageView in
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = false
            }
        }
    }
    
    
    private var bookTitleLabel : UILabel = UILabel()
    private var bookDescriptionLabel : UILabel = UILabel()
    
    @objc func injected() {
       
    }
    
    func configure(model: BookModel) {
        
        sv(
            view.sv(
                bookImageView,
                bookTitleLabel,
                bookDescriptionLabel
            )
            
        )
        
        bookTitleLabel.style { label in
            label.numberOfLines = 0
            label.font = UIFont.boldSystemFont(ofSize: 20)
        }
        
        bookDescriptionLabel.style { label in
            label.numberOfLines = 0
            label.textColor = .gray
            label.font = UIFont.systemFont(ofSize: 14)
        }
        
        bookTitleLabel.text = "Title"
        bookDescriptionLabel.text = "Test"
        
    }
    
    func setConstraint() {
        
        view.Width == UIScreen.main.bounds.width
        view.top(0).bottom(0).left(0).right(0)
        
        bookImageView.top(5).bottom(5).height(150).width(100)
        bookImageView.Leading == 15
        
        bookTitleLabel.Leading == bookImageView.Trailing + 10
        bookTitleLabel.Trailing == -10

        align(tops: bookImageView,bookTitleLabel)

        bookDescriptionLabel.bottom(5)
        bookDescriptionLabel.Trailing == -10
        bookDescriptionLabel.Top == bookTitleLabel.Bottom + 10

        align(lefts: bookTitleLabel, bookDescriptionLabel)
        
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        
        setConstraint()
        
    }

}
