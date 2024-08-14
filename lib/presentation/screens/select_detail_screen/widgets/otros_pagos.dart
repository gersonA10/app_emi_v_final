import 'package:flutter/material.dart';
import 'package:pagos_en_linea_emi/presentation/providers/fetch_data_pagos.dart';
import 'package:pagos_en_linea_emi/presentation/widgets/custom_table_widget.dart';
class PagoInicial extends StatelessWidget {
  const PagoInicial({
    super.key,
    required this.obtenerDataPagos,
    required this.screenSize,
    required this.letterSize,
  });

  final FetchDataPagosProvider obtenerDataPagos;
  final Size screenSize;
  final double letterSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
    height: 400,
    child: ListView.builder(
      itemCount: obtenerDataPagos.itemsPagoInicial.length,
      itemBuilder: (context, index) {
        final item = obtenerDataPagos.itemsPagoInicial[index];
        return Padding(
            padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.002),
            child: CustomTable(
              numeral: '# 000 ${index + 1}',
              titleDetalle: 'Detalle:',
              contentDetalle: item.item,
              titleMonto: 'Monto:',
              contentMonto: '${item.montototal}',
              titlecodigo: 'Cuenta:',
              contentcodigo: item.codigopago,
              children: [
                Text(
                  'Seleccionar',
                  style: TextStyle(fontSize: letterSize * 0.018),
                ),
                Checkbox(
                  value: item.isSelected,

                  onChanged: (bool? value) {
                    obtenerDataPagos.toggleSelectionPagoInicial();                
                  },
                  checkColor: Colors.white,
                  activeColor: const Color.fromARGB(255, 12, 68, 114),
                )
              ]
            )
          );
        }
      ),
    );
  }
}