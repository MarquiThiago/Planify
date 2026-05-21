import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planify/src/core/design_system/design_system.dart';
import 'package:planify/src/core/di/injection.dart';
import 'package:planify/src/features/accounts/domain/entities/account_entity.dart';

import '../../domain/entities/category_entity.dart';
import '../bloc/create_transaction/create_transaction_bloc.dart';
import '../bloc/create_transaction/create_transaction_event.dart';
import '../bloc/create_transaction/create_transaction_state.dart';
import '../transaction_dimens.dart';
import '../transaction_strings.dart';

/// Shows the create transaction bottom sheet.
/// Returns [true] if a transaction was successfully created.
Future<bool?> showCreateTransactionBottomSheet(BuildContext context) {
  final screenHeight = MediaQuery.of(context).size.height;

  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: context.colors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppRadius.xl),
      ),
    ),
    builder: (_) => BlocProvider(
      create: (_) => getIt<CreateTransactionBloc>()
        ..add(const CreateTransactionInitialized()),
      child: SizedBox(
        height: screenHeight * TransactionDimens.sheetHeightFactor,
        child: const _CreateTransactionSheet(),
      ),
    ),
  );
}

// ─── Sheet root ─────────────────────────────────────────────────────────────

class _CreateTransactionSheet extends StatefulWidget {
  const _CreateTransactionSheet();

  @override
  State<_CreateTransactionSheet> createState() =>
      _CreateTransactionSheetState();
}

class _CreateTransactionSheetState extends State<_CreateTransactionSheet> {
  final _notesController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateTransactionBloc, CreateTransactionState>(
      listener: (context, state) {
        if (state is CreateTransactionReady && state.submitError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.submitError!)),
          );
        }
        if (state is CreateTransactionSuccess) {
          Navigator.of(context).pop(true);
        }
      },
      builder: (context, state) => switch (state) {
        CreateTransactionInitial() ||
        CreateTransactionLoadingDeps() =>
          const _LoadingContent(),
        CreateTransactionReady() => _FormContent(
            state: state,
            notesController: _notesController,
            amountController: _amountController,
          ),
        CreateTransactionError(:final message) =>
          _ErrorContent(message: message),
        CreateTransactionSuccess() => const SizedBox.shrink(),
      },
    );
  }
}

// ─── Loading ─────────────────────────────────────────────────────────────────

class _LoadingContent extends StatelessWidget {
  const _LoadingContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SheetDragHandle(),
        _SheetHeader(),
        const Expanded(
          child: Center(child: CircularProgressIndicator()),
        ),
      ],
    );
  }
}

// ─── Error ───────────────────────────────────────────────────────────────────

class _ErrorContent extends StatelessWidget {
  const _ErrorContent({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SheetDragHandle(),
        _SheetHeader(),
        Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline,
                    size: AppIconSize.xxl, color: context.colors.error),
                const SizedBox(height: AppSpacing.md),
                Text(TransactionStrings.loadError,
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: AppSpacing.md),
                TextButton(
                  onPressed: () => context
                      .read<CreateTransactionBloc>()
                      .add(const CreateTransactionInitialized()),
                  child: Text(TransactionStrings.retry),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Main form ───────────────────────────────────────────────────────────────

class _FormContent extends StatelessWidget {
  const _FormContent({
    required this.state,
    required this.notesController,
    required this.amountController,
  });

  final CreateTransactionReady state;
  final TextEditingController notesController;
  final TextEditingController amountController;

  Color _typeColor(BuildContext context) =>
      state.type == TransactionStrings.incomeType
          ? AppColors.income
          : AppColors.expense;

  @override
  Widget build(BuildContext context) {
    final typeColor = _typeColor(context);

    return Column(
      children: [
        _SheetDragHandle(),
        _SheetHeader(),
        // Type tabs
        PlanifyTabSelector(
          tabs: const [
            TransactionStrings.expenseLabel,
            TransactionStrings.incomeLabel,
          ],
          selectedIndex:
              state.type == TransactionStrings.expenseType ? 0 : 1,
          indicatorColor: typeColor,
          onTabChanged: (index) => context.read<CreateTransactionBloc>().add(
                CreateTransactionTypeChanged(
                  index == 0
                      ? TransactionStrings.expenseType
                      : TransactionStrings.incomeType,
                ),
              ),
        ),
        // Amount input
        _AmountInput(
          state: state,
          typeColor: typeColor,
          controller: amountController,
        ),
        const Divider(height: 1),
        // Scrollable form fields + button
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.md),
                _FormField(
                  label: TransactionStrings.accountLabel,
                  value: state.selectedAccount?.name,
                  placeholder: 'Select account',
                  icon: Icons.credit_card_outlined,
                  onTap: () =>
                      _showAccountPicker(context, state.accounts, state.selectedAccount),
                ),
                _FormField(
                  label: TransactionStrings.categoryLabel,
                  value: state.selectedCategory?.name,
                  placeholder: 'Select category',
                  icon: Icons.label_outline,
                  valueColor: state.selectedCategory != null
                      ? _parseColor(state.selectedCategory!.color)
                      : null,
                  onTap: () => _showCategoryPicker(
                      context, state.filteredCategories, state.selectedCategory),
                ),
                _FormField(
                  label: TransactionStrings.dateTimeLabel,
                  value: _formatDateTime(state.selectedDateTime),
                  icon: Icons.calendar_today_outlined,
                  onTap: () =>
                      _showDateTimePicker(context, state.selectedDateTime),
                ),
                _NotesField(controller: notesController),
                const SizedBox(height: AppSpacing.lg),
                PlanifyButton.primary(
                  label: TransactionStrings.addRecord,
                  onTap: state.canSubmit && !state.isSubmitting
                      ? () => context
                          .read<CreateTransactionBloc>()
                          .add(const CreateTransactionSubmitted())
                      : null,
                  isLoading: state.isSubmitting,
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Color _parseColor(String hex) {
    final cleaned = hex.replaceAll('#', '').padLeft(6, '0');
    return Color(int.parse('FF$cleaned', radix: 16));
  }

  String _formatDateTime(DateTime dt) {
    final months = TransactionStrings.monthsAbbr;
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour < 12 ? 'AM' : 'PM';
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}, $hour:$minute $period';
  }

  void _showAccountPicker(
    BuildContext context,
    List<AccountEntity> accounts,
    AccountEntity? selected,
  ) {
    final bloc = context.read<CreateTransactionBloc>();
    showPlanifyModal<AccountEntity>(
      context,
      title: TransactionStrings.selectAccount,
      child: _AccountPickerContent(accounts: accounts, selected: selected),
    ).then((picked) {
      if (picked != null) bloc.add(CreateTransactionAccountSelected(picked));
    });
  }

  void _showCategoryPicker(
    BuildContext context,
    List<CategoryEntity> categories,
    CategoryEntity? selected,
  ) {
    final bloc = context.read<CreateTransactionBloc>();
    showPlanifyModal<CategoryEntity>(
      context,
      title: TransactionStrings.selectCategory,
      child:
          _CategoryPickerContent(categories: categories, selected: selected),
    ).then((picked) {
      if (picked != null) bloc.add(CreateTransactionCategorySelected(picked));
    });
  }

  void _showDateTimePicker(BuildContext context, DateTime current) async {
    final bloc = context.read<CreateTransactionBloc>();

    final date = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (date == null || !context.mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: current.hour, minute: current.minute),
    );
    if (!context.mounted) return;

    bloc.add(CreateTransactionDateTimeChanged(DateTime(
      date.year,
      date.month,
      date.day,
      time?.hour ?? current.hour,
      time?.minute ?? current.minute,
    )));
  }
}

// ─── Amount input ─────────────────────────────────────────────────────────────

class _AmountInput extends StatelessWidget {
  const _AmountInput({
    required this.state,
    required this.typeColor,
    required this.controller,
  });

  final CreateTransactionReady state;
  final Color typeColor;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final prefix = state.type == TransactionStrings.incomeType ? '+\$' : '-\$';
    final labelStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
          color: context.colors.onSurfaceVariant,
        );
    final amountStyle = Theme.of(context).textTheme.displaySmall?.copyWith(
          color: typeColor,
          fontWeight: FontWeight.bold,
        );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Column(
        children: [
          Text(
            state.type == TransactionStrings.expenseType
                ? TransactionStrings.expenseLabel
                : TransactionStrings.incomeLabel,
            style: labelStyle,
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(prefix, style: amountStyle),
              IntrinsicWidth(
                child: TextField(
                  controller: controller,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textAlign: TextAlign.start,
                  style: amountStyle,
                  decoration: InputDecoration(
                    hintText: '0.00',
                    hintStyle: amountStyle?.copyWith(
                      color: context.colors.onSurfaceVariant
                          .withValues(alpha: 0.4),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (value) => context
                      .read<CreateTransactionBloc>()
                      .add(CreateTransactionAmountChanged(value)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Form field row ──────────────────────────────────────────────────────────

class _FormField extends StatelessWidget {
  const _FormField({
    required this.label,
    this.value,
    this.placeholder,
    required this.icon,
    required this.onTap,
    this.valueColor,
  });

  final String label;
  final String? value;
  final String? placeholder;
  final IconData icon;
  final VoidCallback onTap;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final displayValue = value ?? placeholder ?? '';
    final isPlaceholder = value == null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: context.colors.outline.withValues(alpha: 0.2),
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    displayValue,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: isPlaceholder
                              ? context.colors.onSurfaceVariant
                              : (valueColor ?? context.colors.onSurface),
                          fontWeight: isPlaceholder
                              ? FontWeight.normal
                              : FontWeight.w500,
                        ),
                  ),
                ],
              ),
            ),
            Icon(icon,
                size: AppIconSize.lg,
                color: context.colors.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

// ─── Notes field ─────────────────────────────────────────────────────────────

class _NotesField extends StatelessWidget {
  const _NotesField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: context.colors.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            TransactionStrings.notesLabel,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
          ),
          TextField(
            controller: controller,
            onChanged: (value) => context
                .read<CreateTransactionBloc>()
                .add(CreateTransactionNotesChanged(value)),
            decoration: InputDecoration(
              hintText: TransactionStrings.notesHint,
              hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: const EdgeInsets.only(top: AppSpacing.xs),
            ),
            style: Theme.of(context).textTheme.bodyLarge,
            maxLines: null,
          ),
        ],
      ),
    );
  }
}

// ─── Pickers ─────────────────────────────────────────────────────────────────

class _AccountPickerContent extends StatelessWidget {
  const _AccountPickerContent({
    required this.accounts,
    required this.selected,
  });

  final List<AccountEntity> accounts;
  final AccountEntity? selected;

  @override
  Widget build(BuildContext context) {
    if (accounts.isEmpty) {
      return Center(
        child: Text(
          'Nenhuma conta encontrada',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: accounts
          .map(
            (account) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: PlanifySelectableItem(
                label: account.name,
                isSelected: selected?.id == account.id,
                icon: Icons.credit_card_outlined,
                iconColor: AppColors.primary,
                onTap: () => Navigator.of(context).pop(account),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _CategoryPickerContent extends StatelessWidget {
  const _CategoryPickerContent({
    required this.categories,
    required this.selected,
  });

  final List<CategoryEntity> categories;
  final CategoryEntity? selected;

  Color _parseColor(String hex) {
    final cleaned = hex.replaceAll('#', '').padLeft(6, '0');
    return Color(int.parse('FF$cleaned', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return Center(
        child: Text(
          'Nenhuma categoria encontrada',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: categories
          .map(
            (cat) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: PlanifySelectableItem(
                label: cat.name,
                isSelected: selected?.id == cat.id,
                icon: Icons.label_outline,
                iconColor: _parseColor(cat.color),
                onTap: () => Navigator.of(context).pop(cat),
              ),
            ),
          )
          .toList(),
    );
  }
}

// ─── Shared header widgets ────────────────────────────────────────────────────

class _SheetDragHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: Center(
        child: Container(
          width: AppSpacing.xxl,
          height: AppSpacing.xxs,
          decoration: BoxDecoration(
            color: context.colors.outline.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
        ),
      ),
    );
  }
}

class _SheetHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          const SizedBox(width: AppIconSize.xl),
          Expanded(
            child: Text(
              TransactionStrings.addRecord,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.close,
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
