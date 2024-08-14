import 'package:flutter/material.dart';
import 'package:kullanici_giris/kullaniciGiris.dart';
import 'package:kullanici_giris/services/UserAuthService.dart';
import 'package:kullanici_giris/services/cookie_manager.dart';
import 'package:email_validator/email_validator.dart';

class SignUpPage extends StatefulWidget {
  final UserAuthService authService;
  final CookieManager cookieManager;

  const SignUpPage({Key? key, required this.authService, required this.cookieManager}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}
class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _adController = TextEditingController();
  final TextEditingController _soyadController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefonController = TextEditingController();

  bool _isLoading = false;

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        print("Kayıt işlemi başlatılıyor...");

        bool success = await widget.authService.registerUser(
          _emailController.text,
          _usernameController.text,
          _passwordController.text,
          _adController.text,
          _soyadController.text,
          _telefonController.text,
        );

        print("Kayıt işlemi tamamlandı.");

        if (success) {
          print("Kayıt başarılı. Çerezler kaydediliyor...");

          await widget.cookieManager.saveCookie('username', _usernameController.text);
          await widget.cookieManager.saveCookie('email', _emailController.text);
          await widget.cookieManager.saveCookie('ad', _adController.text);
          await widget.cookieManager.saveCookie('soyad', _soyadController.text);
          await widget.cookieManager.saveCookie('telefon', _telefonController.text);

          print("Çerezler kaydedildi. Kullanıcı giriş ekranına yönlendiriliyor...");

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Başarıyla kaydedildi. Giriş yapabilirsiniz.")),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => KullaniciGiris(authService: widget.authService, cookieManager: widget.cookieManager)),
          );
        } else {
          print("Kayıt başarısız.");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Kayıt başarısız. Lütfen bilgilerinizi kontrol edin.")),
          );
        }
      } catch (e) {
        print("Kayıt sırasında bir hata oluştu: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Kayıt işlemi sırasında bir hata oluştu.")),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Üyelik Kayıt Ekranı')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Üye Ol',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              _buildTextFormField(_usernameController, 'Kullanıcı Adı'),
              _buildTextFormField(_adController, 'Ad'),
              _buildTextFormField(_soyadController, 'Soyad'),
              _buildTextFormField(_emailController, 'Email', isEmail: true),
              _buildTextFormField(_passwordController, 'Şifre', isPassword: true),
              _buildTextFormField(_telefonController, 'Telefon'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _registerUser,
                child: _isLoading
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                    : const Text('Üye Ol', style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(TextEditingController controller, String label,
      {bool isPassword = false, bool isEmail = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey[200],
          suffixIcon: isPassword ? IconButton(
            icon: Icon(
              isPassword ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                isPassword = !isPassword;
              });
            },
          ) : null,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$label boş bırakılamaz';
          }
          if (isEmail && !EmailValidator.validate(value)) {
            return 'Geçerli bir email adresi giriniz';
          }
          if (isPassword && value.length < 6) {
            return 'Şifre en az 6 karakter olmalıdır';
          }
          return null;
        },
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _adController.dispose();
    _soyadController.dispose();
    _emailController.dispose();
    _telefonController.dispose();
    super.dispose();
  }
}
