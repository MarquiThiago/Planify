import 'package:dartz/dartz.dart';
import 'package:planify/src/core/failures/failures.dart';

import '../entities/category_entity.dart';

abstract class CategoryRepository {
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
}
