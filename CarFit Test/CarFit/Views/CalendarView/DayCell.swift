//
//  DayCell.swift
//  Calendar
//
//  Test Project
//

import UIKit

class DayCell: UICollectionViewCell {

	var dayCellViewModel:DayCellViewModel! {
		didSet {
			self.day.text = dayCellViewModel.day
			self.weekday.text = dayCellViewModel.weekDay
		}
	}
	
    @IBOutlet weak var dayView: UIView!
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var weekday: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.dayView.layer.cornerRadius = self.dayView.frame.width / 2.0
        self.dayView.backgroundColor = .clear
    }

	override var isSelected: Bool {
        didSet {
			self.dayView.backgroundColor = isSelected ? UIColor.daySelected : .clear
			self.layoutIfNeeded()
        }
    }
}
