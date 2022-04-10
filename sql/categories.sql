CREATE TABLE `categories` (
  `id` CHAR(36) NOT NULL DEFAULT '',
  `parent_id` CHAR(32) DEFAULT NULL,
  `name` VARCHAR(255) NOT NULL DEFAULT '',
  `description` TEXT,
  `created_at` DATETIME NOT NULL,
  `updated_at` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `categories_parent_id` (`parent_id`),
  INDEX `categories_name` (`name`),
  INDEX `categories_created_at` (`created_at`),
  INDEX `categories_updated_at` (`updated_at`)
  CONSTRAINT `categories_parent_id_fk` FOREIGN KEY (`parent_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
