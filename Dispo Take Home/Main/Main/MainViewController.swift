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
    let client = GifAPIClient<APIListResponse>()
    let model: Observable<APIListResponse> = Observable { [weak self] data in
      guard let self = self else { return }
      DispatchQueue.main.async {
        self.collectionView.reloadData()
      }
    }
    let dataState: Observable<ViewDataState> = Observable { [weak self] state in
      guard let state = state else { return }
      self?.handleState(state: state)
    }
    viewModel = MainViewModel(model: model, client: client, state: dataState)
  }
  
  private func handleState(state: ViewDataState) {
    switch state {
      case .loading:
        toggleLoadingMode(on: true)
      case .displaying:
        toggleLoadingMode(on: false)
      case .emptyResults:
        #warning("TODO: Handle No Results Case")
      case .error:
        #warning("TODO: Handle Error Case")
    }
  }
  
  private func toggleLoadingMode(on: Bool) {
    DispatchQueue.main.async {
      if on {
        UIView.animate(withDuration: 0.8, delay: 0) {
          self.spinner.startAnimating()
          self.spinner.alpha = 1
          self.collectionView.alpha = 0
        } completion: { _ in }
      } else {
        UIView.animate(withDuration: 0.8, delay: 0) {
          self.spinner.stopAnimating()
          self.spinner.alpha = 0
          self.collectionView.alpha = 1
        } completion: { _ in }
      }
    }
  }

  override func loadView() {
    view = UIView()
    view.backgroundColor = .systemBackground
    view.addSubview(collectionView)
    view.addSubview(spinner)
    collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    spinner.snp.makeConstraints { make in
      make.width.equalTo(50)
      make.height.equalTo(50)
      make.centerX.equalTo(view.snp.centerX)
      make.centerY.equalTo(view.snp.centerY)
    }
  }
  
  private lazy var spinner: UIActivityIndicatorView = {
    let spinner = UIActivityIndicatorView(style: .large)
    spinner.alpha = 0
    return spinner
  }()

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
    // TODO: implement
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
    cell.setUp(data: data)
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
