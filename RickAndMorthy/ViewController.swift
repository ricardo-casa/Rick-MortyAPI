//
//  ViewController.swift
//  RickAndMorthy
//
//  Created by Ricardo Carrillo Pech on 07/12/23.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.register(UINib(nibName: "CharacterTableViewCell", bundle: nil), forCellReuseIdentifier: viewModel.cellIdentifier)
        }
    }
    
    @IBOutlet weak var pageLabel: UILabel! {
        didSet {
            pageLabel.text = "Current Page: \(viewModel.getCurrentPage())"
        }
    }
    
    @IBOutlet weak var paginationStepper: UIStepper! {
        didSet {
            paginationStepper.minimumValue = 1
            paginationStepper.maximumValue = viewModel.getNumberOfPages()
        }
    }
    
    
    
    // MARK: Model
    let viewModel = ViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        viewModel.delegate = self
        
        paginationStepper.addTarget(self, action: #selector(handleStepperChange), for: .valueChanged)
    }
    
    @objc 
    func handleStepperChange(_ sender: UIStepper) {
        viewModel.setCurrentPage(Int(sender.value))
        pageLabel.text = "Current Page: \(viewModel.getCurrentPage())"
        viewModel.loadCharacters(onPage: viewModel.getCurrentPage())
    }
}

// MARK: ViewModel Delegate
extension ViewController: ViewModelDelegate{
    func shouldRealoadTable() {
        self.tableView.reloadData()
    }
}

// MARK: Table View Data Source & Delegate
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfCharacters()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.cellIdentifier) as! CharacterTableViewCell
                
        viewModel.getCharacterImage(at: indexPath) { image in
            DispatchQueue.main.async {
                cell.characterImageView.image = image
            }
        }
        cell.characterName.text = viewModel.getCharacterName(at: indexPath)
        cell.characterType.text = viewModel.getCharacterType(at: indexPath)
        cell.characterSpecies.text = viewModel.getCharacterSpecies(at: indexPath)
        cell.characterId.text = viewModel.getCharacterId(at: indexPath)
        return cell
    }
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.cellSize
    }
}
