//
//  HomeViewController.swift
//  NuerogleeApp
//
//  Created by User on 2/12/21.
//

import UIKit

class HomeViewController: UIViewController {
    var presenter: HomeViewToPresenterProtocol?
    
    var boxX = [CGPoint]()
    let renderedLines = UIImageView()
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    
    
    //MARK:- UIView Life Cycle
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
        addBackBarButtonCustom()
    }

    override func viewWillAppear(_ animated: Bool) {
        presenter?.viewWillAppear(animated: animated)
    }
    
    //MARK:- UIView Customization
    func addBackBarButtonCustom() {
        let barButton = UIBarButtonItem(image: UIImage(named: "backArrow"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.backButtonaction))
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    //MARK:- UIView Action
    @objc func backButtonaction() {
        presenter?.moveToLandingView()
    }
    
    @IBAction func resetButtonAction(_ sender: Any) {
        presenter?.reStartCurrentGame()
    }
    
    func place(_ connection: UIView,_ index:Int) {
        var randomX = CGFloat.random(in: 50...view.bounds.maxX - 50)//boxX[index].x//
        var randomY = CGFloat.random(in: 150...view.bounds.maxY - 200) //boxX[index].y//
        let filterResult = presenter?.boxConnections!.filter { (tempView) -> Bool in
            let tempViewCenter = tempView.center
            if((randomX+50>tempViewCenter.x && randomX-50<tempViewCenter.x) &&
                (randomY+50>tempViewCenter.y && randomY-50<tempViewCenter.y) || ((randomX == tempViewCenter.x) && (randomY == tempViewCenter.y))) {
                return true
            }
            return false
        }
        if(filterResult?.count != 0) {
            randomX = randomX + 50
            randomY = randomY + 50
        }
        connection.center = CGPoint(x: randomX, y: randomY)
        view.addSubview(connection)
    }
    
    func redrawLines() {
        let renderer = UIGraphicsImageRenderer(bounds: view.bounds)

        renderedLines.image = renderer.image { ctx in
            for connection in presenter?.boxConnections ?? [] {
                UIColor.green.set()
                ctx.cgContext.setLineWidth(2)
                ctx.cgContext.strokeLineSegments(between: [connection.after.center, connection.center])
            }
        }
    }
    
    //MARK:- Move to next level
    func checkMove() {
        //score += currentLevel * 2
        view.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.1, delay: 0, options: [], animations: {
            self.renderedLines.alpha = 0
            self.presenter?.userConnections?.forEach { $0.alpha = 0}
            for connection in self.presenter?.boxConnections ?? [] {
                connection.alpha = 0
            }
        }) { finished in
            self.view.isUserInteractionEnabled = true
            self.renderedLines.alpha = 1
            //self.levelUp()
            self.presenter?.levelUp()
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

//MARK:- Home Presenter To view Protocol
extension HomeViewController : HomePresenterToViewProtocol {
    func showTimerString(time:String, timeSeconds:Int) {
        timeLabel.text = time
    }
    
    func refreshView() {
        
    }
    
    func placeBoxView(boxView: BoxView,for index:Int) {
        boxView.nameLabel.text = "\(index+1)"
        boxView.backgroundColor = .blue
        boxView.layer.cornerRadius = 5
        boxView.layer.borderWidth = 2
        boxView.layer.borderColor = UIColor.black.cgColor
        place(boxView, index)
    }
    
    func drawLinesBetweenBox() {
        redrawLines()
    }
    
    func addUserConnection(userView:ConnectionView,forIndex index:Int) {
        userView.nameLabel.text = "\(index)"
        userView.backgroundColor = .blue
        userView.layer.cornerRadius = 22
        userView.layer.borderWidth = 2
        userView.frame = CGRect(origin: CGPoint(x:index*50,y:Int(view.bounds.maxY)-140), size: CGSize(width: 44, height: 44))
        self.view.addSubview(userView)
    }
    
    func moveToNextLevel () {
        self.checkMove()
    }
    
    func updateScore() {
        scoreLabel.text = "SCORE: \(presenter?.currentScore ?? 0)"
    }
    
    func updateCurrentGameLevel(level:String) {
        levelLabel.text = "Level: " + level
    }
}
