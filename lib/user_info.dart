class UserInfo {
  String? kullaniciAdi;
  String ? kullaniciSoyadi;
  String? kullaniciSifre;
  String? email;
  
  int? isAdmin;

  UserInfo({this.kullaniciAdi,this.kullaniciSoyadi, this.email, this.isAdmin,this.kullaniciSifre});

  get authService => null;

  get cookieManager => null;

  get isLoggedIn => null;

}
