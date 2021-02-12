//
//  ConnectionView.swift
//  NuerogleeApp
//
//  Created by User on 2/12/21.
//

import UIKit

class ConnectionView: UIView {
    var dragStarted: (() -> Void)?
    var dragChanged: (() -> Void)?
    var dragFinished: (() -> Void)?
    var touchStartPos = CGPoint.zero
    weak var after: ConnectionView!
    private weak var covidBoX: BoxView?
    var nameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        nameLabel.backgroundColor = UIColor.yellow
        nameLabel.textColor = .red
        nameLabel.frame = CGRect(origin: self.frame.origin, size: CGSize(width:  self.frame.size.width, height:  self.frame.size.height))
        self.addSubview(nameLabel)
    }
    override func layoutSubviews() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: self.topAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        touchStartPos = touch.location(in: self)

        touchStartPos.x -= frame.width / 2
        touchStartPos.y -= frame.height / 2

        transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
        superview?.bringSubviewToFront(self)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let point = touch.location(in: superview)

        center = CGPoint(x: point.x - touchStartPos.x, y: point.y - touchStartPos.y)
        dragChanged?()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        transform = .identity
        dragFinished?()
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
}
