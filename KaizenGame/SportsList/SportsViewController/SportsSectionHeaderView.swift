//
//  SportsSectionHeaderView.swift
//  KaizenGame
//
//  Created by Gustavo Quenca on 25/09/2024.
//
import UIKit

class SportsSectionHeaderView: UITableViewHeaderFooterView {

    static let identifier = "SportsSectionHeaderView"
    
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let chevronImageView = UIImageView()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        chevronImageView.image = UIImage(systemName: "chevron.down")
        chevronImageView.contentMode = .scaleAspectFit
        
        // Set up icon image view
        iconImageView.contentMode = .scaleAspectFit
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(chevronImageView)
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            chevronImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            chevronImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: 24),
            chevronImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    // Configure the header with title and icon
    func configure(with title: String, sportType: SportType?, isExpanded: Bool) {
        titleLabel.text = title
        iconImageView.image = sportType?.icon
        UIView.animate(withDuration: 0.2) {
            self.chevronImageView.transform = isExpanded ? CGAffineTransform(rotationAngle: .pi) : .identity
        }
    }
}
