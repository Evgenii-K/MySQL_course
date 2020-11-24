DROP DATABASE IF EXISTS vk;
CREATE DATABASE vk;
USE vk;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    firstname VARCHAR(50),
    lastname VARCHAR(50),
    email VARCHAR(50) UNIQUE,
    phone BIGINT UNSIGNED UNIQUE, 
    
    INDEX idx_users_firstname_lastname (firstname, lastname)
);

DROP TABLE IF EXISTS profiles;
CREATE TABLE profiles (
	user_id BIGINT UNSIGNED NOT NULL PRIMARY KEY,
    gender char(1),
    hometown VARCHAR(100),
    created_at DATETIME DEFAULT NOW()
 );
 
ALTER TABLE profiles ADD CONSTRAINT fk_profiles_user_id
FOREIGN KEY (user_id) REFERENCES users(id)
ON UPDATE CASCADE
ON DELETE RESTRICT
;
 
ALTER TABLE profiles ADD COLUMN birthday DATE;

DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
	id SERIAL,
    from_user_id BIGINT UNSIGNED,
    to_user_id BIGINT UNSIGNED,
    body TEXT,
    created_at DATETIME DEFAULT NOW(),
    
    FOREIGN KEY (from_user_id) REFERENCES users(id),
    FOREIGN KEY (to_user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS friend_requests;
CREATE TABLE friend_requests (
	initiator_user_id BIGINT UNSIGNED NOT NULL,
	target_user_id BIGINT UNSIGNED NOT NULL,
    status ENUM ('request', 'approved', 'unfriended', 'declined'),
    created_at DATETIME DEFAULT NOW(),
    update_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
    
    PRIMARY KEY (initiator_user_id, target_user_id),
	FOREIGN KEY (initiator_user_id) REFERENCES users(id),
    FOREIGN KEY (target_user_id) REFERENCES users(id),
    CHECK (initiator_user_id != target_user_id)
);

DROP TABLE IF EXISTS communities;
CREATE TABLE communities (
	id SERIAL,
    name VARCHAR(255),
    admin_user_id BIGINT UNSIGNED NOT NULL,
        
    INDEX (name),
    FOREIGN KEY (admin_user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS users_communities;
CREATE TABLE users_communities (
    community_id BIGINT UNSIGNED NOT NULL,
	user_id BIGINT UNSIGNED NOT NULL,
	        
    PRIMARY KEY (community_id, user_id),
	FOREIGN KEY (community_id) REFERENCES communities(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS media_type;
CREATE TABLE media_type (
	id SERIAL,
    name VARCHAR(255)
);

DROP TABLE IF EXISTS media;
CREATE TABLE media (
	id SERIAL,
    user_id BIGINT UNSIGNED NOT NULL,
    body TEXT,
    filename VARCHAR(255),
    metadata JSON,
	media_type_id BIGINT UNSIGNED NOT NULL,
    
	created_at DATETIME DEFAULT NOW(),
    update_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (media_type_id) REFERENCES media_type(id)
);

DROP TABLE IF EXISTS likes;
CREATE TABLE likes (
	id SERIAL,
    user_id BIGINT UNSIGNED NOT NULL,
    media_id BIGINT UNSIGNED NOT NULL,
    
    PRIMARY KEY (user_id, media_id),
	FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (media_id) REFERENCES media(id)
);

-- ДЗ 1

-- Изменяем тип данных колонки hometown для добавления справочной таблицы

ALTER TABLE profiles MODIFY hometown INT UNSIGNED;

-- Справочная таблица списка стран для таблицы городов

DROP TABLE IF EXISTS country;
CREATE TABLE country (
	country_id SERIAL,
    country_name VARCHAR(100) NOT NULL UNIQUE
);

-- Справочная таблица городов для таблицы profiles
 
DROP TABLE IF EXISTS towns;
CREATE TABLE towns (
	town_id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    town VARCHAR(100) NOT NULL UNIQUE,
    country BIGINT UNSIGNED NOT NULL,
	
    UNIQUE (town, country),
    FOREIGN KEY (country) REFERENCES country(country_id)
);

-- Добавляем внешний ключ на таблицу списка городов
  
ALTER TABLE profiles ADD CONSTRAINT fk_profiles_hometown
FOREIGN KEY (hometown) REFERENCES towns(town_id)
ON UPDATE CASCADE
ON DELETE RESTRICT
;

-- Таблица подсчёта количества просмотров контента пользователя

DROP TABLE IF EXISTS views;
CREATE TABLE views (
	count_id SERIAL,
    media_id BIGINT UNSIGNED NOT NULL,
	view_user_id BIGINT UNSIGNED NOT NULL,
    	        
    UNIQUE (media_id, view_user_id),
	FOREIGN KEY (media_id) REFERENCES media(id),
    FOREIGN KEY (view_user_id) REFERENCES users(id)
);

-- Таблица комментариев к контенту

DROP TABLE IF EXISTS comments;
CREATE TABLE comments (
	id SERIAL,
    media_id BIGINT UNSIGNED NOT NULL,
	user_id BIGINT UNSIGNED NOT NULL,
    body TEXT,
    created_at DATETIME DEFAULT NOW(),
    update_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
    
	FOREIGN KEY (media_id) REFERENCES media(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Таблица комментариев к коментарию

DROP TABLE IF EXISTS comments_to_comments;
CREATE TABLE comments_to_comments (
	id SERIAL,
    comments_id BIGINT UNSIGNED NOT NULL,
	user_id BIGINT UNSIGNED NOT NULL,
    body TEXT,
    created_at DATETIME DEFAULT NOW(),
    update_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
    
	FOREIGN KEY (comments_id) REFERENCES comments(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- ДЗ 2

-- i. Заполнить все таблицы БД vk данными (по 10-100 записей в каждой таблице)

use sakila;

INSERT INTO vk.users (`firstname`, `lastname`, `phone`)
select first_name, last_name, address.phone from address
	inner join actor on address.address_id = actor_id
    where address_id > 3 and address_id < 62;
    
use vk;

UPDATE users SET email = 	'dziebart0@ow.ly'	WHERE id =	1	;
UPDATE users SET email = 	'cromanet1@gravatar.com'	WHERE id =	2	;
UPDATE users SET email = 	'rabrahamovitz2@pen.io'	WHERE id =	3	;
UPDATE users SET email = 	'kbrou3@usa.gov'	WHERE id =	4	;
UPDATE users SET email = 	'btrewett4@jigsy.com'	WHERE id =	5	;
UPDATE users SET email = 	'dboldecke5@symantec.com'	WHERE id =	6	;
UPDATE users SET email = 	'ahexum6@barnesandnoble.com'	WHERE id =	7	;
UPDATE users SET email = 	'wfreebury7@dropbox.com'	WHERE id =	8	;
UPDATE users SET email = 	'larnison8@army.mil'	WHERE id =	9	;
UPDATE users SET email = 	'ejoris9@livejournal.com'	WHERE id =	10	;
UPDATE users SET email = 	'eshirera@guardian.co.uk'	WHERE id =	11	;
UPDATE users SET email = 	'tlambshineb@answers.com'	WHERE id =	12	;
UPDATE users SET email = 	'lgristockc@oakley.com'	WHERE id =	13	;
UPDATE users SET email = 	'partheyd@de.vu'	WHERE id =	14	;
UPDATE users SET email = 	'sshepharde@archive.org'	WHERE id =	15	;
UPDATE users SET email = 	'gbompassf@behance.net'	WHERE id =	16	;
UPDATE users SET email = 	'dchellg@pinterest.com'	WHERE id =	17	;
UPDATE users SET email = 	'bpendallh@mlb.com'	WHERE id =	18	;
UPDATE users SET email = 	'gdipietroi@google.pl'	WHERE id =	19	;
UPDATE users SET email = 	'emilnej@posterous.com'	WHERE id =	20	;
UPDATE users SET email = 	'corltonk@delicious.com'	WHERE id =	21	;
UPDATE users SET email = 	'cpetrozzil@msn.com'	WHERE id =	22	;
UPDATE users SET email = 	'afairpom@usnews.com'	WHERE id =	23	;
UPDATE users SET email = 	'wbellengern@huffingtonpost.com'	WHERE id =	24	;
UPDATE users SET email = 	'msanpereo@gmpg.org'	WHERE id =	25	;
UPDATE users SET email = 	'achappellep@mayoclinic.com'	WHERE id =	26	;
UPDATE users SET email = 	'ehannibalq@google.pl'	WHERE id =	27	;
UPDATE users SET email = 	'wpedraccir@purevolume.com'	WHERE id =	28	;
UPDATE users SET email = 	'olaethams@vinaora.com'	WHERE id =	29	;
UPDATE users SET email = 	'otugwellt@mapquest.com'	WHERE id =	30	;
UPDATE users SET email = 	'ckornilyevu@mit.edu'	WHERE id =	31	;
UPDATE users SET email = 	'egoodbandv@state.tx.us'	WHERE id =	32	;
UPDATE users SET email = 	'hmoverleyw@tinyurl.com'	WHERE id =	33	;
UPDATE users SET email = 	'dfriddx@friendfeed.com'	WHERE id =	34	;
UPDATE users SET email = 	'jmordiey@simplemachines.org'	WHERE id =	35	;
UPDATE users SET email = 	'mmosdallz@nhs.uk'	WHERE id =	36	;
UPDATE users SET email = 	'cgreenlies10@artisteer.com'	WHERE id =	37	;
UPDATE users SET email = 	'hschleicher11@dyndns.org'	WHERE id =	38	;
UPDATE users SET email = 	'nbussey12@hibu.com'	WHERE id =	39	;
UPDATE users SET email = 	'jplayle13@bizjournals.com'	WHERE id =	40	;
UPDATE users SET email = 	'cibarra14@naver.com'	WHERE id =	41	;
UPDATE users SET email = 	'utadman15@xinhuanet.com'	WHERE id =	42	;
UPDATE users SET email = 	'jgorke16@ucoz.ru'	WHERE id =	43	;
UPDATE users SET email = 	'mlangman17@amazon.co.jp'	WHERE id =	44	;
UPDATE users SET email = 	'nfowell18@exblog.jp'	WHERE id =	45	;
UPDATE users SET email = 	'delintune19@foxnews.com'	WHERE id =	46	;
UPDATE users SET email = 	'tarenson1a@imdb.com'	WHERE id =	47	;
UPDATE users SET email = 	'lgrog1b@symantec.com'	WHERE id =	48	;
UPDATE users SET email = 	'npimblett1c@salon.com'	WHERE id =	49	;
UPDATE users SET email = 	'lmatus1d@pcworld.com'	WHERE id =	50	;
UPDATE users SET email = 	'dhuntar1e@bigcartel.com'	WHERE id =	51	;
UPDATE users SET email = 	'hbeadon1f@netlog.com'	WHERE id =	52	;
UPDATE users SET email = 	'vscurrey1g@bizjournals.com'	WHERE id =	53	;
UPDATE users SET email = 	'rsuston1h@pagesperso-orange.fr'	WHERE id =	54	;
UPDATE users SET email = 	'jfifield1i@google.de'	WHERE id =	55	;
UPDATE users SET email = 	'mkingzet1j@webeden.co.uk'	WHERE id =	56	;
UPDATE users SET email = 	'mjuza1k@blogs.com'	WHERE id =	57	;
UPDATE users SET email = 	'cjuschka1l@sakura.ne.jp'	WHERE id =	58	;

INSERT INTO `country` (`country_id`, `country_name`) VALUES ('8', 'Albania');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('20', 'Algeria');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('99', 'American Samoa');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('73', 'Andorra');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('83', 'Angola');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('57', 'Antarctica (the territory South of 60 deg S)');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('32', 'Aruba');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('78', 'Australia');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('39', 'Bahrain');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('49', 'Barbados');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('11', 'Belize');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('46', 'British Indian Ocean Territory (Chagos Archipelago)');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('51', 'Brunei Darussalam');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('31', 'Burkina Faso');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('61', 'Burundi');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('36', 'Cambodia');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('100', 'Canada');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('98', 'Christmas Island');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('96', 'Cocos (Keeling) Islands');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('80', 'Cook Islands');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('23', 'Cuba');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('4', 'Cyprus');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('29', 'Czech Republic');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('76', 'Dominica');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('81', 'Ecuador');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('86', 'Egypt');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('58', 'Eritrea');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('71', 'Falkland Islands (Malvinas)');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('48', 'Faroe Islands');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('91', 'Fiji');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('63', 'Finland');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('37', 'France');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('18', 'French Guiana');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('25', 'French Polynesia');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('92', 'Ghana');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('62', 'Greece');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('27', 'Guernsey');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('17', 'Guinea');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('12', 'Hong Kong');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('72', 'Indonesia');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('22', 'Ireland');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('47', 'Israel');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('45', 'Jordan');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('16', 'Korea');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('33', 'Lebanon');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('24', 'Lesotho');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('10', 'Libyan Arab Jamahiriya');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('19', 'Lithuania');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('42', 'Luxembourg');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('74', 'Macedonia');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('94', 'Malaysia');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('95', 'Maldives');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('13', 'Mali');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('5', 'Marshall Islands');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('79', 'Martinique');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('26', 'Monaco');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('87', 'Mongolia');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('3', 'Montenegro');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('7', 'Morocco');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('34', 'Myanmar');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('75', 'Namibia');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('69', 'Netherlands');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('93', 'Nicaragua');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('41', 'Pakistan');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('35', 'Palau');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('52', 'Panama');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('68', 'Paraguay');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('15', 'Pitcairn Islands');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('67', 'Qatar');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('30', 'Reunion');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('82', 'Russian Federation');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('50', 'Saint Kitts and Nevis');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('14', 'Saint Pierre and Miquelon');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('85', 'Samoa');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('9', 'San Marino');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('54', 'Saudi Arabia');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('21', 'Senegal');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('60', 'Seychelles');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('38', 'Sierra Leone');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('40', 'Slovenia');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('77', 'Solomon Islands');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('1', 'Somalia');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('56', 'South Georgia and the South Sandwich Islands');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('65', 'Spain');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('6', 'Sudan');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('28', 'Svalbard & Jan Mayen Islands');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('44', 'Sweden');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('66', 'Syrian Arab Republic');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('55', 'Timor-Leste');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('43', 'Togo');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('89', 'Tonga');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('97', 'Trinidad and Tobago');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('2', 'Turkmenistan');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('53', 'Turks and Caicos Islands');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('88', 'Ukraine');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('59', 'United Arab Emirates');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('70', 'United Kingdom');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('90', 'Uzbekistan');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('64', 'Yemen');
INSERT INTO `country` (`country_id`, `country_name`) VALUES ('84', 'Zambia');

INSERT INTO `towns` (`town_id`, `town`, `country`) VALUES (1, 'Bobbyport', '1');
INSERT INTO `towns` (`town_id`, `town`, `country`) VALUES (2, 'Danebury', '97');
INSERT INTO `towns` (`town_id`, `town`, `country`) VALUES (3, 'East Alaynabury', '2');
INSERT INTO `towns` (`town_id`, `town`, `country`) VALUES (4, 'Evelineborough', '6');
INSERT INTO `towns` (`town_id`, `town`, `country`) VALUES (5, 'Hagenesshire', '80');
INSERT INTO `towns` (`town_id`, `town`, `country`) VALUES (6, 'Harberbury', '2');
INSERT INTO `towns` (`town_id`, `town`, `country`) VALUES (7, 'Herzoghaven', '16');
INSERT INTO `towns` (`town_id`, `town`, `country`) VALUES (8, 'Lake Elvaville', '4');
INSERT INTO `towns` (`town_id`, `town`, `country`) VALUES (9, 'Lake Reynafort', '8');
INSERT INTO `towns` (`town_id`, `town`, `country`) VALUES (10, 'North Alessiachester', '62');
INSERT INTO `towns` (`town_id`, `town`, `country`) VALUES (11, 'North Laurybury', '6');
INSERT INTO `towns` (`town_id`, `town`, `country`) VALUES (12, 'North Queen', '24');
INSERT INTO `towns` (`town_id`, `town`, `country`) VALUES (13, 'North Skylaberg', '2');
INSERT INTO `towns` (`town_id`, `town`, `country`) VALUES (14, 'Octaviamouth', '2');
INSERT INTO `towns` (`town_id`, `town`, `country`) VALUES (15, 'Port Emely', '3');
INSERT INTO `towns` (`town_id`, `town`, `country`) VALUES (16, 'Port Garnetshire', '4');
INSERT INTO `towns` (`town_id`, `town`, `country`) VALUES (17, 'South Barton', '4');
INSERT INTO `towns` (`town_id`, `town`, `country`) VALUES (18, 'Tinafort', '31');
INSERT INTO `towns` (`town_id`, `town`, `country`) VALUES (19, 'Zanefurt', '43');
INSERT INTO `towns` (`town_id`, `town`, `country`) VALUES (20, 'Ziemeburgh', '22');

INSERT	INTO	`profiles`	(	`user_id`,	`gender`,	`hometown`,	`created_at`,	`birthday`)	VALUES	(	1	,	'M',	20	,	'2013-04-13	02:45:07',	'1986-01-03');	
INSERT	INTO	`profiles`	(	`user_id`,	`gender`,	`hometown`,	`created_at`,	`birthday`)	VALUES	(	2	,	'F',	15	,	'1977-10-18	19:24:38',	'1984-10-22');	
INSERT	INTO	`profiles`	(	`user_id`,	`gender`,	`hometown`,	`created_at`,	`birthday`)	VALUES	(	3	,	'F',	9	,	'1973-03-24	05:27:51',	'2011-10-04');	
INSERT	INTO	`profiles`	(	`user_id`,	`gender`,	`hometown`,	`created_at`,	`birthday`)	VALUES	(	4	,	'M',	12	,	'1970-01-24	10:32:13',	'2013-08-09');	
INSERT	INTO	`profiles`	(	`user_id`,	`gender`,	`hometown`,	`created_at`,	`birthday`)	VALUES	(	5	,	'F',	1	,	'2016-10-12	07:53:03',	'1975-01-14');	
INSERT	INTO	`profiles`	(	`user_id`,	`gender`,	`hometown`,	`created_at`,	`birthday`)	VALUES	(	6	,	'F',	15	,	'1971-04-25	11:47:37',	'1994-12-08');	
INSERT	INTO	`profiles`	(	`user_id`,	`gender`,	`hometown`,	`created_at`,	`birthday`)	VALUES	(	7	,	'M',	3	,	'1988-05-21	16:11:58',	'2012-12-28');	
INSERT	INTO	`profiles`	(	`user_id`,	`gender`,	`hometown`,	`created_at`,	`birthday`)	VALUES	(	8	,	'F',	12	,	'2019-11-18	05:00:11',	'1982-06-09');	
INSERT	INTO	`profiles`	(	`user_id`,	`gender`,	`hometown`,	`created_at`,	`birthday`)	VALUES	(	9	,	'F',	17	,	'2019-07-09	06:42:06',	'1977-12-28');	
INSERT	INTO	`profiles`	(	`user_id`,	`gender`,	`hometown`,	`created_at`,	`birthday`)	VALUES	(	10	,	'M',	7	,	'1977-06-24	20:31:18',	'1983-04-25');	
INSERT	INTO	`profiles`	(	`user_id`,	`gender`,	`hometown`,	`created_at`,	`birthday`)	VALUES	(	11	,	'M',	1	,	'1993-10-30	18:22:35',	'2011-04-27');	
INSERT	INTO	`profiles`	(	`user_id`,	`gender`,	`hometown`,	`created_at`,	`birthday`)	VALUES	(	12	,	'F',	11	,	'2000-02-14	19:57:45',	'2007-11-17');	
INSERT	INTO	`profiles`	(	`user_id`,	`gender`,	`hometown`,	`created_at`,	`birthday`)	VALUES	(	13	,	'M',	16	,	'2004-04-09	17:06:00',	'2008-04-14');	
INSERT	INTO	`profiles`	(	`user_id`,	`gender`,	`hometown`,	`created_at`,	`birthday`)	VALUES	(	14	,	'M',	8	,	'2018-07-17	05:57:16',	'2003-01-11');	
INSERT	INTO	`profiles`	(	`user_id`,	`gender`,	`hometown`,	`created_at`,	`birthday`)	VALUES	(	15	,	'F',	18	,	'1971-07-09	23:31:19',	'1987-10-02');	
INSERT	INTO	`profiles`	(	`user_id`,	`gender`,	`hometown`,	`created_at`,	`birthday`)	VALUES	(	16	,	'M',	8	,	'2015-05-04	03:43:04',	'1999-09-23');	
INSERT	INTO	`profiles`	(	`user_id`,	`gender`,	`hometown`,	`created_at`,	`birthday`)	VALUES	(	17	,	'F',	18	,	'1974-12-21	12:50:36',	'1978-08-15');	
INSERT	INTO	`profiles`	(	`user_id`,	`gender`,	`hometown`,	`created_at`,	`birthday`)	VALUES	(	18	,	'M',	5	,	'1980-03-07	23:29:13',	'2008-11-24');	
INSERT	INTO	`profiles`	(	`user_id`,	`gender`,	`hometown`,	`created_at`,	`birthday`)	VALUES	(	19	,	'M',	14	,	'1982-03-26	22:30:44',	'2013-05-03');	
INSERT	INTO	`profiles`	(	`user_id`,	`gender`,	`hometown`,	`created_at`,	`birthday`)	VALUES	(	20	,	'F',	9	,	'1976-08-07	21:53:59',	'1999-04-12');	
INSERT	INTO	`profiles`	(	`user_id`,	`gender`,	`hometown`,	`created_at`,	`birthday`)	VALUES	(	21	,	'M',	11	,	'1973-12-11	19:08:31',	'2011-11-29');	
INSERT	INTO	`profiles`	(	`user_id`,	`gender`,	`hometown`,	`created_at`,	`birthday`)	VALUES	(	22	,	'M',	17	,	'2009-11-27	21:06:59',	'1978-07-14');	
INSERT	INTO	`profiles`	(	`user_id`,	`gender`,	`hometown`,	`created_at`,	`birthday`)	VALUES	(	23	,	'F',	3	,	'1972-03-16	13:19:52',	'1993-07-11');	
INSERT	INTO	`profiles`	(	`user_id`,	`gender`,	`hometown`,	`created_at`,	`birthday`)	VALUES	(	24	,	'F',	11	,	'2000-08-14	23:19:38',	'1985-05-16');	
INSERT	INTO	`profiles`	(	`user_id`,	`gender`,	`hometown`,	`created_at`,	`birthday`)	VALUES	(	25	,	'F',	8	,	'1970-09-18	13:51:03',	'1978-08-24');	
INSERT	INTO	`profiles`	(	`user_id`,	`gender`,	`hometown`,	`created_at`,	`birthday`)	VALUES	(	26	,	'M',	10	,	'1993-07-31	13:08:21',	'1998-05-16');	
INSERT	INTO	`profiles`	(	`user_id`,	`gender`,	`hometown`,	`created_at`,	`birthday`)	VALUES	(	27	,	'F',	7	,	'1981-09-18	09:07:42',	'1974-01-25');	
INSERT	INTO	`profiles`	(	`user_id`,	`gender`,	`hometown`,	`created_at`,	`birthday`)	VALUES	(	28	,	'M',	13	,	'1970-09-03	06:25:22',	'1990-05-18');	
INSERT	INTO	`profiles`	(	`user_id`,	`gender`,	`hometown`,	`created_at`,	`birthday`)	VALUES	(	29	,	'M',	6	,	'2009-04-10	23:10:55',	'1981-12-23');	
INSERT	INTO	`profiles`	(	`user_id`,	`gender`,	`hometown`,	`created_at`,	`birthday`)	VALUES	(	30	,	'F',	18	,	'1980-04-26	22:57:06',	'2019-09-26');	
INSERT	INTO	`profiles`	(	`user_id`,	`gender`,	`hometown`,	`created_at`,	`birthday`)	VALUES	(	31	,	'M',	6	,	'1989-07-23	13:24:21',	'1980-11-05');	
INSERT	INTO	`profiles`	(	`user_id`,	`gender`,	`hometown`,	`created_at`,	`birthday`)	VALUES	(	32	,	'M',	12	,	'2015-01-03	07:04:39',	'2008-01-10');	
INSERT	INTO	`profiles`	(	`user_id`,	`gender`,	`hometown`,	`created_at`,	`birthday`)	VALUES	(	33	,	'M',	6	,	'1997-11-18	01:10:17',	'2009-01-31');	
INSERT	INTO	`profiles`	(	`user_id`,	`gender`,	`hometown`,	`created_at`,	`birthday`)	VALUES	(	34	,	'M',	17	,	'2011-11-13	12:38:46',	'1974-06-24');	
INSERT	INTO	`profiles`	(	`user_id`,	`gender`,	`hometown`,	`created_at`,	`birthday`)	VALUES	(	35	,	'F',	4	,	'2014-03-10	17:54:47',	'1970-09-10');	
INSERT	INTO	`profiles`	(	`user_id`,	`gender`,	`hometown`,	`created_at`,	`birthday`)	VALUES	(	36	,	'F',	5	,	'2005-10-26	13:35:31',	'1986-03-24');	
INSERT	INTO	`profiles`	(	`user_id`,	`gender`,	`hometown`,	`created_at`,	`birthday`)	VALUES	(	37	,	'M',	9	,	'1994-08-17	08:46:13',	'2001-02-24');	
INSERT	INTO	`profiles`	(	`user_id`,	`gender`,	`hometown`,	`created_at`,	`birthday`)	VALUES	(	38	,	'M',	9	,	'1998-04-21	02:08:39',	'1996-11-20');	
INSERT	INTO	`profiles`	(	`user_id`,	`gender`,	`hometown`,	`created_at`,	`birthday`)	VALUES	(	39	,	'M',	6	,	'1980-10-26	07:53:51',	'2011-01-25');	
INSERT	INTO	`profiles`	(	`user_id`,	`gender`,	`hometown`,	`created_at`,	`birthday`)	VALUES	(	40	,	'F',	10	,	'2011-11-03	14:52:06',	'1993-10-01');	
INSERT	INTO	`profiles`	(	`user_id`,	`gender`,	`hometown`,	`created_at`,	`birthday`)	VALUES	(	41	,	'F',	9	,	'2002-03-30	16:40:03',	'2007-06-08');	
INSERT	INTO	`profiles`	(	`user_id`,	`gender`,	`hometown`,	`created_at`,	`birthday`)	VALUES	(	42	,	'F',	8	,	'1988-11-25	02:13:27',	'1971-08-19');	
INSERT	INTO	`profiles`	(	`user_id`,	`gender`,	`hometown`,	`created_at`,	`birthday`)	VALUES	(	43	,	'M',	8	,	'1971-12-25	09:22:45',	'2018-09-26');	
INSERT	INTO	`profiles`	(	`user_id`,	`gender`,	`hometown`,	`created_at`,	`birthday`)	VALUES	(	44	,	'F',	4	,	'2005-06-07	02:21:33',	'1992-06-09');	
INSERT	INTO	`profiles`	(	`user_id`,	`gender`,	`hometown`,	`created_at`,	`birthday`)	VALUES	(	45	,	'F',	6	,	'1999-11-29	12:42:25',	'2014-02-17');	
INSERT	INTO	`profiles`	(	`user_id`,	`gender`,	`hometown`,	`created_at`,	`birthday`)	VALUES	(	46	,	'F',	5	,	'1978-08-06	21:42:48',	'1979-05-11');	
INSERT	INTO	`profiles`	(	`user_id`,	`gender`,	`hometown`,	`created_at`,	`birthday`)	VALUES	(	47	,	'M',	3	,	'1979-02-02	19:22:10',	'1995-06-27');	
INSERT	INTO	`profiles`	(	`user_id`,	`gender`,	`hometown`,	`created_at`,	`birthday`)	VALUES	(	48	,	'M',	8	,	'1990-06-24	14:15:56',	'1996-03-04');	
INSERT	INTO	`profiles`	(	`user_id`,	`gender`,	`hometown`,	`created_at`,	`birthday`)	VALUES	(	49	,	'F',	6	,	'2011-12-06	08:17:02',	'2004-10-14');	
INSERT	INTO	`profiles`	(	`user_id`,	`gender`,	`hometown`,	`created_at`,	`birthday`)	VALUES	(	50	,	'F',	9	,	'2004-05-19	22:43:03',	'1998-07-20');	
INSERT	INTO	`profiles`	(	`user_id`,	`gender`,	`hometown`,	`created_at`,	`birthday`)	VALUES	(	51	,	'M',	9	,	'1980-04-10	02:05:12',	'2004-04-05');	
INSERT	INTO	`profiles`	(	`user_id`,	`gender`,	`hometown`,	`created_at`,	`birthday`)	VALUES	(	52	,	'F',	7	,	'2018-11-26	21:55:51',	'2004-11-11');	
INSERT	INTO	`profiles`	(	`user_id`,	`gender`,	`hometown`,	`created_at`,	`birthday`)	VALUES	(	53	,	'M',	10	,	'1982-06-07	23:24:35',	'2009-04-07');	
INSERT	INTO	`profiles`	(	`user_id`,	`gender`,	`hometown`,	`created_at`,	`birthday`)	VALUES	(	54	,	'M',	6	,	'1976-07-31	18:51:42',	'1986-12-21');	
INSERT	INTO	`profiles`	(	`user_id`,	`gender`,	`hometown`,	`created_at`,	`birthday`)	VALUES	(	55	,	'M',	1	,	'1978-01-09	12:13:28',	'1973-11-04');	
INSERT	INTO	`profiles`	(	`user_id`,	`gender`,	`hometown`,	`created_at`,	`birthday`)	VALUES	(	56	,	'M',	1	,	'1999-04-14	20:28:15',	'2017-09-25');	
INSERT	INTO	`profiles`	(	`user_id`,	`gender`,	`hometown`,	`created_at`,	`birthday`)	VALUES	(	57	,	'F',	7	,	'2015-12-31	14:40:32',	'1977-03-29');	
INSERT	INTO	`profiles`	(	`user_id`,	`gender`,	`hometown`,	`created_at`,	`birthday`)	VALUES	(	58	,	'F',	15	,	'1997-07-14	02:00:09',	'2020-01-28');	

INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `created_at`) VALUES ('1', '1', '2', 'Maiores quibusdam voluptatum officia voluptas sit harum rem. Voluptatem sit mollitia tempora voluptatem dolore possimus repellendus. Quibusdam id sunt dolor fugit eaque qui.', '2005-06-06 14:39:45');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `created_at`) VALUES ('2', '5', '3', 'Non pariatur non voluptatem ab aut pariatur consequatur. Assumenda magnam sequi soluta deserunt. Occaecati quidem quo tempore tenetur nulla.', '1976-09-12 17:36:05');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `created_at`) VALUES ('3', '4', '8', 'Pariatur modi sunt fuga dolore explicabo. Qui non itaque aspernatur quisquam quis. Enim voluptatem dolor dolor consequatur qui suscipit accusantium.', '2017-07-03 02:03:17');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `created_at`) VALUES ('4', '10', '4', 'Provident et dignissimos quisquam sint. Deleniti earum qui et temporibus. Ullam hic veritatis quas minima corporis quibusdam sequi est. Eius error a fuga nesciunt ullam totam numquam.', '2018-01-23 10:20:34');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `created_at`) VALUES ('5', '6', '7', 'Harum ab voluptatem dolorem quos. Nisi aliquid ipsum quia. Qui rerum facilis omnis quae. Dolorem natus consequatur fugit ea aut iure non.', '1984-01-05 13:33:30');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `created_at`) VALUES ('6', '9', '11', 'Hic voluptatum non nemo id expedita esse dolores voluptas. Et repudiandae beatae saepe exercitationem nihil id qui reiciendis. Sed ea et dolor veritatis reiciendis sapiente rem.', '1997-08-03 07:17:56');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `created_at`) VALUES ('7', '13', '12', 'Tempora aspernatur sunt dolor amet. Nesciunt dolor ratione tempore. Doloremque voluptate eius odio non at commodi beatae.', '2016-05-01 11:56:54');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `created_at`) VALUES ('8', '1', '14', 'Optio occaecati fugit saepe quae cumque quasi. Hic eos veniam dolore. In delectus voluptatibus eaque corporis corrupti. Non earum et officiis ut modi sed.', '2021-06-15 00:22:15');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `created_at`) VALUES ('9', '15', '16', 'Velit harum eaque eos quia voluptatem voluptatem odit. Dolorem ipsam quis nesciunt. Sit qui voluptatem laudantium. Reprehenderit quasi nemo est. Aut illo explicabo nulla officia dolorum culpa explicabo.', '2008-01-09 08:56:37');
INSERT INTO `messages` (`id`, `from_user_id`, `to_user_id`, `body`, `created_at`) VALUES ('10', '7', '9', 'Magni amet quis beatae omnis minima in rem. Ut recusandae odio saepe provident et fugiat voluptas. Exercitationem eaque a corrupti inventore sunt fugit sapiente. Quo ipsum fuga expedita tenetur.', '1999-12-30 15:04:03');

insert into friend_requests (initiator_user_id, target_user_id, status, created_at, update_at) values (5, 1, 'request', '1976-09-12 17:36:05', '1997-08-03 07:17:56');
insert into friend_requests (initiator_user_id, target_user_id, status, created_at, update_at) values (3, 2, 'unfriended', '1997-08-03 07:17:56', '2005-06-06 14:39:45');
insert into friend_requests (initiator_user_id, target_user_id, status, created_at, update_at) values (4, 3, 'approved', '2005-06-06 14:39:45', '2021-06-15 00:22:15');
insert into friend_requests (initiator_user_id, target_user_id, status, created_at, update_at) values (6, 4, 'unfriended', '1984-01-05 13:33:30', '2018-01-23 10:20:34');
insert into friend_requests (initiator_user_id, target_user_id, status, created_at, update_at) values (8, 5, 'request', '1997-08-03 07:17:56', '1997-08-03 07:17:56');
insert into friend_requests (initiator_user_id, target_user_id, status, created_at, update_at) values (9, 6, 'declined', '2021-06-15 00:22:15', '2005-06-06 14:39:45');
insert into friend_requests (initiator_user_id, target_user_id, status, created_at, update_at) values (16, 7, 'approved', '2005-06-06 14:39:45', '2021-06-15 00:22:15');
insert into friend_requests (initiator_user_id, target_user_id, status, created_at, update_at) values (2, 1, 'request', '1997-08-03 07:17:56', '1976-09-12 17:36:05');
insert into friend_requests (initiator_user_id, target_user_id, status, created_at, update_at) values (14, 17, 'unfriended', '2021-06-15 00:22:15', '1997-08-03 07:17:56');
insert into friend_requests (initiator_user_id, target_user_id, status, created_at, update_at) values (10, 3, 'request', '2016-10-12	07:53:03', '2017-10-12	07:53:03');

INSERT INTO `communities` (`id`, `name`, `admin_user_id`) VALUES ('1', 'harum', '1');
INSERT INTO `communities` (`id`, `name`, `admin_user_id`) VALUES ('2', 'excepturi', '12');
INSERT INTO `communities` (`id`, `name`, `admin_user_id`) VALUES ('3', 'praesentium', '3');
INSERT INTO `communities` (`id`, `name`, `admin_user_id`) VALUES ('4', 'amet', '14');
INSERT INTO `communities` (`id`, `name`, `admin_user_id`) VALUES ('5', 'necessitatibus', '5');
INSERT INTO `communities` (`id`, `name`, `admin_user_id`) VALUES ('6', 'praesentium', '16');
INSERT INTO `communities` (`id`, `name`, `admin_user_id`) VALUES ('7', 'vel', '7');
INSERT INTO `communities` (`id`, `name`, `admin_user_id`) VALUES ('8', 'consectetur', '18');
INSERT INTO `communities` (`id`, `name`, `admin_user_id`) VALUES ('9', 'consequatur', '9');
INSERT INTO `communities` (`id`, `name`, `admin_user_id`) VALUES ('10', 'quaerat', '12');

INSERT INTO `users_communities` (`community_id`, `user_id`) VALUES ('1', '2');
INSERT INTO `users_communities` (`community_id`, `user_id`) VALUES ('2', '5');
INSERT INTO `users_communities` (`community_id`, `user_id`) VALUES ('3', '7');
INSERT INTO `users_communities` (`community_id`, `user_id`) VALUES ('4', '4');
INSERT INTO `users_communities` (`community_id`, `user_id`) VALUES ('5', '15');
INSERT INTO `users_communities` (`community_id`, `user_id`) VALUES ('6', '6');
INSERT INTO `users_communities` (`community_id`, `user_id`) VALUES ('7', '9');
INSERT INTO `users_communities` (`community_id`, `user_id`) VALUES ('8', '11');
INSERT INTO `users_communities` (`community_id`, `user_id`) VALUES ('9', '12');
INSERT INTO `users_communities` (`community_id`, `user_id`) VALUES ('10', '8');

INSERT INTO `media_type` (`id`, `name`) VALUES ('1', 'veritatis');
INSERT INTO `media_type` (`id`, `name`) VALUES ('2', 'quis');
INSERT INTO `media_type` (`id`, `name`) VALUES ('3', 'praesentium');
INSERT INTO `media_type` (`id`, `name`) VALUES ('4', 'odio');
INSERT INTO `media_type` (`id`, `name`) VALUES ('5', 'vel');
INSERT INTO `media_type` (`id`, `name`) VALUES ('6', 'sequi');
INSERT INTO `media_type` (`id`, `name`) VALUES ('7', 'officiis');
INSERT INTO `media_type` (`id`, `name`) VALUES ('8', 'est');
INSERT INTO `media_type` (`id`, `name`) VALUES ('9', 'ratione');
INSERT INTO `media_type` (`id`, `name`) VALUES ('10', 'eos');

INSERT INTO `media` (`id`, `user_id`, `body`, `filename`, `metadata`, `media_type_id`, `created_at`, `update_at`) VALUES ('1', '11', 'Rem totam dignissimos fuga nostrum et voluptas voluptate debitis. Nobis nihil quidem et quisquam aperiam. Doloribus quia eum ratione sed harum et sit aut.', 'vero', NULL, '1', '1970-05-10 22:46:18', '1983-05-20 13:39:34');
INSERT INTO `media` (`id`, `user_id`, `body`, `filename`, `metadata`, `media_type_id`, `created_at`, `update_at`) VALUES ('2', '1', 'Consequatur quis neque distinctio non voluptas placeat quod. Voluptate quas rerum et minima minus assumenda nisi. Nesciunt unde corrupti rerum eos.', 'nulla', NULL, '2', '2010-02-12 04:01:44', '1972-03-20 18:29:39');
INSERT INTO `media` (`id`, `user_id`, `body`, `filename`, `metadata`, `media_type_id`, `created_at`, `update_at`) VALUES ('3', '31', 'Illum quasi in qui aut. Officiis sed nulla est. Aut voluptate blanditiis id dolorem nesciunt. Sequi aliquam quisquam voluptas et nihil. Aliquid molestiae dolorum qui voluptatibus sequi.', 'et', NULL, '3', '2018-02-08 05:29:30', '2000-12-18 20:37:43');
INSERT INTO `media` (`id`, `user_id`, `body`, `filename`, `metadata`, `media_type_id`, `created_at`, `update_at`) VALUES ('4', '14', 'Magnam maxime animi occaecati doloremque amet. Cupiditate porro illum doloribus. Aperiam labore sed repudiandae vero et occaecati id. Velit similique beatae et illo.', 'id', NULL, '4', '1977-10-24 22:31:30', '2014-10-15 03:46:41');
INSERT INTO `media` (`id`, `user_id`, `body`, `filename`, `metadata`, `media_type_id`, `created_at`, `update_at`) VALUES ('5', '45', 'Placeat error nam eum at dolores. Et cum soluta molestiae qui doloribus voluptas dolorem similique. Sit rem aut mollitia in possimus natus adipisci odit. Modi iste quod est dolorem.', 'autem', NULL, '5', '1989-06-16 21:20:14', '2000-08-27 06:57:57');
INSERT INTO `media` (`id`, `user_id`, `body`, `filename`, `metadata`, `media_type_id`, `created_at`, `update_at`) VALUES ('6', '16', 'Ut quod fuga impedit qui unde ea. Id amet quis quo culpa dicta in vero. Non animi sunt molestias.', 'suscipit', NULL, '6', '1985-07-06 23:41:08', '2007-07-08 20:53:26');
INSERT INTO `media` (`id`, `user_id`, `body`, `filename`, `metadata`, `media_type_id`, `created_at`, `update_at`) VALUES ('7', '7', 'Ut optio quia illo recusandae consequatur. Qui velit ipsa ea labore quas ipsam. Dolorum fugit accusamus similique qui qui et. Eius veritatis sed qui non sunt et.', 'enim', NULL, '7', '2007-07-09 14:36:13', '2004-10-24 00:53:02');
INSERT INTO `media` (`id`, `user_id`, `body`, `filename`, `metadata`, `media_type_id`, `created_at`, `update_at`) VALUES ('8', '18', 'Mollitia ipsam iste dignissimos maiores pariatur accusamus. Delectus qui aut laboriosam consequatur voluptatem commodi ipsam unde. Qui impedit explicabo aliquid accusamus maiores. Adipisci ex officiis molestiae ut quasi et. Quia eum dignissimos consectetur et voluptatibus.', 'sit', NULL, '8', '1987-01-14 00:41:54', '1978-05-03 19:31:40');
INSERT INTO `media` (`id`, `user_id`, `body`, `filename`, `metadata`, `media_type_id`, `created_at`, `update_at`) VALUES ('9', '9', 'Ipsam facere voluptatem ea exercitationem inventore. Debitis ad in nihil esse. Ex consequatur voluptatem earum cumque reiciendis maxime quidem. Tenetur architecto consequatur est modi deserunt. Illum sequi maiores labore eos ut et.', 'hic', NULL, '9', '1997-09-22 01:52:38', '1980-07-17 05:14:44');
INSERT INTO `media` (`id`, `user_id`, `body`, `filename`, `metadata`, `media_type_id`, `created_at`, `update_at`) VALUES ('10', '2', 'Rerum fugit rem eum alias consequuntur. Eum quia cumque non dolore. Ea voluptates explicabo qui.', 'fugit', NULL, '10', '1980-10-15 20:05:10', '2016-03-07 07:54:42');

INSERT INTO `likes` (`id`, `user_id`, `media_id`) VALUES ('1', '11', '1');
INSERT INTO `likes` (`id`, `user_id`, `media_id`) VALUES ('2', '21', '2');
INSERT INTO `likes` (`id`, `user_id`, `media_id`) VALUES ('3', '13', '3');
INSERT INTO `likes` (`id`, `user_id`, `media_id`) VALUES ('4', '4', '4');
INSERT INTO `likes` (`id`, `user_id`, `media_id`) VALUES ('5', '51', '5');
INSERT INTO `likes` (`id`, `user_id`, `media_id`) VALUES ('6', '1', '6');
INSERT INTO `likes` (`id`, `user_id`, `media_id`) VALUES ('7', '12', '7');
INSERT INTO `likes` (`id`, `user_id`, `media_id`) VALUES ('8', '14', '8');
INSERT INTO `likes` (`id`, `user_id`, `media_id`) VALUES ('9', '5', '9');
INSERT INTO `likes` (`id`, `user_id`, `media_id`) VALUES ('10', '16', '10');

INSERT INTO `views` (`count_id`, `media_id`, `view_user_id`) VALUES ('1', '5', '11');
INSERT INTO `views` (`count_id`, `media_id`, `view_user_id`) VALUES ('2', '2', '2');
INSERT INTO `views` (`count_id`, `media_id`, `view_user_id`) VALUES ('3', '3', '31');
INSERT INTO `views` (`count_id`, `media_id`, `view_user_id`) VALUES ('4', '4', '5');
INSERT INTO `views` (`count_id`, `media_id`, `view_user_id`) VALUES ('5', '3', '15');
INSERT INTO `views` (`count_id`, `media_id`, `view_user_id`) VALUES ('6', '6', '23');
INSERT INTO `views` (`count_id`, `media_id`, `view_user_id`) VALUES ('7', '7', '25');
INSERT INTO `views` (`count_id`, `media_id`, `view_user_id`) VALUES ('8', '8', '28');
INSERT INTO `views` (`count_id`, `media_id`, `view_user_id`) VALUES ('9', '9', '35');
INSERT INTO `views` (`count_id`, `media_id`, `view_user_id`) VALUES ('10', '8', '16');

INSERT INTO `comments` (`id`, `media_id`, `user_id`, `body`, `created_at`, `update_at`) VALUES ('1', '1', '1', 'Et ab et dolor occaecati deserunt dolorum. Consequatur ratione hic natus. Nam sunt rerum id magnam ratione.', '1995-03-13 08:39:56', '2010-01-09 14:24:14');
INSERT INTO `comments` (`id`, `media_id`, `user_id`, `body`, `created_at`, `update_at`) VALUES ('2', '2', '2', 'Odio nihil voluptas qui aliquam exercitationem voluptates maxime. Odio expedita omnis eaque consequatur qui eos. Officia ducimus dolorem aut quibusdam.', '1980-06-03 23:57:16', '1991-12-28 22:17:26');
INSERT INTO `comments` (`id`, `media_id`, `user_id`, `body`, `created_at`, `update_at`) VALUES ('3', '3', '13', 'Distinctio error quae amet odit rem. Eaque molestiae similique cumque id. Non minima minus dignissimos fugiat nostrum aut.', '1979-08-18 20:15:42', '2003-10-20 09:37:36');
INSERT INTO `comments` (`id`, `media_id`, `user_id`, `body`, `created_at`, `update_at`) VALUES ('4', '4', '41', 'Dolorum saepe suscipit dolorem voluptatem voluptatem deleniti sint. Maiores debitis porro voluptatibus sed. Qui suscipit fuga quasi expedita consectetur. Et aut labore accusantium harum ipsam sint.', '1982-04-21 01:59:49', '2001-06-23 05:38:04');
INSERT INTO `comments` (`id`, `media_id`, `user_id`, `body`, `created_at`, `update_at`) VALUES ('5', '5', '15', 'Magnam distinctio animi perferendis odio et. Delectus qui temporibus velit et excepturi. Omnis nostrum quisquam et perspiciatis quasi id molestiae. Aspernatur provident et ut error nemo perferendis ea.', '1996-04-27 08:34:33', '1985-09-30 06:16:24');
INSERT INTO `comments` (`id`, `media_id`, `user_id`, `body`, `created_at`, `update_at`) VALUES ('6', '6', '11', 'Optio quidem laboriosam assumenda accusamus sequi. Quia aliquam dolores nostrum minima occaecati. Aut illo fuga quo ut.', '2005-09-21 09:50:44', '1978-02-02 07:53:08');
INSERT INTO `comments` (`id`, `media_id`, `user_id`, `body`, `created_at`, `update_at`) VALUES ('7', '7', '3', 'Repellendus atque et deserunt et. Ut sed iure qui quasi debitis sit tempora. Debitis dicta voluptatibus fugiat cum voluptatum quae.', '2020-04-27 21:09:32', '1973-03-04 19:23:53');
INSERT INTO `comments` (`id`, `media_id`, `user_id`, `body`, `created_at`, `update_at`) VALUES ('8', '8', '14', 'Quia ut laboriosam animi ullam est dolor. Quia cum ullam ipsum praesentium velit. Ut ullam eveniet doloremque et repellat aliquam.', '2020-10-30 03:14:03', '2017-08-28 01:02:57');
INSERT INTO `comments` (`id`, `media_id`, `user_id`, `body`, `created_at`, `update_at`) VALUES ('9', '9', '5', 'Illo culpa id ut nesciunt velit minus officiis. Consequatur nihil vero quidem sequi rerum vero similique eveniet. Quis iure atque facilis ea.', '2005-03-12 23:30:12', '2012-07-13 23:40:49');
INSERT INTO `comments` (`id`, `media_id`, `user_id`, `body`, `created_at`, `update_at`) VALUES ('10', '10', '25', 'Hic voluptatem ut exercitationem error reiciendis nemo voluptatem. Dolores omnis suscipit aliquam nam nesciunt laudantium qui et. Voluptatem ex pariatur earum harum adipisci rerum ducimus. Soluta mollitia ipsam doloribus a.', '2008-03-08 16:37:52', '1992-01-09 13:14:18');

INSERT INTO `comments_to_comments` (`id`, `comments_id`, `user_id`, `body`, `created_at`, `update_at`) VALUES ('1', '1', '11', 'Magni nobis earum similique ut. Veniam enim reprehenderit autem doloremque et ratione ex. Doloribus quia similique est ullam dolor minima aliquam natus.', '2014-05-04 08:35:21', '1996-09-02 17:26:57');
INSERT INTO `comments_to_comments` (`id`, `comments_id`, `user_id`, `body`, `created_at`, `update_at`) VALUES ('2', '2', '2', 'Quas id tempore ad. Labore quidem facere ea et enim suscipit. Nihil est voluptas distinctio et. Quaerat cum recusandae iure et cupiditate eum deserunt.', '1978-10-05 06:33:55', '1999-11-21 13:23:35');
INSERT INTO `comments_to_comments` (`id`, `comments_id`, `user_id`, `body`, `created_at`, `update_at`) VALUES ('3', '3', '31', 'Quas cum similique aspernatur. Deserunt dolorem repudiandae commodi incidunt numquam ut. Nobis et aut repellendus in qui enim. Tenetur id eaque et laboriosam aperiam omnis et.', '1978-01-24 20:59:02', '1974-06-19 21:41:24');
INSERT INTO `comments_to_comments` (`id`, `comments_id`, `user_id`, `body`, `created_at`, `update_at`) VALUES ('4', '4', '14', 'Eos aut repudiandae autem tenetur dolores. Et officia rerum sed commodi distinctio dolor vero. Facilis itaque illo aut officia aut.', '2006-05-25 17:43:41', '1994-06-28 10:22:30');
INSERT INTO `comments_to_comments` (`id`, `comments_id`, `user_id`, `body`, `created_at`, `update_at`) VALUES ('5', '5', '5', 'Accusantium necessitatibus eius rerum maxime. Officiis ducimus a id doloribus ipsa maiores. Non aut repellendus non aut ad.', '1974-10-27 14:49:35', '2020-06-06 01:33:56');
INSERT INTO `comments_to_comments` (`id`, `comments_id`, `user_id`, `body`, `created_at`, `update_at`) VALUES ('6', '6', '11', 'Architecto totam maiores quo doloribus pariatur voluptatem. Qui eos ipsam distinctio incidunt a. Consequuntur laboriosam ullam accusamus explicabo natus.', '1994-08-20 09:19:24', '2012-07-10 00:08:22');
INSERT INTO `comments_to_comments` (`id`, `comments_id`, `user_id`, `body`, `created_at`, `update_at`) VALUES ('7', '7', '8', 'Nostrum quia dicta ipsa voluptatum est. Veritatis voluptatem omnis quasi repellat. Harum voluptatem tenetur debitis maxime.', '1989-08-30 01:41:00', '1970-01-19 19:18:23');
INSERT INTO `comments_to_comments` (`id`, `comments_id`, `user_id`, `body`, `created_at`, `update_at`) VALUES ('8', '8', '49', 'Eos quasi nesciunt nulla ut harum ut. A natus asperiores consequatur. Molestiae aut id repellendus tempore cum omnis nihil ea. Ratione deleniti laborum nihil expedita iste consequatur necessitatibus.', '1979-01-28 00:13:40', '2010-11-08 09:06:20');
INSERT INTO `comments_to_comments` (`id`, `comments_id`, `user_id`, `body`, `created_at`, `update_at`) VALUES ('9', '9', '23', 'Tempore libero expedita voluptas quod tempora esse et. Incidunt aut harum voluptas vel. Voluptas ea quia sit explicabo qui. Ut sed rerum sint delectus aut dolore rerum. Quia et autem voluptatem facilis perspiciatis.', '2020-10-19 14:50:42', '2015-10-06 02:01:15');
INSERT INTO `comments_to_comments` (`id`, `comments_id`, `user_id`, `body`, `created_at`, `update_at`) VALUES ('10', '10', '30', 'Velit quam animi nihil nemo aut asperiores omnis est. Est id cupiditate omnis. Tempora reiciendis corporis et voluptas repudiandae sint corporis.', '1991-09-16 03:53:04', '1978-09-25 05:59:38');