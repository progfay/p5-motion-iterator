class Position {
  float x, y;

  Position (float _x, float _y) {
    this.x = _x;
    this.y = _y;
  }

  Position (Position _position) {
    this.x = _position.x;
    this.y = _position.y;
  }
}
