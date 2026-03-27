import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:pj_domain/pj_domain.dart';
import '../../core/api_provider.dart';

final shipmentListProvider = FutureProvider<List<Shipment>>((ref) async {
  final client = ref.watch(apiClientProvider);
  try {
    final response = await client.getShipments();
    final List data = response.data['data'];
    return data.map((json) => Shipment.fromJson(json)).toList();
  } on DioException catch (e) {
    if (e.response?.statusCode == 401) {
      throw Exception('مۆڵەت پێنەدراوە. تکایە دووبارە بچۆ ژوورەوە.');
    }
    rethrow;
  }
});
