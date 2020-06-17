-- -----------------------------------------------------
-- Schema vn_collection
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS vn_collection;
CREATE SCHEMA IF NOT EXISTS vn_collection DEFAULT CHARACTER SET utf8mb4;
ALTER SCHEMA vn_collection  DEFAULT CHARACTER SET utf8mb4;
USE vn_collection;

-- -----------------------------------------------------
-- Table vn
-- -----------------------------------------------------
DROP TABLE IF EXISTS vn;

CREATE TABLE IF NOT EXISTS vn (
    vn_id INT PRIMARY KEY ,
    en_title VARCHAR(500) NOT NULL DEFAULT '',
    original_title VARCHAR(500) NULL DEFAULT '',
    alias VARCHAR(500) NULL DEFAULT '',
    intro TEXT NULL,
    INDEX idx_vn_vn_id (vn_id))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table vn_char
-- -----------------------------------------------------
DROP TABLE IF EXISTS vn_char;

CREATE TABLE IF NOT EXISTS vn_char (
    char_id INT PRIMARY KEY,
    en_name VARCHAR(500) NOT NULL DEFAULT '',
    original_name VARCHAR(500) NULL DEFAULT '',
    alias VARCHAR(500) NULL DEFAULT '',
    intro TEXT NULL,
    gender VARCHAR(50) NULL DEFAULT 'unknown',
    b_month INT NULL DEFAULT 0,
    b_day INT NULL DEFAULT 0,
    height INT NULL,
    weight INT NULL,
    blood_type VARCHAR(7) NULL DEFAULT 'unknown',
    age INT NULL,
    INDEX idx_vn_char_char_id (char_id))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table staff
-- -----------------------------------------------------
DROP TABLE IF EXISTS staff;

CREATE TABLE IF NOT EXISTS staff (
    staff_id INT PRIMARY KEY,
    gender VARCHAR(7) NULL DEFAULT 'unknown',
    intro TEXT NULL,
    website VARCHAR(250) NULL,
    twitter VARCHAR(250) NULL,
    INDEX idx_staff_staff_id (staff_id))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table staff_stage_name
-- -----------------------------------------------------
DROP TABLE IF EXISTS staff_stage_name;

CREATE TABLE IF NOT EXISTS staff_stage_name (
    staff_stage_name_id INT PRIMARY KEY,
    en_stage_name VARCHAR(250) NULL,
    original_stage_name VARCHAR(250) NULL,
    staff_id INT NOT NULL,
    CONSTRAINT staff_stage_name_fk_staff_id FOREIGN KEY (staff_id) REFERENCES staff (staff_id))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table lang
-- -----------------------------------------------------
DROP TABLE IF EXISTS lang;

CREATE TABLE IF NOT EXISTS lang (
    language_code VARCHAR(10) PRIMARY KEY ,
    language_name VARCHAR(250) NOT NULL)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table vn_release
-- -----------------------------------------------------
DROP TABLE IF EXISTS vn_release ;

CREATE TABLE IF NOT EXISTS vn_release (
    release_id INT PRIMARY KEY ,
    en_title VARCHAR(500) NOT NULL,
    original_title VARCHAR(500) NULL,
    website VARCHAR(500) NULL,
    note TEXT NULL,
    platform VARCHAR(10) NULL,
    vn_id INT NULL,
    CONSTRAINT vn_release_fk_vn FOREIGN KEY (vn_id) REFERENCES vn(vn_id),
    INDEX idx_vn_release_release_id (release_id),
    INDEX idx_vn_release_vn_id (vn_id))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table producer
-- -----------------------------------------------------
DROP TABLE IF EXISTS producer ;

CREATE TABLE IF NOT EXISTS producer (
    producer_id INT PRIMARY KEY,
    type VARCHAR(50) NOT NULL DEFAULT 'co',
    en_name VARCHAR(500) NOT NULL DEFAULT '',
    original_name VARCHAR(500) NULL DEFAULT '',
    alias VARCHAR(500) NULL,
    website VARCHAR(250) NULL,
    intro TEXT NULL,
    language_code VARCHAR(10) NULL,
    INDEX idx_producer_producer_id (producer_id),
    CONSTRAINT producer_fk_language_code FOREIGN KEY (language_code) REFERENCES lang (language_code))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table vn_producer_relation
-- -----------------------------------------------------
DROP TABLE IF EXISTS vn_producer_relation ;

CREATE TABLE IF NOT EXISTS vn_producer_relation (
    vn_id INT NOT NULL,
    producer_id INT NOT NULL,
    CONSTRAINT vn_producer_relation_fk_vn FOREIGN KEY (vn_id) REFERENCES vn (vn_id),
    CONSTRAINT vn_producer_relation_fk_producer_id FOREIGN KEY (producer_id) REFERENCES producer (producer_id))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table position
-- -----------------------------------------------------
DROP TABLE IF EXISTS staff_position;

CREATE TABLE IF NOT EXISTS staff_position (
  position_id INT PRIMARY KEY ,
  title VARCHAR(250) NULL,
  intro TEXT NULL)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table vn_staff_relation
-- -----------------------------------------------------
DROP TABLE IF EXISTS vn_staff_relation ;

CREATE TABLE IF NOT EXISTS vn_staff_relation (
    vn_id INT NOT NULL,
    staff_id INT NOT NULL,
    position_id INT NULL,
    note TEXT NULL,
    INDEX idx_vn_staff_relation_staff_id (staff_id),
    INDEX idx_vn_staff_relation_vn_id (vn_id),
    INDEX idx_vn_staff_relation_position_id (position_id),
    CONSTRAINT vn_staff_relation_fk_vn_id FOREIGN KEY (vn_id) REFERENCES vn (vn_id),
    CONSTRAINT vn_staff_relation_fk_staff_id FOREIGN KEY (staff_id)REFERENCES staff (staff_id),
    CONSTRAINT vn_staff_relation_fk_position_id FOREIGN KEY (position_id)REFERENCES staff_position (position_id))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table char_vn_relation
-- -----------------------------------------------------
DROP TABLE IF EXISTS char_vn_relation;

CREATE TABLE IF NOT EXISTS char_vn_relation(
    char_id INT NOT NULL,
    vn_id INT NOT NULL,
    role VARCHAR(50),
    INDEX idx_char_vn_relation_fk_char_id (char_id),
    INDEX idx_char_vn_relation_fk_vn_id (vn_id),
    CONSTRAINT char_vn_relation_fk_char_id FOREIGN KEY (char_id) REFERENCES vn_char (char_id),
    CONSTRAINT char_vn_relation_fk_vn_id FOREIGN KEY (vn_id) REFERENCES vn (vn_id))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table lang_vn_release_relation
-- -----------------------------------------------------
DROP TABLE IF EXISTS lang_vn_release_relation;

CREATE TABLE IF NOT EXISTS lang_vn_release_relation(
    language_code VARCHAR(10) NOT NULL,
    release_id INT NOT NULL,
    CONSTRAINT lang_vn_release_relation_fk_language_code FOREIGN KEY (language_code) REFERENCES lang (language_code),
    CONSTRAINT lang_vn_release_relation_fk_release_id FOREIGN KEY (release_id) REFERENCES vn_release (release_id))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table trait
-- -----------------------------------------------------
DROP TABLE IF EXISTS trait;

CREATE TABLE IF NOT EXISTS trait(
    trait_id INT PRIMARY KEY,
    trait_name VARCHAR(500) NOT NULL,
    trait_alias VARCHAR(500) NULL,
    trait_description TEXT NULL)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table tag
-- -----------------------------------------------------
DROP TABLE IF EXISTS tag;

CREATE TABLE IF NOT EXISTS tag(
    tag_id INT PRIMARY KEY,
    tag_name VARCHAR(500) NOT NULL,
    tag_description TEXT NULL)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table trait_char_relation
-- -----------------------------------------------------
DROP TABLE IF EXISTS trait_char_relation;

CREATE TABLE IF NOT EXISTS trait_char_relation(
    trait_id INT NOT NULL,
    char_id INT NOT NULL,
    CONSTRAINT trait_char_relation_fk_trait_id FOREIGN KEY (trait_id) REFERENCES trait (trait_id),
    CONSTRAINT trait_char_relation_fk_char_id FOREIGN KEY (char_id) REFERENCES vn_char (char_id))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table tag_vn_relation
-- -----------------------------------------------------
DROP TABLE IF EXISTS tag_vn_relation;

CREATE TABLE IF NOT EXISTS tag_vn_relation(
    tag_id INT NOT NULL,
    vn_id INT NOT NULL,
    vote INT NULL,
    CONSTRAINT tag_vn_relation_fk_tag_id FOREIGN KEY (tag_id) REFERENCES tag (tag_id),
    CONSTRAINT tag_vn_relation_fk_release_id FOREIGN KEY (vn_id) REFERENCES vn (vn_id))
ENGINE = InnoDB;


