import 'package:dartz/dartz.dart';
import 'package:planify/src/core/failures/failures.dart';
import 'package:planify/src/core/repository_base/repository_base.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/category_entity.dart';
import '../../domain/repository/category_repository.dart';
import '../models/category_model.dart';

class CategoryRepositoryImpl with RepositoryBase implements CategoryRepository {
  CategoryRepositoryImpl(this._client);

  final SupabaseClient _client;

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() =>
      safeCall<List<CategoryEntity>>(
        () async {
          final response =
              await _client.from('categories').select().order('name');
          return response
              .map((json) => CategoryModel.fromJson(json).toEntity())
              .toList();
        },
        operationName: 'CategoryRepository.getCategories',
      );
}
