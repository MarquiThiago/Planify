import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planify/src/core/design_system/design_system.dart';
import 'package:planify/src/features/accounts/domain/entities/account_entity.dart';
import '../../bloc/create_transaction_bloc.dart';
import '../../bloc/create_transaction_event.dart';
import '../../bloc/create_transaction_state.dart';
import '../../create_transaction_strings.dart';
import '../../../domain/entities/category_entity.dart';
import 'create_transaction_account_picker_content.dart';
import 'create_transaction_amount_input.dart';
import 'create_transaction_category_picker_content.dart';
import 'create_transaction_form_field.dart';
import 'create_transaction_notes_field.dart';
import 'create_transaction_sheet_drag_handle.dart';

class CreateTransactionFormContent extends StatelessWidget {
  const CreateTransactionFormContent({
    super.key,
    required this.state,
    required this.notesController,
    required this.amountController,
  });

  final CreateTransactionReady state;
  final TextEditingController notesController;
  final TextEditingController amountController;

  Color _typeColor(BuildContext context) =>
      state.type == CreateTransactionStrings.incomeType
      ? AppColors.income
      : AppColors.expense;

  Color _parseColor(String hex) {
    final cleaned = hex.replaceAll('#', '').padLeft(6, '0');
    return Color(int.parse('FF$cleaned', radix: 16));
  }

  String _formatDateTime(DateTime dt) {
    final months = CreateTransactionStrings.monthsAbbr;
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
      title: CreateTransactionStrings.selectAccount,
      child: CreateTransactionAccountPickerContent(
        accounts: accounts,
        selected: selected,
      ),
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
      title: CreateTransactionStrings.selectCategory,
      child: CreateTransactionCategoryPickerContent(
        categories: categories,
        selected: selected,
      ),
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

    bloc.add(
      CreateTransactionDateTimeChanged(
        DateTime(
          date.year,
          date.month,
          date.day,
          time?.hour ?? current.hour,
          time?.minute ?? current.minute,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final typeColor = _typeColor(context);

    return Column(
      children: [
        const CreateTransactionSheetDragHandle(),
        PlanifyTabSelector(
          tabs: const [
            CreateTransactionStrings.expenseLabel,
            CreateTransactionStrings.incomeLabel,
          ],
          selectedIndex: state.type == CreateTransactionStrings.expenseType
              ? 0
              : 1,
          indicatorColor: typeColor,
          onTabChanged: (index) => context.read<CreateTransactionBloc>().add(
            CreateTransactionTypeChanged(
              index == 0
                  ? CreateTransactionStrings.expenseType
                  : CreateTransactionStrings.incomeType,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        CreateTransactionAmountInput(
          state: state,
          typeColor: typeColor,
          controller: amountController,
        ),
        const Divider(height: 1),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.md),
                CreateTransactionFormField(
                  label: CreateTransactionStrings.accountLabel,
                  value: state.selectedAccount?.name,
                  placeholder: 'Select account',
                  icon: Icons.credit_card_outlined,
                  onTap: () => _showAccountPicker(
                    context,
                    state.accounts,
                    state.selectedAccount,
                  ),
                ),
                CreateTransactionFormField(
                  label: CreateTransactionStrings.categoryLabel,
                  value: state.selectedCategory?.name,
                  placeholder: 'Select category',
                  icon: Icons.label_outline,
                  valueColor: state.selectedCategory != null
                      ? _parseColor(state.selectedCategory!.color)
                      : null,
                  onTap: () => _showCategoryPicker(
                    context,
                    state.filteredCategories,
                    state.selectedCategory,
                  ),
                ),
                CreateTransactionFormField(
                  label: CreateTransactionStrings.dateTimeLabel,
                  value: _formatDateTime(state.selectedDateTime),
                  icon: Icons.calendar_today_outlined,
                  onTap: () =>
                      _showDateTimePicker(context, state.selectedDateTime),
                ),
                CreateTransactionNotesField(controller: notesController),
                const SizedBox(height: AppSpacing.lg),
                PlanifyButton.primary(
                  label: CreateTransactionStrings.addRecord,
                  onTap: state.canSubmit && !state.isSubmitting
                      ? () => context.read<CreateTransactionBloc>().add(
                          const CreateTransactionSubmitted(),
                        )
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
}
