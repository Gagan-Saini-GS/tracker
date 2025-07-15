import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  bool _isIncome = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _isIncome = _tabController.index == 0;
        });
        // Clear form data when switching tabs
        _clearForm();
      }
    });
    _dateController.text = _formatDate(_selectedDate);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  void _clearForm() {
    _nameController.clear();
    _amountController.clear();
    _selectedDate = DateTime.now();
    _dateController.text = _formatDate(_selectedDate);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = _formatDate(_selectedDate);
      });
    }
  }

  void _addTransaction() {
    if (_formKey.currentState!.validate()) {
      // Here you would typically save the transaction to your database
      final transactionType = _isIncome ? 'Income' : 'Expense';
      final name = _nameController.text.trim();
      final amount = double.parse(_amountController.text.trim());

      // Clear the form
      _clearForm();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '$transactionType added successfully! $name - ₹$amount',
          ),
          backgroundColor: const Color(0xFF0C4C48),
          duration: const Duration(seconds: 2),
        ),
      );

      context.go('/home');
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields correctly'),
          backgroundColor: Color.fromARGB(255, 231, 15, 15),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Widget _buildTransactionForm() {
    return Container(
      padding: EdgeInsets.all(14),
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(100),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom Tab Bar - 50% width each
            Container(
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.grey[200]),
              child: Row(
                children: [
                  // Income Tab - 50% width
                  Expanded(
                    child: GestureDetector(
                      onTap: () => {_tabController.animateTo(0), _clearForm()},
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: _isIncome
                              ? const Color(0xFF63B5AF)
                              : const Color(0xFFD2F5F2),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Text(
                          'Income',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _isIncome ? Colors.white : Colors.grey[500],
                            fontWeight: _isIncome
                                ? FontWeight.w800
                                : FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Expense Tab - 50% width
                  Expanded(
                    child: GestureDetector(
                      onTap: () => {_tabController.animateTo(1), _clearForm()},
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: !_isIncome
                              ? const Color(0xFFE83559)
                              : const Color(0xFFFFE2E2),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Text(
                          'Expense',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: !_isIncome ? Colors.white : Colors.grey[500],
                            fontWeight: !_isIncome
                                ? FontWeight.w800
                                : FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // Form Fields - Takes available space
            Expanded(
              child: Column(
                children: [
                  // Name Field
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      hintText: 'Enter transaction name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Name is required';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 15),

                  // Amount Field
                  TextFormField(
                    controller: _amountController,
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      hintText: 'Enter amount',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(Icons.currency_rupee_outlined),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Amount is required';
                      }
                      if (double.tryParse(value.trim()) == null) {
                        return 'Please enter a valid number';
                      }
                      if (double.parse(value.trim()) <= 0) {
                        return 'Amount must be greater than 0';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 15),

                  // Date Field
                  TextFormField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      labelText: 'Date',
                      hintText: 'Select date',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: const Icon(Icons.calendar_today_outlined),
                    ),
                    readOnly: true,
                    onTap: () => _selectDate(context),
                  ),

                  // Spacer to push button to bottom
                  const Spacer(),

                  // Add Button at bottom
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _addTransaction,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isIncome
                            ? const Color(0xFF63B5AF)
                            : const Color(0xFFE83559),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Add ${_isIncome ? 'Income' : 'Expense'}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF63B5AF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF63B5AF),
        title: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: const Text(
            'Add Transaction',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 24,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: SizedBox(
        width: double.infinity,
        child: Expanded(child: _buildTransactionForm()),
      ),
    );
  }
}
