//
//  BirthdayView.swift
//  DogRun
//
//  Created by 이재희 on 4/28/24.
//

import UIKit
import SnapKit

final class BirthdayView: BaseView {
    
    let titleLabel = DRLabel(text: "생년월일을\n입력해주세요.", style: .title)
    let birthdayTextField = DRTextField(title: "생년월일")
    let nextButton = DRButton(title: "가입하기")
    
    let datePicker = UIDatePicker()
    let toolBar = UIToolbar()
    let doneButton = UIBarButtonItem(systemItem: .done)
    
    override func configureHierarchy() {
        [titleLabel, birthdayTextField, nextButton].forEach {
            addSubview($0)
        }
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(40)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        birthdayTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(birthdayTextField.basicHeight)
        }
        
        nextButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(60)
            // FIXME: 아래 코드로 실행하면 textfieldeffects에서 문제생김 (animateViewsForTextEntry() 호출안함)
            //make.bottom.equalTo(keyboardLayoutGuide.snp.top).inset(-16)
            make.height.equalTo(nextButton.basicHeight)
        }
    }
    
    override func configureView() {
        nextButton.isEnabled = false
        birthdayTextField.clearButtonMode = .never
        setupDatePicker()
        setupToolBar()
    }
    
    private func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.maximumDate = Date()
        birthdayTextField.inputView = datePicker
    }
    
    private func setupToolBar() {
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.items = [flexibleSpace, doneButton]
        toolBar.sizeToFit()
        birthdayTextField.inputAccessoryView = toolBar
    }
    
}
