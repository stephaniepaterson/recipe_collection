DROP TABLE IF EXISTS recipes;

CREATE TABLE recipes (
  id SERIAL4 PRIMARY KEY,
  name VARCHAR(255),
  duration INT,
  ingredients VARCHAR(255)
);
