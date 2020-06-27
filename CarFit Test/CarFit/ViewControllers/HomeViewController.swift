//
//  ViewController.swift
//  Calendar
//
//  Test Project
//

import UIKit

class HomeViewController: UIViewController, AlertDisplayer {

	//ViewModel for WorkOrder List
	var cleanerListViewModel = CleanerListViewModel()

	//Top margin constraint of WorkOrdertableView
	lazy var workOrderTableTopConstraint = self.view.constraints.first { (constraint) -> Bool in
		return constraint.identifier == "WorkOrderTableTopConstraint"
	}

	//Top margin constraint of CalendarView
	lazy var calendarViewTopConstraint = self.view.constraints.first { (constraint) -> Bool in
		return constraint.identifier == "CalendarViewTopConstraint"
	}

	var refreshControl = UIRefreshControl()

    @IBOutlet var navBar: UINavigationBar!
	@IBOutlet var calendarView: UIView! {
		didSet {
			calendarView.isHidden = true

			var rect = calendarView.frame
			rect.origin.y = -calendarView.frame.height
			calendarView.frame = rect
		}
	}
    @IBOutlet weak var calendar: UIView!
    @IBOutlet weak var calendarButton: UIBarButtonItem!
    @IBOutlet weak var workOrderTableView: UITableView!
    
    private let cellID = "HomeTableViewCell"
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addCalendar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
		self.addUpdateBinder()
		self.loadWorkOrdersData()
    }
    
    //MARK:- Add calender to view
    private func addCalendar() {
        if let calendar = CalendarView.addCalendar(self.calendar) {
            calendar.delegate = self
        }
    }

	func addUpdateBinder() {
		//Set Update handler
		cleanerListViewModel.updateHandler = viewModelDidUpdate(date:)
	}

	func loadWorkOrdersData() {
		//Initially load data for current date
		cleanerListViewModel.loadData(date: Date().toString(format: "yyyy-MM-dd"))
	}

    //MARK:- UI setups
    private func setupUI() {
        self.navBar.transparentNavigationBar()
        let nib = UINib(nibName: self.cellID, bundle: nil)
        self.workOrderTableView.register(nib, forCellReuseIdentifier: self.cellID)
        self.workOrderTableView.rowHeight = UITableView.automaticDimension
        self.workOrderTableView.estimatedRowHeight = 170

		//Setup pull to refresh control
		self.workOrderTableView.refreshControl = refreshControl
		refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)

		//Set constrains initial values
		self.workOrderTableTopConstraint?.constant = 20
		self.calendarViewTopConstraint?.constant = -self.calendarView.frame.height
    }

	/// Method for updating view when view model has been updated
	/// - Parameter date: String date for the selected calendar date
	func viewModelDidUpdate(date:String) {
		self.navBar.topItem?.title = cleanerListViewModel.navigationTitle(for: date)
		self.workOrderTableView.reloadData()
		self.refreshControl.endRefreshing()
	}

	@objc func refresh(_ sender: AnyObject) {
	   // Code to refresh table view
		cleanerListViewModel.refresh()
	}

    //MARK:- Show calendar when tapped, Hide the calendar when tapped outside the calendar view
    @IBAction func calendarTapped(_ sender: UIBarButtonItem) {
        animateCalendarView()
    }

	/// Setup tap gesture to dismiss calendar view when tapped outside of calendar view
	func setupTapGesture() {
		let tap = UITapGestureRecognizer(target: self, action: #selector(animateCalendarView))
		tap.name = "CalendarViewTapGesture"
		self.workOrderTableView.addGestureRecognizer(tap)
	}

	/// Remove tap gesture
	func removeTapGesture() {
		//Remove added tap gesture
		let gesture = self.workOrderTableView.gestureRecognizers?.first(where: { (gesture) -> Bool in
			return gesture.name == "CalendarViewTapGesture"
		})
		guard let tapGesture = gesture else {
			return
		}
		workOrderTableView.removeGestureRecognizer(tapGesture)
	}

	/// Method for displaying or hiding calendar view
	@objc func animateCalendarView() {

		//Remove tap gesture if there is already added, before adding to new one
		self.removeTapGesture()

		//Check CalendarView current state
		guard self.calendarView.isHidden else {
			//Animate CalendarView to hide
			UIView.animate(withDuration: 0.3, animations: {
				self.calendarView.transform = .identity
				self.workOrderTableView.transform = .identity
			}) { (completed) in
				self.calendarView.isHidden = true
			}
			return
		}

		//Setup tap gesture for listening tap on tableview to hide the CalendarView
		self.setupTapGesture()
		self.calendarView.isHidden = false

		//Animate CalendarView to display
		UIView.animate(withDuration: 0.5) {
			self.calendarView.transform = CGAffineTransform(translationX: 0, y: self.calendarView.frame.height)
			self.workOrderTableView.transform = CGAffineTransform(translationX: 0, y: 120)
		}
	}

	//Listen for touches ended to dismiss the calendar view if its being displayed, otherwise ignore
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesEnded(touches, with: event)
		guard self.calendarView.isHidden == false else {
			return
		}
		animateCalendarView()
	}
}


//MARK:- Tableview delegate and datasource methods
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return cleanerListViewModel.numberOfVisits
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath) as! HomeTableViewCell
		cell.homeCellViewModel = cleanerListViewModel.homeCellViewModel(at: indexPath.row)

        return cell
    }
}

//MARK:- Get selected calendar date
extension HomeViewController: CalendarDelegate {
    
    func getSelectedDate(_ date: String) {
		cleanerListViewModel.loadData(date: date)
    }
}
