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
    
    private var viewModel : BaseModel!
    
    init(withModel model: BaseModel!) {
        super.init(nibName: nil, bundle: nil)
        viewModel = model
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
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        self.view.backgroundColor = .white
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.topViewController()?.navigationController?.setNavigationBarHidden(viewModel.hideNavigationBar, animated: animated)
    }
    
    private var firstLoad: Bool = true
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if firstLoad {
            
            firstLoad = false
            
            viewModel.delegate?.loadWidget?()
            
            if viewModel.centerViewController {
                collectionView.contentInset.top = max((collectionView.frame.height - collectionView.contentSize.height) / 2, 0)
            }
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func addBackgroudImage() {
        backgroundImage = UIImageView(image: viewModel.backgroudImage)
        backgroundImage.contentMode = .scaleAspectFill
        
        view.insertSubview(backgroundImage, at: 0)
        
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        
        let leftConstraint = NSLayoutConstraint(item: backgroundImage, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 0)
        leftConstraint.priority = .defaultHigh
        
        let rightConstraint = NSLayoutConstraint(item: backgroundImage, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1, constant: 0)
        rightConstraint.priority = .defaultHigh
        
        let topConstraint = NSLayoutConstraint(item: backgroundImage, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
        topConstraint.priority = .defaultHigh
        
        let bottomConstraint = NSLayoutConstraint(item: backgroundImage, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
        bottomConstraint.priority = .defaultHigh
        
        view.addConstraints([leftConstraint, rightConstraint, topConstraint, bottomConstraint])
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
        viewModel.delegate?.deinitListener?()
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
    }
    
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = viewModel.cells[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: type(of: item).reuseId, for: indexPath)
        
        item.configure(cell: cell)
//
//        cell.baseModel = viewModel
//        cell.selectedStruct = viewModel.cells[indexPath.item]
//        cell.delegate = viewModel.cells[indexPath.item].delegate
//
//        cell.contentSetup()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.delegate?.selectedCell(index: indexPath)
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
