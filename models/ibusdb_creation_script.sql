SET GLOBAL local_infile = true;

-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema ibusdb
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `ibusdb` ;

-- -----------------------------------------------------
-- Schema ibusdb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `ibusdb` DEFAULT CHARACTER SET utf8 ;
USE `ibusdb` ;

-- -----------------------------------------------------
-- Table `ibusdb`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ibusdb`.`user` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `uuid` CHAR(36) NOT NULL,
  `email` VARCHAR(64) NOT NULL,
  `first_name` VARCHAR(32) NOT NULL,
  `last_name` VARCHAR(32) NOT NULL,
  `usercol` VARCHAR(45) NULL,
  UNIQUE INDEX `UserId_UNIQUE` (`id` ASC) VISIBLE,
  UNIQUE INDEX `UserGuid_UNIQUE` (`uuid` ASC) VISIBLE,
  UNIQUE INDEX `usercol_UNIQUE` (`usercol` ASC) VISIBLE,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ibusdb`.`web_membership`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ibusdb`.`web_membership` (
  `created_date` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `token` CHAR(36) NULL,
  `token_inscription` TIMESTAMP NULL,
  `token_expiration` TIMESTAMP NULL,
  `is_confirmed` BIT NULL,
  `password` VARCHAR(128) NOT NULL,
  `password_changed_date` TIMESTAMP NULL,
  `password_salt` VARCHAR(128) NOT NULL,
  `user_id` INT NOT NULL,
  PRIMARY KEY (`user_id`),
  CONSTRAINT `fk_web_membership_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `ibusdb`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ibusdb`.`roles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ibusdb`.`roles` (
  `id` INT NOT NULL,
  `role_name` VARCHAR(256) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ibusdb`.`project`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ibusdb`.`project` (
  `name` VARCHAR(45) NOT NULL,
  `path` TEXT NULL,
  `user_id` INT NOT NULL,
  `description` VARCHAR(255) NULL,
  `Active` BIT NULL DEFAULT 1,
  PRIMARY KEY (`name`, `user_id`),
  INDEX `fk_project_user1_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `fk_project_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `ibusdb`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ibusdb`.`log_type`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ibusdb`.`log_type` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ibusdb`.`log`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ibusdb`.`log` (
  `time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `message` TEXT NULL,
  `user_id` INT NOT NULL,
  `log_type_id` INT NOT NULL,
  PRIMARY KEY (`time`, `user_id`, `log_type_id`),
  INDEX `fk_log_userprofile1_idx` (`user_id` ASC) VISIBLE,
  INDEX `fk_log_log_type1_idx` (`log_type_id` ASC) VISIBLE,
  CONSTRAINT `fk_log_userprofile1`
    FOREIGN KEY (`user_id`)
    REFERENCES `ibusdb`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_log_log_type1`
    FOREIGN KEY (`log_type_id`)
    REFERENCES `ibusdb`.`log_type` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ibusdb`.`user_has_roles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ibusdb`.`user_has_roles` (
  `user_id` INT NOT NULL,
  `roles_id` INT NOT NULL,
  PRIMARY KEY (`user_id`, `roles_id`),
  INDEX `fk_user_has_roles_roles1_idx` (`roles_id` ASC) VISIBLE,
  INDEX `fk_user_has_roles_user1_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `fk_user_has_roles_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `ibusdb`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_has_roles_roles1`
    FOREIGN KEY (`roles_id`)
    REFERENCES `ibusdb`.`roles` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ibusdb`.`printrequests`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ibusdb`.`printrequests` (
  `name` VARCHAR(255) NOT NULL,
  `uuid` CHAR(36) NOT NULL,
  `filepath` VARCHAR(255) NOT NULL,
  `description` VARCHAR(255) NULL,
  `status` VARCHAR(45) NULL DEFAULT 'request_sent',
  `created_at` TIMESTAMP NULL DEFAULT NOW(),
  `updated_at` TIMESTAMP NULL DEFAULT NOW(),
  `project_user_id` INT NOT NULL,
  `project_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`name`, `project_user_id`, `project_name`),
  UNIQUE INDEX `uuid_UNIQUE` (`uuid` ASC) VISIBLE,
  INDEX `fk_printrequests_project1_idx` (`project_user_id` ASC, `project_name` ASC) VISIBLE,
  CONSTRAINT `fk_printrequests_project1`
    FOREIGN KEY (`project_user_id` , `project_name`)
    REFERENCES `ibusdb`.`project` (`user_id` , `name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ibusdb`.`printrequests_history`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ibusdb`.`printrequests_history` (
  `logged_at` TIMESTAMP NOT NULL DEFAULT NOW(),
  `project_user_id` INT NOT NULL,
  `project_name` VARCHAR(45) NULL,
  `name` VARCHAR(255) NOT NULL,
  `uuid` CHAR(36) NOT NULL,
  `filepath` VARCHAR(255) NOT NULL,
  `description` VARCHAR(255) NULL,
  `status` VARCHAR(45) NULL,
  `created_at` TIMESTAMP NULL,
  `updated_at` TIMESTAMP NULL,
  UNIQUE INDEX `uuid_UNIQUE` (`uuid` ASC) VISIBLE,
  PRIMARY KEY (`logged_at`))
ENGINE = InnoDB;

USE `ibusdb`;

DELIMITER $$
USE `ibusdb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `ibusdb`.`user_BEFORE_INSERT` BEFORE INSERT ON `user` FOR EACH ROW
BEGIN
	IF new.uuid IS NULL OR new.uuid = '' THEN
		SET new.uuid = uuid();
	END IF;
END$$

USE `ibusdb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `ibusdb`.`project_BEFORE_INSERT` BEFORE INSERT ON `project` FOR EACH ROW
BEGIN
	IF new.path IS NULL OR new.path = '' THEN
		SET new.path = CONCAT(CAST(new.user_id AS CHAR), '/', new.name);
	END IF;
END$$

USE `ibusdb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `ibusdb`.`printrequests_BEFORE_INSERT` BEFORE INSERT ON `printrequests` FOR EACH ROW
BEGIN
	IF new.uuid IS NULL OR new.uuid = '' THEN
		SET new.uuid = uuid();
	END IF;
    IF new.filepath IS NULL OR new.filepath = '' THEN
		SET new.filepath = CONCAT('/',new.name);
	END IF;
END$$

USE `ibusdb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `ibusdb`.`printrequests_BEFORE_UPDATE` BEFORE UPDATE ON `printrequests` FOR EACH ROW
BEGIN
	INSERT INTO IBUSdb.printRequests_history(name, project_user_id, project_name, uuid, filepath, description, status, created_at, updated_at) VALUES (old.name, old.project_user_id, old.project_name, old.uuid, old.filepath, old.description, old.status, old.created_at, old.updated_at);
	## check is "name" was updated and update "path" accordingly
    IF !(new.name <=> old.name) AND (new.filepath <=> old.filepath) THEN
		SET new.filepath = new.name;
    END IF;
    SET new.updated_at = now();
END$$


DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;