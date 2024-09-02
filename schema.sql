CREATE TABLE `categories` (
    `id` INT AUTO_INCREMENT,
    `name` VARCHAR(32) NOT NULL,
    `price_factor` FLOAT NOT NULL DEFAULT(1.0),
    PRIMARY KEY(`id`)
);

CREATE TABLE `products` (
    `id` INT AUTO_INCREMENT,
    `name` VARCHAR(32) NOT NULL,
    `category_id` INT NOT NULL,
    PRIMARY KEY(`id`),
    FOREIGN KEY(`category_id`) REFERENCES `categories`(`id`)
);

CREATE TABLE `modules` (
    `id` VARCHAR(32) NOT NULL UNIQUE,
    `name` VARCHAR(32) NOT NULL,
    PRIMARY KEY(`id`)
);

CREATE TABLE `module_to_product` (
    `id` INT AUTO_INCREMENT,
    `product_id` INT NOT NULL,
    `module_id` VARCHAR(32) NOT NULL,
    PRIMARY KEY(`id`),
    FOREIGN KEY(`product_id`) REFERENCES `products`(`id`),
    FOREIGN KEY(`module_id`) REFERENCES `modules`(`id`)
);
CREATE INDEX `idx_mtp_module_id` ON `module_to_product`(`module_id`);
CREATE INDEX `idx_mtp_product_id` ON `module_to_product`(`product_id`);

CREATE TABLE `module_options` (
    `id` VARCHAR(32) NOT NULL,
    `name` VARCHAR(32) NOT NULL,
    `module_id` VARCHAR(32) NOT NULL,
    `price` FLOAT NOT NULL,
    PRIMARY KEY(`id`),
    FOREIGN KEY(`module_id`) REFERENCES `modules`(`id`)
);
CREATE INDEX `idx_mo_module_id` ON `module_options`(`module_id`);

CREATE TABLE `compatibilities` (
    `id` INT AUTO_INCREMENT,
    `module_opt_1_id` VARCHAR(32) NOT NULL,
    `module_opt_2_id` VARCHAR(32) NOT NULL,
    `is_compatible` BOOLEAN NOT NULL DEFAULT(0),
    PRIMARY KEY(`id`),
    FOREIGN KEY(`module_opt_1_id`) REFERENCES `module_options`(`id`),
    FOREIGN KEY(`module_opt_2_id`) REFERENCES `module_options`(`id`)
);
CREATE INDEX `idx_compat_module_opt_1_id` ON `compatibilities`(`module_opt_1_id`);
CREATE INDEX `idx_compat_module_opt_2_id` ON `compatibilities`(`module_opt_2_id`);


CREATE TABLE `configurations` (
    `id` INT AUTO_INCREMENT,
    `product_id` INT NOT NULL,
    `name` VARCHAR(128),
    PRIMARY KEY(`id`),
    FOREIGN KEY(`product_id`) REFERENCES `products`(`id`)
);

CREATE TABLE `configuration_options` (
    `id` INT AUTO_INCREMENT,
    `configuration_id` INT NOT NULL,
    `module_opt_id` VARCHAR(32) NOT NULL,
    PRIMARY KEY(`id`),
    FOREIGN KEY(`configuration_id`) REFERENCES `configurations`(`id`),
    FOREIGN KEY(`module_opt_id`) REFERENCES `module_options`(`id`)
);
CREATE INDEX `idx_cfg_o_module_opt_id` ON `configuration_options`(`module_opt_id`);
CREATE INDEX `idx_cfg_o_cfg_id` ON `configuration_options`(`configuration_id`);
