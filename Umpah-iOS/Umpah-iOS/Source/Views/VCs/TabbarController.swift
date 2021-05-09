//
//  TabbarController.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/05/10.
//

import UIKit

class TabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTabBar()
    }
    
    private func setTabBar() {
        UITabBar.appearance().barTintColor = UIColor.white
        UITabBar.appearance().tintColor = UIColor.systemBlue
        
        let homeStoryboard = UIStoryboard.init(name: "Home", bundle: nil)
        let homeTab = homeStoryboard.instantiateViewController(identifier: "HomeVC")
        homeTab.tabBarItem = UITabBarItem(title: "home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house"))
        
        let analysisStoryboard = UIStoryboard.init(name: "Analysis", bundle: nil)
        let analysisTab = analysisStoryboard.instantiateViewController(identifier: "AnalysisVC")
        analysisTab.tabBarItem = UITabBarItem(title: "분석", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house"))
        
        let storageStoryboard = UIStoryboard.init(name: "Storage", bundle: nil)
        let storageTab = storageStoryboard.instantiateViewController(identifier: "StorageVC")
        storageTab.tabBarItem = UITabBarItem(title: "저장", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house"))
        
        let tabs = [homeTab, analysisTab, storageTab]
        
        self.setViewControllers(tabs, animated: false)
        self.selectedViewController = homeTab
    }
}
