//
//  ViewController.swift
//  RandomCatImage
//
//  Created by Harish Gajabheenkar on 17/10/24.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var factLabel: UILabel!
    @IBOutlet weak var catImage: UIImageView!
    private var viewModel: CatViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        bindViewModel()
        Task {
            await viewModel.fetchCatData()
        }
    }
    
    private func setUpUI(){
        self.navigationController?.navigationBar.topItem?.title = UIConstants.navigationTitle
        self.catImage.layer.cornerRadius = 8
        self.catImage.clipsToBounds = true
        // TapGesture Recongnizer
        self.setUpTapGesture()
    }
    private func bindViewModel() {
        let catFactService = CatFactService()
        let catImageService = CatImageService()
        viewModel = CatViewModel(catFactService: catFactService,catImageService: catImageService)
        viewModel.catFact = { [weak self] fact in
            DispatchQueue.main.async {
                self?.factLabel.text = fact
            }
        }
        
        viewModel.catImage = { [weak self] imageUrl in
            DispatchQueue.main.async {
                if let url = URL(string: imageUrl) {
                    self?.loadImage(from: url)
                }
            }
        }
        
        viewModel.errorHandler = { [weak self] error in
            DispatchQueue.main.async {
                self?.factLabel.text = "Error: \(error)"
            }
        }
        
    }
    private func setUpTapGesture(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    @objc private func handleTap() {
        Task {
            await viewModel.fetchCatData()
        }
    }
    
    private func loadImage(from url: URL) {
        Task {
            do {
                let data = try await URLSession.shared.data(from: url).0
                if let image = UIImage(data: data) {
                    self.catImage.image = image
                }
            } catch {
                print("Error loading image: \(error)")
            }
        }
    }
}

