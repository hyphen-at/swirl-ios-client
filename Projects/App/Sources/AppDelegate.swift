import ComposableArchitecture
import HyphenAuthenticate
import SwiftUI
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
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

        HyphenAuthenticateAppDelegate.shared.application(application)

        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        HyphenAuthenticateAppDelegate.shared.application(app, open: url, options: options)
    }
}
