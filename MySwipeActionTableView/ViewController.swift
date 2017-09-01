//
//  ViewController.swift
//  MyTable
//
//  Created by amarron on 2017/09/01.
//  Copyright © 2017年 amarron. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var items = ["item1", "item2", "item3"]
    
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.delegate = self
        myTableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: UITableViewDataSourceDelegate
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = self.items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    // MARK: UITableViewDelegate
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
//        if editingStyle == .delete {
//            self.items.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }
    

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        let alert: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "") { (action, index) -> Void in
            let alert = UIAlertController(title: self.items[indexPath.row], message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        let delete: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "") { (action, index) -> Void in
            self.items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        delete.backgroundColor = UIColor.red
        
        self.fixAction(alert, text: "", image: UIImage(named: "comments")!, color: .red)
        self.fixAction(delete, text: "", image: UIImage(named: "trash")!, color: .red)
        
        let gap = UITableViewRowAction(style: .normal, title: "") { (_, _) in}
        gap.backgroundColor = .white
        return [gap, delete, alert]
    }

    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let alert = UIContextualAction(style: .normal,
                                              title:  "rename",
                                              handler: { (action: UIContextualAction, view: UIView, success :(Bool) -> Void) in
                                                success(true)
                                                let alert = UIAlertController(title: self.items[indexPath.row], message: nil, preferredStyle: .alert)
                                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                                self.present(alert, animated: true, completion: nil)

        })
        alert.image = UIImage(named: "comments")

        let delete = UIContextualAction(style: .normal,
                                              title: "削除",
                                              handler: { (action: UIContextualAction, view: UIView, success :(Bool) -> Void) in
                                                success(true)
                                                self.items.remove(at: indexPath.row)
                                                tableView.deleteRows(at: [indexPath], with: .fade)
        })
        delete.image = UIImage(named: "trash")
        delete.backgroundColor = .red

        return UISwipeActionsConfiguration(actions: [delete, alert])
    }

    // MARK: Private Methods
    
    func fixAction(_ action:UITableViewRowAction, text:String, image:UIImage, color:UIColor) {

        // make sure the image is a mask that we can color with the passed color
        let mask = image.withRenderingMode(.alwaysTemplate)
        // compute the anticipated width of that non empty string
        let stockSize = action.title!.size(withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)])
        // I know my row height
        let height:CGFloat = 70
        // Standard action width computation seems to add 15px on either side of the text
        let width:CGFloat = stockSize.width + 30.0
        let actionSize = CGSize(width: width, height: height)
        // lets draw an image of actionSize
        UIGraphicsBeginImageContextWithOptions(actionSize, false, 0.0)
        if let context = UIGraphicsGetCurrentContext() {
            context.clear(CGRect(origin: .zero, size: actionSize))
        }
        color.set()
        let attributes:[NSAttributedStringKey : Any] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): color, NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): UIFont.systemFont(ofSize: 15)]
        let textSize = text.size(withAttributes: attributes)
        // implementation of `half` extension left up to the student
        let textPoint = CGPoint(x: (width - textSize.width)/2, y: (height - (textSize.height * 3))/2 + (textSize.height * 2))
        text.draw(at: textPoint, withAttributes: attributes)
        let  maskHeight = textSize.height * 1.8
        let maskRect = CGRect(x: (width - maskHeight)/2, y: textPoint.y - maskHeight, width: maskHeight, height: maskHeight)
        mask.draw(in: maskRect)
        if let result = UIGraphicsGetImageFromCurrentImageContext() {
            // adjust the passed in action's backgroundColor to a patternImage
            action.backgroundColor = UIColor(patternImage: result)
        } else {
            print("Error")
        }
        UIGraphicsEndImageContext()
    }
    
}

