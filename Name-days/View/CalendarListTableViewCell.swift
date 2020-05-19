//
//  CalendarListTableViewCell.swift
//  Name-days
//
//  Created by Jirka  on 19/05/2020.
//  Copyright © 2020 JirkaSmela. All rights reserved.
//

import UIKit

class CalendarListTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = K.myRedColor
        layer.applySketchShadow(color: K.myDarkRoseColor,alpha: 1 ,x: 3, y: 2, blur: 3)
        layer.cornerRadius = 4
        setupView()
    }
    override var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame = newFrame
            let newWidth = frame.width - 3
            frame.size.width = newWidth
            super.frame = frame

        }
    }

    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        lbl.textColor = .white
        lbl.numberOfLines = 0
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    func setupView(){
        addSubview(titleLabel)
        titleLabel.widthAnchor.constraint(equalToConstant: 310).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 36).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
