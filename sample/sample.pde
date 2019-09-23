RectPosition rectPosition;
Position destination;

int RECT_SIZE = 10;

void setup () {
  size(600, 600);
  destination = new Position(
    random(width - RECT_SIZE),
    random(height - RECT_SIZE)
  );
  rectPosition = new RectPosition(
    new Position(0, 0),
    destination,
    int(random(15, 60))
  );
}

void draw () {
  if (!rectPosition.hasNext()) {
    Position origin = new Position(destination);
    destination = new Position(
      random(width - RECT_SIZE),
      random(height - RECT_SIZE)
  );
    rectPosition = new RectPosition(
      origin,
      destination,
      int(random(15, 60))
    );
  }

  background(-1);
  Position position = rectPosition.next();
  rect(position.x, position.y, RECT_SIZE, RECT_SIZE);
}
