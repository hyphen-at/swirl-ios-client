import ComposableArchitecture
import SwirlMakeProfileFeature
import SwirlNameCardDetailFeature
import SwirlNameCardListFeature
import SwirlSignInFeature

struct SwirlRoot: ReducerProtocol {
    enum State: Equatable {
        case signIn(SignIn.State)
        case signInConfirmation(SignInConfirmation.State)
        case makeProfile(MakeProfile.State)
        case nameCardList(NameCardList.State)
        case nameCardDetail(NameCardDetail.State)
    }

    enum Action {
        case signIn(SignIn.Action)
        case signInConfirmation(SignInConfirmation.Action)
        case makeProfile(MakeProfile.Action)
        case nameCardList(NameCardList.Action)
        case nameCardDetail(NameCardDetail.Action)
    }

    var body: some ReducerProtocol<State, Action> {
        Scope(state: /State.signIn, action: /Action.signIn) {
            SignIn()
        }
        Scope(state: /State.signInConfirmation, action: /Action.signInConfirmation) {
            SignInConfirmation()
        }
        Scope(state: /State.makeProfile, action: /Action.makeProfile) {
            MakeProfile()
        }
        Scope(state: /State.nameCardList, action: /Action.nameCardList) {
            NameCardList()
        }
        Scope(state: /State.nameCardDetail, action: /Action.nameCardDetail) {
            NameCardDetail()
        }
    }
}
