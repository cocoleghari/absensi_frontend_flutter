class PusatLokasiModel {
  final int id;
  final String nama_lokasi;
  final String titik_koordinat;
  final String keterangan_lokasi;
  final DateTime created_at;
  final DateTime updated_at;

  PusatLokasiModel({
    required this.id,
    required this.nama_lokasi,
    required this.titik_koordinat,
    required this.keterangan_lokasi,
    required this.created_at,
    required this.updated_at,
  });

  factory PusatLokasiModel.fromJson(Map<String, dynamic> json) {
    return PusatLokasiModel(
      id: json['id'],
      nama_lokasi: json['nama_lokasi'],
      titik_koordinat: json['titik_koordinat'],
      keterangan_lokasi: json['keterangan_lokasi'],
      created_at: DateTime.parse(json['created_at']),
      updated_at: DateTime.parse(json['updated_at']),
    );
  }

  double? get latitude {
    try {
      final parts = titik_koordinat.split(',');
      if (parts.length == 2) {
        return double.tryParse(parts[0].trim());
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  double? get longitude {
    try {
      final parts = titik_koordinat.split(',');
      if (parts.length == 2) {
        return double.tryParse(parts[1].trim());
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  String get formattedKordinat {
    if (latitude != null && longitude != null) {
      return '${latitude!.toStringAsFixed(6)}, ${longitude!.toStringAsFixed(6)}';
    }
    return titik_koordinat;
  }

  bool get isKordinatValid {
    return latitude != null && longitude != null;
  }

  @override
  String toString() {
    return 'PusatLokasi{id: $id, nama: $nama_lokasi, kordinat: $titik_koordinat}';
  }
}
