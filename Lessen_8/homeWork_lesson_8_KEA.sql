-- 1.	Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. 
-- С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", с 18:00 до 00:00 — "Добрый вечер", 
-- с 00:00 до 6:00 — "Доброй ночи".
USE shop;

DROP FUNCTION IF EXISTS hello;

DELIMITER //

CREATE FUNCTION hello ()
RETURNS varchar(255) DETERMINISTIC
BEGIN
	IF (CURTIME() BETWEEN '00:00' AND '06:00') THEN
		RETURN 'Доброй ночи';
	ELSEIF (CURTIME() BETWEEN '06:01' AND '12:00') THEN
		RETURN 'Доброе утро';
	ELSEIF (CURTIME() BETWEEN '12:01' AND '18:00') THEN
		RETURN 'Добрый день';
	ELSEIF (CURTIME() BETWEEN '18:01' AND '24:00') THEN
		RETURN 'Добрый вечер';
	ELSE 
		RETURN 'Ошибка в формате';
	END IF;
END//

SELECT hello()//

-- 2.	В таблице products есть два текстовых поля: name с названием товара и description с его описанием. 
-- Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. 
-- Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. При попытке присвоить полям NULL-значение необходимо отменить операцию.

DELIMITER ;

DROP TRIGGER IF EXISTS check_name_description_before_insert;

DELIMITER //

CREATE TRIGGER check_name_description_before_insert BEFORE INSERT ON products
FOR EACH ROW
begin
    IF (NEW.name AND NEW.description) = NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insert Canceled. Name and description must be not NULL!';
    END IF;
END//

DELIMITER ;
