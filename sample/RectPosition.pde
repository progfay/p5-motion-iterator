class RectPosition implements java.util.Iterator {
  Transition transitionX, transitionY;

  RectPosition (Position _start, Position _end, int _duration) {
    this.transitionX = new Transition(_start.x, _end.x, _duration, EASE_IN_OUT);
    this.transitionY = new Transition(_start.y, _end.y, _duration, EASE_IN_OUT);
  }

  Position next () {
    return new Position(
      this.transitionX.next(),
      this.transitionY.next()
      );
  }

  boolean hasNext () {
    return this.transitionX.hasNext() && this.transitionY.hasNext();
  }
}
