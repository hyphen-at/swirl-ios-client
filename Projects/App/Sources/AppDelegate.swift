import ComposableArchitecture
import FirebaseMessaging
import HyphenAuthenticate
import HyphenCore
import HyphenUI
import SwiftUI
import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = UIHostingController(
            rootView: SwirlApp(
                store: Store(
                    initialState: SwirlCoordinator.State(),
                    reducer: SwirlCoordinator()
//                        .signpost()
//                        ._printChanges()
                )
            )
        )
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.isHidden = true
        // avigationController.navigationItem.backButtonTitle = "Back"
        // navigationController.navigationBar.tintColor = .black
        // navigationController.title = "Key Manager"
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        // HyphenCryptography.deleteKey()

        Hyphen.shared.network = .mainnet
        Hyphen.shared.appSecret = "iuw1jf5k6j2y0y5iz36xakbii4dkkktledplmuj83380"
        HyphenAuthenticateAppDelegate.shared.application(application)
        HyphenUI.shared.application(application, didFinishLaunchingWithOptions: launchOptions)

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error {
                print(error)
            } else {
                DispatchQueue.main.async {
                    UNUserNotificationCenter.current().delegate = self
                    application.registerForRemoteNotifications()
                }
            }

            print("===== [SwirlAppDelegate] remote notification permission isGranted = \(granted)")
        }

        if let notificationInfo = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? [AnyHashable: Any] {
            Task {
                await Hyphen.shared.handleNotificationWhenAppNotRunning(userInfo: notificationInfo)
            }
        }

        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        HyphenAuthenticateAppDelegate.shared.application(app, open: url, options: options)
    }

    func application(_: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Hyphen.shared.apnsToken = deviceToken
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) async -> UIBackgroundFetchResult {
        await Hyphen.shared.application(application, didReceiveRemoteNotification: userInfo)

        return .newData
    }

    func userNotificationCenter(_: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        let userInfo = notification.request.content.userInfo
        print(userInfo)

        return [[.alert, .sound, .badge, .list]]
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        await Hyphen.shared.userNotificationCenter(center, didReceive: response)
    }
}
