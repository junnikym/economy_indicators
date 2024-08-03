import 'dart:collection';

import 'package:economy_indicator/diagram/sankey/sankey_diagram_node.dart';

class SankeyDiagramDrawingNodeGrid {

  final LinkedList<SankeyDiagramGridCol> nodeGrid = LinkedList();

  SankeyDiagramDrawingNodeGrid (
    List<SankeyDiagramNode> rootNodes
  ) {
    nodeGrid.clear();
    SankeyDiagramGridCol rootCol = SankeyDiagramGridCol();
    nodeGrid.add(rootCol);

    for (var it in rootNodes) {
      _fillGrid(it, rootCol, true);
      _fillGrid(it, rootCol, false);
    }
  }

  void _fillGrid(
    SankeyDiagramNode node,
    SankeyDiagramGridCol column,
    bool isAppendRight
  ) {
    column.col.add(node);

    (isAppendRight ? node.prev : node.next)
      .map((it)=> it.node)
      .forEach((nextNode) {
        SankeyDiagramGridCol? nextCol = (isAppendRight ? column.previous : column.next);
        if(nextCol == null) {
          void Function (SankeyDiagramGridCol) appender = isAppendRight ? column.insertBefore : column.insertAfter;
          nextCol = SankeyDiagramGridCol();
          appender(nextCol);
        }

        _fillGrid(nextNode, nextCol!, isAppendRight);
      });
  }

}

final class SankeyDiagramGridCol extends LinkedListEntry<SankeyDiagramGridCol> {

  final List<SankeyDiagramNode> col = [];

}