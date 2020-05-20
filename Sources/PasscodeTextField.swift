//
//  PasscodeTextField.swift
//  PasscodeTextField
//
//  Created by Prashant Shrestha on 5/20/20.
//  Copyright © 2020 Inficare. All rights reserved.
//

import UIKit

class PasscodeTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
        textFieldConfig()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
        textFieldConfig()
    }
    
    private var initialString: String = "○○○○○○"
    private var currentIndex: Int = -1
    public var isReadonly = true
    
    func makeUI() {
        layer.masksToBounds = true
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: 74).isActive = true
        
        self.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        keyboardType = UIKeyboardType.numberPad
    }
    
    func textFieldConfig() {
        self.defaultTextAttributes.updateValue(30, forKey: NSAttributedString.Key.kern)
        let leftView = UIView()
        leftView.translatesAutoresizingMaskIntoConstraints = false
        leftView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        leftView.heightAnchor.constraint(equalTo: leftView.widthAnchor).isActive = true
        self.leftView = leftView
        self.leftViewMode = .always
        self.insertText(initialString)
        self.textAlignment = .center
        self.backgroundColor = UIColor.clear
    }
    
    override func caretRect(for position: UITextPosition) -> CGRect {
        return CGRect.zero
    }
    
    override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        return []
    }
    
    override func target(forAction action: Selector, withSender sender: Any?) -> Any? {
        guard isReadonly else {
            return super.target(forAction: action, withSender: sender)
        }
        
        if #available(iOS 10, *) {
            if action == #selector(UIResponderStandardEditActions.paste(_:)) {
                return nil
            }
        } else {
            if action == #selector(paste(_:)) {
                return nil
            }
        }
        
        return super.target(forAction: action, withSender: sender)
    }
    
    override func closestPosition(to point: CGPoint) -> UITextPosition? {
        let beginning = self.beginningOfDocument
        let end = self.position(from: beginning, offset: self.text?.count ?? 0)
        return end
    }
    
    func reset() {
        self.clear()
        self.currentIndex = -1
        self.text = initialString
    }
}

extension PasscodeTextField {
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = text else { return }
        if text.count == 7 {
            let number = String(text.last!)
            self.currentIndex =  self.currentIndex == 5 ? 5 : self.currentIndex + 1
            self.text = String(text.dropLast())
            let textString = String(text.dropLast())
            let current = textString.index(textString.startIndex, offsetBy: self.currentIndex)
            let result = textString.replacingCharacters(in: current...current, with: number)
            self.clear()
            self.text = result
        } else if text.count == 5 {
            self.text = text + "○"
            if self.currentIndex >= 0 {
                let textString = text + "○"
                let current = textString.index(textString.startIndex, offsetBy: self.currentIndex)
                let result = textString.replacingCharacters(in: current...current, with: "○")
                self.clear()
                self.text = result
                self.currentIndex = self.currentIndex - 1
            }
        } else {
            self.reset()
        }
    }
    
    func clear() {
        text = ""
        attributedText = NSAttributedString(string: "")
    }
}

