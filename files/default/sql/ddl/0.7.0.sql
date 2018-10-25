--
--  Feature store tables in Hopsworks
--
CREATE TABLE IF NOT EXISTS `feature_store` (
  `id`         INT(11)    NOT NULL AUTO_INCREMENT,
  `project_id` INT(11)    NOT NULL,
  `created`    TIMESTAMP           DEFAULT CURRENT_TIMESTAMP,
  `hive_db_id` BIGINT(20) NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`project_id`) REFERENCES `project` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  FOREIGN KEY (`hive_db_id`) REFERENCES `metastore`.`DBS` (`DB_ID`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION
)
  ENGINE = ndbcluster
  DEFAULT CHARSET = latin1
  COLLATE = latin1_general_cs;

CREATE TABLE IF NOT EXISTS `feature_group` (
  `id`               INT(11)        NOT NULL AUTO_INCREMENT,
  `feature_store_id` INT(11)        NOT NULL,
  `hdfs_user_id`     INT(11)        NOT NULL,
  `created`          TIMESTAMP               DEFAULT CURRENT_TIMESTAMP,
  `creator`          INT(11)        NOT NULL,
  `job_id`           INT(11)        NULL,
  `hive_tbl_id`      BIGINT(20)     NOT NULL,
  `input_dataset`    VARCHAR(10000) NOT NULL,
  `version`          INT(11)        NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`feature_store_id`) REFERENCES `feature_store` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  FOREIGN KEY (`job_id`) REFERENCES `jobs` (`id`)
    ON DELETE SET NULL
    ON UPDATE NO ACTION,
  FOREIGN KEY (`hdfs_user_id`) REFERENCES `hops`.`hdfs_users` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  FOREIGN KEY (`hive_tbl_id`) REFERENCES `metastore`.`TBLS` (`TBL_ID`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  FOREIGN KEY (`creator`) REFERENCES `users` (`uid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
  ENGINE = ndbcluster
  DEFAULT CHARSET = latin1
  COLLATE = latin1_general_cs;