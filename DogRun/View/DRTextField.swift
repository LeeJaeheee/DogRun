//
//  DRTextField.swift
//  DogRun
//
//  Created by 이재희 on 4/21/24.
//

import UIKit
import TextFieldEffects

// FIXME: 처음 텍스트필드 선택 시 animateViewsForTextEntry 2번씩 호출되어 깜박거리는 현상 수정하기

final class DRTextField: HoshiTextField {
    
    private let normalColor = UIColor.red
    private let holderColor = UIColor.lightGray
    private let normalFont = UIFont.systemFont(ofSize: 18, weight: .semibold)
    private let holderFont = UIFont.systemFont(ofSize: 13)
    
    var basicHeight: Int { 80 }
    var isValid = false
    
    init(title: String) {
        super.init(frame: .zero)
        
        placeholder = title
        
        font = normalFont
        placeholderColor = holderColor
        placeholderFontScale = 1.0
        clearButtonMode = .whileEditing
        borderInactiveColor = holderColor
        borderActiveColor = holderColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func animateViewsForTextEntry() {
        super.animateViewsForTextEntry()
        
        print(#function)
        
        if text!.isEmpty && isFirstResponder {
            placeholderLabel.textColor = holderColor
            placeholderLabel.font = holderFont
            borderActiveColor = holderColor
        } else if !text!.isEmpty {
            placeholderLabel.textColor = holderColor
            placeholderLabel.font = holderFont
            borderActiveColor = isValid ? .systemBlue : .systemRed
        }
//        else {
//            placeholderLabel.textColor = normalColor
//            placeholderLabel.font = normalFont
//        }
    }
    
    override func animateViewsForTextDisplay() {
        super.animateViewsForTextDisplay()
        
        print(#function)
        
        if text!.isEmpty {
            placeholderLabel.textColor = holderColor
            placeholderLabel.font = normalFont
            placeholderLabel.sizeToFit()
        }
    }
    
    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.clearButtonRect(forBounds: bounds)
        rect.origin.y += 13
        return rect
    }
    
}
