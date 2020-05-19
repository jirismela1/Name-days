//
//  MonthView.swift
//  Name-days
//
//  Created by Jirka  on 19/05/2020.
//  Copyright © 2020 JirkaSmela. All rights reserved.
//

import UIKit

protocol MonthViewDelegate: class{
    func didChanceMonth(monthIndex: Int, year: Int)
}

class MonthView: UIView {
    
    var currentMonthIndex = 0
    var currentYear = 0
    var delegate: MonthViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        currentMonthIndex = Calendar.current.component(.month, from: Date()) - 1
        currentYear = Calendar.current.component(.year, from: Date())
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate var leftArrow: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(previousMonth), for: .touchUpInside)
        return btn
    }()
    
    fileprivate let leftImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "chevron.left")
        image.tintColor = .white
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    fileprivate var rightArrow: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(nextMonth), for: .touchUpInside)
        btn.tintColor = .white
        return btn
    }()
    
    fileprivate let rightImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "chevron.right")
        image.tintColor = .white
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var monthTitle: UILabel = {
        var lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Default monthTitle"
        lbl.font = UIFont(name: "EuphemiaUCAS", size: 22)
        lbl.textColor = .white
        lbl.textAlignment = .center
        return lbl
    }()
    
    
    
    @objc func nextMonth(){
        currentMonthIndex += 1
        if currentMonthIndex > 11{
            currentMonthIndex = 0
            currentYear += 1
        }
        monthTitle.text = "\(K.months[currentMonthIndex]) \(currentYear)"
        delegate?.didChanceMonth(monthIndex: currentMonthIndex, year: currentYear)
    }
    
    @objc func previousMonth(){
        currentMonthIndex -= 1
        if currentMonthIndex < 0{
            currentMonthIndex = 11
            currentYear -= 1
        }
        monthTitle.text = "\(K.months[currentMonthIndex]) \(currentYear)"
        delegate?.didChanceMonth(monthIndex: currentMonthIndex, year: currentYear)
    }
    
    fileprivate func setupView(){
        
        addSubview(monthTitle)
        monthTitle.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        monthTitle.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        monthTitle.widthAnchor.constraint(equalToConstant: 201).isActive = true
        monthTitle.text = "\(K.months[currentMonthIndex]) \(currentYear)"
        
        addSubview(leftArrow)
        leftArrow.centerYAnchor.constraint(equalTo: monthTitle.centerYAnchor).isActive = true
        leftArrow.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        leftArrow.widthAnchor.constraint(equalToConstant: 71).isActive = true
        leftArrow.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        leftArrow.addSubview(leftImage)
        leftImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        leftImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant:  16).isActive = true
        leftImage.widthAnchor.constraint(equalToConstant: 25).isActive = true
        leftImage.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        addSubview(rightArrow)
        rightArrow.centerYAnchor.constraint(equalTo: monthTitle.centerYAnchor).isActive = true
        rightArrow.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        rightArrow.heightAnchor.constraint(equalToConstant: 48).isActive = true
        rightArrow.widthAnchor.constraint(equalToConstant: 71).isActive = true
        
        rightArrow.addSubview(rightImage)
        rightImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        rightImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        rightImage.widthAnchor.constraint(equalToConstant: 25).isActive = true
        rightImage.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
}
