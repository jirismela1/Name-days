//
//  CalendarViewController.swift
//  Name-days
//
//  Created by Jirka  on 19/05/2020.
//  Copyright © 2020 JirkaSmela. All rights reserved.
//

import UIKit
import RealmSwift

fileprivate enum TableDifferentScene{
    case today, differentDay, differentMonth
    // today - loadview, todayDateAction, if selected month is same as today month
    // differendDay - selected in calendar different day than today day
    // differentMonth - if selected month is different than today month
}

class CalendarViewController: UIViewController {
    
    fileprivate var numberOfDaysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
    
    fileprivate var currentMonth: Int = 0
    fileprivate var currentYear: Int = 0
    fileprivate var currentDay: Int = 0
    fileprivate var firstWeekDayOfMonth: Int = 0
    
    fileprivate let localRealm: Realm = {
        let config = Realm.Configuration(fileURL: Bundle.main.url(forResource: "Subject", withExtension: "realm"),readOnly: true)
        let realm = try! Realm(configuration: config)
        return realm
    }()
    
    fileprivate var localRealmData: Results<Subject>?
    
    fileprivate var todayNames = [Subject]()
    fileprivate var namesBySelectedDayInCalendar = [Subject]()
    
    fileprivate var numberSelectedDayInCalendar = 0
    fileprivate var typeOfTableViewScene = TableDifferentScene.today
    fileprivate var collectionDays = [Int]()
    fileprivate var todayDate: TodayDate?
    
    
    override func viewDidLoad() {
        localRealmData = localRealm.objects(Subject.self)
        
        currentMonth = Calendar.current.component(.month, from: Date())
        currentYear = Calendar.current.component(.year, from: Date())
        currentDay = Calendar.current.component(.day, from: Date())
        
        todayDate = TodayDate(currentDay, currentMonth, currentYear)
        
        firstWeekDayOfMonth = getFirstWeekDay()
        
        if currentMonth == 2 && currentYear % 4 == 0{
            numberOfDaysInMonth[currentMonth - 1] = 29
        }
        
        tableTitleDate.delegate = self
        tableTitleDate.dataSource = self
        monthSet.delegate = self
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButtonItem
        myCollectionView.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        tableTitleDate.register(CalendarListTableViewCell.self, forCellReuseIdentifier: "tableCell")
        
        getSortRealmData()
        setupView()
    }
    
    
    
//MARK: - Views & SetupView
    
    fileprivate let monthSet: MonthView = {
        let view = MonthView()
        view.backgroundColor = K.myRedColor
        view.layer.applySketchShadow(color: K.myDarkRoseColor,alpha: 1 ,x: 3, y: 2, blur: 3)
        view.layer.cornerRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate let weekDays: WeekDays = {
        let weekView = WeekDays()
        weekView.translatesAutoresizingMaskIntoConstraints = false
        return weekView
    }()
    
    fileprivate let myCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    fileprivate let tableTitleDate: UITableView = {
        let table = UITableView()
        let footView = UIView()
        footView.frame.size = CGSize(width: 315, height: 4)
        table.tableFooterView = footView
        table.showsVerticalScrollIndicator = false
        table.showsHorizontalScrollIndicator = false
        table.rowHeight = 44
        table.separatorStyle = .none
        table.backgroundColor = .clear
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    fileprivate let moreCellsArrow: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setBackgroundImage(UIImage(systemName: "arrow.down"), for: .normal)
        btn.isEnabled = true
        btn.tintColor = UIColor(named:"text")
        return btn
    }()
    
    fileprivate let titleTable: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont(name: "EuphemiaUCAS", size: 18)
        title.textColor = UIColor(named: "text")
        title.textAlignment = .center
        return title
    }()
    
    fileprivate let topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = K.myDarkRed
        return view
    }()
    
    fileprivate let calendarUIView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = K.myRedColor
        view.layer.applySketchShadow(color: K.myDarkRoseColor,alpha: 1 ,x: 3, y: 2, blur: 3)
        view.layer.cornerRadius = 4
            
        return view
    }()
    
   fileprivate func setupView(){
    
    
    let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
    leftSwipe.direction = .left
    
    let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
    rightSwipe.direction = .right
    
    calendarUIView.addGestureRecognizer(leftSwipe)
    calendarUIView.addGestureRecognizer(rightSwipe)
    
    view.backgroundColor = UIColor(named: "backgroundColor")
    title = "Calendar"
    navigationController?.navigationBar.tintColor = .white
    navigationController?.navigationBar.barStyle = .black
    navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Cochin", size: 38)!, NSAttributedString.Key.foregroundColor: UIColor.white]
    
    navigationController?.navigationBar.setTitleVerticalPositionAdjustment(6, for: UIBarMetrics.default)
    
    let todayBarButtonItem = UIBarButtonItem(title: "Today", style: .plain, target: self, action: #selector(todayDateAction))
    
    navigationItem.rightBarButtonItem = todayBarButtonItem
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.isTranslucent = true
    
    view.addSubview(topView)
    topView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    topView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    topView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    topView.heightAnchor.constraint(equalToConstant: 140).isActive = true
    
    topView.addSubview(monthSet)
    monthSet.topAnchor.constraint(equalTo: topView.topAnchor, constant: 88).isActive = true
    monthSet.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
    monthSet.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
    monthSet.heightAnchor.constraint(equalToConstant: 48).isActive = true
    
    view.addSubview(calendarUIView)
    calendarUIView.topAnchor.constraint(equalTo: monthSet.bottomAnchor,constant: 4).isActive = true
    calendarUIView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
    calendarUIView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
    calendarUIView.heightAnchor.constraint(equalToConstant: 313).isActive = true
    
    calendarUIView.addSubview(weekDays)
    weekDays.topAnchor.constraint(equalTo: calendarUIView.topAnchor,constant: 4).isActive = true
    weekDays.leadingAnchor.constraint(equalTo: calendarUIView.leadingAnchor).isActive = true
    weekDays.trailingAnchor.constraint(equalTo: calendarUIView.trailingAnchor).isActive = true
    weekDays.heightAnchor.constraint(equalToConstant: 21).isActive = true

    calendarUIView.addSubview(myCollectionView)
    myCollectionView.topAnchor.constraint(equalTo: weekDays.bottomAnchor, constant: 4).isActive = true
    myCollectionView.leadingAnchor.constraint(equalTo: calendarUIView.leadingAnchor,constant: 4).isActive = true
    myCollectionView.trailingAnchor.constraint(equalTo: calendarUIView.trailingAnchor,constant: -4).isActive = true
    myCollectionView.heightAnchor.constraint(equalToConstant: 280).isActive = true
    
    view.addSubview(titleTable)
    titleTable.topAnchor.constraint(equalTo: calendarUIView.bottomAnchor, constant: 16).isActive = true
    titleTable.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    titleTable.widthAnchor.constraint(greaterThanOrEqualToConstant: 200).isActive = true
    
    view.addSubview(tableTitleDate)
    tableTitleDate.topAnchor.constraint(equalTo: titleTable.bottomAnchor,constant: 8).isActive = true
    tableTitleDate.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 30).isActive = true
    tableTitleDate.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -26).isActive = true
    tableTitleDate.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32).isActive = true
    
    view.addSubview(moreCellsArrow)
    moreCellsArrow.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -10).isActive = true
    moreCellsArrow.heightAnchor.constraint(equalToConstant: 30).isActive = true
    moreCellsArrow.leadingAnchor.constraint(equalTo: tableTitleDate.trailingAnchor,constant: 5).isActive = true
    moreCellsArrow.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -5).isActive = true

    }
    
    @objc func todayDateAction(){
        if let today = todayDate{
            currentMonth = today.month
            currentYear = today.year
            currentDay = today.day
            //copy saved today date to current month, year, day
        }
        monthSet.currentMonthIndex = currentMonth - 1
        monthSet.currentYear = currentYear
        monthSet.monthTitle.text = "\(K.months[monthSet.currentMonthIndex]) \(monthSet.currentYear)"
        // set title on today date
            
        typeOfTableViewScene = TableDifferentScene.today
        
        collectionDays.removeAll()
        
        firstWeekDayOfMonth = getFirstWeekDay()
        getSortRealmData()
        myCollectionView.reloadData()
        tableTitleDate.reloadData()
    }
    
    @objc func handleSwipe(sender: UISwipeGestureRecognizer){
        if sender.state == .ended{
            switch sender.direction{
            case .right:
                monthSet.previousMonth()
            case .left:
                monthSet.nextMonth()
            default:
                break
            }
        }
    }
}
//MARK: - MonthViewDelegate
extension CalendarViewController: MonthViewDelegate{
    
     func didChanceMonth(monthIndex: Int, year: Int) {
        currentMonth = monthIndex + 1
        currentYear = year
        
        if monthIndex == 1{
            if currentYear % 4 == 0{
                numberOfDaysInMonth[monthIndex] = 29
            }else{
                numberOfDaysInMonth[monthIndex] = 28
            }
        }
        
        if currentMonth == todayDate?.month, currentYear == todayDate?.year{
            typeOfTableViewScene = .today
        }else{
            typeOfTableViewScene = .differentMonth
            titleTable.text = ""
        }
        
        collectionDays.removeAll()
        firstWeekDayOfMonth = getFirstWeekDay()
        getSortRealmData()
        myCollectionView.reloadData()
        tableTitleDate.reloadData()
    }
    
}
//MARK: - CalendarViewController
extension CalendarViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CalendarCollectionViewCell
        cell.layer.cornerRadius = (collectionView.frame.width / 7 - 8) / 2
        cell.backgroundColor = .clear
        
        if indexPath.row <= firstWeekDayOfMonth - 2{
            cell.isHidden = true
            // hide first week days before first day of month
        }else{
            cell.isHidden = false
            let calculateDay = indexPath.row - firstWeekDayOfMonth + 2
            collectionDays.append(calculateDay)
            cell.dayCell.text = "\(calculateDay)"
            weekendColor(indexPath, cell)
            if typeOfTableViewScene == TableDifferentScene.today,let today = todayDate, calculateDay == today.day{
                collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .bottom)
                cell.backgroundColor = K.myDarkRed
                cell.dayCell.textColor = .white
                numberSelectedDayInCalendar = calculateDay
                titleTable.text = "Today is \(K.returnTodayDate(indexDay: indexPath.row, day: today.day, month: K.months[today.month], year: today.year))"
                return cell
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfDaysInMonth[currentMonth - 1] + firstWeekDayOfMonth - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 7 - 8
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        numberSelectedDayInCalendar = collectionDays[indexPath.row - firstWeekDayOfMonth + 1]
        getSortRealmData()
        typeOfTableViewScene = .differentDay
        // talbeView scene change on different day
        let cell = collectionView.cellForItem(at: indexPath) as! CalendarCollectionViewCell
        cell.backgroundColor = K.myDarkRed
        
        let preText = numberSelectedDayInCalendar == todayDate?.day ? "Today is " : ""
        titleTable.text = preText + K.returnTodayDate(indexDay: indexPath.row, day: numberSelectedDayInCalendar, month: K.months[currentMonth - 1], year: currentYear)
        
        cell.dayCell.textColor = .white
        tableTitleDate.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CalendarCollectionViewCell
        cell.backgroundColor = .clear
        weekendColor(indexPath, cell)
    }
}

//MARK: - TableView DataSource, Delegate
extension CalendarViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let localData = localRealmData{
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            let view = ShowSubjectsViewController(collectionViewLayout: layout)
            let filteredLocalData = localData.filter("day == %@ AND month == %@", numberSelectedDayInCalendar,K.months[currentMonth - 1])
            // filtered names which are in selected day and month
            view.dataSubjects = sortArray(data: filteredLocalData, differentScreen: typeOfTableViewScene, indexPath)
            view.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(view, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.4) {
            cell.transform = CGAffineTransform.identity
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableTitleDate.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! CalendarListTableViewCell

        if typeOfTableViewScene == .today{
            cell.titleLabel.text = todayNames[indexPath.section].name
        }else{
            cell.titleLabel.text = namesBySelectedDayInCalendar[indexPath.section].name
        }
            
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // show different number of row if is selected today or different day date in calendar
        if typeOfTableViewScene == .today{
            moreCellsArrow.isHidden = todayNames.count > 4 ? false : true
            return  todayNames.count
        }else if typeOfTableViewScene == .differentDay{
            moreCellsArrow.isHidden = namesBySelectedDayInCalendar.count > 4 ? false : true
            return namesBySelectedDayInCalendar.count
        }else{
            return 0
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 4
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
    
}

//MARK: - Extension Date and String
//get first day of the month
extension Date {
    
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    
    var firstDayOfTheMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
    }
}

//get date from string
extension String {
    
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var date: Date? {
        return String.dateFormatter.date(from: self)
    }
}
//MARK: - Extension CalendarViewController
extension CalendarViewController{
    
    fileprivate func getFirstWeekDay() -> Int {
        let day = ("\(currentYear)-\(currentMonth)-01".date?.firstDayOfTheMonth.weekday)!
        //return 1..7
        switch day{
        case 2...7:
            return day - 1
        default:
            return 7
        }
    }
    
    fileprivate func getSortRealmData(){
        if let localData = localRealmData{
            let sortNamesToMonths = SortNamesToMonths(localData)
            todayNames = sortNamesToMonths.namesOfToday(month: currentMonth - 1, day: currentDay)
            namesBySelectedDayInCalendar = sortNamesToMonths.selectDay(month: currentMonth - 1, day: numberSelectedDayInCalendar)
        }
    }
    
    // change order of names, on first place is name which is selected in tableView
    fileprivate func sortArray(data: Results<Subject>, differentScreen: TableDifferentScene, _ indexPath: IndexPath) -> [Subject]{
        var arrayData = Array(data)
        for (index,element) in data.enumerated(){
            if differentScreen == .today{ // filter for different source of data
                if element.name == todayNames[indexPath.section].name{
                    let remo = arrayData.remove(at: index)
                    arrayData.insert(remo, at: 0)
                }
            }else{
                if element.name == namesBySelectedDayInCalendar[indexPath.section].name{
                    let remo = arrayData.remove(at: index)
                    arrayData.insert(remo, at: 0)
                }
            }
        }
        // return data for pushing to new view controller
        return arrayData
    }
    
    fileprivate func weekendColor(_ indexPath: IndexPath, _ cell: CalendarCollectionViewCell){
        switch indexPath.row{
        case 5,6,12,13,19,20,26,27,33,34:
            cell.dayCell.textColor = .white
        default:
            cell.dayCell.textColor = .black
        }
    }
}
extension CALayer {
    func applySketchShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4,
        spread: CGFloat = 0)
    {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}
