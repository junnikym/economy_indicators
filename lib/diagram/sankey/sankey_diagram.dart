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
  
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: SankeyDiagramPainter(rootNodes),
    );
  }

}

class SankeyDiagramPainter extends CustomPainter {

  List<SankeyDiagramNode> rootNodes;

  static const Size nodeSize = Size(15, 50);
  static const double nodeRadius = 5;

  SankeyDiagramPainter(
    this.rootNodes
  );
  
  void drawNode(Canvas canvas, Offset position) {
    final paint = Paint()
    ..color = Colors.blue
    ..style = PaintingStyle.fill;

    final Rect rect = Rect.fromPoints(
      position,
      Offset(position.dx + nodeSize.width, position.dy + nodeSize.height)
    );
    const Radius radius = Radius.circular(nodeRadius);

    canvas.drawRRect(RRect.fromRectAndRadius(rect, radius), paint);
  }

  void drawNodeLink(Canvas canvas, Offset leftNodePosition, Offset rightNodePoition) {
    final offset = Offset(nodeSize.width / 2, nodeSize.height / 2);

    final midPosition = Offset(
      (leftNodePosition.dx + rightNodePoition.dx) / 2,
      (leftNodePosition.dy + rightNodePoition.dy) / 2
    );

    Paint paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = nodeSize.height;
    
    Path path = Path();
    path.moveTo(
      leftNodePosition.dx + offset.dx + nodeRadius, leftNodePosition.dy + offset.dy
    );
    path.quadraticBezierTo(
      midPosition.dx + offset.dx, leftNodePosition.dy + offset.dy,
      midPosition.dx + offset.dx, midPosition.dy + offset.dy
    );
    path.quadraticBezierTo(
      midPosition.dx + offset.dx, rightNodePoition.dy + offset.dy,
      rightNodePoition.dx + offset.dx - nodeRadius, rightNodePoition.dy + offset.dy
    );

    canvas.drawPath(path, paint);
  }
  
  @override
  void paint(Canvas canvas, Size size) {
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

}

