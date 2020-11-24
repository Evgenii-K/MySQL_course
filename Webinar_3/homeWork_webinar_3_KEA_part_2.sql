-- ii. Написать скрипт, возвращающий список имен (только firstname) пользователей без повторений в алфавитном порядке
    
use vk;

SELECT DISTINCT firstname FROM users;

-- iii. Написать скрипт, отмечающий несовершеннолетних пользователей как неактивных (поле is_active = false). Предварительно добавить такое поле в таблицу profiles со значением по умолчанию = true (или 1)

ALTER TABLE profiles 
ADD COLUMN is_active BOOLEAN DEFAULT true;

UPDATE profiles 
SET 
	is_active = false
WHERE 
   TIMESTAMPDIFF(YEAR, birthday, CURDATE()) < 18;

SELECT * FROM profiles;
   
-- iv. Написать скрипт, удаляющий сообщения «из будущего» (дата больше сегодняшней)

DELETE FROM  messages
WHERE 
	current_date() < created_at;