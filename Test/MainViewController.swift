//
//  MainViewController.swift
//  Test
//
//  Created by Ibrahim Gedami on 17/08/2024.
//

import UIKit
import SwiftUI

class MainViewController: UIViewController {

    init() {
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func didPresentViewButtonTapped(_ sender: UIButton) {
        let view = UIHostingController(rootView: ContentView())
        present(view, animated: true)
    }
    
}
