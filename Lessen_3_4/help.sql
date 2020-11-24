-- Остаток от деления %
-- Целочисленное деление DIV
-- Прибавление к NUUL даёт NULL
-- Если строка не может быть приведена к числу она инетерпретируется как 0
-- Оператор безопасного сравнения <=> позволяет безопасно сравнивать с NULL
-- Оператор IS NULL позволяет определить являтся ли значение NULL (так же используется IS NOT NULL) возвращает 0 или 1 (false или true)
-- Если добавить столбец вычислений (например суммы двух чисел) этот толбец будет вычислятся какждый раз при выводе таблицы. Но если добавить к свойствам такого столбца STORED он будет сохранён на жёстком диске и его можно будет индексировать
-- SELECT * FROM catalogs WHERE id BETWEEN 3 AND 4; - запись попадающая в интервал между 3 и 4 включительно. Так же существует NOT BETWEEN.
-- SELECT * FROM catalogs WHERE id IN (1, 3, 5); - возвращает записи где id равно 1, 3, 5
-- SELECT 2 IN (1, 3, 5); - возвращает false если запись не поппадает в значения между скобок. Так же существует конструкция NOT IN.
-- Вместа оператора = лучше использовать оператор LIKE, например SELECT * FROM catalogs WHERE id LIKE 2; 
-- Оператор LIKE можно использовать со спецсимволами % - любое колличество любых символов и _ - любой один символ.
-- Для того чтобы экранировать спецсимволы используется \ например LIKE 'my\_sql' - в даном случае спецсимвол не интерпритирует.
-- Так же существет оператор противоположный LIKE это оператор NOT LIKE 
-- При использовании оператора LIKE календарный столбец преобразуется к строке
-- Операторы RLIKE и REGEXP позволяют произволить поиск в соответствие с регулярными выражениями
-- Регулярное выражение осуществляет поиск по всему текту. Например SELECT 'программист' RLIKE 'грам'; - осуществляет поиск 'грам' по всему слову 'программист'
