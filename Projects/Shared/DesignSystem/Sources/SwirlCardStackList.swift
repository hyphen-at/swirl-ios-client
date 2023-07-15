import Foundation
import SnapKit
import SwiftUI
import SwirlModel

public struct SwirlCardStackView: UIViewControllerRepresentable {
    @Binding private var profiles: [SwirlProfile]
    private var onNameCardClick: (SwirlProfile) -> Void

    public init(
        profiles: Binding<[SwirlProfile]>,
        onNameCardClick: @escaping (SwirlProfile) -> Void
    ) {
        _profiles = profiles
        self.onNameCardClick = onNameCardClick
    }

    public func makeUIViewController(context _: Context) -> SwirlCardStackViewController {
        let stackedLayout = TGLStackedLayout()
        stackedLayout.isFillingHeight = true
        stackedLayout.movingItemOnTop = true
        stackedLayout.topReveal = 80
        stackedLayout.itemSize = CGSize(width: 0, height: 250)
        stackedLayout.layoutMargin = .init(top: 0, left: 8, bottom: 120, right: 8)

        let viewController = SwirlCardStackViewController(collectionViewLayout: stackedLayout)
        viewController.onNameCardClick = onNameCardClick

        return viewController
    }

    public func updateUIViewController(_ viewController: SwirlCardStackViewController, context _: Context) {
        viewController.updateProfileList(profiles)
    }
}

public class SwirlCardStackViewController: TGLStackedViewController {
    private var profiles: [SwirlProfile] = []

    public var onNameCardClick: (SwirlProfile) -> Void = { _ in }

    public func updateProfileList(_ profiles: [SwirlProfile]) {
        self.profiles = profiles
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
        return profiles.count
    }

    override public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SwirlCardStackCell.reuseIdentifier, for: indexPath) as! SwirlCardStackCell
        cell.isMyProfile = indexPath.item == 0
        cell.profile = profiles[indexPath.item]
        return cell
    }

    override public func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onNameCardClick(profiles[indexPath.item])
    }
}

struct SwirlCardStackCellWrapper: View {
    let profile: SwirlProfile?
    let isMyProfile: Bool

    var body: some View {
        if let profile = profile {
            SwirlNameCard(
                profile: profile,
                isMyProfile: isMyProfile,
                enablePressAnimation: false,
                onClick: {}
            )
            .shadow(radius: 2)
        } else {
            EmptyView()
        }
    }
}

class SwirlCardStackCell: UICollectionViewCell {
    private var _profile: SwirlProfile? = nil
    public var profile: SwirlProfile? {
        set {
            _profile = newValue
            host.rootView = SwirlCardStackCellWrapper(profile: _profile, isMyProfile: isMyProfile)
        }
        get {
            _profile
        }
    }

    public var isMyProfile: Bool = false

    static var reuseIdentifier = "SwirlCardStackCell"

    lazy var host: UIHostingController = .init(
        rootView: SwirlCardStackCellWrapper(
            profile: _profile,
            isMyProfile: isMyProfile
        )
    )

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
