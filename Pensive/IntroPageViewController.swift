//
//  IntroPageViewController.swift
//  Pensive
//
//  Created by Assel Kashkenbayeva on 17/12/2017.
//  Copyright © 2017 Assel Kashkenbayeva. All rights reserved.
//

import UIKit

class IntroPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    lazy var PageArray: [UIViewController] = {
        return [self.VCInstance(name:"FirstPage"), self.VCInstance(name: "SecondPage")]
    }()
    
    func VCInstance(name:String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: name)
    }
    
    var pageControl = UIPageControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        self.dataSource = self
        
        if let FirstPage = PageArray.first {
            setViewControllers([FirstPage], direction: .forward, animated: true, completion: nil)
        }
        
        configurePageControl()
      
           }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = PageArray.index(of: viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return PageArray.last
        }
        return PageArray[previousIndex]
        }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = PageArray.index(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < PageArray.count else {
            return PageArray.first
        }
        guard PageArray.count > nextIndex else {
            return nil
        }
        return PageArray[nextIndex]
    }

    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return PageArray.count
    }
  
    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 50,width: UIScreen.main.bounds.width,height: 50))
        self.pageControl.numberOfPages = PageArray.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.black
        self.pageControl.pageIndicatorTintColor = UIColor.red
        self.pageControl.currentPageIndicatorTintColor = UIColor.black
        self.view.addSubview(pageControl)
    }
    
    // MARK: Delegate functions
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = PageArray.index(of: pageContentViewController)!
    }
}
