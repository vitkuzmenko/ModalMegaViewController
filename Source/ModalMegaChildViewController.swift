//
//  ModalMegaChildViewController.swift
//  Wallet One
//
//  Created by Vitaliy Kuzmenko on 28/02/2017.
//  Copyright © 2017 Wallet One. All rights reserved.
//

import UIKit

open class ModalMegaChildViewController: UIViewController {
    
    @IBOutlet open var cancelButton: UIBarButtonItem!
    
    open weak var modalMegaViewController: ModalMegaViewController!
    
    open var preferredContentHeight: CGFloat {
        return 100
    }
    
    open let topSpace: CGFloat = 130
    
    open let maxHeight = UIScreen.main.bounds.height - 64
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        print("deinit ModalMegaChildViewController")
        NotificationCenter.default.removeObserver(self)
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        set(height: preferredContentHeight, animated: animated)
    }
    
    @IBAction open func cancel() {
        modalMegaViewController._dismiss(animated: true)
    }
    
    open func setNeedsHeightUpdate(complete: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            self.set(height: self.preferredContentHeight, animated: true, complete: complete)
        }
    }
    
    func set(height: CGFloat, animated: Bool, complete: (() -> Void)? = nil) {
        
        let space: CGFloat
        
        if #available(iOS 11.0, *) {
            space = view.safeAreaInsets.bottom
        } else {
            space = bottomLayoutGuide.length
        }
        
        modalMegaViewController?.heightConstraint.constant = min(height + space, maxHeight)
        if animated {
            UIView.animate(withDuration: 0.3, animations: {
                self.modalMegaViewController?.view.layoutIfNeeded()
            }) { f in
                complete?()
            }
        }
    }
    
    override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ModalMegaChildViewController {
            vc.modalMegaViewController = self.modalMegaViewController
        }
    }
    
    override open func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        modalMegaViewController._dismiss(animated: flag, completion: completion)
    }
    
    override open func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        modalMegaViewController.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    
    func viewWillDismiss(animated: Bool) {
        
    }
    
    // MARK: - Keyboard
    
    @objc func keyboardWillShow(notification: Notification) {
        guard let nInfo = notification.userInfo as? [String: Any], let value = nInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        keyboardWillShow(frame: value.cgRectValue)
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        guard let nInfo = notification.userInfo as? [String: Any], let value = nInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        keyboardWillHide(frame: value.cgRectValue)
    }
    
    func keyboardWillShow(frame: CGRect) {
        let bottom = frame.height - modalMegaViewController.cornerRadius
        let sum = bottom + modalMegaViewController.heightConstraint.constant
        
        if sum > maxHeight {
            let newHeight = maxHeight - frame.height
            set(height: newHeight, animated: false)
        }
        
        modalMegaViewController.holderViewBottomConstraint.constant = -bottom
        modalMegaViewController.view.layoutIfNeeded()
    }
    
    func keyboardWillHide(frame: CGRect) {
        modalMegaViewController.holderViewBottomConstraint.constant = modalMegaViewController.cornerRadius
        set(height: preferredContentHeight, animated: false)
        modalMegaViewController.view.layoutIfNeeded()
    }
    
}

