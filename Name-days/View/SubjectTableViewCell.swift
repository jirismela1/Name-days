//
//  SubjectTableViewCell.swift
//  Name-days
//
//  Created by Jirka  on 19/05/2020.
//  Copyright © 2020 JirkaSmela. All rights reserved.
//

import UIKit

class SubjectTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor(named: "backgroundColor")
        setupView()
    }
    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 0
        lbl.adjustsFontSizeToFitWidth = true
        lbl.font = UIFont(name: "EuphemiaUCAS", size: 16)
        lbl.textAlignment = .left
        lbl.textColor = UIColor(named: "text")
        return lbl
    }()
    
    let dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .left
        lbl.textColor = UIColor(named: "text")
        lbl.font = UIFont(name: "EuphemiaUCAS", size: 12)
        return lbl
    }()
    
    let profilImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let lineView: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = UIColor(named: "text")
        return line
    }()
    
    let daysCount: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "365"
        lbl.textColor = .lightGray
        lbl.textAlignment = .right
        lbl.font = UIFont(name: "EuphemiaUCAS", size: 12)
        return lbl
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 2, left: 8, bottom: 2, right: 8))
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = UIColor(named: "text")?.cgColor
        contentView.layer.applySketchShadow(color: K.myDarkRed,alpha: 1 ,x: 3, y: 2, blur: 3)
        contentView.layer.cornerRadius = 4
    }
    
    fileprivate func setupView(){
        addSubview(profilImage)
        profilImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profilImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 4).isActive = true
        profilImage.widthAnchor.constraint(equalToConstant: 32).isActive = true
        profilImage.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        addSubview(lineView)
        lineView.leadingAnchor.constraint(equalTo: profilImage.trailingAnchor,constant: 4).isActive = true
        lineView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        lineView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        lineView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        
        addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: lineView.trailingAnchor, constant: 8).isActive = true
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        addSubview(dateLabel)
        dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 1).isActive = true
        dateLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4).isActive = true
        
        addSubview(daysCount)
        daysCount.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor).isActive = true
        daysCount.heightAnchor.constraint(equalTo: dateLabel.heightAnchor).isActive = true
        daysCount.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        daysCount.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
