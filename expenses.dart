import 'package:flutter/material.dart';

import 'package:expense/widgets/expense_list/new_expense.dart';
import 'package:expense/chart/chart.dart';
import 'package:expense/models/expense.dart';
import 'package:expense/widgets/expense_list/expenses_list.dart';





class Expenses extends StatefulWidget{
 const Expenses({super.key});

 @override
  State<Expenses> createState() {
   return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
      title: 'Flutter Course',
      amount: 19.99,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: 'Cinema',
      amount: 15.69,
      date: DateTime.now(),
      category: Category.leisure,
    ),
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context, 
      builder: (ctx) =>  NewExpense( onAddExpense:_addExpense),
       );
  }

  void  _addExpense(Expense expense) {
    setState(() {
      
    _registeredExpenses.add(expense);
    });
  }

  void _removeExpenses( Expense expense ) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    }
    );
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const  Duration(seconds:3),
        content: const  Text('Expense deleted.'),
        action: SnackBarAction(
          label: 'Undo',
        onPressed: () {
          setState(() {
            _registeredExpenses.insert(expenseIndex, expense);
          });
          
        }
        ),
        
      ),
      );
  }


  @override
  Widget build(BuildContext context) {
  final width = (MediaQuery.of(context).size.width);
 


     Widget mainContent = const Center(
      child: Text(' No expenses found. Start adding some!')
     );
    if (_registeredExpenses.isNotEmpty) {
      mainContent =  ExpensesList(
            expenses: _registeredExpenses, 
          onRemoveExpense: _removeExpenses,
          );
    }
     return Scaffold(
      appBar: AppBar(
        centerTitle: false ,
        title: const Text('Flutter ExpenseTracker'),
        actions: [
         IconButton(
          onPressed: _openAddExpenseOverlay,
          icon: const Icon(Icons.add),
          ),
      ],
      ),
      body: width < 600
       ? Column(
       children: [
         Chart(expenses: _registeredExpenses),
          Expanded(
            child: mainContent,
           
          ),
        ],
      )
      : Row(children: [
         Expanded(
          child:  Chart(expenses: _registeredExpenses),
         ),
         Expanded(
            child: mainContent,
          ) 
      ],),
      
    );
  }
}
  




