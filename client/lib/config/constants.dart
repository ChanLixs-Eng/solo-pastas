enum TipoGasto {
  insumo('Insumo'),
  servicio('Servicio'),
  otros('Otros');

  final String label;
  const TipoGasto(this.label);
}

enum ConceptoPago {
  sueldo('Sueldo'),
  adelanto('Adelanto'),
  bono('Bono');

  final String label;
  const ConceptoPago(this.label);
}
