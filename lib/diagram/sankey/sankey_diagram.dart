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
    return Container(
      color: Colors.blue,
      width: 100,
      height: 100,
    );
  }

}