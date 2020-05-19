//
//  SearchViewController.swift
//  Name-days
//
//  Created by Jirka  on 19/05/2020.
//  Copyright © 2020 JirkaSmela. All rights reserved.
//


import UIKit
import RealmSwift

class SearchViewController: UIViewController{

    fileprivate let localRealm: Realm = {
        let config = Realm.Configuration(fileURL: Bundle.main.url(forResource: "Subject", withExtension: "realm"),readOnly: true)
        let realm = try! Realm(configuration: config)
        return realm
    }()
    
    fileprivate var realm = try! Realm()
    
    fileprivate var localRealmData: Results<Subject>?
    fileprivate var dataRealmFilter: Results<Subject>?

    fileprivate var sortNamesToMonths = [[Subject]]()
    fileprivate var monthsTitles = [String]()
    
    fileprivate let mySearchController = UISearchController(searchResultsController: nil)
    
    fileprivate var isSearchBarEmtpy: Bool {
        return mySearchController.searchBar.text?.isEmpty ?? true
    }
    fileprivate var isFiltering: Bool {
        // start filtering after will be active and contain some text
        return mySearchController.isActive && !isSearchBarEmtpy
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localRealmData = localRealm.objects(Subject.self)
        getSortRealmData()
        
        // need !nil dataFilter
        dataRealmFilter = localRealm.objects(Subject.self).filter("FALSEPREDICATE")
        
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButtonItem
        
        myTable.delegate = self
        myTable.dataSource = self
        viewSetup()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage(color: K.myDarkRed), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
    }
 
//MARK: - Views & SetupView
    
    fileprivate let infoLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = ""
        lbl.textAlignment = .center
        lbl.textColor = .white
        lbl.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        lbl.layer.cornerRadius = 7
        lbl.layer.masksToBounds = true
        return lbl
    }()
    
    fileprivate let myTable: UITableView = {
        let table = UITableView()
        table.backgroundColor = UIColor(named: "backgroundColor")
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(SubjectTableViewCell.self, forCellReuseIdentifier: "Cell")
        return table
    }()
    
    
    
    fileprivate func viewSetup(){

        self.title = "List"
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .black
        mySearchController.searchBar.backgroundColor = K.myDarkRed
        mySearchController.searchBar.tintColor = .white
        mySearchController.searchBar.barTintColor = .white
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(color: K.myDarkRed), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Cochin", size: 38)!, NSAttributedString.Key.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.setTitleVerticalPositionAdjustment(6, for: UIBarMetrics.default)
        
        navigationItem.searchController = mySearchController
        navigationItem.hidesSearchBarWhenScrolling = false
        mySearchController.searchResultsUpdater = self
        mySearchController.searchBar.placeholder = "Search Name or Event"
        mySearchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        view.addSubview(myTable)
        myTable.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        myTable.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        myTable.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        myTable.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        myTable.keyboardDismissMode = .onDrag
        
        
        myTable.addSubview(infoLabel)
        infoLabel.isHidden = true
        infoLabel.centerXAnchor.constraint(equalTo: myTable.centerXAnchor).isActive = true
        infoLabel.widthAnchor.constraint(equalToConstant: 310).isActive = true
        infoLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -40).isActive = true
        
    }
}
//MARK: - SearchViewController
extension SearchViewController: UISearchResultsUpdating{
    
    
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text{
            dataRealmFilter = localRealm.objects(Subject.self).filter("name CONTAINS [cd] %@", text)
            myTable.reloadData()
        }
    }
}
//MARK: - UITableView DataSource, Delegate
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedRow = sortNamesToMonths[indexPath.section][indexPath.row]
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = ShowSubjectsViewController(collectionViewLayout: layout)
    
        if let filterData = dataRealmFilter, let localData = localRealmData{
            
            var selectedRowSubject: Subject {
               let array =  Array(filterData)
                return array[indexPath.row]
            }
            
            if isFiltering{
                let filteredLocalData = localData.filter("day == %@ AND month == %@", selectedRowSubject.day,selectedRowSubject.month)
                
                 view.dataSubjects = sortArray(data: filteredLocalData, indexPath,name: selectedRowSubject.name)
            }else{
                let filteredLocalData = localData.filter("day == %@ AND month == %@", selectedRow.day, selectedRow.month)
                view.dataSubjects = sortArray(data: filteredLocalData, indexPath,name: selectedRow.name)
            }
        }
        view.hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(view, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isFiltering{
            return K.searchTitle[section]
        }else{
            if section < monthsTitles.count{
                return monthsTitles[section]
            }else{
                return nil
            }
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        if isFiltering{
            return K.searchTitle.count
        }else{
            return monthsTitles.count
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering{
            if let data = dataRealmFilter{
                return data.count
            }
            return 1
        }else{
            return sortNamesToMonths[section].count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SubjectTableViewCell
        let sortNames = sortNamesToMonths[indexPath.section][indexPath.row]

        guard let cellDataFilter = dataRealmFilter else {
            cell.titleLabel.text = "Error cellDAtaFilter"
            return cell}
        
        let person = isFiltering ? cellDataFilter[indexPath.row] : sortNames
        
        cell.titleLabel.text = person.name
        cell.dateLabel.text = "\(person.day). \(person.month)"
        cell.daysCount.isHidden = true
    
        if person.male{
            cell.profilImage.image = UIImage(named: "Male_icon")
        }else if person.female{
            cell.profilImage.image = UIImage(named: "Female_icon")
        }else if person.event{
            cell.profilImage.image = UIImage(named: "Event_icon")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favorite = UIContextualAction(style: .normal, title: nil) { (action, view, success) in
            var favoriteSubject = Subject()
            if self.isFiltering{
                guard let filterData = self.dataRealmFilter else {return}
                let rowSubject = Array(filterData)
                favoriteSubject = rowSubject[indexPath.row]
            }else{
                favoriteSubject = self.sortNamesToMonths[indexPath.section][indexPath.row]
            }
            
            
            let containDatabase = self.realm.objects(Subject.self).filter("name == %@", favoriteSubject.name)
            
            if containDatabase.count == 0{
                self.infoLabel.text = "Add to Favorite list"
                try! self.realm.write{
                    self.realm.create(Subject.self, value: favoriteSubject)
                }
            }else{
                self.infoLabel.text = "Already added"
            }
            
            var second = 3
            self.setView(view: self.infoLabel, hidden: false) // animation
            Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true) { (timer) in
                
                if second > 0{
                    second -= 1
                }else{
                    self.setView(view: self.infoLabel, hidden: true) // animation
                    timer.invalidate()
                }
            }
            success(true)
        }
        favorite.backgroundColor = #colorLiteral(red: 0.9786494007, green: 0.6374411387, blue: 0, alpha: 1)
        favorite.image = UIImage(systemName: "star")

        let configuration = UISwipeActionsConfiguration(actions: [favorite])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = K.myRedColor
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .white
        header.textLabel?.font = UIFont(name: "EuphemicalUCAS", size: 12)
    }

}

//MARK: - Extension SearchViewController
extension SearchViewController{
    fileprivate func getSortRealmData(){
        if let localData = localRealmData{
            sortNamesToMonths = SortNamesToMonths(localData).sortDataName()
            monthsTitles = K.months
        }
    }
    fileprivate func setView(view: UIView, hidden: Bool) {
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            view.isHidden = hidden
        })
    }
    // change order of names, on first place is name which is selected in tableView
    fileprivate func sortArray(data: Results<Subject>, _ indexPath: IndexPath, name: String) -> [Subject]{
        var arrayData = Array(data)
        for (index,element) in data.enumerated(){
                if element.name == name{
                    let remo = arrayData.remove(at: index)
                    arrayData.insert(remo, at: 0)
                }
            }
        // return data for pushing to new view controller
        return arrayData
    }

}

extension UIImage {
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}
