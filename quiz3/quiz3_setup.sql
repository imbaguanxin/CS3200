-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema futbol
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `futbol` ;

-- -----------------------------------------------------
-- Schema futbol
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `futbol` DEFAULT CHARACTER SET utf8 ;
USE `futbol` ;

-- -----------------------------------------------------
-- Table `town`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `town` ;

CREATE TABLE IF NOT EXISTS `town` (
  `town_id` INT NOT NULL,
  `town_name` VARCHAR(45) NULL,
  PRIMARY KEY (`town_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `team`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `team` ;

CREATE TABLE IF NOT EXISTS `team` (
  `team_id` INT NOT NULL,
  `team_name` VARCHAR(45) NULL,
  `color` VARCHAR(45) NULL,
  `town_id` INT NOT NULL,
  PRIMARY KEY (`team_id`),
  INDEX `fk_team_town_idx` (`town_id` ASC),
  CONSTRAINT `fk_team_town`
    FOREIGN KEY (`town_id`)
    REFERENCES `town` (`town_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `matchup`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `matchup` ;

CREATE TABLE IF NOT EXISTS `matchup` (
  `home_id` INT NOT NULL,
  `visitor_id` INT NOT NULL,
  `home_goals` INT NULL,
  `visitor_goals` INT NULL,
  PRIMARY KEY (`home_id`, `visitor_id`),
  INDEX `fk_team_has_team_team2_idx` (`visitor_id` ASC),
  INDEX `fk_team_has_team_team1_idx` (`home_id` ASC),
  CONSTRAINT `fk_team_has_team_team1`
    FOREIGN KEY (`home_id`)
    REFERENCES `team` (`team_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_team_has_team_team2`
    FOREIGN KEY (`visitor_id`)
    REFERENCES `team` (`team_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `position`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `position` ;

CREATE TABLE IF NOT EXISTS `position` (
  `position_id` INT NOT NULL,
  `position_name` VARCHAR(45) NULL,
  PRIMARY KEY (`position_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `player`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `player` ;

CREATE TABLE IF NOT EXISTS `player` (
  `player_id` INT NOT NULL,
  `player_name` VARCHAR(45) NULL,
  `goals` INT NULL,
  `position_id` INT NULL,
  `team_id` INT NOT NULL,
  PRIMARY KEY (`player_id`, `team_id`),
  INDEX `fk_player_position1_idx` (`position_id` ASC),
  INDEX `fk_player_team1_idx` (`team_id` ASC),
  CONSTRAINT `fk_player_position1`
    FOREIGN KEY (`position_id`)
    REFERENCES `position` (`position_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_player_team1`
    FOREIGN KEY (`team_id`)
    REFERENCES `team` (`team_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `town`
-- -----------------------------------------------------
START TRANSACTION;
USE `futbol`;
INSERT INTO `town` (`town_id`, `town_name`) VALUES (1, 'Manchester');
INSERT INTO `town` (`town_id`, `town_name`) VALUES (2, 'Chelsea');
INSERT INTO `town` (`town_id`, `town_name`) VALUES (3, 'Liverpool');
INSERT INTO `town` (`town_id`, `town_name`) VALUES (4, 'West Ham');
INSERT INTO `town` (`town_id`, `town_name`) VALUES (5, 'Southampton');

COMMIT;


-- -----------------------------------------------------
-- Data for table `team`
-- -----------------------------------------------------
START TRANSACTION;
USE `futbol`;
INSERT INTO `team` (`team_id`, `team_name`, `color`, `town_id`) VALUES (1, 'Panthers', 'Yellow', 1);
INSERT INTO `team` (`team_id`, `team_name`, `color`, `town_id`) VALUES (2, 'Giants', 'Blue', 2);
INSERT INTO `team` (`team_id`, `team_name`, `color`, `town_id`) VALUES (3, 'RedSox', 'Red', 2);
INSERT INTO `team` (`team_id`, `team_name`, `color`, `town_id`) VALUES (4, 'Goobers', 'Purple', 3);

COMMIT;


-- -----------------------------------------------------
-- Data for table `matchup`
-- -----------------------------------------------------
START TRANSACTION;
USE `futbol`;
INSERT INTO `matchup` (`home_id`, `visitor_id`, `home_goals`, `visitor_goals`) VALUES (1, 2, 4, 1);
INSERT INTO `matchup` (`home_id`, `visitor_id`, `home_goals`, `visitor_goals`) VALUES (1, 3, 6, 5);
INSERT INTO `matchup` (`home_id`, `visitor_id`, `home_goals`, `visitor_goals`) VALUES (1, 4, 2, 3);
INSERT INTO `matchup` (`home_id`, `visitor_id`, `home_goals`, `visitor_goals`) VALUES (2, 1, 2, 2);
INSERT INTO `matchup` (`home_id`, `visitor_id`, `home_goals`, `visitor_goals`) VALUES (2, 3, 5, 5);
INSERT INTO `matchup` (`home_id`, `visitor_id`, `home_goals`, `visitor_goals`) VALUES (2, 4, 2, 1);
INSERT INTO `matchup` (`home_id`, `visitor_id`, `home_goals`, `visitor_goals`) VALUES (3, 1, 2, 2);
INSERT INTO `matchup` (`home_id`, `visitor_id`, `home_goals`, `visitor_goals`) VALUES (3, 2, 1, 8);
INSERT INTO `matchup` (`home_id`, `visitor_id`, `home_goals`, `visitor_goals`) VALUES (3, 4, 0, 0);
INSERT INTO `matchup` (`home_id`, `visitor_id`, `home_goals`, `visitor_goals`) VALUES (4, 1, 3, 5);
INSERT INTO `matchup` (`home_id`, `visitor_id`, `home_goals`, `visitor_goals`) VALUES (4, 2, 4, 0);
INSERT INTO `matchup` (`home_id`, `visitor_id`, `home_goals`, `visitor_goals`) VALUES (4, 3, 2, 1);

COMMIT;


-- -----------------------------------------------------
-- Data for table `position`
-- -----------------------------------------------------
START TRANSACTION;
USE `futbol`;
INSERT INTO `position` (`position_id`, `position_name`) VALUES (1, 'goalkeeper');
INSERT INTO `position` (`position_id`, `position_name`) VALUES (2, 'sweeper');
INSERT INTO `position` (`position_id`, `position_name`) VALUES (3, 'stopper');
INSERT INTO `position` (`position_id`, `position_name`) VALUES (4, 'left back');
INSERT INTO `position` (`position_id`, `position_name`) VALUES (5, 'right back');
INSERT INTO `position` (`position_id`, `position_name`) VALUES (6, 'left midfielder');
INSERT INTO `position` (`position_id`, `position_name`) VALUES (7, 'right midfielder');
INSERT INTO `position` (`position_id`, `position_name`) VALUES (8, 'defensive midfielder');
INSERT INTO `position` (`position_id`, `position_name`) VALUES (9, 'striker');
INSERT INTO `position` (`position_id`, `position_name`) VALUES (10, 'forward');

COMMIT;


-- -----------------------------------------------------
-- Data for table `player`
-- -----------------------------------------------------
START TRANSACTION;
USE `futbol`;
INSERT INTO `player` (`player_id`, `player_name`, `goals`, `position_id`, `team_id`) VALUES (1, 'Bobby', 0, 1, 1);
INSERT INTO `player` (`player_id`, `player_name`, `goals`, `position_id`, `team_id`) VALUES (2, 'Susie', 3, 8, 1);
INSERT INTO `player` (`player_id`, `player_name`, `goals`, `position_id`, `team_id`) VALUES (3, 'Mikey', 1, 6, 1);
INSERT INTO `player` (`player_id`, `player_name`, `goals`, `position_id`, `team_id`) VALUES (4, 'Annie', 7, 9, 1);
INSERT INTO `player` (`player_id`, `player_name`, `goals`, `position_id`, `team_id`) VALUES (5, 'Johnny', 10, 10, 1);
INSERT INTO `player` (`player_id`, `player_name`, `goals`, `position_id`, `team_id`) VALUES (6, 'Jonathan', 0, 1, 2);
INSERT INTO `player` (`player_id`, `player_name`, `goals`, `position_id`, `team_id`) VALUES (7, 'An', 2, 2, 2);
INSERT INTO `player` (`player_id`, `player_name`, `goals`, `position_id`, `team_id`) VALUES (8, 'Jess', 4, 3, 2);
INSERT INTO `player` (`player_id`, `player_name`, `goals`, `position_id`, `team_id`) VALUES (9, 'Liang', 7, 9, 2);
INSERT INTO `player` (`player_id`, `player_name`, `goals`, `position_id`, `team_id`) VALUES (10, 'Xin', 5, 10, 2);
INSERT INTO `player` (`player_id`, `player_name`, `goals`, `position_id`, `team_id`) VALUES (11, 'Yihun', 0, 1, 3);
INSERT INTO `player` (`player_id`, `player_name`, `goals`, `position_id`, `team_id`) VALUES (12, 'Prateek', 2, 2, 3);
INSERT INTO `player` (`player_id`, `player_name`, `goals`, `position_id`, `team_id`) VALUES (13, 'Sanket', 0, 7, 3);
INSERT INTO `player` (`player_id`, `player_name`, `goals`, `position_id`, `team_id`) VALUES (14, 'Soumya', 7, 9, 3);
INSERT INTO `player` (`player_id`, `player_name`, `goals`, `position_id`, `team_id`) VALUES (15, 'Arima', 5, 10, 3);
INSERT INTO `player` (`player_id`, `player_name`, `goals`, `position_id`, `team_id`) VALUES (16, 'Will', 0, 1, 4);
INSERT INTO `player` (`player_id`, `player_name`, `goals`, `position_id`, `team_id`) VALUES (17, 'Prasanna', 1, 2, 4);
INSERT INTO `player` (`player_id`, `player_name`, `goals`, `position_id`, `team_id`) VALUES (18, 'Austin', 1, 7, 4);
INSERT INTO `player` (`player_id`, `player_name`, `goals`, `position_id`, `team_id`) VALUES (19, 'Samhita', 9, 9, 4);
INSERT INTO `player` (`player_id`, `player_name`, `goals`, `position_id`, `team_id`) VALUES (20, 'Megha', 2, 10, 4);

COMMIT;



use futbol;



-- WRITE A QUERY FOR EACH QUESTION BELOW

-- Some free advice: If faced with a challenging query, take it step by step.
-- Work incrementally, starting with one table, joining to add additional data that you need
-- while filtering out columns you don't need.
-- With each step, try to get closer and closer to the target columns
-- Don't forget sorting criteria when requested. Read each question carefully.




-- 1. Who scored the most goals?
-- Output just the name of the player



-- 2. how many matchups ended in a draw?



-- 3. How many matchups were blowouts?
-- Let's say that a blowout is a game where the goal differential is GREATER THAN 3


-- 4. How many total goals were scored by players who do NOT wear a jersey that's a primary color
-- Primary colors are red, blue, and yellow


-- 5. How many goals were scored by players on teams from Chelsea?


-- 6. What team does Soumya play for?
-- Output the name of the team, and the town that the team is from



-- 7. For each matchup, list the home team name, visitor team name, and total goals scored by either team.
-- Order matchups by total goals scored



-- 8. Not counting goal keepers, what TWO positions scored the FEWEST goals?
-- Output the name of the position and the number of goals scored by that position
-- HINT: Start by figuring out how many total goals are scored by each position



-- 9. How many teams come from each town?
-- Include towns that have no teams
-- Output town name and number of teams sorted from most teams to fewest teams



-- 10. How many players play for each position
-- Include in your table positions that have no players.
-- Only list positions that end in the letter "r".
-- Sort your output by the number of players in that position descending followed by the position name.




-- 11. What players were above average in terms of goals scored?
-- Give the name of the player and their goals scored
-- Order by goals scored descending.
-- DO NOT INCLUDE GOAL KEEPERS IN COMPUTING THE OVERALL AVERAGE!
-- HINT: Start by figuring out what was the average # of goals scored by non-goalkeepeers.




-- 12. List every player name, their position, their team, and the town that the team represents
-- Order our output by town, then team, then player



-- 13. Who is the Striker for the team from Manchester?
-- Give the name and the number of goals she scored (That was a hint!)





-- 14. For each team, output the min, max, average, and total goals scored among that team's players
-- Include only teams in your output with an average greater than or equal to 3.0 goals / team.
-- In calculating the average, you may include goal keepers, but think about how the query
-- would be different if we had to exclude goal keepers.




-- 15. How many games did the Giants lose?
-- This one is a little tricky. Using a JOIN, find matchups where the giants are either the home team or the visiting team
-- If the giants are the home team we want home_goals < visitor_goals. Similarly, if the giants are the visiting team
-- we want matchups where the visiting team scores fewer goals.
-- Finally, count the rows that meet all these conditions!