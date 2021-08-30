
/* class GoogleSignHelper {
  static GoogleSignHelper _instance = GoogleSignHelper._private();
  GoogleSignHelper._private();

  static GoogleSignHelper get instance => _instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  Future<GoogleSignInAccount?> signIn() async {
    try {
      final user = await _googleSignIn.signIn();
      return user;
    } catch (e) {
      print("Google Signin Error: $e");
    }
  }

  Future<GoogleSignInAuthentication?> googleAuthtentice() async {
    try {
      if (await _googleSignIn.isSignedIn()) {
        final user = _googleSignIn.currentUser;
        final userData = await user!.authentication;

        return userData;
      }
    } catch (e) {
      print("Google Signin Error: $e");
    }
  }

  Future<GoogleSignInAccount?> signOut() async {
    try {
      final user = await _googleSignIn.signOut();
      return user;
    } catch (e) {
      print("Google Signin Error: $e");
    }
  }
}
 */