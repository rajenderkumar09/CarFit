//
//  CalendarView.swift
//  Calendar
//
//  Test Project
//

import UIKit

protocol CalendarDelegate: class {
    func getSelectedDate(_ date: String)
}

class CalendarView: UIView {

	var calendarViewModel:CalendarViewModel = CalendarViewModel()

    @IBOutlet weak var monthAndYear: UILabel!
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var daysCollectionView: UICollectionView!
    
    private let cellID = "DayCell"
    weak var delegate: CalendarDelegate?

    //MARK:- Initialize calendar
    private func initialize() {
        let nib = UINib(nibName: self.cellID, bundle: nil)
        self.daysCollectionView.register(nib, forCellWithReuseIdentifier: self.cellID)
        self.daysCollectionView.delegate = self
        self.daysCollectionView.dataSource = self
		if let indexPath = calendarViewModel.selectedIndexPath {
			self.daysCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
		}

		//Bind for updates
		calendarViewModel.didChange = self.didChange
    }
    
    //MARK:- Change month when left and right arrow button tapped
    @IBAction func arrowTapped(_ sender: UIButton) {
		let dateAdjustment = sender == rightBtn ? 1 : -1
		calendarViewModel.changeMonth(adjustment: dateAdjustment)
    }

	func didChange(date:String){

		self.daysCollectionView.reloadData()
		self.monthAndYear.text = calendarViewModel.monthAndYear
		self.delegate?.getSelectedDate(date)

		if let indexPath = calendarViewModel.selectedIndexPath {
			self.daysCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
		}
	}
}

//MARK:- Calendar collection view delegate and datasource methods
extension CalendarView: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return calendarViewModel.numberOfDays
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellID, for: indexPath) as! DayCell

		//Set Cell view model
		let day = indexPath.item + 1
		let dayCellViewModel = DayCellViewModel(date: calendarViewModel.date(for: day))
		cell.dayCellViewModel = dayCellViewModel

		//Check for selected Date
		cell.isSelected = dayCellViewModel.cellDate == calendarViewModel.dateSelected

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let cell = collectionView.cellForItem(at: indexPath) as? DayCell else {
			return
		}
		calendarViewModel.updateSelectedDate(date: cell.dayCellViewModel.cellDate)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}

//MARK:- Add calendar to the view
extension CalendarView {
    
    public class func addCalendar(_ superView: UIView) -> CalendarView? {
        var calendarView: CalendarView?
        if calendarView == nil {
            calendarView = UINib(nibName: "CalendarView", bundle: nil).instantiate(withOwner: self, options: nil).last as? CalendarView
            guard let calenderView = calendarView else { return nil }
            calendarView?.frame = CGRect(x: 0, y: 0, width: superView.bounds.size.width, height: superView.bounds.size.height)
            superView.addSubview(calenderView)
            calenderView.initialize()
            return calenderView
        }
        return nil
    }
    
}
