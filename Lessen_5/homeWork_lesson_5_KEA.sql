USE shop;
-- 1.	Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.

INSERT INTO orders (user_id) VALUES
  (1),
  (5),
  (3),
  (2),
  (3),
  (4);
  
SELECT DISTINCT users.name FROM orders 
	inner join users on orders.user_id = users.id
    order by users.name;
    
-- 2.	Выведите список товаров products и разделов catalogs, который соответствует товару.

SELECT catalogs.name AS 'Раздел', products.name AS 'Товар', products.desription AS 'Описание', products.price AS 'Цена' FROM products
	INNER JOIN catalogs ON products.catalog_id = catalogs.id;
    
-- 3.	(по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). 
-- Поля from, to и label содержат английские названия городов, поле name — русское. 
-- Выведите список рейсов flights с русскими названиями городов.

DROP TABLE IF EXISTS cities;
CREATE TABLE cities (
  id SERIAL PRIMARY KEY,
  label VARCHAR(255) NOT NULL,
  name VARCHAR(255) NOT NULL
);

DROP TABLE IF EXISTS flights;
CREATE TABLE flights (
  id SERIAL PRIMARY KEY,
  flight_from VARCHAR(255) NOT NULL,
  flight_to VARCHAR(255) NOT NULL
);
    
INSERT INTO cities (label, name) VALUES
  ('moscow', 'Москва'),
  ('irkutsk', 'Иркутск'),
  ('novgorod', 'Новгород'),
  ('kazan', 'Казань'),
  ('omsk', 'Омск');
  
INSERT INTO flights (flight_from, flight_to) VALUES
  ('moscow', 'omsk'),
  ('novgorod', 'kazan'),
  ('irkutsk', 'moscow'),
  ('omsk', 'irkutsk'),
  ('moscow', 'kazan');
  
SELECT 
	flights.id AS 'Номер рейса', 
    cities.name AS 'Вылет',
    (SELECT name FROM cities WHERE flights.flight_to = cities.label) AS 'Прилёт'
FROM flights 
	inner join cities on flights.flight_from = cities.label
    ORDER BY flights.id;
    
SELECT 
	flights.id AS 'Номер рейса', 
    c_from.name AS 'Вылет',
    c_to.name AS 'Прилёт'
FROM flights 
	JOIN cities AS c_from on flights.flight_from = c_from.label
    JOIN cities AS c_to on flights.flight_to = c_to.label
    ORDER BY flights.id;
    
