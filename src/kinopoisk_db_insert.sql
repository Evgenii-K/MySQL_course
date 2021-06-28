use sakila;

INSERT INTO kinopoisk.country (`country_name`)
select country from country;

INSERT INTO kinopoisk.cities (`city`, `country`)
select city, country_id from city
group by city;

INSERT INTO kinopoisk.ganre (`ganre_name`)
select name from category;

INSERT INTO kinopoisk.users (`firstname`, `lastname`, `phone`)
select first_name, last_name, address.phone from address
	inner join actor on address.address_id = actor_id
    where address_id > 3 and address_id < 18;
    
INSERT INTO kinopoisk.language (`language_name`)
select name from language;
    
use kinopoisk;

INSERT INTO category (profession) VALUES 
	('Actor'),
    ('Director'),
    ('Screenwriter'),
    ('Producer'),
    ('Operator'),
    ('Composer');
    
INSERT INTO language (language_name) VALUES ('Russian');
    
UPDATE users SET email = 'dziebart0@ow.ly'	WHERE id =	1	;
UPDATE users SET email = 'cromanet1@gravatar.com'	WHERE id =	2	;
UPDATE users SET email = 'rabrahamovitz2@pen.io'	WHERE id =	3	;
UPDATE users SET email = 'kbrou3@usa.gov'	WHERE id =	4	;
UPDATE users SET email = 'btrewett4@jigsy.com'	WHERE id =	5	;
UPDATE users SET email = 'dboldecke5@symantec.com'	WHERE id =	6	;
UPDATE users SET email = 'ahexum6@barnesandnoble.com'	WHERE id =	7	;
UPDATE users SET email = 'wfreebury7@dropbox.com'	WHERE id =	8	;
UPDATE users SET email = 'larnison8@army.mil'	WHERE id =	9	;
UPDATE users SET email = 'ejoris9@livejournal.com'	WHERE id =	10	;
UPDATE users SET email = 'eshirera@guardian.co.uk'	WHERE id =	11	;
UPDATE users SET email = 'tlambshineb@answers.com'	WHERE id =	12	;
UPDATE users SET email = 'lgristockc@oakley.com'	WHERE id =	13	;
UPDATE users SET email = 'partheyd@de.vu'	WHERE id =	14	;

UPDATE users SET city = '5'	WHERE id =	1	;
UPDATE users SET city =	'11' WHERE id =	2	;
UPDATE users SET city =	'4'	WHERE id =	3	;
UPDATE users SET city =	'27' WHERE id =	4	;
UPDATE users SET city =	'8'	WHERE id =	5	;
UPDATE users SET city =	'2'	WHERE id =	6	;
UPDATE users SET city =	'15' WHERE id =	7	;
UPDATE users SET city =	'3'	WHERE id =	8	;
UPDATE users SET city =	'41' WHERE id =	9	;
UPDATE users SET city =	'52' WHERE id =	10	;
UPDATE users SET city =	'8'	WHERE id =	11	;
UPDATE users SET city =	'6'	WHERE id =	12	;
UPDATE users SET city =	'12' WHERE id =	13	;
UPDATE users SET city =	'1'	WHERE id =	14	;

-- Добавляем анонимного пользователя для триггера

insert into users (id, firstname) value ('99', 'anonymous');
  
INSERT INTO films (originalname, transletionname, language, yearcreated, country, ganre, description, budget) VALUES
	('Knockin" on Heaven"s Door', 'Достучаться до небес', '6', '1997', '38', '7', 
		'Судьба сводит двух незнакомцев в больнице, где они получают смертельные диагнозы. 
        Но парни не хотят мириться с судьбой и тихо заканчивать свои дни в больничной палате - угнав машину с миллионом немецких марок в багажнике, 
        они сбегают из больницы.', '4300000'),
	('Inception', 'Начало', '1', '2010', '103', '14', 
		'Шпионаж фантастического уровня. С помощью сверхтехнологии герой Ди Каприо и его команда проникают в чужие сны', '160000000'),
	('Shutter Island', 'Остров проклятых', '1', '2009', '103', '7',
		'Скорсезе отправляет ДиКаприо и Руффало в 50-е — искать детоубийцу, сбежавшую из лечебницы на зловещем острове', '80000000'),
	('Léon', 'Леон', '5', '1994', '34', '1',
		'Профессиональный убийца Леон неожиданно для себя самого решает помочь 11-летней соседке Матильде, 
        семью которой убили коррумпированные полицейские.', '115000000'),
	('Джентльмены удачи', '', '8', '1971', '80', '5', 
		'Воспитатель из детского сада пускается во все тяжкие', NULL),
	('Fight Club', 'Бойцовский клуб', '1', '1999', '103', '1', 
		'Классика от Дэвида Финчера', '63000000'),
	('The Prestige', 'Престиж', '1', '2006', '102', '1', 
		'Ретрофантастика Кристофера Нолана об опасной вражде двух иллюзионистов. Бонус – Дэвид Боуи в роли Николы Теслы', '40000000'),
	('Whiplash', 'Одержимость', '1', '2013', '103', '7', 
		'Эндрю мечтает стать великим. Казалось бы, вот-вот его мечта осуществится.', '3300000'),
	('A Beautiful Mind', 'Игры разума', '1', '2001', '103', '7', 
		'Оскароносная биография великого математика с Расселом Кроу', '58000000'),
	('Shrek', 'Шрэк', '1', '2001', '103', '2', 
		'Полная сюрпризов сказка об ужасном болотном огре, который ненароком наводит порядок в Сказочной стране', '60000000'),
	('La vita è bella', 'Жизнь прекрасна', '2', '1997', '49', '5', 
		'Отец изобретает игру, чтобы помочь сыну выжить в концлагере. Пронзительная история о силе духа и любви', '20000000'),
	('Harry Potter', 'Гарри Поттер', '1', '2004', '102', '8', 
		'Беглый маг, тайны прошлого и путешествия во времени. В третьей части поттерианы Альфонсо Куарон сгущает краски', '130000000'),
	('Tenet', 'Довод', '1', '2020', '102', '1', 
		'Протагонист пытается обезвредить террориста с помощью уникальной технологии. Блокбастер-пазл Кристофера Нолана', '205000000'),
	('Palm Springs', 'Зависнуть в Палм-Спрингс', '1', '2020', '103', '5', 
		'Бездельник и сестра невесты застревают в праздничном Дне сурка. Ромком с Энди Сэмбергом, покоривший критиков', NULL);
	
INSERT INTO comments (id, film_id, user_id, body, created_at, update_at) VALUES ('1', '1', '1', 'Et ab et dolor occaecati deserunt dolorum. Consequatur ratione hic natus. Nam sunt rerum id magnam ratione.', '1995-03-13 08:39:56', '2010-01-09 14:24:14'),
	('2', '2', '2', 'Odio nihil voluptas qui aliquam exercitationem voluptates maxime. Odio expedita omnis eaque consequatur qui eos. Officia ducimus dolorem aut quibusdam.', '1980-06-03 23:57:16', '1991-12-28 22:17:26'),
	('3', '3', '13', 'Distinctio error quae amet odit rem. Eaque molestiae similique cumque id. Non minima minus dignissimos fugiat nostrum aut.', '1979-08-18 20:15:42', '2003-10-20 09:37:36'),
	('4', '4', '1', 'Dolorum saepe suscipit dolorem voluptatem voluptatem deleniti sint. Maiores debitis porro voluptatibus sed. Qui suscipit fuga quasi expedita consectetur. Et aut labore accusantium harum ipsam sint.', '1982-04-21 01:59:49', '2001-06-23 05:38:04'),
	('5', '5', '12', 'Magnam distinctio animi perferendis odio et. Delectus qui temporibus velit et excepturi. Omnis nostrum quisquam et perspiciatis quasi id molestiae. Aspernatur provident et ut error nemo perferendis ea.', '1996-04-27 08:34:33', '1985-09-30 06:16:24'),
	('6', '6', '8', 'Optio quidem laboriosam assumenda accusamus sequi. Quia aliquam dolores nostrum minima occaecati. Aut illo fuga quo ut.', '2005-09-21 09:50:44', '1978-02-02 07:53:08'),
	('7', '7', '3', 'Repellendus atque et deserunt et. Ut sed iure qui quasi debitis sit tempora. Debitis dicta voluptatibus fugiat cum voluptatum quae.', '2020-04-27 21:09:32', '1973-03-04 19:23:53'),
	('8', '8', '14', 'Quia ut laboriosam animi ullam est dolor. Quia cum ullam ipsum praesentium velit. Ut ullam eveniet doloremque et repellat aliquam.', '2020-10-30 03:14:03', '2017-08-28 01:02:57'),
	('9', '9', '5', 'Illo culpa id ut nesciunt velit minus officiis. Consequatur nihil vero quidem sequi rerum vero similique eveniet. Quis iure atque facilis ea.', '2005-03-12 23:30:12', '2012-07-13 23:40:49'),
	('10', '10', '11', 'Hic voluptatem ut exercitationem error reiciendis nemo voluptatem. Dolores omnis suscipit aliquam nam nesciunt laudantium qui et. Voluptatem ex pariatur earum harum adipisci rerum ducimus. Soluta mollitia ipsam doloribus a.', '2008-03-08 16:37:52', '1992-01-09 13:14:18');

INSERT INTO `likes` (`id`, `user_id`, `film_id`) VALUES ('1', '1', '1'),
	('2', '2', '5'),
	('3', '1', '3'),
	('4', '2', '11'),
	('5', '1', '9'),
	('6', '1', '6'),
	('7', '3', '7'),
	('8', '4', '8'),
	('9', '3', '9'),
	('10', '5', '10');

INSERT INTO `media_type` (`id`, `type`) VALUES ('1', 'poster'),
	('2', 'trailer'),
	('3', 'images');
    
INSERT INTO `movie_people` (`first_name`,`last_name`,`gender`,`country`,`birthday`,`biography`) VALUES 
	("Felix","Santiago",1,82,"1986-12-26","dui nec urna suscipit nonummy. Fusce"),
	("Zephr","Hardin",1,11,"1966-04-06","leo. Vivamus"),
    ("Leroy","Padilla",1,94,"1970-12-15","leo. Cras vehicula aliquet libero. Integer in magna. Phasellus dolor"),
    ("Damon","Kelley",0,75,"1979-06-09","massa lobortis ultrices. Vivamus rhoncus. Donec est. Nunc ullamcorper, velit"),
    ("Olga","Park",0,45,"1974-01-23","nunc sed libero."),
    ("Acton","Mckee",1,58,"1997-08-28","Aliquam nisl. Nulla eu neque pellentesque massa lobortis ultrices. Vivamus"),
    ("Brett","Waller",1,107,"1992-02-08","ac ipsum. Phasellus vitae mauris sit"),
    ("Anthony","Rocha",1,85,"1971-01-17","quam vel sapien imperdiet ornare. In faucibus."),
    ("Linus","Stein",1,61,"1952-11-27","ornare, libero at auctor ullamcorper, nisl arcu iaculis enim,"),
    ("Petra","Barker",1,46,"1971-08-12","et arcu imperdiet ullamcorper. Duis at lacus."),
    ("Jack","Odonnell",1,56,"1975-12-31","Aenean eget metus. In nec orci."),
    ("Laura","Hamilton",1,28,"1987-10-30","a, aliquet vel, vulputate eu, odio. Phasellus at"),
    ("Carol","Mcfadden",1,105,"1968-11-06","nascetur ridiculus mus. Aenean eget magna."),
    ("Angela","Barlow",0,100,"1999-12-06","nisi. Aenean eget metus. In nec"),
    ("Yvonne","Lee",0,109,"1961-07-24","arcu. Vestibulum"),
    ("Sylvia","Beasley",1,73,"1958-01-15","arcu imperdiet ullamcorper. Duis"),
    ("Hu","Valentine",1,53,"1980-05-05","arcu ac orci. Ut semper pretium"),
    ("Danielle","Kramer",0,29,"1971-09-15","non,"),
    ("Nelle","Cunningham",0,97,"1976-04-30","iaculis aliquet diam. Sed diam lorem, auctor"),
    ("Brynn","Boyd",1,40,"1985-09-17","molestie orci tincidunt adipiscing. Mauris molestie pharetra nibh. Aliquam ornare,"),
    ("Brady","Sears",0,94,"1956-08-10","nec ante. Maecenas mi felis, adipiscing fringilla,"),
    ("Nathan","Hurley",0,2,"1975-07-21","ac mi eleifend egestas. Sed pharetra, felis eget varius"),
    ("Allen","White",0,9,"1961-11-25","fringilla mi lacinia mattis. Integer eu lacus. Quisque"),
    ("Cody","Patterson",0,83,"1983-10-26","nulla magna, malesuada vel, convallis in, cursus et,"),
    ("Asher","Lowe",0,30,"1966-03-04","tellus sem mollis dui, in sodales elit erat vitae risus."),
    ("Quinlan","Langley",0,55,"1987-02-07","rhoncus id, mollis"),
    ("Amelia","Hunt",0,29,"1955-03-17","orci lacus vestibulum lorem, sit amet ultricies sem magna"),
    ("Callum","Houston",0,84,"1960-02-25","et pede. Nunc sed orci"),
    ("Vincent","Griffin",0,76,"1998-07-14","egestas lacinia. Sed congue, elit sed consequat auctor, nunc nulla"),
    ("Sade","Rodriguez",0,102,"1999-10-25","ridiculus mus. Donec dignissim magna"),
    ("Kelly","Eaton",0,16,"1993-08-21","odio. Etiam ligula tortor, dictum eu,"),
    ("Veronica","Pena",0,99,"1956-03-29","nisl. Maecenas malesuada fringilla est. Mauris eu turpis. Nulla"),
    ("Cruz","Glover",0,13,"1988-03-22","Aenean egestas hendrerit neque. In ornare sagittis felis."),
    ("Yardley","Levy",1,62,"1950-03-18","quis lectus. Nullam suscipit, est"),
    ("Daphne","Hayden",0,5,"2000-08-30","lobortis mauris."),
    ("Alice","Prince",0,82,"1989-11-27","In"),
    ("Gil","Hooper",0,75,"1973-01-30","et ipsum cursus vestibulum."),
    ("Lael","Holt",0,91,"1992-12-26","felis. Donec tempor, est ac"),
    ("Valentine","Cervantes",1,32,"1998-03-26","aliquet libero."),
    ("Mia","Duran",0,45,"1958-01-08","pulvinar arcu et pede. Nunc sed orci"),
    ("Laura","Pacheco",1,55,"1984-02-27","sed, est. Nunc laoreet lectus quis massa. Mauris vestibulum,"),
    ("Tobias","Little",1,58,"1988-01-20","Quisque varius. Nam porttitor"),
    ("Scarlet","Emerson",0,71,"1991-05-15","dui. Fusce aliquam, enim nec tempus scelerisque, lorem ipsum"),
    ("Sawyer","Delgado",0,1,"1954-02-10","elit. Aliquam auctor, velit eget laoreet posuere, enim nisl elementum"),
    ("Quinn","Stevenson",0,97,"1975-03-22","molestie dapibus"),
    ("Deacon","Kramer",1,50,"1990-01-28","sociis natoque penatibus et magnis dis parturient montes,"),
    ("Jelani","Rich",1,47,"1953-07-20","nunc sit amet metus. Aliquam erat volutpat."),
    ("Oliver","Kerr",0,65,"1985-03-29","sit amet orci. Ut sagittis lobortis mauris. Suspendisse aliquet molestie"),
    ("Emerson","Goff",1,7,"1959-12-26","Duis at lacus."),
    ("Keith","Richards",1,87,"1958-05-19","sodales nisi magna sed dui. Fusce");

INSERT INTO `people_film` (`film`,`people`,`category`) VALUES (10,8,1),(2,47,4),(7,14,1),(5,32,1),(3,49,1),(7,44,2),(12,29,4),(1,48,3),(9,18,1),(2,15,1),(1,42,4),(7,24,1),(11,46,2),(10,13,1),(6,47,1),(1,8,1),(4,40,6),(3,20,4),(8,26,3),(11,27,1),(3,28,3),(2,1,1),(7,39,3),(12,47,1),(6,17,4),(5,20,4),(3,29,1),(6,5,1),(1,4,4),(9,8,1),(7,16,5),(12,11,1),(2,48,4),(10,41,1),(12,49,2),(6,34,1),(4,49,3),(4,17,1),(8,27,5),(12,6,1),(9,9,5),(6,44,1),(12,3,1),(12,1,1),(9,36,1),(4,39,1),(12,2,2),(2,28,1),(3,41,3),(6,39,1),(4,10,3),(10,15,1),(8,28,5),(12,12,1),(7,10,5),(1,46,1),(11,48,5),(4,19,1),(10,29,1),(5,42,1),(4,45,2),(11,14,4),(7,14,4),(3,36,5),(4,28,1),(10,6,1),(12,31,5),(9,44,4),(2,8,2),(4,42,1),(1,44,6),(9,1,1),(3,33,6),(2,14,1),(10,41,2),(3,22,3),(8,10,1),(12,8,1),(9,15,3),(2,39,1),(9,49,6),(10,50,4),(1,44,3),(4,37,1),(1,24,4),(1,19,1),(7,17,2),(4,35,1),(5,30,3),(7,2,1),(4,18,6),(7,21,1),(10,24,1),(4,5,2),(8,47,1),(4,16,4),(9,26,1),(8,12,4),(9,21,1),(11,33,1),(13,25,1),(13,33,1),(13,44,4),(13,12,1),(14,24,1),(14,32,1),(14,43,3),(14,13,1),(14,18,4);
	