class Product {
  final int id;
  final int kategoriId;
  final String urunAdi;
  final String urunAciklama;
  final double urunFiyat;
  final int urunStok;
  final String eklenmeTarihi;
  final String urunDurum;
  final String urunGorsel;

  Product({
    required this.id,
    required this.kategoriId,
    required this.urunAdi,
    required this.urunAciklama,
    required this.urunFiyat,
    required this.urunStok,
    required this.eklenmeTarihi,
    required this.urunDurum,
    required this.urunGorsel,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      kategoriId: json['kategoriId'],
      urunAdi: json['urunAdi'],
      urunAciklama: json['urunAciklama'],
      urunFiyat: json['urunFiyat'],
      urunStok: json['urunStok'],
      eklenmeTarihi: json['eklenmeTarihi'],
      urunDurum: json['urunDurum'],
      urunGorsel: json['urunGorsel'],
    );
  }
  
  
}
