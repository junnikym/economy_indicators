import 'package:uuid/uuid.dart';

class SankeyDiagramNode {

  static const Uuid uuidGenerator = Uuid();

  final id = uuidGenerator.v4();

  final String name;
  final double amount = 0.0;

  final List<SankeyDiagramNodeLinker> prev = [];
  final List<SankeyDiagramNodeLinker> next = [];

  SankeyDiagramNode(this.name);

  void addPrev(SankeyDiagramNode node, double amount) {
    prev.add(SankeyDiagramNodeLinker(node, amount));
    amount += amount;
  }

  void addNext(SankeyDiagramNode node, double amount) {
    next.add(SankeyDiagramNodeLinker(node, amount));
    amount += amount;
  }
  
}

class SankeyDiagramNodeLinker {

  final SankeyDiagramNode node;
  final double amount;

  SankeyDiagramNodeLinker (
    this.node,
    this.amount
  );

}