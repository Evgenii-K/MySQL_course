-- 1.	В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.

start transaction;

INSERT INTO
    sample.users (name)
SELECT
    shop.users.name
FROM
    shop.users
WHERE
    shop.users.id = 1;
    
DELETE FROM  
	shop.users
WHERE 
	id = 1;

commit;

-- 2.	Создайте представление, которое выводит название name товарной позиции из таблицы products и соответствующее название каталога name из таблицы catalogs.
use shop;

create view products_name as
select
	products.name AS 'Товар',
    catalogs.name AS 'Категория'
from products 
	join catalogs on products.catalog_id = catalogs.id;
