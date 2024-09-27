
//
//  EventTableViewCell.swift
//  KaizenGame
//
//  Created by Gustavo Quenca on 25/09/2024.
//

import UIKit
import Combine

class EventTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    static let identifier = "EventTableViewCell"
    var viewModel: EventCellViewModel?
    
    var favoriteButtonTapped: ((String) -> Void)?

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 6
        layout.estimatedItemSize = CGSize(width: 120, height: 180)
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()

    private var collectionViewHeightConstraint: NSLayoutConstraint?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(EventCollectionViewCell.self, forCellWithReuseIdentifier: EventCollectionViewCell.identifier)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])

        collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 150)
        collectionViewHeightConstraint?.isActive = true
    }

    func configure(with viewModel: EventCellViewModel) {
        self.viewModel = viewModel

        // Adjust collection view height if necessary (optional)
        DispatchQueue.main.async { [unowned self] in
            self.collectionView.reloadData()
            let contentHeight = self.collectionView.collectionViewLayout.collectionViewContentSize.height
            self.collectionViewHeightConstraint?.constant = contentHeight
        }
    }

    // MARK: - UICollectionView DataSource & Delegate

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfEvents() ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventCollectionViewCell.identifier, for: indexPath) as! EventCollectionViewCell

        if let event = viewModel?.event(at: indexPath.item) {
            // Pass the toggle favorite action to the cell
            cell.favoriteButtonAction = { [weak self] index in
                self?.viewModel?.toggleFavorite(at: index)
                let eventID = self?.viewModel?.event(at: index)?.eventID
                self?.favoriteButtonTapped?(eventID ?? "")
                cell.updateFavoriteButton(isFavorite: event.favorite)
            }
            
            cell.configure(with: event, at: indexPath.item)
        }

        return cell
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        collectionView.reloadData()
        viewModel = nil
    }
}
