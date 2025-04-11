//
//  ChipsView.swift
//  Moviemax
//
//  Created by Volchanka on 08.04.2025.
//

import UIKit


protocol ChipsViewDelegate: AnyObject {
    func chipsView(_ chipsView: ChipsView, didSelectItemAt index: Int, value: String)
}

final class ChipsView: UIView {
    weak var delegate: ChipsViewDelegate?
    
    private var items: [String] = []
    private var selectedIndex: IndexPath = IndexPath(item: 0, section: 0)
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(
            ChipViewCell.self,
            forCellWithReuseIdentifier: ChipViewCell.identifier
        )
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    init() {
        super.init(frame: .zero)
        setupView()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with items: [String]) {
        self.items = items
        collectionView.reloadData()
    }
}

// MARK: - Private methods
private extension ChipsView {
    func setupView() {
        addSubview(collectionView)
    }
    
    func setupConstraints() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension ChipsView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChipViewCell.identifier, for: indexPath) as? ChipViewCell,
            let text = items[safe: indexPath.row] else {
            return UICollectionViewCell()
        }
        
        let isSelected = (indexPath == selectedIndex)
        cell.configure(with: text, selected: isSelected)
        
        return cell
    }
}

extension ChipsView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath != selectedIndex,  let text = items[safe: indexPath.item] {
            let previous = selectedIndex
            selectedIndex = indexPath
            UIView.performWithoutAnimation {
                collectionView.reloadItems(at: [previous, selectedIndex])
            }
            delegate?.chipsView(self, didSelectItemAt: indexPath.item, value: text)
        }
    }
}
