import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/budget_creation/budget_creation_bloc.dart';
import '../../bloc/budget_creation/budget_creation_event.dart';
import '../../budget_dimens.dart';
import '../../budget_strings.dart';

class StepIncomeWidget extends StatefulWidget {
  const StepIncomeWidget({super.key});

  @override
  State<StepIncomeWidget> createState() => _StepIncomeWidgetState();
}

class _StepIncomeWidgetState extends State<StepIncomeWidget> {
  final _incomeController = TextEditingController();
  final _savingsController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _incomeController.dispose();
    _savingsController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    context.read<BudgetCreationBloc>().add(
          BudgetCreationIncomeSubmitted(
            monthlyIncome: double.parse(
              _incomeController.text.replaceAll(',', '.'),
            ),
            savingsPct: double.parse(
              _savingsController.text.replaceAll(',', '.'),
            ),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(BudgetDimens.pagePadding),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              BudgetStrings.step1Title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: BudgetDimens.sectionSpacing),
            TextFormField(
              controller: _incomeController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: BudgetStrings.step1IncomeLabel,
                hintText: BudgetStrings.step1IncomeHint,
                prefixText: 'R\$ ',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Informe sua renda';
                final parsed = double.tryParse(value.replaceAll(',', '.'));
                if (parsed == null || parsed <= 0) {
                  return 'Valor inválido';
                }
                return null;
              },
            ),
            const SizedBox(height: BudgetDimens.itemSpacing),
            TextFormField(
              controller: _savingsController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: BudgetStrings.step1SavingsLabel,
                hintText: BudgetStrings.step1SavingsHint,
                suffixText: BudgetStrings.step1SavingsSuffix,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Informe o percentual';
                }
                final parsed = double.tryParse(value.replaceAll(',', '.'));
                if (parsed == null || parsed < 0 || parsed >= 100) {
                  return 'Deve ser entre 0 e 99';
                }
                return null;
              },
            ),
            const Spacer(),
            FilledButton(
              onPressed: _submit,
              child: const Text(BudgetStrings.step1NextButton),
            ),
          ],
        ),
      ),
    );
  }
}
