-- 1. Пусть задан некоторый пользователь. Из всех пользователей соц. сети найдите человека, который больше всех общался с выбранным пользователем (написал ему сообщений).

SELECT 
	firstname, lastname 
FROM 
    users 
WHERE 
	id = (SELECT from_user_id 
	FROM messages 
    WHERE to_user_id = 2
	GROUP BY from_user_id 
    ORDER BY COUNT(*) DESC
    LIMIT 1);

-- 2. Подсчитать общее количество лайков, которые получили пользователи младше 10 лет.

SELECT
	COUNT(*)
FROM 
	profiles 
WHERE 
	(TIMESTAMPDIFF(YEAR, birthday, CURDATE()) <= 10) AND ((SELECT media_id FROM likes WHERE media_id = profiles.user_id) IS NOT NULL);
   
-- 3. Определить кто больше поставил лайков (всего): мужчины или женщины.
    
SELECT 
	COUNT(*) AS 'Лайки',
    (SELECT gender FROM profiles WHERE user_id = likes.user_id) AS 'Пол'
FROM 
	likes
GROUP BY
	(SELECT gender FROM profiles WHERE user_id = likes.user_id)
ORDER BY 
	COUNT(*) DESC
LIMIT 1;
