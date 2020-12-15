DROP TABLE IF EXISTS logs_users;
CREATE TABLE logs_users (
	id int unsigned NOT NULL AUTO_INCREMENT,
	user_id bigint unsigned NOT NULL,
	changetype enum('NEW','EDIT','DELETE') NOT NULL,
	changetime timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (id),
	KEY ix_user_id (user_id),
	KEY ix_changetype (changetype),
	KEY ix_changetime (changetime),
	CONSTRAINT FK_logs_user_id FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

drop trigger if exists users_after_insert;

DELIMITER //

CREATE
	TRIGGER users_after_insert AFTER INSERT ON users 
	FOR EACH ROW 
    BEGIN
	
		IF NEW.deleted THEN
			SET @changetype = 'DELETE';
		ELSE
			SET @changetype = 'NEW';
		END IF;
    
		INSERT INTO logs_users (user_id, changetype) VALUES (NEW.id, @changetype);
		
    END//
 
DELIMITER ;

drop trigger if exists users_after_update;

DELIMITER //

CREATE
	TRIGGER users_after_update AFTER UPDATE 
	ON users 
	FOR EACH ROW 
    BEGIN
	
		IF NEW.deleted THEN
			SET @changetype = 'DELETE';
		ELSE
			SET @changetype = 'EDIT';
		END IF;
    
		INSERT INTO logs_users (user_id, changetype) VALUES (NEW.id, @changetype);
		
    END//

DELIMITER ;

-- Изменение пользователя на анонимного в таблицах likes и comments, которые внешним ключём ссылаются на таблицу users, 
-- при удалении данных пользователя из таблицы users.

drop trigger if exists delete_profile;
DELIMITER //
create trigger delete_profile before delete on users
for each row
begin
	update likes set user_id = '99' where user_id = old.id;
    update comments set user_id = '99' where user_id = old.id;
end //
DELIMITER ;