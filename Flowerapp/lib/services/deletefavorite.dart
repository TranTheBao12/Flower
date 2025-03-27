import 'package:http/http.dart' as http;

class DeleteFavoriteService {
  final String apiUrl = 'https://newyellowrock28.conveyor.cloud/api/FavoriteProduct/product'; // Không thêm dấu `/` cuối

  Future<void> deleteFavoriteProduct(int idProduct) async {
    final url = Uri.parse('$apiUrl/$idProduct'); // Tạo URL chính xác

    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception('Không thể xóa sản phẩm yêu thích');
    }
  }
}
