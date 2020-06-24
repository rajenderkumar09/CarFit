//
//  ViewController.swift
//  Calendar
//
//  Test Project
//

import UIKit

class HomeViewController: UIViewController, AlertDisplayer {

    @IBOutlet var navBar: UINavigationBar!
	@IBOutlet var calendarView: UIView! {
		didSet {
			calendarView.isHidden = true
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
    }
    
    //MARK:- Show calendar when tapped, Hide the calendar when tapped outside the calendar view
    @IBAction func calendarTapped(_ sender: UIBarButtonItem) {
        animateCalendarView()
    }

	@objc func animateCalendarView() {

		self.removeTapGesture()
		guard self.calendarView.isHidden else {
			self.calendarView.isHidden = true
			UIView.animate(withDuration: 0.8, animations: {
				self.calendarView.transform = CGAffineTransform(translationX: 1, y: 0)
			}) { (completed) in
				self.calendarView.isHidden = true
			}
			return
		}
		self.setupTapGesture()
		self.calendarView.isHidden = false
		UIView.animate(withDuration: 0.5) {
			self.calendarView.transform = .identity
		}
	}

	func setupTapGesture() {
		let tap = UITapGestureRecognizer(target: self, action: #selector(animateCalendarView))
		tap.name = "CalendarViewTap"
		self.workOrderTableView.addGestureRecognizer(tap)
	}

	func removeTapGesture() {
		//Remove added tap gesture
		let gesture = self.workOrderTableView.gestureRecognizers?.first(where: { (gesture) -> Bool in
			return gesture.name == "CalendarViewTap"
		})
		guard let tapGesture = gesture else {
			return
		}
		workOrderTableView.removeGestureRecognizer(tapGesture)
	}
}


//MARK:- Tableview delegate and datasource methods
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath) as! HomeTableViewCell
        return cell
    }
    
}

//MARK:- Get selected calendar date
extension HomeViewController: CalendarDelegate {
    
    func getSelectedDate(_ date: String) {
        
    }
    
}
