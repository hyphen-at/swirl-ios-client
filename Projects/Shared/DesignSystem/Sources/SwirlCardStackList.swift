import Foundation
import SnapKit
import SwiftUI

public struct SwirlCardStackView: UIViewControllerRepresentable {
    @Binding private var cardCount: Int

    public init(
        cardCount: Binding<Int>
    ) {
        _cardCount = cardCount
    }

    public func makeUIViewController(context _: Context) -> SwirlCardStackViewController {
        let stackedLayout = TGLStackedLayout()
        stackedLayout.isFillingHeight = true
        stackedLayout.movingItemOnTop = true
        stackedLayout.topReveal = 80
        stackedLayout.itemSize = CGSize(width: 0, height: 250)
        stackedLayout.layoutMargin = .init(top: 00, left: 16, bottom: 120, right: 16)

        return SwirlCardStackViewController(collectionViewLayout: stackedLayout)
    }

    public func updateUIViewController(_ viewController: SwirlCardStackViewController, context _: Context) {
        viewController.updateCardCount(cardCount)
    }
}

public class SwirlCardStackViewController: TGLStackedViewController {
    private var cardCount: Int = 3

    public func updateCardCount(_ count: Int) {
        cardCount = count
        collectionView.reloadData()
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        collectionView.snp.makeConstraints { make in
            make.size.equalToSuperview()
            make.center.equalToSuperview()
        }

        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(SwirlCardStackCell.self, forCellWithReuseIdentifier: SwirlCardStackCell.reuseIdentifier)
    }

    // MARK: - UICollectionViewDataSource protocol

    override public func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return cardCount
    }

    override public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SwirlCardStackCell.reuseIdentifier, for: indexPath) as! SwirlCardStackCell

        return cell
    }
}

struct SwirlCardStackCellWrapper: View {
    @State var name: String = ""
    @State var date: Date = .init()
    @State var location: String = ""
    @State var color: Color = .clear

    var body: some View {
        SwirlNameCard(
            name: name,
            profileUrl: "",
            date: date,
            location: location,
            color: color,
            enablePressAnimation: false,
            onClick: {}
        )
        .shadow(radius: 2)
        .onAppear {
            date = randomDate()
            location = randomLocation()
            name = randomFakeFirstName()
            color = Color(hue: Double.random(in: 0 ... 1), saturation: 0.62, brightness: 1)
        }
    }
}

class SwirlCardStackCell: UICollectionViewCell {
    static var reuseIdentifier = "SwirlCardStackCell"

    lazy var host: UIHostingController = .init(rootView: SwirlCardStackCellWrapper())

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        host.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(host.view)
        contentView.backgroundColor = .clear
        host.view.backgroundColor = .clear

        if #available(iOS 16.0, *) {
            host.sizingOptions = .intrinsicContentSize
        }

        NSLayoutConstraint.activate([
            host.view.topAnchor.constraint(equalTo: contentView.topAnchor),
            host.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            host.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            host.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
}

func randomFakeFirstName() -> String {
    let firstNameList = ["Henry", "William", "Geoffrey", "Jim", "Yvonne", "Jamie", "Leticia", "Priscilla", "Sidney", "Nancy", "Edmund", "Bill", "Megan"]
    return firstNameList.randomElement()!
}

func randomLocation() -> String {
    let locations = [
        "LA, United States",
        "NYC, United States",
        "Chicago, United States",
        "San Francisco, United States",
        "Miami, United States",
        "Seattle, United States",
        "Austin, United States",
        "Las Vegas, United States",
        "Orlando, United States",
        "Denver, United States",
        "Boston, United States",
        "Philadelphia, United States",
        "San Diego, United States",
        "Nashville, United States",
        "Dallas, United States",
        "Portland, United States",
        "Atlanta, United States",
        "Phoenix, United States",
        "Detroit, United States",
        "New Orleans, United States",
    ]

    return locations.randomElement()!
}

func randomDate() -> Date {
    let day = arc4random_uniform(30) + 1
    let month = arc4random_uniform(12) + 1
    let year = 2023
    let hour = arc4random_uniform(24)
    let minute = arc4random_uniform(60)

    var dateComponents = DateComponents()
    dateComponents.year = Int(year)
    dateComponents.month = Int(month)
    dateComponents.day = Int(day)
    dateComponents.hour = Int(hour)
    dateComponents.minute = Int(minute)

    let userCalendar = Calendar.current
    return userCalendar.date(from: dateComponents)!
}
