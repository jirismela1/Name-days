//
//  ShowSubjectsViewController.swift
//  Name-days
//
//  Created by Jirka  on 19/05/2020.
//  Copyright © 2020 JirkaSmela. All rights reserved.
//

import UIKit
import RealmSwift

class ShowSubjectsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var dataSubjects = [Subject](){
       didSet{
        topTitleDate.text = "\(dataSubjects[0].day) \(dataSubjects[0].month)"
        }
    }
    
    fileprivate let pagingScrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(ScreenCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        setupView()
    }
    
//MARK: - View & SetupView
    fileprivate let pageControl: UIPageControl = {
        let control = UIPageControl(frame: .zero)
        control.translatesAutoresizingMaskIntoConstraints = false
        control.currentPageIndicatorTintColor = UIColor(named: "text")
        control.pageIndicatorTintColor = UIColor.gray
        return control
    }()
    
    
    let topTitleDate: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont(name: "Cochin", size: 38)
        lbl.textAlignment = .center
        lbl.textColor = .white
        return lbl
    }()
    
    
    
    fileprivate func setupView(){
        
        
        
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.tintColor = .white

        
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.backgroundColor = .white
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        
        
        view.addSubview(topTitleDate)
        topTitleDate.topAnchor.constraint(equalTo: view.topAnchor, constant: 54).isActive = true
        topTitleDate.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32).isActive = true
        topTitleDate.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32).isActive = true
        topTitleDate.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        
        
        view.addSubview(pageControl)
        
        pageControl.hidesForSinglePage = true
        pageControl.numberOfPages = dataSubjects.count
        
        
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        
        
    }
    
//MARK: - ColectionView
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSubjects.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ScreenCollectionViewCell
        
        cell.nameLabel.text = dataSubjects[indexPath.row].name
        
        if dataSubjects[indexPath.row].male == true{
            cell.imageProfile.image = UIImage(named: "Male_icon")
        }else if dataSubjects[indexPath.row].female == true{
            cell.imageProfile.image = UIImage(named: "Female_icon")
        }else{
            cell.imageProfile.image = UIImage(named: "Event_icon")
        }
        
        if dataSubjects[indexPath.row].eventInfo.isEmpty{
            cell.infoTextView.text = dataSubjects[indexPath.row].nameInfo
        }else{
            cell.infoTextView.text = dataSubjects[indexPath.row].eventInfo
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height )
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollPos = scrollView.contentOffset.x / view.frame.width
        pageControl.currentPage = Int(scrollPos)
    }
}
