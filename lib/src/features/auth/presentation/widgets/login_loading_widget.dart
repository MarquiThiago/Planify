import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../auth_dimens.dart';

class LoginLoadingWidget extends StatelessWidget {
  const LoginLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: Padding(
        padding: const EdgeInsets.all(AuthDimens.pagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AuthDimens.spacingXLarge),
            // Title skeleton
            Container(
              height: 32,
              width: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AuthDimens.buttonRadius),
              ),
            ),
            const SizedBox(height: AuthDimens.spacingSmall),
            // Subtitle skeleton
            Container(
              height: 16,
              width: 240,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AuthDimens.buttonRadius),
              ),
            ),
            const SizedBox(height: AuthDimens.spacingLarge),
            // Email field skeleton
            Container(
              height: AuthDimens.buttonHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AuthDimens.fieldRadius),
              ),
            ),
            const SizedBox(height: AuthDimens.spacing),
            // Password field skeleton
            Container(
              height: AuthDimens.buttonHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AuthDimens.fieldRadius),
              ),
            ),
            const SizedBox(height: AuthDimens.spacingLarge),
            // Sign in button skeleton
            Container(
              height: AuthDimens.buttonHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AuthDimens.buttonRadius),
              ),
            ),
            const SizedBox(height: AuthDimens.spacingLarge),
            // OAuth buttons skeleton
            Container(
              height: AuthDimens.buttonHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AuthDimens.buttonRadius),
              ),
            ),
            const SizedBox(height: AuthDimens.spacing),
            Container(
              height: AuthDimens.buttonHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AuthDimens.buttonRadius),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
