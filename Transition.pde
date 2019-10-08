class Transition implements java.util.Iterator<Float> {
  float start, end;
  int duration, frame;
  CubicBezier bezier;

  Transition (float _start, float _end, int _duration, CubicBezier _bezier) {
    this.start = _start;
    this.end = _end;
    this.duration = _duration;
    this.frame = 0;
    this.bezier = _bezier;
  }

  Float next () {
    int currentFrame = this.frame;
    this.frame++;

    return (float) (this.start + (this.end - this.start) * this.bezier.solve((double) currentFrame / this.duration));
  }

  boolean hasNext () {
    return this.frame <= this.duration;
  }
}
