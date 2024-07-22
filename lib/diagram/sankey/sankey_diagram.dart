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

  static const double nodeRadius = 5;

  SankeyDiagramPainter(
    this.rootNodes
  );
  
  void drawNode(
    Canvas canvas, 
    Offset position,
    Size nodeSize
  ) {
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

  void drawNodeLink(
    Canvas canvas, 
    Offset leftNodePosition,
    Size leftNodeSize, 
    Offset rightNodePoition,
    Size rightNodeSize
  ) {

    final midPositionX = (leftNodePosition.dx + rightNodePoition.dx) / 2;

    final midSize = Size(
      (leftNodeSize.width/2 + rightNodeSize.width/2) / 2, 
      (leftNodeSize.height/2 + rightNodeSize.height/2) / 2
    );

    Paint topPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;
    
    Path path = Path();

    path.moveTo(
      leftNodePosition.dx + leftNodeSize.width - nodeRadius, leftNodePosition.dy
    );
    path.quadraticBezierTo(
      midPositionX - (midSize.width/2), leftNodePosition.dy,
      midPositionX, (leftNodePosition.dy + rightNodePoition.dy) / 2
    );
    path.quadraticBezierTo(
      midPositionX + (midSize.width/2), rightNodePoition.dy,
      rightNodePoition.dx + nodeRadius, rightNodePoition.dy
    );

    path.lineTo(
      rightNodePoition.dx + nodeRadius, rightNodePoition.dy + rightNodeSize.height
    );
    path.quadraticBezierTo(
      midPositionX + (midSize.width/2), rightNodePoition.dy + rightNodeSize.height,
      midPositionX, ((leftNodePosition.dy + leftNodeSize.height) + (rightNodePoition.dy + rightNodeSize.height)) / 2
    );
    path.quadraticBezierTo(
      midPositionX - (midSize.width/2), leftNodePosition.dy + leftNodeSize.height,
      leftNodePosition.dx + leftNodeSize.width - nodeRadius, leftNodePosition.dy + leftNodeSize.height
    );

    path.close();
    canvas.drawPath(path, topPaint);
  }
  
  @override
  void paint(Canvas canvas, Size size) {
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

}