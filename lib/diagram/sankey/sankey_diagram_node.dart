class SankeyDiagramNode {

  String name;

  List<SankeyDiagramNode> prev;
  List<SankeyDiagramNode> next;

  SankeyDiagramNode(
    this.name,
    this.prev,
    this.next
  );

}