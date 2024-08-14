import 'package:flutter/material.dart';

class AdminPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Paneli'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.people),
            title: Text('Kullanıcı Yönetimi'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => UsersManagementPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Ürün Yönetimi'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProductsManagementPage()));
            },
          ),
        ],
      ),
    );
  }
}

class UsersManagementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kullanıcı Yönetimi'),
      ),
      body: Center(
        child: Text('Kullanıcı Ekle/Çıkar'),
      ),
    );
  }
}

class ProductsManagementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ürün Yönetimi'),
      ),
      body: Center(
        child: Text('Ürün Ekle/Çıkar'),
      ),
    );
  }
}
