final CubicBezier LINEAR = new CubicBezier(0, 0, 1, 1);
final CubicBezier EASE = new CubicBezier(.25, .1, .25, 1);
final CubicBezier EASE_IN = new CubicBezier(.42, 0, 1, 1);
final CubicBezier EASE_OUT = new CubicBezier(0, 0, .58, 1);
final CubicBezier EASE_IN_OUT = new CubicBezier(.42, 0, .58, 1);

class CubicBezier {
  static final int CUBIC_BEZIER_SPLINE_SAMPLES = 11;
  static final int K_MAX_NEWTON_TERATIONS = 4;
  static final double K_BEZIER_EPSILON = 1e-7;

  private double _ax, _ay, _bx, _by, _cx, _cy;
  private double _startGradient, _endGradient;
  private double[] _splineSamples = new double[CUBIC_BEZIER_SPLINE_SAMPLES];

  public CubicBezier (double p1x, double p1y, double p2x, double p2y) {
    this._cx = 3.0 * p1x;
    this._cy = 3.0 * p1y;
    this._bx = 3.0 * (p2x - p1x) - this._cx;
    this._by = 3.0 * (p2y - p1y) - this._cy;
    this._ax = 1.0 - this._cx - this._bx;
    this._ay = 1.0 - this._cy - this._by;

    if (p1x > 0) this._startGradient = p1y / p1x;
    else if (p1y == 0 && p2x > 0) this._startGradient = p2y / p2x;
    else if (p1y == 0 && p2y == 0) this._startGradient = 1;
    else this._startGradient = 0;

    if (p2x < 1) this._endGradient = (p2y - 1) / (p2x - 1);
    else if (p2y == 1 && p1x < 1) this._endGradient = (p1y - 1) / (p1x - 1);
    else if (p2y == 1 && p1y == 1) this._endGradient = 1;
    else this._endGradient = 0;

    double deltaT = 1.0 / (CUBIC_BEZIER_SPLINE_SAMPLES - 1);
    for (int i = 0; i < CUBIC_BEZIER_SPLINE_SAMPLES; i++) {
      this._splineSamples[i] = this.sampleCurveX(i * deltaT);
    }
  }

  private double sampleCurveX (double t) {
    return ((this._ax * t + this._bx) * t + this._cx) * t;
  }

  private double sampleCurveY (double t) {
    return ((this._ay * t + this._by) * t + this._cy) * t;
  }

  private double sampleCurveDerivativeX (double t) {
    return (3.0 * this._ax * t + 2.0 * this._bx) * t + this._cx;
  }

  private double solveCurveX (double x) {
    double t0 = 0, t1 = 0, t2 = x, x2 = 0, d2 = 0;
    int i;
    double deltaT = 1.0 / (CUBIC_BEZIER_SPLINE_SAMPLES - 1);
    for (i = 1; i < CUBIC_BEZIER_SPLINE_SAMPLES; i++) {
      if (x <= this._splineSamples[i]) {
        t1 = deltaT * i;
        t0 = t1 - deltaT;
        t2 = t0 + (t1 - t0) * (x - this._splineSamples[i - 1]) / (this._splineSamples[i] - this._splineSamples[i - 1]);
        break;
      }
    }

    for (i = 0; i < K_MAX_NEWTON_TERATIONS; i++) {
      x2 = this.sampleCurveX(t2) - x;
      if (Math.abs(x2) < K_BEZIER_EPSILON) return t2;
      d2 = this.sampleCurveDerivativeX(t2);
      if (Math.abs(d2) < K_BEZIER_EPSILON) break;
      t2 -= x2 / d2;
    }
    if (Math.abs(x2) < K_BEZIER_EPSILON) return t2;

    while (t0 < t1) {
      x2 = this.sampleCurveX(t2);
      if (Math.abs(x2 - x) < K_BEZIER_EPSILON) return t2;
      if (x > x2) t0 = t2; 
      else t1 = t2;
      t2 = (t0 + t1) * 0.5;
    }
    return t2;
  }

  public double solve (double x) {
    if (x < 0.0) return 0.0 + this._startGradient * x;
    if (x > 1.0) return 1.0 + this._endGradient * (x - 1.0);
    return this.sampleCurveY(this.solveCurveX(x));
  }
}
