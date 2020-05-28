DROP DATABASE IF EXISTS twitter; 
CREATE DATABASE twitter;

USE twitter;

CREATE TABLE IF NOT EXISTS user (
	user_id INT PRIMARY KEY AUTO_INCREMENT,
    password VARCHAR(50) NOT NULL,
    username VARCHAR(50) NOT NULL UNIQUE,
    organization TINYINT NOT NULL COMMENT "whether is a organization",
    handle VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(50) NOT NULL,
    profile VARCHAR(255) DEFAULT NULL,
    hidden TINYINT NOT NULL DEFAULT 0 COMMENT "whether hidden the profile; 0 means not hidden"
);

CREATE TABLE IF NOT EXISTS tweet (
	tweet_id INT PRIMARY KEY AUTO_INCREMENT,
    time_stamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_id INT NOT NULL,
    text VARCHAR(160) NOT NULL,
    CONSTRAINT fk_tweet_user
		FOREIGN KEY (user_id) REFERENCES user (user_id)
);

CREATE TABLE IF NOT EXISTS hashtag (
	hashtag_id INT PRIMARY KEY AUTO_INCREMENT,
    hashtag_content VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS tweet_hashtag (
	tweet_id INT NOT NULL,
	hashtag_id INT NOT NULL,
    CONSTRAINT fk_tweet_hashtag_tweet_id
		FOREIGN KEY (tweet_id) REFERENCES tweet (tweet_id),
	CONSTRAINT fk_tweet_hashtag_hashtag_id
		FOREIGN KEY (hashtag_id) REFERENCES hashtag (hashtag_id)
);

CREATE TABLE IF NOT EXISTS follow (
	follower_id INT NOT NULL,
	followee_id INT NOT NULL,
    CONSTRAINT fk_follow_follower_id
		FOREIGN KEY (follower_id) REFERENCES user (user_id),
	CONSTRAINT fk_follow_followee_id
		FOREIGN KEY (followee_id) REFERENCES user (user_id)
);

CREATE TABLE IF NOT EXISTS like_tb (
	user_id INT NOT NULL,
	tweet_id INT NOT NULL,
    CONSTRAINT fk_like_tb_user_id
		FOREIGN KEY (user_id) REFERENCES user (user_id),
	CONSTRAINT fk_like_tb_tweet_id
		FOREIGN KEY (tweet_id) REFERENCES tweet (tweet_id)
);

-- Inserting data

INSERT INTO user (password, username, organization, handle, email)
VALUES ('gqy6q$;A@<', 'alice', 0, 'alice', 'alice@gmail.com'),
('9(\,&vPw`]', 'bob', 0, 'bob', 'bob@outlook.com'),
('r2?L:55,U<', 'cathy', 0, 'cathy', 'catherine@icloud.com'),
('Q6vsh5~pL', 'northeastern_university', 1, 'NEU', 'admin@northeastern.edu'),
('J?#)2rG~,W', 'boston_university', 1, 'BU', 'admin@gmail.bu.edu');

INSERT INTO user (password, username, organization, handle, email, hidden)
VALUES 
('vMW-]>7E%)', 'dan', 0, 'dan', 'dannnn@yahoo.com', 1);

INSERT INTO tweet (user_id, text) 
VALUES
(1, 'hello world from Alice!'),
(2, 'This is bob from NEU'),
(3, 'Welcome to my tweet!'),
(4, 'Northeastern is a global, experiential, research university built on a tradition of engagement with the world.'),
(5, 'Boston University is a leading private research institution with two primary campuses in the heart of Boston and programs around the world.'),
(1, 'I like Northeastern'),
(2, 'I like CS3200 at NEU'),
(3, 'I am enrolled in CS4100 Artificial Intelligence this summer');

INSERT INTO tweet (user_id, text, time_stamp)
VAlUES
(4, 'Campus locked due to COVID-19', timestamp('2020-3-15 12:30:00')),
(1, 'NO class TODAY at neu!', timestamp('2020-3-15 15:30:00')),
(1, 'Leaving dorm.', timestamp('2020-3-20 12:00:00')),
(1, 'traveling home, class move online.', timestamp('2020-3-21 13:52:03')),
(1, 'WIFI stopped, miss neu!', timestamp('2020-5-15 07:32:00')),
(1, 'no job, sad.', timestamp('2020-5-21 21:51:00'));

INSERT INTO hashtag (hashtag_content)
VALUES ('helloWorld'), ('NEU'), ('BU'), ('CS3200'), ('summer');

INSERT INTO tweet_hashtag
VALUES (1,1),(2,2),(4,2),(5,3),(6,2),(7,2),(7,4),
(7,5),(8,5),(9,2),(10,2),(11,2),(12,2),(13,2);

INSERT INTO follow
VALUES (1, 4), (2, 4), (3, 4), (4, 5), (5, 4), (1, 2), (6, 5);

INSERT INTO like_tb
VALUES (1, 4), (2, 4), (3, 4), (4, 5), (2, 6), 
(3, 6), (4, 6), (1, 7), (2, 7), (1, 8), (1, 9), 
(2, 9), (3, 9), (4, 9), (5, 9);


-- Database Validation

-- Which user has the most followers?
SELECT followee_id, count(*)
FROM follow
GROUP BY followee_id
ORDER BY count(*) DESC
LIMIT 1;

-- For one user, list the five most recent tweets by that user, from newest to oldest. 
-- Include only tweets containing the hashtag “#NEU”

-- Here I choose user with user_id = 1
SELECT * 
FROM tweet
WHERE tweet_id in (SELECT tweet_id
				   FROM tweet_hashtag
				   WHERE hashtag_id = (SELECT hashtag_id
						  			   FROM hashtag
									   WHERE hashtag_content = 'NEU')
				   AND tweet_id in (SELECT tweet_id 
									FROM tweet
									WHERE user_id = 1))
ORDER BY time_stamp DESC;

-- What are the most popular hashtags? Sort from most popular to least popular. 
-- Output the hashtag_id and the number of times that hashtag was used in a tweet.
-- Rank your output by number of occurrences in descending order 
SELECT hashtag_id, count(*)
FROM tweet_hashtag
GROUP BY hashtag_id
ORDER BY count(*) DESC;

-- How many tweets have exactly 1 hashtag?
CREATE VIEW tweet_id_one_hashtag AS 
(SELECT tweet_id, count(*)
 FROM tweet_hashtag
 GROUP BY tweet_id
 HAVING count(*) = 1);
SELECT count(*)
FROM tweet_id_one_hashtag;
DROP VIEW tweet_id_one_hashtag;

-- What is the most liked tweet? Output the tweet attributes.
CREATE VIEW max_liked_tweet AS
(SELECT tweet_id, count(*)
 FROM like_tb
 GROUP BY tweet_id
 ORDER BY count(*) DESC
 LIMIT 1);
SELECT * 
FROM tweet
WHERE tweet_id = (SELECT tweet_id
				  FROM max_liked_tweet);
DROP VIEW max_liked_tweet;
