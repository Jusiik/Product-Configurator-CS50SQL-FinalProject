-- source reset.sql
-- DROP views
DROP VIEW IF EXISTS `show_all_configurations`;
DROP VIEW IF EXISTS `show_modules_machine_b`;

-- Drop tables
DROP TABLE IF EXISTS `configuration_options`;
DROP TABLE IF EXISTS `configurations`;SE
DROP TABLE IF EXISTS `compatibilities`;
DROP TABLE IF EXISTS `module_to_product`;
DROP TABLE IF EXISTS `module_options`;
DROP TABLE IF EXISTS `products`;
DROP TABLE IF EXISTS `categories`;
DROP TABLE IF EXISTS `modules`;


-- Create tables based on schema
source schema.sql;


-- Insert datas to tables
INSERT INTO `categories` (`id`, `name`, `price_factor`)
VALUES
(1, 'standard', 1.0),
(2, 'premium', 1.20);

INSERT INTO `products` (`id`, `name`, `category_id`)
VALUES
(1, 'Machine A', 1),
(2, 'Machine B', 1),
(3, 'Machine B Premium', 2);

INSERT INTO `modules` (`id`, `name`)
VALUES
('base_units_s', 'Base units(small)'),
('base_units_m', 'Base units(medium)'),
('base_units_l', 'Base units(large)'),
('motor_units_s', 'Motor units(small)'),
('motor_units_m', 'Motor units(medium)'),
('motor_units_l', 'Motor units(large)'),
('light_sets', 'Light sets'),
('safety_guards', 'Safety guards'),
('accessories', 'Accessories'),
('services', 'Services');

INSERT INTO `module_to_product` (`product_id`, `module_id`)
VALUES
-- Machine A
(1, 'base_units_s'),
(1, 'motor_units_s'),
(1, 'accessories'),
(1, 'services'),
-- Machine B
(2, 'base_units_m'),
(2, 'base_units_l'),
(2, 'motor_units_m'),
(2, 'motor_units_l'),
(2, 'light_sets'),
(2, 'safety_guards'),
(2, 'accessories'),
(2, 'services'),
-- Machine B Premium
(3, 'base_units_m'),
(3, 'base_units_l'),
(3, 'motor_units_m'),
(3, 'motor_units_l'),
(3, 'light_sets'),
(3, 'safety_guards'),
(3, 'accessories'),
(3, 'services')
;

INSERT INTO `module_options` (`id`, `name`, `module_id`, `price`)
VALUES
('1001', 'BU 500', 'base_units_s', 500),
('1002', 'BU 1000', 'base_units_m', 1000),
('1003', 'BU 2000', 'base_units_l', 2000),
('5001', 'MOT 50', 'motor_units_s', 50),
('5002', 'MOT 100', 'motor_units_m', 100),
('5003', 'MOT 150', 'motor_units_m', 150),
('5004', 'MOT 200', 'motor_units_l', 200),
('6001', 'No lights', 'light_sets', 20),
('6002', 'Lights(standard)', 'light_sets', 100),
('6003', 'Lights(premium)', 'light_sets', 200),
('6004', 'No safety equipment', 'safety_guards', 0),
('6005', 'Basic safety equipment', 'safety_guards', 150),
('6006', 'Premium safety equipment', 'safety_guards', 300),
('6007', 'Workbench(small)', 'accessories', 150),
('6008', 'Workbench(large)', 'accessories', 400),
('6009', 'Additional safety gear', 'accessories', 100),
('8001', 'No services', 'services', 0),
('8002', 'Installation service', 'services', 500),
('8003', 'Training service', 'services', 200);

INSERT INTO `compatibilities` (`module_opt_1_id`, `module_opt_2_id`, `is_compatible`)
VALUES
-- Main module 500
('1001', '5001', 1),
('1001', '5002', 1),
('1001', '6007', 1),
('1001', '6009', 1),
('1001', '6009', 1),
('1001', '8001', 1),
('1001', '8002', 1),
('1001', '8003', 1),

-- Main module 1000
('1002', '5002', 1),
('1002', '5003', 1),
('1002', '6001', 1),
('1002', '6002', 1),
('1002', '6003', 1),
('1002', '6004', 1),
('1002', '6005', 1),
('1002', '6006', 1),
('1002', '6007', 1),
('1002', '6008', 1),
('1002', '6009', 1),
('1002', '6009', 1),
('1002', '8001', 1),
('1002', '8002', 1),
('1002', '8003', 1),

-- Main module 2000
('1003', '5003', 1),
('1003', '5004', 1),
('1003', '6001', 1),
('1003', '6002', 1),
('1003', '6003', 1),
('1003', '6004', 1),
('1003', '6005', 1),
('1003', '6006', 1),
('1003', '6007', 1),
('1003', '6008', 1),
('1003', '6009', 1),
('1003', '6009', 1),
('1003', '8001', 1),
('1003', '8002', 1),
('1003', '8003', 1),

-- Safety modules and accessories
('6009', '6005', 1),
('6009', '6006', 1)
;


-- Create configuration
INSERT INTO `configurations` (`product_id`, `name`)
VALUES
(1, 'Machine A low-cost for customer X'),
(1, 'Machine A low-cost for customer X (+service)'),
(2, 'Machine B for customer Y');

-- Create configuration options
INSERT INTO `configuration_options` (`configuration_id`, `module_opt_id`)
VALUES
(1, '1001'),
(1, '5001'),
(1, '6007'),
(1, '8001'),
(2, '1001'),
(2, '5001'),
(2, '6007'),
(2, '8002'),
(2, '8003'),
(3, '1002'),
(3, '5003'),
(3, '6002'),
(3, '6005'),
(3, '6007'),
(3, '8002')
;


-- CREATE VIEWS

-- VIEW to show all saved configurations
CREATE VIEW show_all_configurations AS
SELECT c.`id` AS 'ID(cfg)', p.`name` AS 'Product Name', c.`name` AS 'Configuration Name'
FROM `configurations` c
JOIN `products` p ON p.`id` = c.`product_id`;

-- VIEW all modules for Machine B (id 2)
CREATE VIEW show_modules_machine_b AS
SELECT `id`, `name`
FROM `module_options`
WHERE `module_id` IN (
    SELECT `module_id`
    FROM `module_to_product`
    WHERE `product_id` = 2
);
