-- Практическое задание по теме “Операторы, фильтрация, сортировка и ограничение”

-- 1.	Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.

use shop;

UPDATE users SET created_at = current_timestamp;

SELECT * FROM users;

-- 2.	Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате "20.10.2017 8:10". Необходимо преобразовать поля к типу DATETIME, сохранив введеные ранее значения.

ALTER TABLE users 
	CHANGE COLUMN created_at created_at VARCHAR(45) NULL,
	CHANGE COLUMN updated_at updated_at VARCHAR(45) NULL;


UPDATE users
	SET created_at = DATE_FORMAT(created_at, '%d.%m.%y %H:%i'),
	updated_at = DATE_FORMAT(created_at, '%d.%m.%y %H:%i');

ALTER TABLE users 
	CHANGE COLUMN created_at created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	CHANGE COLUMN updated_at updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

SELECT * FROM users;

-- 3.	В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 0, если товар закончился и выше нуля, если на складе имеются запасы. Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. Однако, нулевые запасы должны выводиться в конце, после всех записей.

SELECT * FROM storehouses_products;

INSERT INTO storehouses_products (value) VALUES (0), (2500), (0), (30), (500), (1);

SELECT value FROM storehouses_products ORDER BY IF(value = 0, 1, 0 ), value; 

-- Практическое задание теме “Агрегация данных”

-- 1.	Подсчитайте средний возраст пользователей в таблице users

SELECT FLOOR(AVG(TIMESTAMPDIFF (YEAR, birthday_at, CURDATE()))) AS 'average age' FROM users;

-- 2.	Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. Следует учесть, что необходимы дни недели текущего года, а не года рождения.

SELECT count(*) AS 'Дней рождений в этот день', name AS 'Имя', birthday_at AS 'Дата рождения', 
	DATE_FORMAT(birthday_at, "2020-%m-%d") AS 'День рождения в этом году', DAYNAME(DATE_FORMAT(birthday_at, "2020-%m-%d")) AS 'День недели' 
	FROM users GROUP BY DAYNAME(DATE_FORMAT(birthday_at, "2020-%m-%d")) ORDER BY DAYOFWEEK(DATE_FORMAT(birthday_at, "2020-%m-%d"));