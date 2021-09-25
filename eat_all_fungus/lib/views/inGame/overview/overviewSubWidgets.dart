import 'package:flutter/material.dart';

const List<Widget> overviewTiles = <Widget>[
  _buildToDoList(),
  _buildTilePreview(),
  _buildTileInfo(),
  _buildInventory(),
  _buildPlayerStatus(),
  _buildNews()
];

const int colorIntensity = 900;

class Panel extends StatelessWidget {
  final Widget child;
  const Panel({required this.child});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: child,
      ),
    );
  }
}

class _buildToDoList extends StatelessWidget {
  const _buildToDoList();

  @override
  Widget build(BuildContext context) {
    return Panel(
      child: Container(
        color: Colors.grey[colorIntensity],
        child: Center(
          child: Text('ToDo'),
        ),
      ),
    );
  }
}

class _buildTilePreview extends StatelessWidget {
  const _buildTilePreview();

  @override
  Widget build(BuildContext context) {
    return Panel(
      child: Container(
        color: Colors.grey[colorIntensity],
        child: Center(
          child: Text('Tile Preview'),
        ),
      ),
    );
  }
}

class _buildInventory extends StatelessWidget {
  const _buildInventory();

  @override
  Widget build(BuildContext context) {
    return Panel(
      child: Container(
        color: Colors.grey[colorIntensity],
        child: Center(
          child: Text('Inventory'),
        ),
      ),
    );
  }
}

class _buildTileInfo extends StatelessWidget {
  const _buildTileInfo();

  @override
  Widget build(BuildContext context) {
    return Panel(
      child: Container(
        color: Colors.grey[colorIntensity],
        child: Center(
          child: Text('Tile Infos'),
        ),
      ),
    );
  }
}

class _buildPlayerStatus extends StatelessWidget {
  const _buildPlayerStatus();

  @override
  Widget build(BuildContext context) {
    return Panel(
      child: Container(
        color: Colors.grey[colorIntensity],
        child: Center(
          child: Text('Player Status'),
        ),
      ),
    );
  }
}

class _buildNews extends StatelessWidget {
  const _buildNews();

  @override
  Widget build(BuildContext context) {
    return Panel(
      child: Container(
        color: Colors.grey[colorIntensity],
        child: Center(
          child: Text('News'),
        ),
      ),
    );
  }
}
