//
//  FavoriteViewController.swift
//  Name-days
//
//  Created by Jirka  on 19/05/2020.
//  Copyright © 2020 JirkaSmela. All rights reserved.
//

import UIKit
import RealmSwift

class FavoriteViewController: UIViewController {
    
    fileprivate let realm = try! Realm()
    fileprivate var realmData: Results<Subject>?
    fileprivate var sortNamesToMonths = [[Subject]]()
    fileprivate var monthsTitles = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SubjectTableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButtonItem
        
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        realmData = realm.objects(Subject.self)
        getData()
        tableView.reloadData()
    }
//MARK: - Views & SetupView
    fileprivate let tableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.backgroundColor = UIColor(named: "backgroundColor")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    fileprivate let topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = K.myDarkRed
        return view
    }()
    
    fileprivate let infoLabel: UILabel = {
           let lbl = UILabel()
           lbl.translatesAutoresizingMaskIntoConstraints = false
           lbl.text = "Delete"
           lbl.textAlignment = .center
           lbl.textColor = .white
           lbl.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
           lbl.layer.cornerRadius = 7
           lbl.layer.masksToBounds = true
           return lbl
       }()

    fileprivate func setupView(){
        title = "Favorite"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Cochin", size: 38)!, NSAttributedString.Key.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.setTitleVerticalPositionAdjustment(6, for: UIBarMetrics.default)
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()

        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barStyle = .black
        
        view.addSubview(topView)
        topView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        topView.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.addSubview(infoLabel)
        infoLabel.isHidden = true
        infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        infoLabel.widthAnchor.constraint(equalToConstant: 170).isActive = true
        infoLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -40).isActive = true
    }
    
    func daysCountDown(_ index: IndexPath) -> Int{
        let userCalendar = Calendar.current
        let namesDate = sortNamesToMonths[index.section][index.row]
        var nextTimeNamesDate = DateComponents()
        var now = DateComponents()
        nextTimeNamesDate.day = namesDate.day
        nextTimeNamesDate.month = index.section + 1
        nextTimeNamesDate.year = userCalendar.component(.year, from: Date())
        guard let nextMonth = nextTimeNamesDate.month, let nextDay = nextTimeNamesDate.day else {return 10_000_000}
        
        if nextMonth == userCalendar.component(.month, from: Date()){
            
            if nextDay == userCalendar.component(.day, from: Date()){
                return 0
            }else{
                nextTimeNamesDate.year! += nextDay < userCalendar.component(.day, from: Date()) ? 1 : 0
            }
        }else{
            nextTimeNamesDate.year! += nextMonth < userCalendar.component(.month, from: Date()) ? 1 : 0
        }
        now = userCalendar.dateComponents([.day], from: Date(), to: userCalendar.date(from: nextTimeNamesDate)!)
        return now.day! + 1
    }

}
//MARK: - TableView DataSource, Delegate
extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource{
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for:  indexPath) as! SubjectTableViewCell
        let cellSortData = sortNamesToMonths[indexPath.section][indexPath.row]
        
        cell.titleLabel.text = cellSortData.name
        cell.dateLabel.text = "\(cellSortData.day). \(cellSortData.month)"
        
        if cellSortData.male{
            cell.profilImage.image = UIImage(named: "Male_icon")
        }else if cellSortData.female{
            cell.profilImage.image = UIImage(named: "Female_icon")
        }else if cellSortData.event{
            cell.profilImage.image = UIImage(named: "Event_icon")
        }
        
        if daysCountDown(indexPath) == 0{
            cell.daysCount.text = "Today"
        }else{
            cell.daysCount.text = "in \(daysCountDown(indexPath)) days"
        }
        
        
        return cell
    }
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortNamesToMonths[section].count
    }
     func numberOfSections(in tableView: UITableView) -> Int {
        return monthsTitles.count
    }
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if sortNamesToMonths[section].count != 0{
            if section < monthsTitles.count{
                return monthsTitles[section]
            }else{
                return nil
            }
        }else{
            return nil
        }
       
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let localData = realmData{
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            let view = ShowSubjectsViewController(collectionViewLayout: layout)
            view.dataSubjects = Array(localData.filter("name == %@", sortNamesToMonths[indexPath.section][indexPath.row].name))
            view.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(view, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
     func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favorite = UIContextualAction(style: .destructive, title: nil) { (action, view, success) in
            let favoriteSubject = self.sortNamesToMonths[indexPath.section][indexPath.row]
            try! self.realm.write{
                self.realm.delete(favoriteSubject)
                self.getData()
                self.tableView.reloadData()
            }
            
            var second = 3
            self.setView(view: self.infoLabel, hidden: false)
            Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true) { (timer) in

                if second > 0{
                    second -= 1
                }else{
                    self.setView(view: self.infoLabel, hidden: true)
                    timer.invalidate()
                }
            }
            success(true)
        }
        favorite.title = "Delete"
        
        let configuration = UISwipeActionsConfiguration(actions: [favorite])
        configuration.performsFirstActionWithFullSwipe = true
        
        return configuration
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = K.myRedColor
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .white
        header.textLabel?.font = UIFont(name: "EuphemicalUCAS", size: 12)
    }
}
//MARK: - Extension FavoriteViewController
extension FavoriteViewController{
    fileprivate func getData(){
        if let myData = realmData{
            sortNamesToMonths = SortNamesToMonths(myData).sortDataName()
            monthsTitles = K.months
        }
    }
    fileprivate func setView(view: UIView, hidden: Bool) {
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            view.isHidden = hidden
        })
    }
}
