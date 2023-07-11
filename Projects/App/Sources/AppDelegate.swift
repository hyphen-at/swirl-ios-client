import ComposableArchitecture
import HyphenAuthenticate
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
            rootView: SwirlApp(
                store: Store(
                    initialState: SwirlCoordinator.State(),
                    reducer: SwirlCoordinator()
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
