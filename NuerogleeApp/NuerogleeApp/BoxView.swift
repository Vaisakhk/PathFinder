//
//  BoxView.swift
//  NuerogleeApp
//
//  Created by User on 2/12/21.
//
import UIKit

class BoxView: UIView {
    var nameLabel = UILabel()
    weak var after: BoxView!
    weak var connectedUser: ConnectionView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        nameLabel.backgroundColor = UIColor.clear
        nameLabel.textColor = .red
        nameLabel.font = UIFont.boldSystemFont(ofSize: 30)
        nameLabel.textAlignment = .center
        nameLabel.frame = CGRect(origin: self.bounds.origin, size: CGSize(width:  self.bounds.size.width, height:  self.bounds.size.height))
        self.addSubview(nameLabel)
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: self.topAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
}
