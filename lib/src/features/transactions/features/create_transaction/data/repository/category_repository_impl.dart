import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/category_entity.dart';
import '../../domain/repository/category_repository.dart';
import '../models/category_model.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  CategoryRepositoryImpl(this._client);

  final SupabaseClient _client;

  @override
  Future<List<CategoryEntity>> getCategories() async {
    final response = await _client
        .from('categories')
        .select()
        .order('name');

    return response
        .map((json) => CategoryModel.fromJson(json).toEntity())
        .toList();
  }
}
