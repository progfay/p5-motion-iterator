# p5-transition

```java
Transition transitionX;

void setup () {
  size(600, 600);
  transitionX = new Transition(50, width - 50, 60, Mode.EASE_IN_OUT);
}

void draw () {
  if (!transitionX.hasNext()) {
    noLoop();
    return;
  }

  background(-1);
  float positionX = transitionX.next();
  ellipse(positionX, height * 0.5, 50, 50);
}
```

