-- 1.	Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, catalogs и products в таблицу logs 
-- помещается время и дата создания записи, название таблицы, идентификатор первичного ключа и содержимое поля name.

USE shop;

DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
	table_name VARCHAR(50) COMMENT 'Название таблицы',
    NEW_id_Table BIGINT COMMENT 'Первичный ключ отслеживаемой таблицы',
	name VARCHAR(255) COMMENT 'Данные из поля name',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) COMMENT 'Log file' ENGINE=Archive;

DELIMITER //

CREATE TRIGGER log_insert_users AFTER INSERT ON users
FOR EACH ROW
BEGIN
	INSERT INTO logs (table_name, NEW_id_Table, name) VALUES ('users', NEW.id, NEW.name);
END//

CREATE TRIGGER log_insert_catalogs AFTER INSERT ON catalogs
FOR EACH ROW
BEGIN
	INSERT INTO logs (table_name, NEW_id_Table, name) VALUES ('catalogs', NEW.id, NEW.name);
END//

CREATE TRIGGER log_insert_products AFTER INSERT ON products
FOR EACH ROW
BEGIN
	INSERT INTO logs (table_name, NEW_id_Table, name) VALUES ('products', NEW.id, NEW.name);
END//

DELIMITER ;
