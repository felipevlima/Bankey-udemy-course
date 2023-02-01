//
//  ViewControllerPreview.swift
//  Bankey
//
//  Created by Felipe Vieira Lima on 01/02/23.
//

import UIKit
import SwiftUI

struct ViewControllerPreview: UIViewControllerRepresentable {
    
    let viewControllerBuilder: () -> UIViewController
    
    init(_ viewControllerBuilder: @escaping () -> UIViewController) {
        self.viewControllerBuilder = viewControllerBuilder
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return viewControllerBuilder()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
