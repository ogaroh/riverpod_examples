import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:social_up/state/auth/backend/authenticator.dart';
import 'package:social_up/state/auth/models/auth_result.dart';
import 'package:social_up/state/auth/models/auth_state.dart';
import 'package:social_up/state/posts/typedefs/user_id.dart';
import 'package:social_up/state/user_info/backend/user_info_storage.dart';

class AuthStateNotifier extends StateNotifier<AuthState> {
  final _authenticator = const Authenticator();
  final _userInfoStorage = const UserInfoStorage();

  AuthStateNotifier() : super(const AuthState.unknown()) {
    if (_authenticator.isAlreadyLoggedIn) {
      state = AuthState(
        isLoading: false,
        result: AuthResult.success,
        userId: _authenticator.userId,
      );
    }
  }

  // logout
  Future<void> logOut() async {
    state = state.copiedWithIsLoading(true);
    await _authenticator.logout();
    state = const AuthState.unknown();
  }

  // login with Google
  Future<void> loginWithGoogle() async {
    state = state.copiedWithIsLoading(true);

    final result = await _authenticator.loginWithGoogle();
    final userId = _authenticator.userId;

    if (result == AuthResult.success && userId != null) {
      await saveUserInfo(
        userId: userId,
      );
    }

    state = AuthState(
      result: result,
      isLoading: false,
      userId: userId,
    );
  }

  // login with Facebook
  Future<void> loginWithFacebook() async {
    state = state.copiedWithIsLoading(true);

    final result = await _authenticator.loginWithFacebook();
    final userId = _authenticator.userId;

    if (result == AuthResult.success && userId != null) {
      await saveUserInfo(
        userId: userId,
      );
    }

    state = AuthState(
      result: result,
      isLoading: false,
      userId: userId,
    );
  }

  // save user info
  Future<void> saveUserInfo({required UserId userId}) =>
      _userInfoStorage.saveUserInfo(
        userId: userId,
        displayName: _authenticator.displayName,
        email: _authenticator.email,
      );
}
