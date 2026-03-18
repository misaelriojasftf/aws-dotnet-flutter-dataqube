import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/create_stock_adjustment_request.dart';
import '../models/stock_adjustment.dart';
import '../viewmodels/home_view_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: 'store-3');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      context.read<HomeViewModel>().searchAdjustments(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Stock Adjustments')),
      floatingActionButton: FloatingActionButton(
        onPressed: vm.isCreating ? null : () => _openCreateAdjustmentSheet(context),
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: vm.isSearching ? null : (_) => _submitSearch(context),
              decoration: InputDecoration(
                labelText: 'Store ID',
                hintText: 'Search adjustments by store',
   
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: vm.isSearching ? null : () => _submitSearch(context),
              icon: vm.isSearching
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.search),
              label: Text(vm.isSearching ? 'Searching...' : 'Search'),
            ),
            if (vm.searchError != null) ...[
              const SizedBox(height: 12),
              Text(
                vm.searchError!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ],
            const SizedBox(height: 16),
            Expanded(
              child: _AdjustmentsBody(
                isSearching: vm.isSearching,
                adjustments: vm.adjustments,
                storeId: vm.selectedStoreId,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitSearch(BuildContext context) async {
    await context.read<HomeViewModel>().searchAdjustments(_searchController.text);
  }

  Future<void> _openCreateAdjustmentSheet(BuildContext context) async {
    final vm = context.read<HomeViewModel>();
    final createdStoreId = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return _CreateAdjustmentSheet(initialStoreId: vm.selectedStoreId);
      },
    );

    if (!context.mounted || createdStoreId == null) {
      return;
    }

    _searchController.text = createdStoreId;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Adjustment created successfully.'),
      ),
    );
  }
}

class _CreateAdjustmentSheet extends StatefulWidget {
  final String initialStoreId;

  const _CreateAdjustmentSheet({required this.initialStoreId});

  @override
  State<_CreateAdjustmentSheet> createState() => _CreateAdjustmentSheetState();
}

class _CreateAdjustmentSheetState extends State<_CreateAdjustmentSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _storeIdController;
  late final TextEditingController _skuController;
  late final TextEditingController _deltaQtyController;
  late final TextEditingController _reasonController;

  @override
  void initState() {
    super.initState();
    _storeIdController = TextEditingController(text: widget.initialStoreId);
    _skuController = TextEditingController();
    _deltaQtyController = TextEditingController();
    _reasonController = TextEditingController();
  }

  @override
  void dispose() {
    _storeIdController.dispose();
    _skuController.dispose();
    _deltaQtyController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Consumer<HomeViewModel>(
        builder: (_, formVm, _) {
          return Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Create Adjustment',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _storeIdController,
                  decoration: const InputDecoration(labelText: 'Store ID'),
                  validator: _requiredValidator,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _skuController,
                  decoration: const InputDecoration(labelText: 'SKU'),
                  validator: _requiredValidator,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _deltaQtyController,
                  decoration: const InputDecoration(labelText: 'Delta Quantity'),
                  keyboardType: const TextInputType.numberWithOptions(
                    signed: true,
                  ),
                  validator: _deltaQtyValidator,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _reasonController,
                  decoration: const InputDecoration(labelText: 'Reason'),
                  validator: _requiredValidator,
                ),
                if (formVm.creationError != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    formVm.creationError!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: formVm.isCreating
                      ? null
                      : () async {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }

                          final success = await formVm.createAdjustment(
                            CreateStockAdjustmentRequest(
                              storeId: _storeIdController.text.trim(),
                              sku: _skuController.text.trim(),
                              deltaQty: int.parse(_deltaQtyController.text.trim()),
                              reason: _reasonController.text.trim(),
                            ),
                          );

                          if (!context.mounted || !success) {
                            return;
                          }

                          Navigator.of(context).pop(_storeIdController.text.trim());
                        },
                  icon: formVm.isCreating
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save),
                  label: Text(formVm.isCreating ? 'Saving...' : 'Create'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Required';
    }

    return null;
  }

  String? _deltaQtyValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Required';
    }

    if (int.tryParse(value.trim()) == null) {
      return 'Enter a valid number';
    }

    return null;
  }
}

class _AdjustmentsBody extends StatelessWidget {
  final bool isSearching;
  final List<StockAdjustment> adjustments;
  final String storeId;

  const _AdjustmentsBody({
    required this.isSearching,
    required this.adjustments,
    required this.storeId,
  });

  @override
  Widget build(BuildContext context) {
    if (isSearching && adjustments.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (adjustments.isEmpty) {
      return Center(
        child: Text('No adjustments found for $storeId.'),
      );
    }

    return ListView.separated(
      itemCount: adjustments.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final adjustment = adjustments[index];

        return Card(
          child: ListTile(
            title: Text(adjustment.sku),
            subtitle: Text(
              'Store: ${adjustment.storeId}\n'
              'Reason: ${adjustment.reason?.isNotEmpty == true ? adjustment.reason : 'N/A'}\n'
              'Created: ${_formatDate(adjustment.createdAt)}',
            ),
            isThreeLine: true,
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${adjustment.deltaQty > 0 ? '+' : ''}${adjustment.deltaQty}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text('#${adjustment.id}'),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) {
      return 'Unknown date';
    }

    final localDate = dateTime.toLocal();
    final month = localDate.month.toString().padLeft(2, '0');
    final day = localDate.day.toString().padLeft(2, '0');
    final hour = localDate.hour.toString().padLeft(2, '0');
    final minute = localDate.minute.toString().padLeft(2, '0');

    return '${localDate.year}-$month-$day $hour:$minute';
  }
}
