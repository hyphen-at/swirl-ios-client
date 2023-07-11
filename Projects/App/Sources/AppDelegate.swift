import ComposableArchitecture
import Feature
import SwiftUI
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = UIHostingController(
            rootView: CosmoApp(
                store: Store(
                    initialState: CosmoCoordinator.State(),
                    reducer: CosmoCoordinator()
                        .signpost()
                        ._printChanges()
                )
            )
        )
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()

        return true
    }
}
