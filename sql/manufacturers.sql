CREATE TABLE `manufacturers` (
  `id` CHAR(36) NOT NULL DEFAULT '',
  `name` VARCHAR(255) NOT NULL DEFAULT '',
  `description` TEXT,
  `created_at` DATETIME NOT NULL,
  `updated_at` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `manufacturers_name` (`name`),
  INDEX `manufacturers_created_at` (`created_at`),
  INDEX `manufacturers_updated_at` (`updated_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
