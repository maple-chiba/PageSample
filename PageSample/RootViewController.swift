//
//  RootViewController.swift
//  PageSample
//
//  Created by USER on 2015/06/18.
//  Copyright (c) 2015年 YukaChiba. All rights reserved.
//

import UIKit

class RootViewController: UIViewController, UIPageViewControllerDelegate {

    var pageViewController: UIPageViewController?


    override func viewDidLoad() {
        super.viewDidLoad()
        println("RootのViewDidLoad:Start")
        // Do any additional setup after loading the view, typically from a nib.
        // Configure the page view controller and add it as a child view controller.
        self.pageViewController = UIPageViewController(transitionStyle: .PageCurl, navigationOrientation: .Horizontal, options: nil)
        self.pageViewController!.delegate = self

        let startingViewController: DataViewController = self.modelController.viewControllerAtIndex(0, storyboard: self.storyboard!)!
        let viewControllers = [startingViewController]
        self.pageViewController!.setViewControllers(viewControllers, direction: .Forward, animated: false, completion: {done in })

        self.pageViewController!.dataSource = self.modelController

        self.addChildViewController(self.pageViewController!)
        self.view.addSubview(self.pageViewController!.view)

        // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
        //var pageViewRect = self.view.bounds
        var pageViewRect = CGRectMake(10, 10, 600, 300)
        self.pageViewController!.view.frame = pageViewRect


        self.pageViewController!.didMoveToParentViewController(self)

        // Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
        self.view.gestureRecognizers = self.pageViewController!.gestureRecognizers
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var modelController: ModelController {
        // Return the model controller object, creating it if necessary.
        // In more complex implementations, the model controller may be passed to the view controller.
        if _modelController == nil {
            _modelController = ModelController()
        }
        return _modelController!
    }

    var _modelController: ModelController? = nil

    // MARK: - UIPageViewController delegate methods

    func pageViewController(pageViewController: UIPageViewController, spineLocationForInterfaceOrientation orientation: UIInterfaceOrientation) -> UIPageViewControllerSpineLocation {

        // Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to true, so set it to false here.

        // View（ページ）の生成
        let currentViewController: DataViewController = self.pageViewController!.viewControllers[0] as! DataViewController
        var viewControllers: NSArray = NSArray()
        // ページのindexを取得
        var indexOfCurrentViewController: NSInteger = self.modelController.indexOfViewController(currentViewController)

        if indexOfCurrentViewController == 0 || indexOfCurrentViewController % 2 == 0 {
            // ページのindexが0または偶数の場合、次のページを用意する
            var nextViewController: UIViewController = self.modelController.pageViewController(self.pageViewController!, viewControllerAfterViewController: currentViewController)!
            viewControllers = [currentViewController, nextViewController]
        } else {
            // ページのindexが奇数の場合、前のページを用意する
            var previousViewController: UIViewController = self.modelController.pageViewController(self.pageViewController!, viewControllerBeforeViewController: currentViewController)!
            viewControllers = [previousViewController, currentViewController]
        }

        // PageViewControllerに２ページ分のViewを渡す
        self.pageViewController!.setViewControllers(viewControllers as [AnyObject], direction: .Forward, animated: true, completion: {done in })


        // 見開き表示(2ページ分の表示)をTrueにする
        self.pageViewController!.doubleSided = true

        // 中心をPageViewControllerの真ん中にする
        return .Mid
    }


}

