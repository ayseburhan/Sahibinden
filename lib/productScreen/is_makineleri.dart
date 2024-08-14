import 'package:flutter/material.dart';
import 'package:kullanici_giris/productScreen/productdetail/isMakineleriDetay.dart';
import 'yeniIlan.dart';


enum IsMakineleriKategori {
  tumu,
  tarim,
  sanayi,
  insaat,
  diger,
}

enum IsMakineleriDurum {
  tumu,
  satilik,
  kiralik,
  parca,
}

class IsMakinesi {
  final String imageUrl;
  final String title;
  final String description;
  final String price;
  final IsMakineleriKategori kategori;

  IsMakinesi({
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.price,
    required this.kategori,
  });
}

class IsMakineleriPage extends StatefulWidget {
  const IsMakineleriPage({super.key});

  @override
  _IsMakineleriPageState createState() => _IsMakineleriPageState();
}

class _IsMakineleriPageState extends State<IsMakineleriPage> {
  IsMakineleriKategori selectedKategori = IsMakineleriKategori.tumu;
  IsMakineleriDurum selectedDurum = IsMakineleriDurum.tumu;

  List<IsMakinesi> tumMakineler = [
    IsMakinesi(
      imageUrl: 'https://www.eker-mak.com.tr/wp-content/uploads/2020/12/SFN_1839-1.jpg',
      title: 'Tarım Makinesi ',
      description: 'Bu makine tarım işleri için tasarlanmıştır.',
      price: '50.000 TL',
      kategori: IsMakineleriKategori.tarim,
    ),
    IsMakinesi(
      imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTX_xJfAIDLyliJvUFK7ISP-DqTZgQBRO-z8w&s',
      title: 'Sanayi Makinesi ',
      description: 'Bu makine endüstriyel işler için uygun.',
      price: '100.000 TL',
      kategori: IsMakineleriKategori.sanayi,
    ),
    IsMakinesi(
      imageUrl: 'https://www.enka.com.tr/u/i/kategori/hitachi-ekskavatorler.jpg',
      title: 'İnşaat Makinesi ',
      description: 'Büyük inşaat projeleri için ideal.',
      price: '200.000 TL',
      kategori: IsMakineleriKategori.insaat,
    ),
    IsMakinesi(
      imageUrl: 'https://fulljenerator.com/Content/img/hakkimizda_800x800.jpg',
      title: 'Diğer Makine ',
      description: 'Genel amaçlı iş makineleri.',
      price: '80.000 TL',
      kategori: IsMakineleriKategori.diger,
    ),
  ];

  void _ilanEkle(String title, String price, String imageUrl, String description) {
    setState(() {
      tumMakineler.add(
        IsMakinesi(
          imageUrl: imageUrl,
          title: title,
          description: description,
          price: price,
          kategori: selectedKategori, // Kategori burada seçilen kategori olarak set ediliyor
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('İş Makineleri'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => YeniIlanPage(onIlanEkle: _ilanEkle),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFilterWidget(),
          Expanded(
            child: ListView.builder(
              itemCount: _filterMakineler().length,
              itemBuilder: (context, index) {
                final makine = _filterMakineler()[index];
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IsMakinesiDetay(
                          imageUrl: makine.imageUrl,
                          title: makine.title,
                          description: makine.description,
                          price: makine.price,
                        ),
                      ),
                    );
                  },
                  leading: Image.network(
                    makine.imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(makine.title),
                  subtitle: Text(makine.description),
                  trailing: Text(makine.price),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<IsMakinesi> _filterMakineler() {
    return tumMakineler.where((makine) {
      bool kategoriMatch = selectedKategori == IsMakineleriKategori.tumu ||
          makine.kategori == selectedKategori;
      bool durumMatch = selectedDurum == IsMakineleriDurum.tumu;
      return kategoriMatch && durumMatch;
    }).toList();
  }

  Widget _buildFilterWidget() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kategori Seçiniz',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          DropdownButton<IsMakineleriKategori>(
            value: selectedKategori,
            onChanged: (value) {
              setState(() {
                selectedKategori = value!;
              });
            },
            items: IsMakineleriKategori.values
                .map((kategori) => DropdownMenuItem(
              value: kategori,
              child: Text(kategori.toString().split('.').last),
            ))
                .toList(),
          ),
          const SizedBox(height: 20),
          const Text(
            'Durum Seçiniz',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          DropdownButton<IsMakineleriDurum>(
            value: selectedDurum,
            onChanged: (value) {
              setState(() {
                selectedDurum = value!;
              });
            },
            items: IsMakineleriDurum.values
                .map((durum) => DropdownMenuItem(
              value: durum,
              child: Text(durum.toString().split('.').last),
            ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
