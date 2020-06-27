//
//  HomeTableViewCell.swift
//  Calendar
//
//  Test Project
//

import UIKit
import CoreLocation

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var customer: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var tasks: UILabel!
    @IBOutlet weak var arrivalTime: UILabel!
    @IBOutlet weak var destination: UILabel!
    @IBOutlet weak var timeRequired: UILabel!
    @IBOutlet weak var distance: UILabel!

	var homeCellViewModel: HomeCellViewModel! {
		didSet {
			self.customer.text = homeCellViewModel.houseOwnerName
			self.status.text = homeCellViewModel.visitStatus?.rawValue
			self.tasks.text = homeCellViewModel.taskTitle
			self.arrivalTime.text = homeCellViewModel.startTime
			self.destination.text = homeCellViewModel.houseAddress
			self.timeRequired.text = homeCellViewModel.timeInMinutes
			self.distance.text = homeCellViewModel.distance

			//Update Status Color
			guard let state = homeCellViewModel.visitStatus else {
				return
			}
			switch state {
			case VisitState.Done:
				self.statusView.backgroundColor = UIColor.doneOption
			case VisitState.InProgress:
				self.statusView.backgroundColor = UIColor.inProgressOption
			case VisitState.ToDo:
				self.statusView.backgroundColor = UIColor.todoOption
			case VisitState.Rejected:
				self.statusView.backgroundColor = UIColor.rejectedOption
			}
		}
	}

    override func awakeFromNib() {
        super.awakeFromNib()
        self.bgView.layer.cornerRadius = 10.0
        self.statusView.layer.cornerRadius = self.status.frame.height / 2.0
        self.statusView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    }

}
