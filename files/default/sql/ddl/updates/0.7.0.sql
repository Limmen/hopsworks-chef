DROP TABLE IF EXISTS  `hopsworks`.`file_activity`;

ALTER TABLE `hopsworks`.`dataset` MODIFY COLUMN `inode_pid` BIGINT(20);
ALTER TABLE `hopsworks`.`dataset` MODIFY COLUMN `partition_id` BIGINT(20);
ALTER TABLE `hopsworks`.`dataset` MODIFY COLUMN `inode_id` BIGINT(20);

ALTER TABLE `hopsworks`.`meta_data_schemaless` MODIFY COLUMN `inode_parent_id` BIGINT(20);
ALTER TABLE `hopsworks`.`meta_data_schemaless` MODIFY COLUMN `inode_partition_id` BIGINT(20);

ALTER TABLE `hopsworks`.`meta_inode_basic_metadata` MODIFY COLUMN `inode_pid` BIGINT(20);
ALTER TABLE `hopsworks`.`meta_inode_basic_metadata` MODIFY COLUMN `partition_id` BIGINT(20);

ALTER TABLE `hopsworks`.`meta_template_to_inode` MODIFY COLUMN `inode_pid` BIGINT(20);
ALTER TABLE `hopsworks`.`meta_template_to_inode` MODIFY COLUMN `partition_id` BIGINT(20);

ALTER TABLE `hopsworks`.`meta_tuple_to_file` MODIFY COLUMN `inodeid` BIGINT(20);
ALTER TABLE `hopsworks`.`meta_tuple_to_file` MODIFY COLUMN `inode_pid` BIGINT(20);
ALTER TABLE `hopsworks`.`meta_tuple_to_file` MODIFY COLUMN `partition_id` BIGINT(20);

ALTER TABLE `hopsworks`.`project` MODIFY COLUMN `inode_pid` BIGINT(20);
ALTER TABLE `hopsworks`.`project` MODIFY COLUMN `partition_id` BIGINT(20);

ALTER TABLE `hopsworks`.`ops_log` MODIFY COLUMN `dataset_id` BIGINT(20);
ALTER TABLE `hopsworks`.`ops_log` MODIFY COLUMN `inode_id` BIGINT(20);

ALTER TABLE `hopsworks`.`meta_log` MODIFY COLUMN `meta_pk2` BIGINT(20);
ALTER TABLE `hopsworks`.`meta_log` MODIFY COLUMN `meta_pk3` BIGINT(20);

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
  `id`                      INT(11)    NOT NULL AUTO_INCREMENT,
  `feature_store_id`        INT(11)    NOT NULL,
  `hdfs_user_id`            INT(11)    NOT NULL,
  `created`                 TIMESTAMP           DEFAULT CURRENT_TIMESTAMP,
  `creator`                 INT(11)    NOT NULL,
  `job_id`                  INT(11)    NULL,
  `hive_tbl_id`             BIGINT(20) NOT NULL,
  `input_dataset`           VARCHAR(10000)      DEFAULT NULL,
  `feature_corr_matrix_img` TEXT                DEFAULT NULL,
  `features_histogram_img`  TEXT                DEFAULT NULL,
  `descriptive_stats`       TEXT                DEFAULT NULL,
  `cluster_analysis`        MEDIUMTEXT          DEFAULT NULL,
  `version`                 INT(11)    NOT NULL,
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

CREATE TABLE IF NOT EXISTS `feature_statistic` (
  `id`               INT(11) NOT NULL AUTO_INCREMENT,
  `feature_group_id` INT(11) NOT NULL,
  `name`             VARCHAR(10000)   DEFAULT NULL,
  `statistic_type`   INT(11) NOT NULL DEFAULT '0',
  `value`            TEXT             DEFAULT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`feature_group_id`) REFERENCES `feature_group` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION
)
  ENGINE = ndbcluster
  DEFAULT CHARSET = latin1
  COLLATE = latin1_general_cs;

CREATE TABLE IF NOT EXISTS `training_dataset` (
  `id`                      INT(11)      NOT NULL AUTO_INCREMENT,
  `feature_store_id`        INT(11)      NOT NULL,
  `hdfs_user_id`            INT(11)      NOT NULL,
  `created`                 TIMESTAMP             DEFAULT CURRENT_TIMESTAMP,
  `creator`                 INT(11)      NOT NULL,
  `job_id`                  INT(11)      NULL,
  `input_dataset`           VARCHAR(10000)        DEFAULT NULL,
  `version`                 INT(11)      NOT NULL,
  `dataset_schema`          TEXT                  DEFAULT NULL,
  `descriptive_stats`       TEXT                  DEFAULT NULL,
  `data_format`             VARCHAR(128) NOT NULL,
  `training_dataset_folder` INT(11)      NOT NULL,
  `feature_corr_matrix_img` TEXT                  DEFAULT NULL,
  `features_histogram_img`  TEXT                  DEFAULT NULL,
  `cluster_analysis`        MEDIUMTEXT                  DEFAULT NULL,
  `inode_pid` BIGINT(20) NOT NULL,
  `inode_name`              VARCHAR(255) NOT NULL,
  `partition_id`            BIGINT(20)      NOT NULL,
  `description`             VARCHAR(2000)         DEFAULT NULL,
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
  FOREIGN KEY (`creator`) REFERENCES `users` (`uid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  FOREIGN KEY (`training_dataset_folder`) REFERENCES `dataset` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  FOREIGN KEY (`inode_pid`, `inode_name`, `partition_id`) REFERENCES `hops`.`hdfs_inodes` (`parent_id`, `name`, `partition_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION
)
  ENGINE = ndbcluster
  DEFAULT CHARSET = latin1
  COLLATE = latin1_general_cs;

ALTER TABLE `hopsworks`.`dataset`
  ADD COLUMN `feature_store_id` INT(11) DEFAULT NULL;
ALTER TABLE `hopsworks`.`dataset`
  ADD FOREIGN KEY `featurestore_fk` (`feature_store_id`) REFERENCES `feature_store` (`id`)
  ON DELETE SET NULL
  ON UPDATE NO ACTION;