//
//  GifCellView.swift
//  Dispo Take Home
//
//  Created by Daniel Phiri on 1/26/22.
//

import UIKit
import SnapKit

class GifCellView: UICollectionViewCell, CellConfigurable {
  
  static let reuseIdentifier = "GifCellView"
  private let padding        : CGFloat = 20
  
  private var gifView: UIView = {
    let view = UIView()
    view.backgroundColor = .blue
    return view
  }()
  
  private var titleLabel: UILabel = {
    let label             = UILabel()
    label.backgroundColor = .clear
    label.textColor       = .systemBlack
    label.textAlignment   = .left
    label.numberOfLines   = 0
    label.font            = UIFont.systemFont(ofSize: 25, weight: .black)
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    loadSubviews()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    loadSubviews()
  }
  
  func setUp() {
    
  }
  
  private func loadSubviews() {
    addSubview(gifView)
    addSubview(titleLabel)
    addAllConstaints()
  }
  
  private func addAllConstaints() {
    gifView.snp.makeConstraints { make in
      make.leading.equalTo(contentView).offset(padding)
      make.top.equalTo(contentView)
      make.bottom.equalTo(contentView)
      make.height.equalTo(contentView.frame.height)
      make.width.equalTo(contentView.frame.height + padding)
    }
    titleLabel.snp.makeConstraints { make in
      make.left.equalTo(gifView.snp_rightMargin).offset(padding)
      make.right.equalTo(contentView)
      make.bottom.equalTo(contentView)
      make.top.equalTo(contentView)
    }
  }
  
    
}
