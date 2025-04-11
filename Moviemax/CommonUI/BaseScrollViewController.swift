//
//  BaseScrollViewController.swift
//  Moviemax
//
//  Created by Николай Игнатов on 07.04.2025.
//

import UIKit

class BaseScrollViewController: UIViewController {
    private(set) lazy var contentView = UIView()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.keyboardDismissMode = .interactive
        return scrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        setupKeyboardObservers()
        addTapGesture()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setScrollState(isScrollEnabled: Bool) {
        scrollView.isScrollEnabled = isScrollEnabled
    }
}

// MARK: - Private Methods
private extension BaseScrollViewController {
    func setupView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
    }
    
    func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
    }
    
    func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard
            let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        else { return }
        
        let keyboardHeight: CGFloat = keyboardFrame.height
        let baseOffset: CGFloat = 30
        let resultOffset: CGFloat = keyboardHeight + baseOffset
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: resultOffset, right: 0)
        
        UIView.animate(withDuration: duration) {
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
            
            // Если есть активное текстовое поле, прокручиваем к нему
            if let activeField = self.view.findFirstResponder() as? UITextField {
                let activeRect = activeField.convert(activeField.bounds, to: self.scrollView)
                let visibleRect = self.scrollView.bounds.inset(by: contentInsets)
                
                if !visibleRect.contains(activeRect) {
                    self.scrollView.scrollRectToVisible(activeRect, animated: true)
                }
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        UIView.animate(withDuration: duration) {
            self.scrollView.contentInset = .zero
            self.scrollView.scrollIndicatorInsets = .zero
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
