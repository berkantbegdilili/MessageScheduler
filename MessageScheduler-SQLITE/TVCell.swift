//
//  TVCell.swift
//  MessageScheduler-SQLITE
//
//  Created by Berkant Beğdilili on 18.05.2020.
//  Copyright © 2020 Berkant Beğdilili. All rights reserved.
//

import UIKit

class TVCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//     Hücre Görünümü
    let cellView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(displayP3Red: 0.543973, green: 0.127511, blue: 0.10608, alpha: 1)
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let phoneNo: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let message: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let date: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupView(){
        addSubview(cellView)
        cellView.addSubview(phoneNo)
        cellView.addSubview(message)
        cellView.addSubview(date)
        self.selectionStyle = .none

        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            cellView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            cellView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])

        phoneNo.heightAnchor.constraint(equalToConstant: 200).isActive = true
        phoneNo.widthAnchor.constraint(equalToConstant: 300).isActive = true
        phoneNo.centerYAnchor.constraint(equalTo: cellView.centerYAnchor,constant: -20).isActive = true
        phoneNo.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 20).isActive = true

        message.heightAnchor.constraint(equalToConstant: 200).isActive = true
        message.widthAnchor.constraint(equalToConstant: 300).isActive = true
        message.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
        message.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 20).isActive = true

        date.heightAnchor.constraint(equalToConstant: 200).isActive = true
        date.widthAnchor.constraint(equalToConstant: 300).isActive = true
        date.centerYAnchor.constraint(equalTo: cellView.centerYAnchor, constant: 20).isActive = true
        date.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 20).isActive = true
    }

}
