//
//  LoadingViewController.swift
//  stefano_vecchiati_test
//
//  Created by stefano vecchiati on 09/03/2019.
//  Copyright © 2019 com.stefanovecchiati. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    override func viewDidLoad() {
            super.viewDidLoad()
            
            self.view.backgroundColor = .white
            
            
            
        }
        
        override func viewDidAppear(_ animated: Bool) {
            
            super.viewDidAppear(animated)
            
            let viewController = ViewController(withModel: Model.createModel())
            
            UIApplication.shared.delegate?.window??.rootViewController = BaseNavigationController(rootViewController: viewController)
            UIApplication.shared.delegate?.window??.makeKeyAndVisible()
            
        }
        
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }

}

