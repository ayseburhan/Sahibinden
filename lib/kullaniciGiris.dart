import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'ana_sayfa.dart';
import 'kullanici_kayit.dart';
import 'services/UserAuthService.dart';
import 'services/cookie_manager.dart';
import 'globals.dart'; // Global değişkeni import edin

class KullaniciGiris extends StatefulWidget {
  final UserAuthService authService;
  final CookieManager cookieManager;

  const KullaniciGiris({
    Key? key,
    required this.authService,
    required this.cookieManager,
  }) : super(key: key);

  @override
  State<KullaniciGiris> createState() => _KullaniciGirisState();
}

class _KullaniciGirisState extends State<KullaniciGiris> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

void _loginUser() async {
  bool isValid = _formKey.currentState!.validate();
  print('Form validation result: $isValid');

  if (isValid) {
    setState(() => _isLoading = true);
    try {
      int? adminBilgi= await widget.authService.loginUser(
        _emailController.text,
        _passwordController.text,
      );
// loginUser üzerinde taşınan admin bilgisini değişkene atayıp globalUserInfo.isAdmin değişkenine ataması yapılacak
      if (adminBilgi != null) {
        Map<String, String> userInfo = await _getUserInfoFromCookies();

        // Global kullanıcı bilgilerini ayarla
        globalUserInfo.kullaniciAdi = userInfo['username'];
        globalUserInfo.kullaniciSoyadi = userInfo['soyad'];
        globalUserInfo.kullaniciSifre = userInfo['sifre'];
        globalUserInfo.email = userInfo['email'];
        globalUserInfo.isAdmin = adminBilgi;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Giriş başarılı.")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(cookieManager: widget.cookieManager),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Giriş başarısız. Lütfen bilgilerinizi kontrol edin.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Bir hata oluştu: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Form validasyonu başarısız. Lütfen tüm alanları doğru doldurduğunuzdan emin olun.")),
    );
  }
}



  Future<Map<String, String>> _getUserInfoFromCookies() async {
    Map<String, String> userInfo = {};
    userInfo['username'] = await widget.cookieManager.getCookie('username') ?? '';
    userInfo['email'] = await widget.cookieManager.getCookie('email') ?? '';
    userInfo['ad'] = await widget.cookieManager.getCookie('ad') ?? '';
    userInfo['soyad'] = await widget.cookieManager.getCookie('soyad') ?? '';
    userInfo['telefon'] = await widget.cookieManager.getCookie('telefon') ?? '';
    return userInfo;
  }

  void _continueAsGuest() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(cookieManager: widget.cookieManager),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 20.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20.0,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Kullanıcı Giriş Ekranı',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen email adresinizi girin';
                    }
                    if (!EmailValidator.validate(value)) {
                      return 'Geçerli bir email adresi giriniz';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Şifre',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen şifrenizi girin';
                    }
                    if (value.length < 6) {
                      return 'Şifre en az 6 karakter olmalıdır';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isLoading ? null : _loginUser,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Giriş Yap'),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: _continueAsGuest,
                  child: const Text(
                    'Üyeliksiz Devam Et',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Hesabınız yok mu?'),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUpPage(
                              authService: widget.authService,
                              cookieManager: widget.cookieManager,
                            ),
                          ),
                        );
                      },
                      child: const Text('Üye Ol', style: TextStyle(fontSize: 20)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
