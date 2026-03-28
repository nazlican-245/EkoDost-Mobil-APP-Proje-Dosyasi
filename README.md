<div align="center">

# ⚡ EkoDost

### Akıllı Enerji Tüketimi Takip ve Gamification Uygulaması
### Smart Energy Consumption Tracking & Gamification Application

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart)](https://dart.dev)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-lightgrey)](https://flutter.dev)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)
[![TÜBİTAK](https://img.shields.io/badge/TÜBİTAK-Destekli%20Proje-red)](https://www.tubitak.gov.tr)

</div>

---

## 📌 Proje Hakkında / About

**TR:** EkoDost, hane halkının elektrik tüketimini gerçek zamanlı olarak izlemesini, analiz etmesini ve gamification mekanizmaları aracılığıyla tasarruf davranışlarını geliştirmesini sağlayan bir mobil uygulamadır. Proje, enerji verimliliğini artırmaya yönelik TÜBİTAK destekli bir araştırma kapsamında geliştirilmiştir.

**EN:** EkoDost is a mobile application that enables households to monitor their electricity consumption in real time, analyze usage patterns, and improve energy-saving behaviors through gamification mechanisms. The project was developed as part of a TÜBİTAK-supported research initiative aimed at improving energy efficiency.

---

## 🌟 Özellikler / Features

| Özellik / Feature | Açıklama / Description |
|---|---|
| 📊 **Gerçek Zamanlı Dashboard** | Anlık tüketim verisi ve günlük özet / Real-time consumption & daily summary |
| 📈 **Tüketim Analizi** | Grafik bazlı tüketim analizi ve trend raporları / Chart-based analysis & trend reports |
| 🔮 **Tahmin & Uyarılar** | AI destekli tüketim tahmini ve anomali tespiti / AI-powered forecasting & anomaly detection |
| 🏆 **Gamification Hub** | Rozet, seviye, görev ve liderboard sistemi / Badges, levels, missions & leaderboard |
| 🎯 **Hedef Yönetimi** | Kişiselleştirilmiş tasarruf hedefleri / Personalized saving goals |
| 👤 **Hane Profili** | Akıllı sayaç entegrasyonu ve grup atama / Smart meter integration & group assignment |
| 🔔 **Akıllı Bildirimler** | Pik saat uyarıları ve tasarruf ipuçları / Peak hour alerts & saving tips |

---

## 🏗️ Mimari & Teknolojiler / Architecture & Technologies

### Teknoloji Yığını / Tech Stack
- **Framework:** Flutter (Dart)
- **HTTP Client:** Dio
- **Grafik / Charts:** FL Chart
- **Yerel Depolama / Local Storage:** Shared Preferences
- **Responsive Tasarım / Responsive Design:** Sizer
- **Animasyonlar / Animations:** Flutter Animate
- **QR / Barkod:** Mobile Scanner

### Proje Yapısı / Project Structure

```
ekodost/
├── lib/
│   ├── core/
│   │   ├── utils/              # Hesaplama yardımcıları / Calculation helpers
│   │   └── widgets/            # Ortak widget'lar / Shared widgets
│   ├── features/
│   │   ├── feedback/           # Görev/misyon sistemi / Mission system
│   │   └── gamification/       # Gamification mantığı / Gamification logic
│   ├── presentation/
│   │   ├── authentication_screen/
│   │   ├── consumption_analysis_screen/
│   │   ├── gamification_hub_screen/
│   │   ├── household_profile_setup_screen/
│   │   ├── predictions_and_alerts_screen/
│   │   ├── profile_screen/
│   │   └── real_time_dashboard_screen/
│   ├── routes/                 # Uygulama yönlendirme / App routing
│   ├── theme/                  # Tema konfigürasyonu / Theme config
│   ├── widgets/                # Yeniden kullanılabilir bileşenler / Reusable components
│   └── main.dart
├── assets/
│   └── images/
├── android/
├── ios/
├── test/
├── env.example.json            # Ortam değişkeni şablonu / Env variable template
└── pubspec.yaml
```

---

## 🚀 Kurulum / Installation

### Gereksinimler / Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) `^3.x`
- Dart SDK `^3.9.0`
- Android Studio veya VS Code (Flutter eklentileriyle / with Flutter extensions)
- Android SDK (Android için / for Android) veya Xcode (iOS için / for iOS)

### Adımlar / Steps

**1. Repository'yi klonlayın / Clone the repository**
```bash
git clone https://github.com/KULLANICI_ADINIZ/ekodost.git
cd ekodost
```

**2. Ortam değişkenlerini ayarlayın / Configure environment variables**
```bash
cp env.example.json env.json
# env.json dosyasını kendi API anahtarlarınızla doldurun
# Fill env.json with your own API keys
```

**3. Bağımlılıkları yükleyin / Install dependencies**
```bash
flutter pub get
```

**4. Uygulamayı çalıştırın / Run the application**
```bash
flutter run
```

---

## 🧪 Testler / Tests

```bash
# Tüm testleri çalıştır / Run all tests
flutter test

# Belirli bir test dosyası / Specific test file
flutter test test/core/calculations_test.dart
```

Test kapsamı / Test coverage:
- `test/core/calculations_test.dart` — Enerji hesaplama testleri / Energy calculation tests
- `test/features/feedback/goal_progress_bar_test.dart` — Hedef ilerleme çubuğu testleri
- `test/features/gamification/mission_widget_test.dart` — Görev widget testleri
- `test/features/gamification/streak_flame_test.dart` — Streak sistemi testleri

---

## 📦 Derleme / Build

```bash
# Android APK
flutter build apk --release

# Android App Bundle (Play Store için / for Play Store)
flutter build appbundle --release

# iOS
flutter build ios --release
```

---

## 🔐 Güvenlik Notu / Security Note

Bu proje API anahtarları ve hassas bilgileri `env.json` dosyasında saklar. Bu dosya `.gitignore`'a eklenmiştir ve **kesinlikle versiyon kontrolüne dahil edilmemelidir**.

This project stores API keys and sensitive information in `env.json`. This file is added to `.gitignore` and **must never be committed to version control**.

`env.example.json` dosyası yapılandırma referansı olarak sunulmuştur. / `env.example.json` is provided as a configuration reference.

---

## 📄 Lisans / License

Bu proje MIT Lisansı kapsamında lisanslanmıştır. Detaylar için [LICENSE](LICENSE) dosyasına bakınız.

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## 🙏 Teşekkür / Acknowledgments

Bu proje **TÜBİTAK** (Türkiye Bilimsel ve Teknolojik Araştırma Kurumu) desteğiyle geliştirilmiştir.

This project was developed with the support of **TÜBİTAK** (The Scientific and Technological Research Council of Türkiye).

- [Flutter](https://flutter.dev) & [Dart](https://dart.dev) — Uygulama çerçevesi / Application framework
- [FL Chart](https://pub.dev/packages/fl_chart) — Grafik kütüphanesi / Chart library
- [Material Design](https://material.io) — Tasarım sistemi / Design system

---

<div align="center">
Türkiye 🇹🇷 için geliştirildi / Developed for Türkiye 🇹🇷
</div>
