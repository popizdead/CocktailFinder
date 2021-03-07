import UIKit

// Make sure you added this dependency to your project
// More info at https://bit.ly/CVPagingLayout
import CollectionViewPagingLayout

// The cell class needs to conform to `StackTransformView` protocol
// to be able to provide the transform options
class MyCell: UICollectionViewCell, StackTransformView {
    
    var stackOptions = StackTransformViewOptions(
        scaleFactor: -0.03,
        minScale: 0.20,
        maxScale: 1.00,
        maxStackSize: 3,
        spacingFactor: 0.01,
        maxSpacing: nil,
        alphaFactor: 0.10,
        bottomStackAlphaSpeedFactor: 0.90,
        topStackAlphaSpeedFactor: 0.30,
        perspectiveRatio: 0.00,
        shadowEnabled: true,
        shadowColor: .black,
        shadowOpacity: 0.50,
        shadowOffset: .zero,
        shadowRadius: 8.00,
        stackRotateAngel: 0.20,
        popAngle: 0.79,
        popOffsetRatio: .init(width: -1.45, height: 0.40),
        stackPosition: .init(x: 0.00, y: 1.00),
        reverse: false,
        blurEffectEnabled: false,
        maxBlurEffectRadius: 0.00,
        blurEffectStyle: .light
    )

    // The card view that we apply transforms on
    var card: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        // Adjust the card view frame you can use Autolayout too
        let cardFrame = CGRect(x: frame.width / 5,
                               y: frame.maxY / 9,
                               width: frame.width - frame.width / 4,
                               height: frame.height - frame.height / 3)
        card = UIView(frame: cardFrame)
       
        card.backgroundColor = .white
        card.layer.cornerRadius = 10
        print(frame.width)
        //414
        //375
        print(frame.height)
        //896
        //667
        contentView.addSubview(card)
    }
}

// A simple View Controller that filled with a UICollectionView
// You can use `UICollectionViewController` too
class CardsViewController: UIViewController, UICollectionViewDataSource {
    
    var collectionView: UICollectionView!
    @IBOutlet weak var collectionFrame: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(
            frame: collectionFrame.frame,
            collectionViewLayout: CollectionViewPagingLayout()
        )
        collectionView.isPagingEnabled = true
        collectionView.register(MyCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        view.addSubview(collectionView)
        collectionView.backgroundColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.async { [weak self] in
            self?.collectionView?.performBatchUpdates({ [weak self] in
                self?.collectionView?.collectionViewLayout.invalidateLayout()
            })
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        10
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(
            withReuseIdentifier: "cell",
            for: indexPath
        )
    }
    
}
