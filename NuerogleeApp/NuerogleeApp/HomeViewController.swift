//
//  HomeViewController.swift
//  NuerogleeApp
//
//  Created by User on 2/12/21.
//

import UIKit

class HomeViewController: UIViewController {
    var currentLevel = 0
    var boxConnections = [BoxView]()
    var userConnections = [ConnectionView]()
    var boxX = [CGPoint]()
    let renderedLines = UIImageView()
    var resultDict:[String:Bool] = [:]
    var score = 0 {
        didSet {
           print("SCORE: \(score)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        renderedLines.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(renderedLines)
        
        let maximumXValue = view.bounds.maxY/6
        let maximumYValue = view.bounds.maxY/6
        
        boxX.append(CGPoint(x: maximumXValue,y: maximumYValue))
        boxX.append(CGPoint(x: maximumXValue*2,y: maximumYValue*3))
        boxX.append(CGPoint(x: maximumXValue*4,y: maximumYValue*4))
        boxX.append(CGPoint(x: maximumXValue*5,y: maximumYValue*5))
        boxX.append(CGPoint(x: maximumXValue*3,y: maximumYValue*4))
        boxX.append(CGPoint(x: maximumXValue*4,y: maximumYValue*2))
        
        NSLayoutConstraint.activate([
            renderedLines.topAnchor.constraint(equalTo: view.topAnchor),
            renderedLines.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            renderedLines.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            renderedLines.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
    }

    override func viewWillAppear(_ animated: Bool) {
        levelUp()
        loadUsers()
    }
    
    @IBAction func resetButtonAction(_ sender: Any) {
        levelUp()
        loadUsers()
    }
    
    func levelUp() {
        currentLevel += 1
        boxConnections.forEach { $0.removeFromSuperview() }
        boxConnections.removeAll()
        
        for i in 1...(currentLevel + 4 > 6 ? 6 : currentLevel + 4) {
            let boxConnection = BoxView(frame: CGRect(origin: .zero, size: CGSize(width: 80, height: 80)))
            boxConnection.tag = i
            boxConnection.nameLabel.text = "\(i)"
            boxConnection.backgroundColor = .blue
            boxConnection.layer.cornerRadius = 5
            boxConnection.layer.borderWidth = 2
            boxConnection.layer.borderColor = UIColor.black.cgColor
            boxConnections.append(boxConnection)
            view.addSubview(boxConnection)

//            connection.dragChanged = { [weak self] in
//                self?.redrawLines()
//            }

//            connection.dragFinished = { [weak self] in
//                self?.checkMove()
//            }
        }
        
        for i in 0 ..< boxConnections.count {
            if i == boxConnections.count - 1 {
                boxConnections[i].after = boxConnections[i]//connections[0]
            } else {
                boxConnections[i].after = boxConnections[i + 1]
            }
        }

//        boxConnections.forEach(place)
//        for i in 0..<boxConnections.count {
//            place(boxConnections[i],i)
//        }
        repeat {
            for i in 0..<boxConnections.count {
                place(boxConnections[i],i)
            }
        } while levelClear()
        redrawLines()
    }
    
    func loadUsers () {
        userConnections.forEach { $0.removeFromSuperview() }
        userConnections.removeAll()
        for i in 1...(currentLevel + 4 > 6 ? 6 : currentLevel + 4) {
            let connection = ConnectionView(frame: CGRect(origin: CGPoint(x:50*i,y:Int(view.bounds.maxY)-140), size: CGSize(width: 44, height: 44)))
            connection.tag = i
            connection.nameLabel.text = "\(i)"
            connection.backgroundColor = .blue
            connection.layer.cornerRadius = 22
            connection.layer.borderWidth = 2
            userConnections.append(connection)
            view.addSubview(connection)
            connection.dragChanged = { [weak self] in
                //self?.overlapped(movedConnection: connection)
            }
            connection.dragFinished = { [weak self] in
                self?.overlapped(movedConnection: connection)
                self?.checkMove()
            }
        }
    }
    
    func place(_ connection: UIView,_ index:Int) {
        var randomX = CGFloat.random(in: 50...view.bounds.maxX - 50)//boxX[index].x//
        var randomY = CGFloat.random(in: 80...view.bounds.maxY - 200) //boxX[index].y//
        let filterResult = boxConnections.filter { (tempView) -> Bool in
            let tempViewCenter = tempView.center
            if((randomX+50>tempViewCenter.x && randomX-50<tempViewCenter.x) &&
                (randomY+50>tempViewCenter.y && randomY-50<tempViewCenter.y) || ((randomX == tempViewCenter.x) && (randomY == tempViewCenter.y))) {
                return true
            }
            return false
        }
        if(filterResult.count != 0) {
            randomX = randomX + 100
            randomY = randomY + 100
        }
        connection.center = CGPoint(x: randomX, y: randomY)
    }
    
    func redrawLines() {
        let renderer = UIGraphicsImageRenderer(bounds: view.bounds)

        renderedLines.image = renderer.image { ctx in
            for connection in boxConnections {
                var isLineClear = true

//                for other in connections {
//                    if linesCross(start1: connection.center, end1: connection.after.center, start2: other.center, end2: other.after.center) != nil {
//                        isLineClear = false
//                        break
//                    }
//                }

                if isLineClear {
                    UIColor.green.set()
                } else {
                    UIColor.red.set()
                }
                ctx.cgContext.setLineWidth(2)
                ctx.cgContext.strokeLineSegments(between: [connection.after.center, connection.center])
            }
        }
    }
    
//    func overlapped(movedConnection:ConnectionView) {
//        for connection in boxConnections {
//
//            if((movedConnection.frame.origin.x>=connection.frame.origin.x && movedConnection.frame.origin.x <= connection.frame.origin.x + connection.frame.width) && movedConnection.frame.origin.y>=connection.frame.origin.y && movedConnection.frame.origin.y <= connection.frame.origin.y + connection.frame.height) {
//                if(movedConnection.tag == connection.tag) {
//                    if(connection.connectedUser != nil && connection.connectedUser != movedConnection) {
//                        movedConnection.frame = CGRect(origin: CGPoint(x:50*movedConnection.tag,y:Int(view.bounds.maxY)-140), size: CGSize(width: 44, height: 44))
//                        connection.connectedUser = nil
//                        movedConnection.covidBoX = connection
//                    }else {
//                        movedConnection.covidBoX = connection
//                        connection.backgroundColor = .green
//                        connection.connectedUser = movedConnection
//                    }
//                }else {
//                    if(connection.connectedUser != nil && connection.connectedUser != movedConnection) {
//                        movedConnection.frame = CGRect(origin: CGPoint(x:50*movedConnection.tag,y:Int(view.bounds.maxY)-140), size: CGSize(width: 44, height: 44))
//                        connection.connectedUser = nil
//                        movedConnection.covidBoX = connection
//                    }else {
//                        connection.backgroundColor = .red
//                        connection.connectedUser = movedConnection
//                    }
//                }
//                //break
//            }else {
//
//                if(connection.connectedUser  == nil) {
//                    connection.backgroundColor = .blue
//                }else if(connection.connectedUser  == movedConnection) {
//                    connection.connectedUser  = nil
//                    movedConnection.covidBoX = nil
//                    connection.backgroundColor = .blue
//                    movedConnection.frame = CGRect(origin: CGPoint(x:50*movedConnection.tag,y:Int(view.bounds.maxY)-140), size: CGSize(width: 44, height: 44))
//                }
//
//            }
//        }
//    }
    
    
    func overlapped(movedConnection:ConnectionView) {
        for connection in boxConnections {
            if((movedConnection.frame.origin.x>=connection.frame.origin.x && movedConnection.frame.origin.x <= connection.frame.origin.x + connection.frame.width) && movedConnection.frame.origin.y>=connection.frame.origin.y && movedConnection.frame.origin.y <= connection.frame.origin.y + connection.frame.height) {
                if(movedConnection.tag == connection.tag) {
                    if(connection.connectedUser != nil && connection.connectedUser != movedConnection) {
                        movedConnection.frame = CGRect(origin: CGPoint(x:50*movedConnection.tag,y:Int(view.bounds.maxY)-140), size: CGSize(width: 44, height: 44))
                        connection.connectedUser = nil
                    }else {
                        connection.backgroundColor = .green
                        connection.connectedUser = movedConnection
                    }
                }else {
                    if(connection.connectedUser != nil && connection.connectedUser != movedConnection) {
                        movedConnection.frame = CGRect(origin: CGPoint(x:50*movedConnection.tag,y:Int(view.bounds.maxY)-140), size: CGSize(width: 44, height: 44))
                        if(connection.tag != connection.connectedUser?.tag){
                        connection.connectedUser = nil
                        }
                    }else {
                        connection.backgroundColor = .red
                        connection.connectedUser = nil
                        movedConnection.frame = CGRect(origin: CGPoint(x:50*movedConnection.tag,y:Int(view.bounds.maxY)-140), size: CGSize(width: 44, height: 44))
                    }
                }
            }else {
                if(connection.connectedUser  == nil) {
                    connection.backgroundColor = .blue
                }else if(connection.connectedUser  == movedConnection) {
                    connection.connectedUser  = nil
                    connection.backgroundColor = .blue
                    movedConnection.frame = CGRect(origin: CGPoint(x:50*movedConnection.tag,y:Int(view.bounds.maxY)-140), size: CGSize(width: 44, height: 44))
                }

            }
        }
    }
    
    //TO Check if any crossing between views
    func levelClear() -> Bool {
        let isFinished = boxConnections.filter { (box) -> Bool in
            box.connectedUser != nil
        }.count == boxConnections.count

        return isFinished
    }
    
    //MARK:- Move to next level
    func checkMove() {
        if levelClear() {
            score += currentLevel * 2
            view.isUserInteractionEnabled = false

            UIView.animate(withDuration: 0.5, delay: 1, options: [], animations: {
                self.renderedLines.alpha = 0

                for connection in self.boxConnections {
                    connection.alpha = 0
                }
            }) { finished in
                self.view.isUserInteractionEnabled = true
                self.renderedLines.alpha = 1
                self.levelUp()
            }
        } else {
            // they are still playing this level
            score -= 1
        }
    }
}


extension ClosedRange where Element: Hashable {
    func random(without excluded:[Element]) -> Element {
        let valid = Set(self).subtracting(Set(excluded))
        let random = Int(arc4random_uniform(UInt32(valid.count)))
        return Array(valid)[random]
    }
}
