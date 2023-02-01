//
//  OnboardingContainerVC.swift
//  Bankey
//
//  Created by Felipe Vieira Lima on 31/01/23.
//

import UIKit
import SwiftUI

protocol OnboardingContainerVCDelegate: AnyObject {
    func didFinishOnboarding()
}

class OnboardingContainerVC: UIViewController {
    let pageViewController: UIPageViewController
    var pages = [UIViewController]()
    weak var delegate: OnboardingContainerVCDelegate?
    
    var currentVC: UIViewController {
        didSet {
            guard let index = pages.firstIndex(of: currentVC) else { return }
            nextButton.isHidden = index == pages.count - 1
            backButton.isHidden = index == 0
            doneButton.isHidden = !(index == pages.count - 1)
        }
    }
    
    let nextButton = UIButton(type: .system)
    let backButton = UIButton(type: .system)
    let closeButton = UIButton(type: .system)
    let doneButton = UIButton(type: .system)
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        let page1 = OnboardingViewController(
            heroImageName: "delorean",
            titleText: "Bankey is faster, easier to use, and has a brand new look and feel that will make you feel like you are back in 1989."
        )
        let page2 = OnboardingViewController(
            heroImageName: "world",
            titleText: "Move your money around the world quickly and securely."
        )
        let page3 = OnboardingViewController(
            heroImageName: "thumbs",
            titleText: "Learn more at www.bankey.com"
        )
        
        pages.append(page1)
        pages.append(page2)
        pages.append(page3)
        
        currentVC = pages.first!
    
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        style()
        layout()
    }
    
    private func setup() {
        view.backgroundColor = .purple
        
        addChild(pageViewController)
        view.addSubview(pageViewController.view)

        pageViewController.didMove(toParent: self)
        
        pageViewController.dataSource = self
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: pageViewController.view.topAnchor),
            view.leadingAnchor.constraint(equalTo: pageViewController.view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: pageViewController.view.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: pageViewController.view.bottomAnchor),
            
        ])
        
        pageViewController.setViewControllers([pages.first!], direction: .forward, animated: false, completion: nil)
        currentVC = pages.first!
    }
    
    private func style() {
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.setTitle("Next", for: .normal)
        nextButton.addTarget(self, action: #selector(nextTapped), for: .primaryActionTriggered)
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setTitle("Back", for: .normal)
        backButton.addTarget(self, action: #selector(backTapped), for: .primaryActionTriggered)
            
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setTitle("Close", for: .normal)
        closeButton.addTarget(self, action: #selector(closeTapped), for: .primaryActionTriggered)
        
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.setTitle("Done", for: .normal)
        doneButton.addTarget(self, action: #selector(doneTapped), for: .primaryActionTriggered)
    }
    
    private func layout() {
        view.addSubview(nextButton)
        view.addSubview(backButton)
        view.addSubview(closeButton)
        view.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32)
        ])
    }
}

extension OnboardingContainerVC: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return getPreviousVC(from: viewController)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return getNextVC(from: viewController)
    }
    
    private func getPreviousVC(from viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index - 1 >= 0 else { return nil }
        currentVC = pages[index - 1]
        return pages[index - 1]
    }
    
    private func getNextVC(from viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index + 1 < pages.count else { return nil }
        currentVC = pages[index + 1]
        return pages[index + 1]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return pages.firstIndex(of: self.currentVC) ?? 0
    }
}

extension OnboardingContainerVC: OnboardingContainerVCDelegate {
    func didFinishOnboarding() {
    }
}

struct PreviewOnboardingContainer_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            OnboardingContainerVC()
        }
    }
}

// MARK: - Actions
extension OnboardingContainerVC {
    @objc private func nextTapped(_ sender: UIButton) {
        guard let nextVC = getNextVC(from: currentVC) else { return }
        pageViewController.setViewControllers([nextVC], direction: .forward, animated: true)
    }
    
    @objc private func backTapped(_ sender: UIButton) {
        guard let previousVC = getPreviousVC(from: currentVC) else { return }
        pageViewController.setViewControllers([previousVC], direction: .reverse, animated: true)
    }
    
    @objc private func closeTapped(_ sender: UIButton) {
        delegate?.didFinishOnboarding()
    }
    
    @objc private func doneTapped(_ sender: UIButton) {
        delegate?.didFinishOnboarding()
    }
}
