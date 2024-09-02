/* === Init mysql ===
1. START MYSQL SERVER
docker container run --name mysql -p 3306:3306 -v /workspaces/$RepositoryName:/mnt -e MYSQL_ROOT_PASSWORD=crimson -d mysql

2. CONNECT TO MYSQL SERVER
mysql -h 127.0.0.1 -P 3306 -u root -p

3. RESTART MYSQL CONTAINER
docker container start mysql

4. OPEN Database e.g. configurator
USE configurator;

5. INIT the tables
source reset.sql
*/

-- Create configuration (By default in this case the id of cfg will be 5)
INSERT INTO `configurations` (`product_id`, `name`)
VALUES
(1, 'Machine A low-cost for customer Y')
;

-- Create configuration options for the above configuration (id number gotten from above or should be checked by user)
INSERT INTO `configuration_options` (`configuration_id`, `module_opt_id`)
VALUES
(5, '1001'),
(5, '5001'),
(5, '6007'),
(5, '8001');

-- Update configuration options for the above order. Change 6007 to 6008
UPDATE `configuration_options`
SET `module_opt_id` = '6008'
WHERE `configuration_id` = 5 AND `module_opt_id` = '6007';


-- Show available module options for "Machine B"
SELECT `id`, `name`
FROM `module_options`
WHERE `module_id` IN (
    SELECT `module_id`
    FROM `module_to_product`
    WHERE `product_id` = (
        SELECT `id`
        FROM `products`
        WHERE `name` LIKE '%Machine B'
    )
);


-- Show all configurations for "Machine B" and "Machine A"
SELECT c.`id` AS 'ID(cfg)', p.`name` AS 'Product Name', c.`name` AS 'Configuration Name'
FROM `configurations` c
JOIN `products` p ON p.`id` = c.`product_id`
WHERE `product_id` IN (
    SELECT `id`
    FROM `products`
    WHERE `name` LIKE '%Machine B' OR `name` LIKE '%Machine A'
);


-- Show breakdown of price and modules for a configuration "Machine A low-cost": cfg nr 1
SELECT co.`module_opt_id`, mo.`name`, mo.`price`
FROM `configurations` c
JOIN `products` p ON p.`id` = c.`product_id`
JOIN `configuration_options` co ON co.`configuration_id` = c.`id`
JOIN `module_options` mo ON co.`module_opt_id` = mo.`id`
WHERE c.`id` = 1;
-- Show total price
SELECT c.`name`, SUM(mo.`price`)
FROM `configurations` c
JOIN `products` p ON p.`id` = c.`product_id`
JOIN `configuration_options` co ON co.`configuration_id` = c.`id`
JOIN `module_options` mo ON co.`module_opt_id` = mo.`id`
WHERE c.`id` = 1;

-- Show breakdown of price and modules for a configuration "Machine B": cfg nr 2
SELECT co.`module_opt_id`, mo.`name`, mo.`price`
FROM `configurations` c
JOIN `products` p ON p.`id` = c.`product_id`
JOIN `configuration_options` co ON co.`configuration_id` = c.`id`
JOIN `module_options` mo ON co.`module_opt_id` = mo.`id`
WHERE c.`id` = 2;
-- Show total price
SELECT c.`name`, SUM(mo.`price`)
FROM `configurations` c
JOIN `products` p ON p.`id` = c.`product_id`
JOIN `configuration_options` co ON co.`configuration_id` = c.`id`
JOIN `module_options` mo ON co.`module_opt_id` = mo.`id`
WHERE c.`id` = 2;


-- CHECK compatibility between parts in a configuration
SELECT co1.`module_opt_id` AS 'opt_1', co2.`module_opt_id` AS 'opt_2', c.`is_compatible`
FROM `configuration_options` co1
JOIN `configuration_options` co2 ON co1.`configuration_id` = co2.`configuration_id`
JOIN `compatibilities` c ON (co1.`module_opt_id` = c.`module_opt_1_id` AND co2.`module_opt_id` = c.`module_opt_2_id`)
                         OR (co1.`module_opt_id` = c.`module_opt_2_id` AND co2.`module_opt_id` = c.`module_opt_1_id`)
WHERE co1.`configuration_id` = 2 AND co1.`module_opt_id` < co2.`module_opt_id`;
