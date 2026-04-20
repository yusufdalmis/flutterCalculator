# Flutter Scientific Calculator

Flutter ile geliştirilmiş bilimsel hesap makinesi uygulaması.

## Ozellikler

- Bilimsel fonksiyonlar: `sin`, `cos`, `tan`, `log`, `sqrt`
- Temel islemler: toplama, cikarma, carpma, bolme
- Us alma (`^`) ve parantez destegi
- `DEL` (geri silme), `C` (temizleme), `=` (hesaplama)
- Web, Android, Windows dahil coklu platform calisma destegi

## Gereksinimler

- Flutter SDK (onerilen: 3.41.x veya ustu)
- Dart SDK (Flutter ile birlikte gelir)
- Git
- Android cihazda calistirmak icin:
	- Android Studio veya Android SDK + platform tools
	- USB debugging acik bir Android telefon
- Webde calistirmak icin:
	- Chrome veya Edge

## 1) Projeyi Indirme

### A) Normal klonlama

```bash
git clone https://github.com/yusufdalmis/flutterCalculator.git
cd flutterCalculator
```

### B) Proje klasoru zaten varsa (bu repo icindeyseniz)

Sadece terminalde proje kok dizinine gecin:

```bash
cd D:/flutter_calculator
```

## 2) Bagimliliklari Yukleme

```bash
flutter pub get
```

## 3) Ortami Dogrulama

```bash
flutter doctor
flutter devices
```

- `flutter doctor`: eksik SDK veya lisans sorunlarini gosterir.
- `flutter devices`: calistirma hedeflerini listeler (telefon, web, masaustu).

## 4) Uygulamayi Calistirma

### Web (onerilen hizli baslangic)

Chrome icin:

```bash
flutter run -d chrome
```

Edge icin:

```bash
flutter run -d edge
```

Komut calisinca uygulama tarayicida acilir.

### Android telefon

1. Telefonda gelistirici seceneklerini ve USB debugging ozelligini acin.
2. Telefonu USB ile baglayin.
3. Cihazin gorundugunu kontrol edin:

```bash
flutter devices
```

4. Listede cihaz ID gorundugunde calistirin:

```bash
flutter run -d <cihaz_id>
```

Ornek:

```bash
flutter run -d R58N123ABC
```

### Windows masaustu

```bash
flutter run -d windows
```

## 5) Gelistirme Sirasinda Yarali Komutlar

```bash
flutter analyze
flutter test
flutter clean
flutter pub get
```

- `flutter analyze`: statik analiz ve kod kalitesi kontrolu
- `flutter test`: birim/widget testlerini calistirir
- `flutter clean`: gecici build dosyalarini temizler

## 6) Uretim Build Alma

### Android APK

```bash
flutter build apk --release
```

APK yolu:

`build/app/outputs/flutter-apk/app-release.apk`

### Web Build

```bash
flutter build web --release
```

Cikti klasoru:

`build/web/`

### Windows Build

```bash
flutter build windows --release
```

## Sik Karsilasilan Sorunlar

### 1) Cihaz gorunmuyor

- `flutter devices` komutunu calistirin.
- Android icin USB debugging acik oldugundan emin olun.
- Gerekirse kabloyu degistirin ve tekrar baglayin.

### 2) Lisans veya SDK hatasi

```bash
flutter doctor --android-licenses
flutter doctor
```

### 3) Paket indirme hatalari

- Internet baglantisini kontrol edin.
- Ardindan:

```bash
flutter clean
flutter pub get
```

## Proje Yapisi

- `lib/main.dart`: arayuz ve hesaplama mantigi
- `test/widget_test.dart`: temel widget testi
- `pubspec.yaml`: bagimliliklar ve proje metadata

## Kaynaklar

- [Flutter Dokumantasyon](https://docs.flutter.dev/)
- [Dart Dokumantasyon](https://dart.dev/guides)
