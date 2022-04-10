CREATE TABLE `products` (
  `id` CHAR(36) NOT NULL DEFAULT '',
  `manufacturer_id` CHAR(36) DEFAULT NULL,
  `name` VARCHAR(255) NOT NULL DEFAULT '',
  `description` TEXT DEFAULT '',
  `manufacturer_part_number` VARCHAR(255) NOT NULL DEFAULT '',
  `cost` DECIMAL(20,6) UNSIGNED NOT NULL DEFAULT 0.00,
  `price` DECIMAL(20,6) UNSIGNED NOT NULL DEFAULT 0.00,
  `created_at` DATETIME NOT NULL,
  `updated_at` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `products_manufacturer_id` (`manufacturer_id`,`manufacturer_part_number`),
  INDEX `products_price` (`price`),
  INDEX `products_name` (`name`),
  INDEX `products_created_at` (`created_at`),
  INDEX `products_updated_at` (`updated_at`)
  CONSTRAINT `products_manufacturer_id_fk` FOREIGN KEY (`manufacturer_id`) REFERENCES `manufacturers` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
