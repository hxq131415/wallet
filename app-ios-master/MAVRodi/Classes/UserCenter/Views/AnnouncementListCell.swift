//
//  AnnouncementListCell.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/19.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit

class AnnouncementListCell: UITableViewCell {
    
    @IBOutlet weak var dateTimeLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var reminderView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        reminderView.backgroundColor = UIColorFromRGB(hexRGB: 0xea1919)
        reminderView.layer.masksToBounds = true
        reminderView.layer.cornerRadius = 4
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        reminderView.backgroundColor = UIColorFromRGB(hexRGB: 0xea1919)
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        reminderView.backgroundColor = UIColorFromRGB(hexRGB: 0xea1919)
    }
    
    func configCellWithModel(model: AnnouncementListModel) {
        
        titleLbl.text = model.title
        dateTimeLbl.text = model.dateStr
        reminderView.isHidden = model.is_read
        
        switch model.type {
        case 1:
            typeLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: UserCenter_announcement_title_key)
        case 2:
            typeLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: AnnouncementListPage_cell_title_key)
        default:
            typeLbl.text = nil
            break
        }
    }
    
    
}
