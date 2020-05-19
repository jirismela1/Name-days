//
//  CalendarCollectionViewCell.swift
//  Name-days
//
//  Created by Jirka  on 19/05/2020.
//  Copyright © 2020 JirkaSmela. All rights reserved.
//

import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let dayCell: UILabel = {
        let cell = UILabel()
        cell.translatesAutoresizingMaskIntoConstraints = false
        cell.text = "00"
        cell.font = UIFont(name: "EuphemiaUCAS", size: 16)
        cell.textAlignment = .center
        
        return cell
    }()
    
    fileprivate func setupView(){
        addSubview(dayCell)
        dayCell.topAnchor.constraint(equalTo: topAnchor).isActive = true
        dayCell.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        dayCell.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        dayCell.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}

