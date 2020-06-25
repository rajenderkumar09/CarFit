//
//  ViewController.swift
//  Calendar
//
//  Test Project
//

import UIKit

class HomeViewController: UIViewController, AlertDisplayer {

	var calendarListViewModel = CalendarListViewModel()

	lazy var workOrderTableTopConstraint = self.view.constraints.first { (constraint) -> Bool in
		return constraint.identifier == "WorkOrderTableTopConstraint"
	}

	lazy var calendarViewTopConstraint = self.view.constraints.first { (constraint) -> Bool in
		return constraint.identifier == "CalendarViewTopConstraint"
	}

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

		//Initially load data for current date
		calendarListViewModel.loadData(date: Date().toString(format: "yyyy-MM-dd"))
		self.navBar.topItem?.title = "I DAG"
    }
    
    //MARK:- Add calender to view
    private func addCalendar() {
        if let calendar = CalendarView.addCalendar(self.calendar) {
            calendar.delegate = self
        }
    }

    //MARK:- UI setups
    private func setupUI() {
        self.navBar.transparentNavigationBar()
        let nib = UINib(nibName: self.cellID, bundle: nil)
        self.workOrderTableView.register(nib, forCellReuseIdentifier: self.cellID)
        self.workOrderTableView.rowHeight = UITableView.automaticDimension
        self.workOrderTableView.estimatedRowHeight = 170

		//Set constrains initial values
		self.workOrderTableTopConstraint?.constant = 20
		self.calendarViewTopConstraint?.constant = -self.calendarView.frame.height
    }
    
    //MARK:- Show calendar when tapped, Hide the calendar when tapped outside the calendar view
    @IBAction func calendarTapped(_ sender: UIBarButtonItem) {
        animateCalendarView()
    }

	func setupTapGesture() {
		let tap = UITapGestureRecognizer(target: self, action: #selector(animateCalendarView))
		tap.name = "CalendarViewTapGesture"
		self.workOrderTableView.addGestureRecognizer(tap)
	}

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

	@objc func animateCalendarView() {

		//Remove tap gesture
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
		return calendarListViewModel.data.count
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath) as! HomeTableViewCell
		cell.homeCellViewModel = calendarListViewModel.data[indexPath.row]
        return cell
    }
}

//MARK:- Get selected calendar date
extension HomeViewController: CalendarDelegate {
    
    func getSelectedDate(_ date: String) {

		calendarListViewModel.loadData(date: date)
		self.workOrderTableView.reloadData()

		if date == Date().toString(format: "yyyy-MM-dd") {
			self.navBar.topItem?.title = "I dag"
		} else {
			self.navBar.topItem?.title = date
		}
    }
}
