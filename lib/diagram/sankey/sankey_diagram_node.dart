import 'package:uuid/uuid.dart';

class SankeyDiagramNode {

  static const Uuid uuidGenerator = Uuid();

  final id = uuidGenerator.v4();

  final String name;
  final double amount;

  final List<SankeyDiagramNodeLinker> prev = [];
  final List<SankeyDiagramNodeLinker> next = [];

  SankeyDiagramNode(this.name, this.amount);

  SankeyDiagramNode addPrev(SankeyDiagramNode node, double amount) {
    prev.add(SankeyDiagramNodeLinker(node, amount));
    amount += amount;
    return this;
  }

  SankeyDiagramNode addNext(SankeyDiagramNode node, double amount) {
    next.add(SankeyDiagramNodeLinker(node, amount));
    amount += amount;
    return this;
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