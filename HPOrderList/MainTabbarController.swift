//
//  MainTabbarController.swift
//  HPOrderList
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 6/5/20.
//  Copyright © 2020 Cuong Le. All rights reserved.
//

import UIKit

class MainTabbarController: UITabBarController {

    var indicatorImage: UIImageView?
    override func viewDidLoad() {
        super.viewDidLoad()
        let numberOfItems = CGFloat(tabBar.items!.count)
        let tabBarItemSize = CGSize(width: (tabBar.frame.width / numberOfItems), height: tabBar.frame.height)
        indicatorImage?.center.x = tabBar.frame.width/numberOfItems/2
        indicatorImage = UIImageView(image: UIImage.lineWithColor(UIColor.mainColor, size: tabBarItemSize, lineHeight: 3))
        tabBar.addSubview(indicatorImage!)
        tabBar.layer.borderWidth = 1
        tabBar.layer.borderColor = UIColor.borderColor.cgColor
        tabBar.clipsToBounds = true
    }

    override var selectedIndex: Int{
        didSet {
            if let count = viewControllers?.count, let item = self.tabBar.items, (selectedIndex >= 0 && selectedIndex < count) {
                tabChanged(self.tabBar, didSelect: item[selectedIndex])
            }
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        tabChanged(tabBar, didSelect: item)
    }
    
    
    private func tabChanged(_ tabBar: UITabBar, didSelect item: UITabBarItem){
        UIView.animate(withDuration: 0.3) {
            let number = -(tabBar.items?.firstIndex(of: item)?.distance(to: 0))! + 1
            let numberOfItems = CGFloat(tabBar.items!.count)
            let firstCenterX = tabBar.frame.width/numberOfItems/2
            let additionNumber = tabBar.frame.width/numberOfItems
            if number == 1 {
                self.indicatorImage?.center.x =  firstCenterX
            }else{
                self.indicatorImage?.center.x = firstCenterX + additionNumber*CGFloat(number-1)
            }
        }
    }

}
