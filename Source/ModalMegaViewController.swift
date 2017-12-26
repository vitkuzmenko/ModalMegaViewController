//
//  ModalMegaViewController.swift
//  Wallet One
//
//  Created by Vitaliy Kuzmenko on 22/02/2017.
//  Copyright © 2017 Wallet One. All rights reserved.
//

import UIKit

open class ModalMegaViewController: UIViewController {
    
    var backdropView: UIView!
    
    var shadowView: UIView!
    
    var holderView: UIView!
    
    var heightConstraint: NSLayoutConstraint!
    
    var holderViewBottomConstraint: NSLayoutConstraint!
    
    var contentViewBottomConstraint: NSLayoutConstraint!
    
    var contentView: UIView!
    
    var cornerRadius: CGFloat = 0
    
    var isVisualEffect: Bool = true
    
    open var childViewController: ModalMegaChildViewController
    
    var isBackdropDissmissable: Bool = false
    
    public init(childViewController: ModalMegaChildViewController, visualEffect: Bool = false, rounded: Bool = false, backdropDissmissable: Bool = false) {
        self.childViewController = childViewController
        
        super.init(nibName: nil, bundle: nil)
        
        self.isVisualEffect = visualEffect
        self.isBackdropDissmissable = backdropDissmissable
        
        if rounded {
            cornerRadius = 10
        }
        self.modalPresentationStyle = .overFullScreen
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("you can not use modal view controller in storyboard or nib")
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        
        configureRootViewController()
        
        automaticallyAdjustsScrollViewInsets = false
        
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        set(backdropAlpha: 1, animated: animated) { f in }
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    deinit {
        print("deinit ModalMegaViewController")
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - View configuration
    
    func configureViews() {
        
        var baseFrame = UIScreen.main.bounds
        let baseHeight: CGFloat = 100
        baseFrame.origin.y = baseFrame.height - baseHeight
        baseFrame.size.height = baseHeight
        
        // Holder
        holderView = UIView(frame: baseFrame)
        holderView.clipsToBounds = true
        holderView.layer.cornerRadius = cornerRadius
        view.addSubview(holderView)
        holderView.autoPinEdge(.left, to: .left, of: view)
        holderView.autoPinEdge(.right, to: .right, of: view)
        holderViewBottomConstraint = holderView.autoPinEdge(.bottom, to: .bottom, of: view, withOffset: cornerRadius, relation: .equal)
        heightConstraint = holderView.autoSetDimension(.height, toSize: baseHeight, relation: .equal)
        
        // Backdrop
        backdropView = UIView(frame: UIScreen.main.bounds)
        backdropView.backgroundColor = UIColor(white: 0, alpha: 0.4)
        backdropView.alpha = 0
        view.insertSubview(backdropView, belowSubview: holderView)
        backdropView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
        if isVisualEffect {
            backdropView.autoPinEdge(.bottom, to: .top, of: holderView, withOffset: cornerRadius, relation: .equal)
        } else {
            backdropView.autoPinEdge(toSuperviewEdge: .bottom)
        }
        
        if isBackdropDissmissable {
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapBackdrop))
            backdropView.addGestureRecognizer(tap)
        }
        
        // Content
        contentView = UIView(frame: baseFrame)
        holderView.addSubview(contentView)
        contentView.autoPinEdge(.top, to: .top, of: holderView)
        contentView.autoPinEdge(.left, to: .left, of: holderView)
        contentView.autoPinEdge(.right, to: .right, of: holderView)
        contentViewBottomConstraint = contentView.autoPinEdge(.bottom, to: .bottom, of: holderView, withOffset: -cornerRadius, relation: .equal)
    }
    
    // MARK: - ViewController
    
    func configureRootViewController() {
        let vc = childViewController
        vc.modalMegaViewController = self
        contentView.addSubview(vc.view)
        vc.view.autoPinEdgesToSuperviewEdges()
    }
    
    func set(backdropAlpha: CGFloat, duration: TimeInterval = 0.5, animated: Bool, completion: @escaping (Bool) -> Void) {
        if animated {
            UIView.animate(withDuration: duration, animations: {
                self.backdropView.alpha = backdropAlpha
            }, completion: completion)
        } else {
            self.backdropView.alpha = backdropAlpha
            completion(true)
        }
    }
    
    @objc func tapBackdrop() {
        self._dismiss(animated: true)
    }
    
    func _dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        set(backdropAlpha: 0, duration: 0.3, animated: flag) { f in
            self.childViewController.viewWillDismiss(animated: flag)
            self.dismiss(animated: flag, completion: completion)
        }
    }
    
}

