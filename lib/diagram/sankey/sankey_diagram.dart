import 'dart:collection';
import 'dart:math';

import 'package:economy_indicator/core/pair.dart';
import 'package:economy_indicator/diagram/sankey/sankey_diagram_grid.dart';
import 'package:economy_indicator/diagram/sankey/sankey_diagram_node.dart';
import 'package:flutter/material.dart';

class SankeyDiagram extends StatefulWidget {

  const SankeyDiagram({ 
    super.key
  });
  
  @override
  State<StatefulWidget> createState() => SankeyDiagramStatus();
  
}

class SankeyDiagramStatus extends State<SankeyDiagram> {

  List<SankeyDiagramNode> rootNodes = [];

  SankeyDiagramStatus();
  
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: SankeyDiagramPainter(rootNodes),
      size: const Size(300, 200)
    );
  }

}

class SankeyDiagramPainter extends CustomPainter {

  final List<SankeyDiagramNode> rootNodes;
  final SankeyDiagramGrid grid;

  static const double nodeRadius = 5;

  final double horizontalBlankRatio = 0.10;

  Map<String, SankeyDiagramNodePainter> nodePainters = HashMap();

  SankeyDiagramPainter(
    this.rootNodes
  ): grid = SankeyDiagramGrid(rootNodes);

  @override
  void paint(Canvas canvas, Size size) {
    nodePainters.clear();
    nodePainters.addAll(nodePainterOf(size));

    for (var painter in nodePainters.values) {
      painter.drawNode(canvas);
    }

    for (var node in rootNodes) {
      drawNodeLinks(canvas, node, null, (n)=> n.prev.map((it)=> it.node));
      drawNodeLinks(canvas, node, null, (n)=> n.next.map((it)=> it.node));
    }
  }

  void drawNodeLinks(
    Canvas canvas,
    SankeyDiagramNode from, 
    SankeyDiagramNode? to,
    Iterable<SankeyDiagramNode> Function (SankeyDiagramNode) nextNodeGetter
  ) {
    if(to == null) {
      for (var it in nextNodeGetter(from)) {
        drawNodeLinks(canvas, from, it, nextNodeGetter);
      }

      return;
    }
  
    if(!nodePainters.containsKey(from.id) || !nodePainters.containsKey(to.id)) {
      throw Exception("Not Found Painter");
    }

    final SankeyDiagramNodePainter fromNodePainter = nodePainters[from.id]!;
    final SankeyDiagramNodePainter toNodePainter = nodePainters[to.id]!;

    fromNodePainter.drawLink(canvas, toNodePainter);

    for (var it in nextNodeGetter(to)) {
      drawNodeLinks(canvas, to, it, nextNodeGetter);
    }
  }

  Map<String, SankeyDiagramNodePainter> nodePainterOf(Size size) {
    final List<Pair<double, double>> totalNodeAndBlankAmounts = grid.nodes
      .map((column) {
        final int nBlank = column.size() - 1;

        final double totalNodeAmount = column.nodes().map((it)=> it.amount).reduce((val, amount)=> val+amount);
        final double totalBlankAmount = (horizontalBlankRatio * totalNodeAmount) * nBlank;

        return Pair(totalNodeAmount, totalBlankAmount);
      })
      .toList();

    final double maxAmount = totalNodeAndBlankAmounts
      .map((elem)=> elem.first + elem.second)
      .reduce((val, elem)=> val > elem ? val : elem);
      
    final double heightPerAmount = size.height / maxAmount;

    int idx = 0;
    final Map<String, SankeyDiagramNodePainter> nodePainters = HashMap();
    for (var column in grid.nodes) {
      final int nBlank = column.size() - 1;

      final double allNodesAmount = totalNodeAndBlankAmounts[idx].first;
      final double blankAmount = nBlank == 0 ? 0 : (maxAmount - allNodesAmount) / nBlank;
      final double halfMarginAmount = (maxAmount - (allNodesAmount + blankAmount)) / 2;

      double dx = (idx / (grid.nodes.length - 1)) * size.width;
      double dy = halfMarginAmount * heightPerAmount;
      
      for (var node in column.nodes()) {
        final double h = node.amount * heightPerAmount;
        nodePainters[node.id] = SankeyDiagramNodePainter(node, Offset(dx, dy), Size(15, h), nodeRadius);
        dy += h + (blankAmount * heightPerAmount);
      }

      idx++;
    }

    return nodePainters;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

}

class SankeyDiagramNodePainter {

  final SankeyDiagramNode node;

  final Offset position;
  final Size size;
  final double radius;

  SankeyDiagramNodePainter(this.node, this.position, this.size, this.radius);

  void drawNode(Canvas canvas) {
    final paint = Paint()
    ..color = Colors.blue
    ..style = PaintingStyle.fill;

    final Rect rect = Rect.fromPoints(
      position,
      Offset(position.dx + size.width, position.dy + size.height)
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(radius)), 
      paint
    );
  }

  void drawLink(
    Canvas canvas, 
    SankeyDiagramNodePainter to
  ) {

    final Offset leftNodePosition;
    final Size leftNodeSize;
    final Offset rightNodePoition;
    final Size rightNodeSize;

    if(position.dx < to.position.dx) {
      leftNodePosition = position;    leftNodeSize = size;
      rightNodePoition = to.position; rightNodeSize = to.size;
    } else {
      leftNodePosition = to.position; leftNodeSize = to.size;
      rightNodePoition = position;    rightNodeSize = size;
    }

    final Random random = Random();
    Paint topPaint = Paint()
      ..color = Color.fromRGBO(
        random.nextInt(255), 
        random.nextInt(255), 
        random.nextInt(255), 
        1.0
      )
      ..style = PaintingStyle.fill;
    
    Path path = Path();

    // Draw Top Line

    final Offset topStartPoint = Offset(leftNodePosition.dx + leftNodeSize.width - radius, leftNodePosition.dy);
    final Offset topEndPoint = Offset(rightNodePoition.dx + radius, rightNodePoition.dy);
    final Offset topMidPoint = _midpoint(topStartPoint, topEndPoint);
    final Offset topFirstQuarterPoint = _midpoint(topStartPoint, topMidPoint);
    final Offset topThirdQuarterPoint = _midpoint(topMidPoint, topEndPoint);
    
    path.moveTo(
      topStartPoint.dx, topStartPoint.dy
    );
    path.quadraticBezierTo(
      topFirstQuarterPoint.dx, topStartPoint.dy,
      topMidPoint.dx, topMidPoint.dy
    );
    path.quadraticBezierTo(
      topThirdQuarterPoint.dx, topEndPoint.dy,
      topEndPoint.dx, topEndPoint.dy
    );

    // Draw Bottom Line

    final Offset bottomStartPoint = Offset(rightNodePoition.dx + radius, rightNodePoition.dy + rightNodeSize.height);
    final Offset bottomEndPoint = Offset(leftNodePosition.dx + leftNodeSize.width - radius, leftNodePosition.dy + leftNodeSize.height);
    final Offset bottomMidPoint = _midpoint(bottomStartPoint, bottomEndPoint);
    final Offset bottomFirstQuarterPoint = _midpoint(bottomStartPoint, bottomMidPoint);
    final Offset bottomThirdQuarterPoint = _midpoint(bottomMidPoint, bottomEndPoint);

    path.lineTo(
      bottomStartPoint.dx, bottomStartPoint.dy
    );
    path.quadraticBezierTo(
      bottomFirstQuarterPoint.dx, bottomStartPoint.dy,
      bottomMidPoint.dx, bottomMidPoint.dy
    );
    path.quadraticBezierTo(
      bottomThirdQuarterPoint.dx, bottomEndPoint.dy,
      bottomEndPoint.dx, bottomEndPoint.dy
    );

    path.close();
    canvas.drawPath(path, topPaint);
  }

  Offset _midpoint(Offset from, Offset to) {
    return Offset(
      (from.dx + to.dx) / 2, 
      (from.dy + to.dy) / 2
    );
  }

}