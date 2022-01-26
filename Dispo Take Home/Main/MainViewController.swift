import UIKit

class MainViewController: UIViewController {
  
  private let screenBounds : CGRect = UIScreen.main.bounds
  private let padding      : CGFloat = .zero
  private let cellsHeight  : CGFloat  = 134

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.titleView = searchBar

  }

  override func loadView() {
    view = UIView()
    view.backgroundColor = .systemBackground
    view.addSubview(collectionView)

    collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }

  private lazy var searchBar: UISearchBar = {
    let searchBar = UISearchBar()
    searchBar.placeholder = "search gifs..."
    searchBar.delegate = self
    return searchBar
  }()

  private var layout: UICollectionViewLayout {
    // TODO: implement
    let layout                     = UICollectionViewFlowLayout()
    layout.itemSize                = CGSize(
                                          width  : screenBounds.width - (padding * 2),
                                          height : cellsHeight
                                        )
    layout.scrollDirection         = .vertical
    layout.minimumInteritemSpacing = padding
    return layout
  }

  private lazy var collectionView: UICollectionView = {
    let collectionView = UICollectionView(
      frame: .zero,
      collectionViewLayout: layout
    )
    collectionView.backgroundColor = .clear
    collectionView.keyboardDismissMode = .onDrag
    return collectionView
  }()
}

// MARK: UISearchBarDelegate

extension MainViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    // TODO: implement
  }
}
