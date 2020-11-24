create database if not exists example;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  UNIQUE unique_name(name(10))
);

INSERT INTO users VALUES
  (DEFAULT, 'Петр'),
  (DEFAULT, 'Анна'),
  (DEFAULT, 'Дмитрий');
