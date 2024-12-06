import 'dart:js_interop';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() {
  runApp(const MyDashBoard());
}

class MyDashBoard extends StatefulWidget{
  const MyDashBoard({super.key});

  State<MyDashBoard> createState() => _MyDashBoardState();

}

class _MyDashBoardState extends State<MyDashBoard> {
  bool isDarkMode = false;

  ThemeData _buildTheme(bool isDark ) {
    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 167, 227, 169),
        brightness: isDark ? Brightness.dark : Brightness.light),
      cardTheme: CardTheme(
        elevation: 4,
        shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ));

  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard Proyect',
      theme: _buildTheme(isDarkMode),
      home: DashBoardScreen(toggleTheme: () {
        setState((){
         isDarkMode = !isDarkMode;
      });
      }, 
      isDarkMode: isDarkMode,));
  }
}

class DashBoardScreen extends StatelessWidget{
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const DashBoardScreen ({
    super.key, required this.toggleTheme, required this.isDarkMode});


@override
Widget build(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;

  final screenWidth = MediaQuery.of(context).size.width;

  int crossAxisCount;

  if (screenWidth < 600) {
    crossAxisCount = 2;
  } else {
    crossAxisCount = 4;
  }

  return Scaffold(
    appBar: AppBar(
      title: const Text('Dashboard Inventory'),
      backgroundColor: isDarkMode ? Color.fromARGB(255, 7, 101, 10) : Color.fromARGB(255, 163, 222, 165),
      actions: [
        IconButton(
          icon: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
        onPressed: toggleTheme,
        )
      ],
  ),
    body: SingleChildScrollView(
      padding:const EdgeInsets.all(16.0),
      child: Column(children: [GridView.count(crossAxisCount: crossAxisCount,
      shrinkWrap: true,
      crossAxisSpacing: 16.0,
      mainAxisSpacing: 16.0,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildSummaryCard(context, 'Inventario Total','1,650', 
          Icons.archive, colorScheme.primary),
        _buildSummaryCard(context, 'Productos Agotados', '13',
          Icons.shopping_cart, colorScheme.secondary),
        _buildSummaryCard(context, 'Por Cobrar', "RD\$380,000",
          Icons.attach_money, colorScheme.tertiary),
        _buildSummaryCard(context, 'Ventas del Mes', 'RD\$290,000',
        Icons.trending_down, colorScheme.error),
      ],
      ),

    const SizedBox(height: 15),
    Text('Resumen de ventas',
    style: Theme.of(context).textTheme.titleLarge),
    const _ChartSales(),

    const SizedBox(height: 20),
    Text( 'Pedidos Recientes',
    style: Theme.of(context).textTheme.titleLarge,
    ),
    const SizedBox(height: 15),
    _buildRecentOrderList(context),

    const SizedBox(height: 15),
    Text('Estadísticas',
    style: Theme.of(context).textTheme.titleLarge),
    _buildStatisticCard(context),


      ],)
      ),
  );
}

//Widget para las estadisticas
Widget _buildStatisticCard(BuildContext context) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildStatisticRow('Ventas totales', '\$450,654'),
          _buildStatisticRow('Promedio diario', '\$20,000'),
          _buildStatisticRow('Tasa de conversión', '\$65%'),
          _buildStatisticRow('Clientes nuevos', '\$98'),

        ],),));
}

//Organizacion del Widget de estadisticas, como se visulaiza
Widget _buildStatisticRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
        style: const TextStyle(fontWeight: FontWeight.bold)), 
        Text(value,
        style: const TextStyle(fontWeight: FontWeight.bold))],
        )
  );
}

//Widget para los pedidos recientes
Widget _buildRecentOrderList(BuildContext context){
  return Card(
    child: ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 5,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary ,
            child: Text('#${index + 1}'),
          ),
        title: Text('Pedido' '#${index + 2000}'),
        subtitle: Text('Cliente' '#${index + 3}'),
        trailing: Text('\$${(index + 1) * 100}'),

        );
      },
    ),
  );
}


Widget _buildSummaryCard(
  BuildContext context,
  String title,
  String value,
  IconData icon,
  Color color
){
  return Card(
    child: Padding(padding: const EdgeInsets.all(16.0),
    child: Column(mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, 
        children: [
          Icon(icon, color: color, size: 24),
          Text(value,
          style: Theme.of(context).textTheme.headlineSmall?.
          copyWith(
            fontWeight:FontWeight.bold,color: color),
        )
      ],
      ),
const SizedBox(height: 10,
  ),
  Text(
    title,
    style: Theme.of(context).textTheme.titleMedium)

    ],
    ),
    ),
  );
}
}

class _ChartSales extends StatelessWidget {
  const _ChartSales();

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      title: ChartTitle(text: 'Analisis de los primeros cinco meses'),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <CartesianSeries<_SalesData, String>>[
        LineSeries<_SalesData, String>(
          dataSource: [
            _SalesData('Enero', 34500),
            _SalesData('Febrero', 28300),
            _SalesData('Marzo', 3400),
            _SalesData('Abril', 32000),
            _SalesData('Junio', 40000)
          ],
          xValueMapper: (_SalesData sales, _) => sales.year,
          yValueMapper: (_SalesData sales, _) => sales.sales,
        ),
      ],
    );
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}