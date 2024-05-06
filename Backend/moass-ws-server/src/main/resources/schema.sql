DROP TABLE IF EXISTS `Screenshot`;
DROP TABLE IF EXISTS `BoardUser`;
DROP TABLE IF EXISTS `Board`;

DROP TABLE IF EXISTS `UserReservationInfo`;
DROP TABLE IF EXISTS `ReservationInfo`;
DROP TABLE IF EXISTS `Reservation`;
DROP TABLE IF EXISTS `Position`;
DROP TABLE IF EXISTS `Device`;
DROP TABLE IF EXISTS `Seat`;
DROP TABLE IF EXISTS `User`;
DROP TABLE IF EXISTS `SsafyUser`;

DROP TABLE IF EXISTS `Team`;
DROP TABLE IF EXISTS `Class`;
DROP TABLE IF EXISTS `Location`;

CREATE TABLE `Location` (
                            `location_code`	VARCHAR(5)	NOT NULL,
                            `location_name`	VARCHAR(40)	NOT NULL,
                            PRIMARY KEY (`location_code`)
);

CREATE TABLE `Class` (
                         `class_code`	VARCHAR(5)	NOT NULL,
                         `location_code`	VARCHAR(5)	NOT NULL,
                         PRIMARY KEY (`class_code`),
                         FOREIGN KEY (`location_code`) REFERENCES `Location` (`location_code`)
);

CREATE TABLE `Team` (
                        `team_code` VARCHAR(5)	NOT NULL,
                        `team_name` VARCHAR(20) NULL,
                        `class_code` VARCHAR(5)	NOT NULL,
                        PRIMARY KEY (`team_code`),
                        FOREIGN KEY (`class_code`) REFERENCES `Class` (`class_code`)
);

CREATE TABLE `SsafyUser`(
                            `user_id`   VARCHAR(20) NOT NULL,
                            `job_code`  INT NOT NULL,
                            `team_code` VARCHAR(5)  NOT NULL,
                            `user_name` VARCHAR(10) NOT NULL,
                            `card_serial_id` VARCHAR(30)  NULL,
                            PRIMARY KEY (`user_id`),
                            FOREIGN KEY (`team_code`) REFERENCES `Team` (`team_code`)
);

CREATE TABLE `User`(
                       `user_id` VARCHAR(20) NOT NULL,
                       `status_id` INT NOT NULL DEFAULT 0,
                       `user_email` VARCHAR(40) NOT NULL COMMENT '로그인',
                       `password` VARCHAR (255)NOT NULL,
                       `profile_img` VARCHAR(255) NULL,
                       `background_img` VARCHAR(255) NULL,
                       `layout` INT NOT NULL DEFAULT 1,
                       `connect_flag` INT NULL DEFAULT 0,
                       `position_name` VARCHAR(20) NULL,
                       PRIMARY KEY (`user_id`),
                       CONSTRAINT `FK_SSAFYUser_TO_User_1` FOREIGN KEY (`user_id`) REFERENCES `SsafyUser` (`user_id`)
);

CREATE TABLE `Seat` (
                        `seat_id` INT NOT NULL AUTO_INCREMENT,
                        `user_id` VARCHAR(20) NULL,
                        `x_coord` VARCHAR(40) NULL,
                        `y_coord` VARCHAR(20) NULL,
                        PRIMARY KEY (`seat_id`),
                        FOREIGN KEY (`user_id`) REFERENCES `User` (`user_id`)
);

CREATE TABLE `Device` (
                          `device_id` VARCHAR(40) NOT NULL,
                          `user_id` VARCHAR(20) NULL,
                          PRIMARY KEY (`device_id`),
                          FOREIGN KEY (`user_id`) REFERENCES `User` (`user_id`)
);


CREATE TABLE `Position`
(
    `position_name` VARCHAR(20) NOT NULL,
    `color_code`    VARCHAR(8)  NOT NULL DEFAULT '#6ECEF5',
    PRIMARY KEY (`position_name`)
);


CREATE TABLE `Reservation` (
                               `reservation_id`	INT	NOT NULL  AUTO_INCREMENT,
                               `class_code`	VARCHAR(5)	NOT NULL,
                               `category`	VARCHAR(40)	NOT NULL,
                               `time_limit`	INT	NOT NULL	DEFAULT 2,
                               `reservation_name`	VARCHAR(40)	NOT NULL,
                               `color_code`	VARCHAR(8)	NOT NULL	DEFAULT '#6ECEF5',
                               PRIMARY KEY (`reservation_id`),
                               FOREIGN KEY (`class_code`) REFERENCES `Class` (`class_code`)
);


CREATE TABLE `ReservationInfo` (
                                   `info_id` INT NOT NULL AUTO_INCREMENT,
                                   `reservation_id` INT NOT NULL,
                                   `user_id` VARCHAR(20) NOT NULL,
                                   `info_state` INT NOT NULL,
                                   `info_name` VARCHAR(8) NOT NULL,
                                   `info_date` DATE NOT NULL,
                                   `info_time` INT NOT NULL,
                                   `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                   `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                   PRIMARY KEY (`info_id`),
                                   FOREIGN KEY (`reservation_id`) REFERENCES `Reservation`(`reservation_id`),
                                   FOREIGN KEY (`user_id`) REFERENCES `User`(`user_id`)
);

CREATE TABLE `UserReservationInfo` (
                                       `info_id` INT NOT NULL,
                                       `user_id` VARCHAR(20) NOT NULL,
                                       PRIMARY KEY (`info_id`, `user_id`),
                                       FOREIGN KEY (`info_id`) REFERENCES `ReservationInfo` (`info_id`),
                                       FOREIGN KEY (`user_id`) REFERENCES `User` (`user_id`)
);

CREATE TABLE `Board`
(
    `board_id` INT NOT NULL AUTO_INCREMENT,
    `board_name` VARCHAR(255),
    `board_url` VARCHAR(255),
    `is_active` BOOLEAN,
    `completed_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`board_id`)
);

CREATE TABLE `BoardUser`
(
    `board_user_id` INT NOT NULL AUTO_INCREMENT,
    `board_id` INT NOT NULL,
    `user_id` VARCHAR(20) NOT NULL,
    PRIMARY KEY (`board_user_id`),
    FOREIGN KEY (`user_id`) REFERENCES `User` (`user_id`),
    FOREIGN KEY (`board_id`) REFERENCES `Board` (`board_id`)
);

CREATE TABLE  `Screenshot`
(
    `screenshot_id` INT NOT NULL AUTO_INCREMENT,
    `screenshot_url` VARCHAR(255),
    `board_user_id` INT NOT NULL,
    PRIMARY KEY (`screenshot_id`),
    FOREIGN KEY (`board_user_id`) REFERENCES `BoardUser` (`board_user_id`)
);