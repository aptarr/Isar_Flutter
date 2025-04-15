# PPB Assignment 2

| Nama                       | NRP           |
|----------------------------|---------------|
| Apta Rasendriya Wijaya     |5025211139     |

## Introduction

### Explanation
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
1. Langkah pertama untuk menggunakan database Isar kita perlu mendefine terlebih dahulu letak kita menyimpan data tersebut dengan bantuan library `path_provider` yang mana data ini nantinya akan disimpan pada project kita saja atau dalam aplikasinya sendiri ketika dijalankan

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

2. Langkah Kedua setelah selesai untuk menggunakan database Isar kita perlu mendeklarasikan terlebih dahulu class untuk data yang akan kita simpan (class disini bisa kita ibaratkan sebagai tabel pada database SQL) seperti pada file `alarm.dart`:

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
3. untuk memanggil sintax disini saya hanya akan menjelaskan 4 saja yaitu Mengambil semua data, Add data, Edit data, dan delete data
   a. Mengambil semua data
        untuk mengambil semua data pada database Isar kita bisa menggunakan sintax berikut

```dart
final isarAlarms = await DatabaseService.db.alarms.where().findAll();
```

dimana natinya hasil ini tetap akan di letakkan pada sebuah variable List<> sebagai perantara untuk dibaca oleh aplikasi (implemntasi ini sendiri bisa dilihat pada file `alarm_home.dart`). Berikut merupakan contoh hasil setelah data berhasil ditambahakn:
    

    b. Menambahkan data semua data
        untuk mengambil semua data pada database Isar kita bisa menggunakan sintax berikut

```dart
final isarAlarms = await DatabaseService.db.alarms.where().findAll();
```