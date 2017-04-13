//
//  ModalMegaNavigationController.swift
//  Wallet One
//
//  Created by Vitaliy Kuzmenko on 28/02/2017.
//  Copyright © 2017 Wallet One. All rights reserved.
//

import UIKit
import PureLayout

open class ModalMegaNavigationController: ModalMegaViewController, UINavigationControllerDelegate {

    open var modalMegaNvigationController: UINavigationController!
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if #available(iOS 9, *) {
            var frame = modalMegaNvigationController.navigationBar.frame
            frame.origin.y = 0
            modalMegaNvigationController.navigationBar.frame = frame
        }
    }
    
    override func configureRootViewController() {
        let vc = childViewController
        vc.modalMegaViewController = self
        let nvc = UINavigationController(rootViewController: vc)
        nvc.navigationBar.setBackgroundImage(UIImage(), for: .default)
        nvc.automaticallyAdjustsScrollViewInsets = false
        nvc.delegate = self
        contentView.addSubview(nvc.view)
        nvc.view.autoPinEdgesToSuperviewEdges()
        modalMegaNvigationController = nvc
        configure(navigationController: nvc)
    }
    
    open func configure(navigationController: UINavigationController) {
        
    }
    
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let vc = viewController as! ModalMegaChildViewController
        vc.modalMegaViewController = self
        configure(childViewController: vc)
    }
    
    open func configure(childViewController: ModalMegaChildViewController) {
        
    }

}
