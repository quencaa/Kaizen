//
//  EventCollectionViewCell.swift
//  KaizenGame
//
//  Created by Gustavo Quenca on 25/09/2024.
//

import UIKit

class EventCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "EventCollectionViewCell"
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        label.textColor = .darkGray
        return label
    }()
    
    private let firstTeamLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private let vsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.text = "vs"
        label.numberOfLines = 1
        return label
    }()
    
    private let secondTeamLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)  // Add target
        return button
    }()
    
    private var eventIndex: Int?  // Track the index for this cell
    var favoriteButtonAction: ((Int) -> Void)?  // Closure to handle button tap

    // Main stack view to hold timer, event name, and favorite button
    private let mainStackView = UIStackView()
    
    // Stack view for the event name (two teams with "vs")
    private let titleStackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {        
        // Title stack view (for team names and "vs")
        titleStackView.axis = .vertical
        titleStackView.alignment = .center
        titleStackView.spacing = 4
        titleStackView.addArrangedSubview(firstTeamLabel)
        titleStackView.addArrangedSubview(vsLabel)
        titleStackView.addArrangedSubview(secondTeamLabel)
        
        // Main stack view setup
        mainStackView.axis = .vertical
        mainStackView.alignment = .center
        mainStackView.spacing = 2
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.addArrangedSubview(timerLabel)
        mainStackView.addArrangedSubview(titleStackView)
        mainStackView.addArrangedSubview(favoriteButton)
        
        // Add the stack view to the content view
        contentView.addSubview(mainStackView)
        
        // Layout constraints for main stack view
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2)
        ])
    }

    func configure(with event: Event, at index: Int) {
        self.eventIndex = index
        
        // Set the timer string (use your countdown logic here)
        timerLabel.text = countdownString(for: event)

        // Split the event name at the hyphen and replace it with "vs"
        let splitNames = event.eventName.split(separator: "-").map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
        
        if splitNames.count == 2 {
            firstTeamLabel.text = splitNames[0]
            secondTeamLabel.text = splitNames[1]
        } else {
            firstTeamLabel.text = event.eventName
            vsLabel.isHidden = true
            secondTeamLabel.isHidden = true
        }
        
        updateFavoriteButton(isFavorite: event.favorite)
    }

    private func countdownString(for event: Event) -> String {
        let now = Int(Date().timeIntervalSince1970)
        let remainingTime = event.eventStartTime - now
        if remainingTime <= 0 {
            return "Started"
        } else {
            let hours = remainingTime / 3600
            let minutes = (remainingTime % 3600) / 60
            let seconds = remainingTime % 60
            return "\(hours)h \(minutes)m \(seconds)s remaining"
        }
    }
    
    @objc private func favoriteButtonTapped() {
          guard let index = eventIndex else { return }
          favoriteButtonAction?(index)  // Call the closure when the button is tapped
    }
    
    func updateFavoriteButton(isFavorite: Bool) {
        // Configure the favorite button
        let starImage = isFavorite ? "star.fill" : "star"
        favoriteButton.setImage(UIImage(systemName: starImage), for: .normal)
        favoriteButton.tintColor = isFavorite ? .yellow : .gray
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        timerLabel.text = nil
        firstTeamLabel.text = nil
        vsLabel.isHidden = false
        secondTeamLabel.isHidden = false
        favoriteButton.tintColor = nil
    }
}
