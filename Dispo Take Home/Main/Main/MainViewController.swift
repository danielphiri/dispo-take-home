import UIKit

class MainViewController: UIViewController {
  
  private let screenBounds : CGRect = UIScreen.main.bounds
  private let padding      : CGFloat = .zero
  private let cellsHeight  : CGFloat  = 120
  private var viewModel    : MainViewModel?

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.titleView = searchBar
    initViewModel()
  }
  
  private func initViewModel() {
    let model: Observable<APIListResponse> = Observable { [weak self] data in
      guard let self = self else { return }
      DispatchQueue.main.async {
        self.collectionView.reloadData()
      }
    }
    viewModel = MainViewModel(model: model)
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
    collectionView.backgroundColor     = .clear
    collectionView.keyboardDismissMode = .onDrag
    collectionView.delegate            = self
    collectionView.dataSource          = self
    collectionView.register(GifCellView.self, forCellWithReuseIdentifier: GifCellView.reuseIdentifier)
    return collectionView
  }()
}

// MARK: UISearchBarDelegate

extension MainViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    viewModel?.search(text: searchText)
  }
}

// MARK: UICollectionViewDelegate

extension MainViewController: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    presentGifDetail(forIndex: indexPath)
  }
  
}

// MARK: UICollectionViewDataSource

extension MainViewController: UICollectionViewDataSource {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GifCellView.reuseIdentifier, for: indexPath) as? CellConfigurable else {
      safePrint("Gif Cell View not set up")
      return .init()
    }
    let data = viewModel?.model.value?.data[indexPath.row]
    cell.setUp(data: data, resetUI: searchBar.text != nil && searchBar.text != "")
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel?.model.value?.data.count ?? 0
  }
  
}

// MARK: Navigation

extension MainViewController {
  
  private func presentGifDetail(forIndex index: IndexPath) {
    DispatchQueue.main.async {
      guard let gif    = self.viewModel?.model.value?.data[index.row] else { return }
      let result       = SearchResult(
                          id     : gif.id,
                          gifUrl : gif.images.fixed_height.url,
                          title  : gif.title
                        )
      let controller   = DetailViewController(searchResult: result)
      controller.title = "Gif Info Details"
      self.navigationController?.pushViewController(controller, animated: true)
    }
  }
  
}
