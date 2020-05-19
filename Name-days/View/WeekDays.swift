//
//  WeekDays.swift
//  Name-days
//
//  Created by Jirka  on 19/05/2020.
//  Copyright © 2020 JirkaSmela. All rights reserved.
//

import UIKit

class WeekDays: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate var weekStack: UIStackView = {
        var stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillEqually
        return stack
    }()
    
    fileprivate func setupView(){
        addSubview(weekStack)
        
        weekStack.topAnchor.constraint(equalTo: topAnchor).isActive = true
        weekStack.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        weekStack.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        weekStack.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        for day in K.daysShortcut.indices {
            let lbl = UILabel()
            lbl.text = K.daysShortcut[day]
            lbl.font = UIFont(name: "GillSans", size: 18)
            lbl.textAlignment = .center
            lbl.textColor = .black
            weekStack.addArrangedSubview(lbl)
        }
    }
}
