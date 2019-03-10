//
//  LoadingViewController.swift
//  stefano_vecchiati_test
//
//  Created by stefano vecchiati on 09/03/2019.
//  Copyright © 2019 com.stefanovecchiati. All rights reserved.
//

import UIKit

/*
 I use this view also if we really don't need it, but it's helpful if you have some login logic etc.
 So I prefer always have it, for maybe future implementations and also to keep a logic all the time the same.
 So basically this viewController is our RootViewController and should have the same design as the LaunchScreen, in this case, the user doesn't see the difference between the 2.
*/
class RootViewController: UIViewController {

    override func viewDidLoad() {
            super.viewDidLoad()
            
            self.view.backgroundColor = .white
            
        }
        
        override func viewDidAppear(_ animated: Bool) {
            
            super.viewDidAppear(animated)
            
            let viewModel = BookListViewModel()
            let viewController = ViewController(withModel: viewModel)
            
            UIApplication.shared.delegate?.window??.rootViewController = BaseNavigationController(rootViewController: viewController)
            UIApplication.shared.delegate?.window??.makeKeyAndVisible()
            
        }
        
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }

}

