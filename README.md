# PPB Assignment 2

| Nama                       | NRP           |
|----------------------------|---------------|
| Apta Rasendriya Wijaya     |5025211139     |

## Introduction

### Penjelasan Singkat
Isar adalah database NoSQL yang cepat, skalabel, dan sepenuhnya offline yang dibuat khusus untuk Flutter, dengan operasi asinkron, pencarian teks lengkap, dukungan ACID, tanpa boilerplate—dan sepenuhnya kompatibel di iOS, Android, dan Desktop.


## Setup
Untuk menggunakan database local Isar kita perlu mengubah konfigurasi pada file `pubspec.yaml` pada bagian `dependencies` dan `dev_dependencies` seperti berikut:

```yaml
dependencies:
  flutter:
    sdk: flutter

  cupertino_icons: ^1.0.8
  intl: ^0.17.0
  isar: ^3.1.0+1
  isar_flutter_libs: ^3.1.0+1
  path_provider: ^2.1.5

dev_dependencies:
  flutter_test:
    sdk: flutter

  flutter_lints: ^5.0.0
  isar_generator: ^3.1.0+1
  build_runner: any
```

## Implementation
### 1. Inisialisasi Database
Langkah pertama adalah mengatur lokasi penyimpanan data dengan menggunakan bantuan library `path_provider`. Data akan disimpan secara lokal di direktori aplikasi.

```dart
import 'package:isar/isar.dart';
import 'package:isar_local_db/models/alarm.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseService {

  static late final Isar db;

  static Future<void> setup() async {
    final appDir = await getApplicationDocumentsDirectory();
    db = await Isar.open([AlarmSchema], directory: appDir.path);
  }
}

```

### 2. Membuat Model (Schema)
Langkah selanjutnya adalah membuat model atau class yang akan digunakan sebagai schema untuk Isar. Gunakan anotasi @Collection() di atas class untuk menandai bahwa ini adalah model Isar. Model ini dapat dianalogikan seperti tabel di database SQL.

Di sini kita juga menggunakan fungsi updateAlarm() daripada constructor untuk kemudahan dalam pembaruan data, menghindari potensi error ketika mendefinisikan constructor yang kompleks.

Contoh file alarm.dart:

```dart
import 'package:isar/isar.dart';

part 'alarm.g.dart';

@Collection()
class Alarm {
  Id id = Isar.autoIncrement;
  DateTime alarmDateTime = DateTime.now();
  String? description;
  bool isActive = true;

  Alarm updateAlarm(DateTime alarmDateTime, {String? description, bool isActive = true}){
    final updated = Alarm()
      ..alarmDateTime = alarmDateTime
      ..description = description
      ..isActive = isActive
      ..id = id;
    return updated;
  }
}
```

Jangan lupa untuk memastikan penamaan part disesuaikan dengan nama file .dart seperti pada contoh di atas, yaitu `alarm.g.dart`. Setelah selesai membuat model, jalankan perintah berikut di terminal untuk menghasilkan file `alarm.g.dart`:

```
flutter pub run build_runner build
```
File `alarm.g.dart` akan berisi kode bagaimaan bentuk schema kita dalam data base.

![image](https://github.com/user-attachments/assets/331e8758-c466-4b5d-bcef-b316352b51cf)


### 3. Operasi CRUD (Create, Read, Update, Delete)
Berikut adalah cara-cara umum yang dapat digunakan untuk operasi CRUD (Create, Read, Update, Delete) di database Isar.


####  a. Mengambil Semua Data (Read)
Untuk mengambil semua data dari database Isar, gunakan:

```dart
final isarAlarms = await DatabaseService.db.alarms.where().findAll();
```

Hasil dari query ini bisa disimpan dalam List<Alarm> untuk ditampilkan ke UI. Contoh implementasinya dapat dilihat di file [alarm_home.dart](lib/alarm_home.dart). Berikut merupakan contoh hasil setelah data berhasil dibaca:

![image](https://github.com/user-attachments/assets/bebd2df7-c04d-4aed-92aa-4b7a3bdfdd2d)

    
####  b. Menambahkan Data (Create)
Untuk menambahkan data baru ke database, gunakan:

```dart
await DatabaseService.db.writeTxn(() async {
  DatabaseService.db.alarms.put(newAlarm);
});
```
Contoh implementasinya dapat dilihat di file [alarm_add.dart](lib/alarm_add.dart). Berikut merupakan contoh hasil setelah data berhasil ditambahkan:

![image](https://github.com/user-attachments/assets/429a7459-7191-467d-a216-18c2f24c683d)

    
####  c. Memperbarui Data (Update)
Untuk memperbarui data yang sudah ada, gunakan:

```dart
await DatabaseService.db.writeTxn(() async {
  await DatabaseService.db.alarms.put(alarmToEdit);
});
```
Contoh implementasinya dapat dilihat di file [alarm_home.dart](lib/alarm_home.dart). Berikut merupakan contoh hasil setelah data berhasil diperbarui:

![image](https://github.com/user-attachments/assets/f4d2aca2-e3ce-4c65-9833-ab2d8fbf326b)

      
####  d. Menghapus Data (Delete)
Untuk menghapus data berdasarkan ID, gunakan:

```dart
await DatabaseService.db.writeTxn(() async {
  await DatabaseService.db.alarms.delete(alarmToDelete.id);
});
```
Contoh implementasinya dapat dilihat di file [alarm_home.dart](lib/alarm_home.dart). Berikut merupakan contoh hasil setelah data berhasil dihapus:
    
![image](https://github.com/user-attachments/assets/19495c34-5fd2-448d-8eb1-58e218cfe31e)


