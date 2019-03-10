//
//  ViewController.swift
//
//  Created by stefano vecchiati .
//  Copyright © 2018 com.stefanovecchiati. All rights reserved.
//

import UIKit
import Stevia

class ViewController: UIViewController {
    
    var collectionView: BaseColletcionView!
    var backgroundImage : UIImageView!
    
    var viewModel : BaseModel!
    
    init(withModel model: BaseModel?) {
        super.init(nibName: nil, bundle: nil)
        viewModel = model ?? BaseModel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if viewModel.titleViewController != nil && !viewModel.titleViewController.isEmpty {
            
            if (UIDevice().type != .iPhone5S && UIDevice().type != .iPhoneSE && UIDevice().type != .simulator) || UIScreen.main.bounds.height > 568.0 {
                self.title = viewModel.titleViewController
            }
            
        }
        
        self.navigationItem.rightBarButtonItems = viewModel.rightBarButtonItems
        self.navigationItem.leftBarButtonItems = viewModel.leftBarButtonItems
        
        addBackgroudImage()
        addCollectionView()
        
        viewModel.collectionDirector = CollectionDirector(collectionView: self.collectionView, items: self.viewModel.cells)
        
        viewModel.registerCells()
        
        viewModel.addHandlers()
        
        self.view.backgroundColor = .white
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.topViewController()?.navigationController?.setNavigationBarHidden(viewModel.hideNavigationBar, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func addBackgroudImage() {
        backgroundImage = UIImageView(image: viewModel.backgroudImage)
        backgroundImage.contentMode = .scaleAspectFill
        
        view.sv(
            backgroundImage
        )
        
        backgroundImage.fillContainer()
    }
    
    var collectionBottomConstraint : NSLayoutConstraint!
    
    private func addCollectionView() {
        
        collectionView = BaseColletcionView(frame: view.frame, collectionViewLayout: UICollectionViewFlowLayout.init())
        
        view.sv(
           collectionView
        )
        
        collectionView.fillContainer()
        
        collectionView.setupCollection(withModel: viewModel)
        
        
    }
    
    
}
