//
//  ScreenCollectionViewCell.swift
//  Name-days
//
//  Created by Jirka  on 19/05/2020.
//  Copyright © 2020 JirkaSmela. All rights reserved.
//

import UIKit

class ScreenCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(named: "backgroundColor")
        setupView()
    }
    
    fileprivate let topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = K.myDarkRed
        return view
    }()

    let imageProfile: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    fileprivate let nameLabelView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "EuphemiaUCAS", size: 20)
        lbl.textColor = .black
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.adjustsFontSizeToFitWidth = true
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    
     private let profileView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.applySketchShadow(color: K.myDarkRoseColor,alpha: 1 ,x: 3, y: 2, blur: 3)
        view.layer.cornerRadius = 4
        view.backgroundColor = K.myRedColor
        return view
    }()

     private let infoView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.applySketchShadow(color: K.myDarkRoseColor,alpha: 1 ,x: 3, y: 2, blur: 3)
        view.layer.cornerRadius = 4
        view.backgroundColor = K.myRedColor
        return view
    }()
    
    let infoTextView: UITextView = {
        let scroll = UITextView(frame: .zero)
        scroll.backgroundColor = .clear
        scroll.textColor = .black
        scroll.font = UIFont(name: "EuphemiaUCAS", size: 14)
        scroll.isEditable = false
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()

    fileprivate let profileStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    fileprivate func setupView(){
        
        addSubview(topView)
        topView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        topView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        topView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        topView.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
        addSubview(profileView)
        profileView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: -16).isActive = true
        profileView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        profileView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        profileView.heightAnchor.constraint(equalToConstant: 112).isActive = true
        
        profileView.addSubview(profileStackView)
        profileStackView.topAnchor.constraint(equalTo: profileView.topAnchor,constant: 4).isActive = true
        profileStackView.leadingAnchor.constraint(equalTo: profileView.leadingAnchor,constant: 4).isActive = true
        profileStackView.trailingAnchor.constraint(equalTo: profileView.trailingAnchor,constant: -4).isActive = true
        profileStackView.bottomAnchor.constraint(equalTo: profileView.bottomAnchor,constant: -4).isActive = true
        
        profileStackView.addArrangedSubview(imageProfile)
        profileStackView.addArrangedSubview(nameLabelView)
        imageProfile.widthAnchor.constraint(equalTo: nameLabelView.widthAnchor, multiplier: 0.5).isActive = true
        
        nameLabelView.addSubview(nameLabel)
        nameLabel.centerYAnchor.constraint(equalTo: nameLabelView.centerYAnchor).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: nameLabelView.centerXAnchor).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: nameLabelView.widthAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: nameLabelView.heightAnchor).isActive = true
        
        addSubview(infoView)
        infoView.topAnchor.constraint(equalTo: profileView.bottomAnchor, constant: 8).isActive = true
        infoView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 16).isActive = true
        infoView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        infoView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -75).isActive = true
        
        infoView.addSubview(infoTextView)
        infoTextView.topAnchor.constraint(equalTo: infoView.topAnchor, constant: 16).isActive = true
        infoTextView.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: 8).isActive = true
        infoTextView.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: -8).isActive = true
        infoTextView.bottomAnchor.constraint(equalTo: infoView.bottomAnchor, constant: -8).isActive = true
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
