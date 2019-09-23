static enum Mode {
  LINEAR,
  EASE_IN,
  EASE_OUT,
  EASE_IN_OUT
};

class Transition implements java.util.Iterator<Float> {
  float start, end, duration, frame;
  Mode mode;
  
  Transition (float _start, float _end, int _duration, Mode _mode) {
    this.start = _start;
    this.end = _end;
    this.duration = _duration;
    this.frame = 0;
    this.mode = _mode;
  }
  
  Float next () {
    float currentFrame = this.frame;
    this.frame++;
    
    switch (this.mode != null ? this.mode : Mode.LINEAR) {
      case EASE_IN:
        return - (this.end - this.start) * cos(HALF_PI * currentFrame / this.duration) + this.end;

      case EASE_OUT:
        return (this.end - this.start) * sin(HALF_PI * currentFrame / this.duration) + this.start;
        
      case EASE_IN_OUT:
        return - (this.end - this.start) / 2.0 * (cos(PI * currentFrame / this.duration) - 1) + this.start;
      
      case LINEAR:
      default:
        return (this.end - this.start) * currentFrame / this.duration + this.start;
    }
  }
  
  boolean hasNext () {
    return this.frame <= this.duration;
  }
}
