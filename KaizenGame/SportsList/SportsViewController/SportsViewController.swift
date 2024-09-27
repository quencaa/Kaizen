//
//  ViewController.swift
//  KaizenGame
//
//  Created by Gustavo Quenca on 24/09/2024.
//

import UIKit
import Combine

class SportsViewController: UIViewController {
    
    private var viewModel: SportsViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    private let tableView = UITableView()
    private var collapsedSections: Set<Int> = [] // Track which sections are collapsed
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    init(viewModel: SportsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        bindViewModel()
        
        Task {
            DispatchQueue.main.async { [unowned self] in
                self.showLoadingIndicator(true)
            }
            
            await viewModel.fetchSportsData()
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Kaizen Game"
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 350
        
        tableView.separatorStyle = .none
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EventTableViewCell.self, forCellReuseIdentifier: EventTableViewCell.identifier)
        tableView.register(SportsSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: SportsSectionHeaderView.identifier)
        
        // Add loading indicator to the view
        view.addSubview(loadingIndicator)
        
        // Center the loading indicator
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.$sports
            .receive(on: DispatchQueue.main)
            .sink { [weak self] sports in
                guard let self = self else { return }
                self.showLoadingIndicator(false)
                self.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                if let errorMessage = errorMessage {
                    self?.showErrorAlert(errorMessage)
                }
            }
            .store(in: &cancellables)
    }
    
    private func showErrorAlert(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func showLoadingIndicator(_ show: Bool) {
        if show {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
    }
}

extension SportsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sports.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collapsedSections.contains(section) ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EventTableViewCell.identifier, for: indexPath) as! EventTableViewCell
        
        // Handle favcorite button taps
        cell.favoriteButtonTapped = { [weak self] eventIndex in
            self?.viewModel.toggleFavorite(forEventID: String(eventIndex))
        }

        let eventCellViewModel = EventCellViewModel(events: viewModel.sports[indexPath.section].events,
                                                    sportID: viewModel.sports[indexPath.section].sportID)
        cell.configure(with: eventCellViewModel)
        
        return cell
    }
    
    // Handle expanding and collapsing of sections
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: SportsSectionHeaderView.identifier) as! SportsSectionHeaderView
        let sport = viewModel.sports[section]
        let isExpanded = !collapsedSections.contains(section)
        let sportType = SportType(rawValue: sport.sportName)
        header.configure(with: sport.sportName, sportType: sportType, isExpanded: isExpanded)
        
        // Add a tap gesture to handle the collapsing of the section
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleSection(_:)))
        header.tag = section
        header.addGestureRecognizer(tapGesture)
        
        return header
    }
    
    @objc private func toggleSection(_ sender: UITapGestureRecognizer) {
        let section = sender.view!.tag
        if collapsedSections.contains(section) {
            collapsedSections.remove(section)
        } else {
            collapsedSections.insert(section)
        }
        
        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }
}
