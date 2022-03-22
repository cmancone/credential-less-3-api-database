CREATE TABLE `product_categories` (
  `id` CHAR(36) NOT NULL DEFAULT '',
  `product_id` CHAR(36) DEFAULT NULL,
  `category_id` CHAR(36) DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `product_categories_product_id` (`product_id`, `category_id`),
  INDEX `product_categories_category_id` (`category_id`, `product_id`)
  CONSTRAINT `product_categories_product_id_fk` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `product_categories_category_id_fk` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
