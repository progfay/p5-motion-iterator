static enum Mode {
  LINEAR,
  EASE_IN,
  EASE_OUT,
  EASE_IN_OUT
};

class RectPosition implements java.util.Iterator {
  Position start, end;
  float frame, currentFrame;
  Mode mode;
  
  RectPosition (Position _start, Position _end, int _frame, Mode _mode) {
    this.start = new Position(_start);
    this.end = new Position(_end);
    this.frame = _frame;
    this.currentFrame = 0;
    this.mode = _mode;
  }
  
  Position next () {
    Position position;    
    switch (this.mode != null ? this.mode : Mode.LINEAR) {
      case EASE_IN:
        position = new Position(
          - (this.end.x - this.start.x) * cos(HALF_PI * this.currentFrame / this.frame) + this.end.x,
          - (this.end.y - this.start.y) * cos(HALF_PI * this.currentFrame / this.frame) + this.end.y
        );
        break;

      case EASE_OUT:
        position = new Position(
          (this.end.x - this.start.x) * sin(HALF_PI * this.currentFrame / this.frame) + this.start.x,
          (this.end.y - this.start.y) * sin(HALF_PI * this.currentFrame / this.frame) + this.start.y
        );
        break;
        
      case EASE_IN_OUT:
        position = new Position(
          - (this.end.x - this.start.x) / 2.0 * (cos(PI * this.currentFrame / this.frame) - 1) + this.start.x,
          - (this.end.y - this.start.y) / 2.0 * (cos(PI * this.currentFrame / this.frame) - 1) + this.start.y
        );
        break;
      
      case LINEAR:
      default:
        position = new Position(
          lerp(this.start.x, this.end.x, this.currentFrame / this.frame),
          lerp(this.start.y, this.end.y, this.currentFrame / this.frame)
        );
        break;
    }

    this.currentFrame++;
    return position;
  }
  
  boolean hasNext () {
    return this.currentFrame <= this.frame;
  }
}
