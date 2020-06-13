drop database if exists vndb;
create database if not exists vndb;
use vndb;
ALTER DATABASE vndb CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS vn (
	vn_id INT PRIMARY KEY,
    title varchar(255),
    original_title varchar(255),
);