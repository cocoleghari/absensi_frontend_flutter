class PusatLokasiModel {
  final int id;
  final String nama_lokasi;
  final String titik_koordinat;
  final String keterangan_lokasi;

  PusatLokasiModel({
    required this.id,
    required this.nama_lokasi,
    required this.titik_koordinat,
    required this.keterangan_lokasi,
  });

  factory PusatLokasiModel.fromJson(Map<String, dynamic> json) {
    return PusatLokasiModel(
      id: json['id'],
      nama_lokasi: json['nama_lokasi'],
      titik_koordinat: json['titik_koordinat'],
      keterangan_lokasi: json['keterangan_lokasi'],
    );
  }
}
