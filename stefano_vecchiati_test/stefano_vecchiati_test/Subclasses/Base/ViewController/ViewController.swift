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
        
        if viewModel.resizeForKeyboard {
            
            let notificationCenter = NotificationCenter.default
            notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
            notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
            
        }
        
        if viewModel.touchForCloseKeyboard {
            
            hideKeyboardWhenTappedAround()
            
        }
        
        if viewModel.titleViewController != nil && !viewModel.titleViewController.isEmpty {
            self.title = viewModel.titleViewController
        }
        
        self.navigationItem.rightBarButtonItems = viewModel.rightBarButtonItems
        self.navigationItem.leftBarButtonItems = viewModel.leftBarButtonItems
        
        addBackgroudImage()
        addCollectionView()
        
        for cell in viewModel.cells {
            collectionView.register(BookWidget.self, forCellWithReuseIdentifier: type(of: cell).reuseId)
        }
        
        viewModel.collectionDirector = CollectionDirector(collectionView: self.collectionView, items: self.viewModel.cells)
        
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
    
    @objc func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            collectionBottomConstraint.constant = 0
        } else {
            collectionBottomConstraint.constant = collectionBottomConstraint.constant - keyboardScreenEndFrame.height
        }
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
    }
    
    
}


extension ViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
