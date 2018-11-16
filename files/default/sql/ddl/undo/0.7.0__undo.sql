ALTER TABLE `hopsworks`.`dataset` DROP FOREIGN KEY `featurestore_fk`;
ALTER TABLE `hopsworks`.`dataset` DROP COLUMN `feature_store_id`;

DROP TABLE IF EXISTS `feature_group`;
DROP TABLE IF EXISTS `feature_store`;
DROP TABLE IF EXISTS `training_dataset`;
