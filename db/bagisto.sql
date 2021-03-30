-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 30, 2021 at 03:49 PM
-- Server version: 10.4.17-MariaDB
-- PHP Version: 7.3.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `bagisto`
--

DELIMITER $$
--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `get_url_path_of_category` (`categoryId` INT, `localeCode` VARCHAR(255)) RETURNS VARCHAR(255) CHARSET utf8mb4 BEGIN

                DECLARE urlPath VARCHAR(255);

                IF NOT EXISTS (
                    SELECT id
                    FROM categories
                    WHERE
                        id = categoryId
                        AND parent_id IS NULL
                )
                THEN
                    SELECT
                        GROUP_CONCAT(parent_translations.slug SEPARATOR '/') INTO urlPath
                    FROM
                        categories AS node,
                        categories AS parent
                        JOIN category_translations AS parent_translations ON parent.id = parent_translations.category_id
                    WHERE
                        node._lft >= parent._lft
                        AND node._rgt <= parent._rgt
                        AND node.id = categoryId
                        AND node.parent_id IS NOT NULL
                        AND parent.parent_id IS NOT NULL
                        AND parent_translations.locale = localeCode
                    GROUP BY
                        node.id;

                    IF urlPath IS NULL
                    THEN
                        SET urlPath = (SELECT slug FROM category_translations WHERE category_translations.category_id = categoryId);
                    END IF;
                 ELSE
                    SET urlPath = '';
                 END IF;

                 RETURN urlPath;
            END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `addresses`
--

CREATE TABLE `addresses` (
  `id` int(10) UNSIGNED NOT NULL,
  `address_type` varchar(191) NOT NULL,
  `customer_id` int(10) UNSIGNED DEFAULT NULL COMMENT 'null if guest checkout',
  `cart_id` int(10) UNSIGNED DEFAULT NULL COMMENT 'only for cart_addresses',
  `order_id` int(10) UNSIGNED DEFAULT NULL COMMENT 'only for order_addresses',
  `first_name` varchar(191) NOT NULL,
  `last_name` varchar(191) NOT NULL,
  `gender` varchar(191) DEFAULT NULL,
  `company_name` varchar(191) DEFAULT NULL,
  `address1` varchar(191) NOT NULL,
  `address2` varchar(191) DEFAULT NULL,
  `postcode` varchar(191) NOT NULL,
  `city` varchar(191) NOT NULL,
  `state` varchar(191) NOT NULL,
  `country` varchar(191) NOT NULL,
  `email` varchar(191) DEFAULT NULL,
  `phone` varchar(191) DEFAULT NULL,
  `vat_id` varchar(191) DEFAULT NULL,
  `default_address` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'only for customer_addresses',
  `additional` longtext DEFAULT NULL CHECK (json_valid(`additional`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `admins`
--

CREATE TABLE `admins` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(191) NOT NULL,
  `email` varchar(191) NOT NULL,
  `password` varchar(191) DEFAULT NULL,
  `api_token` varchar(80) DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 0,
  `role_id` int(10) UNSIGNED NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `admins`
--

INSERT INTO `admins` (`id`, `name`, `email`, `password`, `api_token`, `status`, `role_id`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'Example', 'admin@example.com', '$2y$10$s4Q0aPfNAcMdQJmHWdmkxOaENA87k4vSq7kTZlA61/RiZRmyEqCAS', 'GgxZN6mV3lonmSB2jWNFiPhH4N0diWxRwCQYbbcl01SdATsv3tHixDMNYlSaeo5pXsXU9Xeo2GotPhgN', 1, 1, NULL, '2021-02-17 20:04:58', '2021-02-17 20:04:58');

-- --------------------------------------------------------

--
-- Table structure for table `admin_password_resets`
--

CREATE TABLE `admin_password_resets` (
  `email` varchar(191) NOT NULL,
  `token` varchar(191) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `attributes`
--

CREATE TABLE `attributes` (
  `id` int(10) UNSIGNED NOT NULL,
  `code` varchar(191) NOT NULL,
  `admin_name` varchar(191) NOT NULL,
  `type` varchar(191) NOT NULL,
  `validation` varchar(191) DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  `is_required` tinyint(1) NOT NULL DEFAULT 0,
  `is_unique` tinyint(1) NOT NULL DEFAULT 0,
  `value_per_locale` tinyint(1) NOT NULL DEFAULT 0,
  `value_per_channel` tinyint(1) NOT NULL DEFAULT 0,
  `is_filterable` tinyint(1) NOT NULL DEFAULT 0,
  `is_configurable` tinyint(1) NOT NULL DEFAULT 0,
  `is_user_defined` tinyint(1) NOT NULL DEFAULT 1,
  `is_visible_on_front` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `swatch_type` varchar(191) DEFAULT NULL,
  `use_in_flat` tinyint(1) NOT NULL DEFAULT 1,
  `is_comparable` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `attributes`
--

INSERT INTO `attributes` (`id`, `code`, `admin_name`, `type`, `validation`, `position`, `is_required`, `is_unique`, `value_per_locale`, `value_per_channel`, `is_filterable`, `is_configurable`, `is_user_defined`, `is_visible_on_front`, `created_at`, `updated_at`, `swatch_type`, `use_in_flat`, `is_comparable`) VALUES
(1, 'sku', 'SKU', 'text', NULL, 1, 1, 1, 0, 0, 0, 0, 0, 0, '2021-02-17 20:04:57', '2021-02-17 20:04:57', NULL, 1, 0),
(2, 'name', 'Name', 'text', NULL, 3, 1, 0, 1, 1, 0, 0, 0, 0, '2021-02-17 20:04:57', '2021-02-17 20:04:57', NULL, 1, 1),
(3, 'url_key', 'URL Key', 'text', NULL, 4, 1, 1, 0, 0, 0, 0, 0, 0, '2021-02-17 20:04:57', '2021-02-17 20:04:57', NULL, 1, 0),
(4, 'tax_category_id', 'Tax Category', 'select', NULL, 5, 0, 0, 0, 1, 0, 0, 0, 0, '2021-02-17 20:04:57', '2021-02-17 20:04:57', NULL, 1, 0),
(5, 'new', 'New', 'boolean', NULL, 6, 0, 0, 0, 0, 0, 0, 0, 0, '2021-02-17 20:04:57', '2021-02-17 20:04:57', NULL, 1, 0),
(6, 'featured', 'Featured', 'boolean', NULL, 7, 0, 0, 0, 0, 0, 0, 0, 0, '2021-02-17 20:04:57', '2021-02-17 20:04:57', NULL, 1, 0),
(7, 'visible_individually', 'Visible Individually', 'boolean', NULL, 9, 1, 0, 0, 0, 0, 0, 0, 0, '2021-02-17 20:04:57', '2021-02-17 20:04:57', NULL, 1, 0),
(8, 'status', 'Status', 'boolean', NULL, 10, 1, 0, 0, 0, 0, 0, 0, 0, '2021-02-17 20:04:57', '2021-02-17 20:04:57', NULL, 1, 0),
(9, 'short_description', 'Short Description', 'textarea', NULL, 11, 1, 0, 1, 1, 0, 0, 0, 0, '2021-02-17 20:04:57', '2021-02-17 20:04:57', NULL, 1, 0),
(10, 'description', 'Description', 'textarea', NULL, 12, 1, 0, 1, 1, 0, 0, 0, 0, '2021-02-17 20:04:57', '2021-02-17 20:04:57', NULL, 1, 1),
(11, 'price', 'Price', 'price', 'decimal', 13, 1, 0, 0, 0, 1, 0, 0, 0, '2021-02-17 20:04:57', '2021-02-17 20:04:57', NULL, 1, 1),
(12, 'cost', 'Cost', 'price', 'decimal', 14, 0, 0, 0, 1, 0, 0, 1, 0, '2021-02-17 20:04:57', '2021-02-17 20:04:57', NULL, 1, 0),
(13, 'special_price', 'Special Price', 'price', 'decimal', 15, 0, 0, 0, 0, 0, 0, 0, 0, '2021-02-17 20:04:57', '2021-02-17 20:04:57', NULL, 1, 0),
(14, 'special_price_from', 'Special Price From', 'date', NULL, 16, 0, 0, 0, 1, 0, 0, 0, 0, '2021-02-17 20:04:57', '2021-02-17 20:04:57', NULL, 1, 0),
(15, 'special_price_to', 'Special Price To', 'date', NULL, 17, 0, 0, 0, 1, 0, 0, 0, 0, '2021-02-17 20:04:57', '2021-02-17 20:04:57', NULL, 1, 0),
(16, 'meta_title', 'Meta Title', 'textarea', NULL, 18, 0, 0, 1, 1, 0, 0, 0, 0, '2021-02-17 20:04:57', '2021-02-17 20:04:57', NULL, 1, 0),
(17, 'meta_keywords', 'Meta Keywords', 'textarea', NULL, 20, 0, 0, 1, 1, 0, 0, 0, 0, '2021-02-17 20:04:57', '2021-02-17 20:04:57', NULL, 1, 0),
(18, 'meta_description', 'Meta Description', 'textarea', NULL, 21, 0, 0, 1, 1, 0, 0, 1, 0, '2021-02-17 20:04:57', '2021-02-17 20:04:57', NULL, 1, 0),
(19, 'width', 'Width', 'text', 'decimal', 22, 0, 0, 0, 0, 0, 0, 1, 0, '2021-02-17 20:04:57', '2021-02-17 20:04:57', NULL, 1, 0),
(20, 'height', 'Height', 'text', 'decimal', 23, 0, 0, 0, 0, 0, 0, 1, 0, '2021-02-17 20:04:57', '2021-02-17 20:04:57', NULL, 1, 0),
(21, 'depth', 'Depth', 'text', 'decimal', 24, 0, 0, 0, 0, 0, 0, 1, 0, '2021-02-17 20:04:57', '2021-02-17 20:04:57', NULL, 1, 0),
(22, 'weight', 'Weight', 'text', 'decimal', 25, 1, 0, 0, 0, 0, 0, 0, 0, '2021-02-17 20:04:57', '2021-02-17 20:04:57', NULL, 1, 0),
(23, 'color', 'Color', 'select', NULL, 26, 0, 0, 0, 0, 1, 1, 1, 0, '2021-02-17 20:04:57', '2021-02-17 20:04:57', NULL, 1, 0),
(24, 'size', 'Size', 'select', NULL, 27, 0, 0, 0, 0, 1, 1, 1, 0, '2021-02-17 20:04:57', '2021-02-17 20:04:57', NULL, 1, 0),
(25, 'brand', 'Brand', 'select', NULL, 28, 0, 0, 0, 0, 1, 0, 1, 1, '2021-02-17 20:04:57', '2021-02-17 20:04:57', NULL, 1, 0),
(26, 'guest_checkout', 'Guest Checkout', 'boolean', NULL, 8, 1, 0, 0, 0, 0, 0, 0, 0, '2021-02-17 20:04:57', '2021-02-17 20:04:57', NULL, 1, 0),
(27, 'product_number', 'Product Number', 'text', NULL, 2, 0, 1, 0, 0, 0, 0, 0, 0, '2021-02-17 20:04:57', '2021-02-17 20:04:57', NULL, 1, 0);

-- --------------------------------------------------------

--
-- Table structure for table `attribute_families`
--

CREATE TABLE `attribute_families` (
  `id` int(10) UNSIGNED NOT NULL,
  `code` varchar(191) NOT NULL,
  `name` varchar(191) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 0,
  `is_user_defined` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `attribute_families`
--

INSERT INTO `attribute_families` (`id`, `code`, `name`, `status`, `is_user_defined`) VALUES
(1, 'default', 'Default', 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `attribute_groups`
--

CREATE TABLE `attribute_groups` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(191) NOT NULL,
  `position` int(11) NOT NULL,
  `is_user_defined` tinyint(1) NOT NULL DEFAULT 1,
  `attribute_family_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `attribute_groups`
--

INSERT INTO `attribute_groups` (`id`, `name`, `position`, `is_user_defined`, `attribute_family_id`) VALUES
(1, 'General', 1, 0, 1),
(2, 'Description', 2, 0, 1),
(3, 'Meta Description', 3, 0, 1),
(4, 'Price', 4, 0, 1),
(5, 'Shipping', 5, 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `attribute_group_mappings`
--

CREATE TABLE `attribute_group_mappings` (
  `attribute_id` int(10) UNSIGNED NOT NULL,
  `attribute_group_id` int(10) UNSIGNED NOT NULL,
  `position` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `attribute_group_mappings`
--

INSERT INTO `attribute_group_mappings` (`attribute_id`, `attribute_group_id`, `position`) VALUES
(1, 1, 1),
(2, 1, 3),
(3, 1, 4),
(4, 1, 5),
(5, 1, 6),
(6, 1, 7),
(7, 1, 8),
(8, 1, 10),
(9, 2, 1),
(10, 2, 2),
(11, 4, 1),
(12, 4, 2),
(13, 4, 3),
(14, 4, 4),
(15, 4, 5),
(16, 3, 1),
(17, 3, 2),
(18, 3, 3),
(19, 5, 1),
(20, 5, 2),
(21, 5, 3),
(22, 5, 4),
(23, 1, 11),
(24, 1, 12),
(25, 1, 13),
(26, 1, 9),
(27, 1, 2);

-- --------------------------------------------------------

--
-- Table structure for table `attribute_options`
--

CREATE TABLE `attribute_options` (
  `id` int(10) UNSIGNED NOT NULL,
  `admin_name` varchar(191) DEFAULT NULL,
  `sort_order` int(11) DEFAULT NULL,
  `attribute_id` int(10) UNSIGNED NOT NULL,
  `swatch_value` varchar(191) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `attribute_options`
--

INSERT INTO `attribute_options` (`id`, `admin_name`, `sort_order`, `attribute_id`, `swatch_value`) VALUES
(1, 'Red', 1, 23, NULL),
(2, 'Green', 2, 23, NULL),
(3, 'Yellow', 3, 23, NULL),
(4, 'Black', 4, 23, NULL),
(5, 'White', 5, 23, NULL),
(6, 'S', 1, 24, NULL),
(7, 'M', 2, 24, NULL),
(8, 'L', 3, 24, NULL),
(9, 'XL', 4, 24, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `attribute_option_translations`
--

CREATE TABLE `attribute_option_translations` (
  `id` int(10) UNSIGNED NOT NULL,
  `locale` varchar(191) NOT NULL,
  `label` text DEFAULT NULL,
  `attribute_option_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `attribute_option_translations`
--

INSERT INTO `attribute_option_translations` (`id`, `locale`, `label`, `attribute_option_id`) VALUES
(1, 'en', 'Red', 1),
(2, 'en', 'Green', 2),
(3, 'en', 'Yellow', 3),
(4, 'en', 'Black', 4),
(5, 'en', 'White', 5),
(6, 'en', 'S', 6),
(7, 'en', 'M', 7),
(8, 'en', 'L', 8),
(9, 'en', 'XL', 9);

-- --------------------------------------------------------

--
-- Table structure for table `attribute_translations`
--

CREATE TABLE `attribute_translations` (
  `id` int(10) UNSIGNED NOT NULL,
  `locale` varchar(191) NOT NULL,
  `name` text DEFAULT NULL,
  `attribute_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `attribute_translations`
--

INSERT INTO `attribute_translations` (`id`, `locale`, `name`, `attribute_id`) VALUES
(1, 'en', 'SKU', 1),
(2, 'en', 'Name', 2),
(3, 'en', 'URL Key', 3),
(4, 'en', 'Tax Category', 4),
(5, 'en', 'New', 5),
(6, 'en', 'Featured', 6),
(7, 'en', 'Visible Individually', 7),
(8, 'en', 'Status', 8),
(9, 'en', 'Short Description', 9),
(10, 'en', 'Description', 10),
(11, 'en', 'Price', 11),
(12, 'en', 'Cost', 12),
(13, 'en', 'Special Price', 13),
(14, 'en', 'Special Price From', 14),
(15, 'en', 'Special Price To', 15),
(16, 'en', 'Meta Description', 16),
(17, 'en', 'Meta Keywords', 17),
(18, 'en', 'Meta Description', 18),
(19, 'en', 'Width', 19),
(20, 'en', 'Height', 20),
(21, 'en', 'Depth', 21),
(22, 'en', 'Weight', 22),
(23, 'en', 'Color', 23),
(24, 'en', 'Size', 24),
(25, 'en', 'Brand', 25),
(26, 'en', 'Allow Guest Checkout', 26),
(27, 'en', 'Product Number', 27);

-- --------------------------------------------------------

--
-- Table structure for table `bookings`
--

CREATE TABLE `bookings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `qty` int(11) DEFAULT 0,
  `from` int(11) DEFAULT NULL,
  `to` int(11) DEFAULT NULL,
  `order_item_id` int(10) UNSIGNED DEFAULT NULL,
  `booking_product_event_ticket_id` int(10) UNSIGNED DEFAULT NULL,
  `order_id` int(10) UNSIGNED DEFAULT NULL,
  `product_id` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `booking_products`
--

CREATE TABLE `booking_products` (
  `id` int(10) UNSIGNED NOT NULL,
  `type` varchar(191) NOT NULL,
  `qty` int(11) DEFAULT 0,
  `location` varchar(191) DEFAULT NULL,
  `show_location` tinyint(1) NOT NULL DEFAULT 0,
  `available_every_week` tinyint(1) DEFAULT NULL,
  `available_from` datetime DEFAULT NULL,
  `available_to` datetime DEFAULT NULL,
  `product_id` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `booking_product_appointment_slots`
--

CREATE TABLE `booking_product_appointment_slots` (
  `id` int(10) UNSIGNED NOT NULL,
  `duration` int(11) DEFAULT NULL,
  `break_time` int(11) DEFAULT NULL,
  `same_slot_all_days` tinyint(1) DEFAULT NULL,
  `slots` longtext DEFAULT NULL CHECK (json_valid(`slots`)),
  `booking_product_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `booking_product_default_slots`
--

CREATE TABLE `booking_product_default_slots` (
  `id` int(10) UNSIGNED NOT NULL,
  `booking_type` varchar(191) NOT NULL,
  `duration` int(11) DEFAULT NULL,
  `break_time` int(11) DEFAULT NULL,
  `slots` longtext DEFAULT NULL CHECK (json_valid(`slots`)),
  `booking_product_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `booking_product_event_tickets`
--

CREATE TABLE `booking_product_event_tickets` (
  `id` int(10) UNSIGNED NOT NULL,
  `price` decimal(12,4) DEFAULT 0.0000,
  `qty` int(11) DEFAULT 0,
  `special_price` decimal(12,4) DEFAULT NULL,
  `special_price_from` datetime DEFAULT NULL,
  `special_price_to` datetime DEFAULT NULL,
  `booking_product_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `booking_product_event_ticket_translations`
--

CREATE TABLE `booking_product_event_ticket_translations` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `locale` varchar(191) NOT NULL,
  `name` text DEFAULT NULL,
  `description` text DEFAULT NULL,
  `booking_product_event_ticket_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `booking_product_rental_slots`
--

CREATE TABLE `booking_product_rental_slots` (
  `id` int(10) UNSIGNED NOT NULL,
  `renting_type` varchar(191) NOT NULL,
  `daily_price` decimal(12,4) DEFAULT 0.0000,
  `hourly_price` decimal(12,4) DEFAULT 0.0000,
  `same_slot_all_days` tinyint(1) DEFAULT NULL,
  `slots` longtext DEFAULT NULL CHECK (json_valid(`slots`)),
  `booking_product_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `booking_product_table_slots`
--

CREATE TABLE `booking_product_table_slots` (
  `id` int(10) UNSIGNED NOT NULL,
  `price_type` varchar(191) NOT NULL,
  `guest_limit` int(11) NOT NULL DEFAULT 0,
  `duration` int(11) NOT NULL,
  `break_time` int(11) NOT NULL,
  `prevent_scheduling_before` int(11) NOT NULL,
  `same_slot_all_days` tinyint(1) DEFAULT NULL,
  `slots` longtext DEFAULT NULL CHECK (json_valid(`slots`)),
  `booking_product_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `cart`
--

CREATE TABLE `cart` (
  `id` int(10) UNSIGNED NOT NULL,
  `customer_email` varchar(191) DEFAULT NULL,
  `customer_first_name` varchar(191) DEFAULT NULL,
  `customer_last_name` varchar(191) DEFAULT NULL,
  `shipping_method` varchar(191) DEFAULT NULL,
  `coupon_code` varchar(191) DEFAULT NULL,
  `is_gift` tinyint(1) NOT NULL DEFAULT 0,
  `items_count` int(11) DEFAULT NULL,
  `items_qty` decimal(12,4) DEFAULT NULL,
  `exchange_rate` decimal(12,4) DEFAULT NULL,
  `global_currency_code` varchar(191) DEFAULT NULL,
  `base_currency_code` varchar(191) DEFAULT NULL,
  `channel_currency_code` varchar(191) DEFAULT NULL,
  `cart_currency_code` varchar(191) DEFAULT NULL,
  `grand_total` decimal(12,4) DEFAULT 0.0000,
  `base_grand_total` decimal(12,4) DEFAULT 0.0000,
  `sub_total` decimal(12,4) DEFAULT 0.0000,
  `base_sub_total` decimal(12,4) DEFAULT 0.0000,
  `tax_total` decimal(12,4) DEFAULT 0.0000,
  `base_tax_total` decimal(12,4) DEFAULT 0.0000,
  `discount_amount` decimal(12,4) DEFAULT 0.0000,
  `base_discount_amount` decimal(12,4) DEFAULT 0.0000,
  `checkout_method` varchar(191) DEFAULT NULL,
  `is_guest` tinyint(1) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `conversion_time` datetime DEFAULT NULL,
  `customer_id` int(10) UNSIGNED DEFAULT NULL,
  `channel_id` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `applied_cart_rule_ids` varchar(191) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `cart`
--

INSERT INTO `cart` (`id`, `customer_email`, `customer_first_name`, `customer_last_name`, `shipping_method`, `coupon_code`, `is_gift`, `items_count`, `items_qty`, `exchange_rate`, `global_currency_code`, `base_currency_code`, `channel_currency_code`, `cart_currency_code`, `grand_total`, `base_grand_total`, `sub_total`, `base_sub_total`, `tax_total`, `base_tax_total`, `discount_amount`, `base_discount_amount`, `checkout_method`, `is_guest`, `is_active`, `conversion_time`, `customer_id`, `channel_id`, `created_at`, `updated_at`, `applied_cart_rule_ids`) VALUES
(1, NULL, NULL, NULL, NULL, NULL, 0, 1, '1.0000', NULL, 'USD', 'USD', 'USD', 'USD', '250.0000', '250.0000', '250.0000', '250.0000', '0.0000', '0.0000', '0.0000', '0.0000', NULL, 1, 1, NULL, NULL, 1, '2021-02-24 18:09:07', '2021-02-24 18:09:08', ''),
(2, NULL, NULL, NULL, NULL, NULL, 0, 1, '1.0000', NULL, 'USD', 'USD', 'USD', 'USD', '300.0000', '300.0000', '300.0000', '300.0000', '0.0000', '0.0000', '0.0000', '0.0000', NULL, 1, 1, NULL, NULL, 1, '2021-03-02 15:18:30', '2021-03-02 15:18:32', '');

-- --------------------------------------------------------

--
-- Table structure for table `cart_items`
--

CREATE TABLE `cart_items` (
  `id` int(10) UNSIGNED NOT NULL,
  `quantity` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `sku` varchar(191) DEFAULT NULL,
  `type` varchar(191) DEFAULT NULL,
  `name` varchar(191) DEFAULT NULL,
  `coupon_code` varchar(191) DEFAULT NULL,
  `weight` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `total_weight` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_total_weight` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `price` decimal(12,4) NOT NULL DEFAULT 1.0000,
  `base_price` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `total` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_total` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `tax_percent` decimal(12,4) DEFAULT 0.0000,
  `tax_amount` decimal(12,4) DEFAULT 0.0000,
  `base_tax_amount` decimal(12,4) DEFAULT 0.0000,
  `discount_percent` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `discount_amount` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_discount_amount` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `additional` longtext DEFAULT NULL CHECK (json_valid(`additional`)),
  `parent_id` int(10) UNSIGNED DEFAULT NULL,
  `product_id` int(10) UNSIGNED NOT NULL,
  `cart_id` int(10) UNSIGNED NOT NULL,
  `tax_category_id` int(10) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `custom_price` decimal(12,4) DEFAULT NULL,
  `applied_cart_rule_ids` varchar(191) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `cart_items`
--

INSERT INTO `cart_items` (`id`, `quantity`, `sku`, `type`, `name`, `coupon_code`, `weight`, `total_weight`, `base_total_weight`, `price`, `base_price`, `total`, `base_total`, `tax_percent`, `tax_amount`, `base_tax_amount`, `discount_percent`, `discount_amount`, `base_discount_amount`, `additional`, `parent_id`, `product_id`, `cart_id`, `tax_category_id`, `created_at`, `updated_at`, `custom_price`, `applied_cart_rule_ids`) VALUES
(1, 1, '123456', 'simple', 'MAN', NULL, '50.0000', '50.0000', '50.0000', '250.0000', '250.0000', '250.0000', '250.0000', '0.0000', '0.0000', '0.0000', '0.0000', '0.0000', '0.0000', '{\"is_buy_now\":\"0\",\"_token\":\"jQcEfBuBxc5SadPiQ61ckkTXHnzHIryOp3YagTeh\",\"product_id\":\"1\",\"quantity\":\"1\"}', NULL, 1, 1, NULL, '2021-02-24 18:09:07', '2021-02-24 18:09:08', NULL, ''),
(2, 1, '123456', 'simple', 'MAN', NULL, '50.0000', '50.0000', '50.0000', '300.0000', '300.0000', '300.0000', '300.0000', '0.0000', '0.0000', '0.0000', '0.0000', '0.0000', '0.0000', '{\"quantity\":1,\"product_id\":\"1\",\"_token\":\"shkqYoGLsXhAolNnRs0caPmATvogHZ8kkkGpnYvx\"}', NULL, 1, 2, NULL, '2021-03-02 15:18:31', '2021-03-02 15:18:31', NULL, '');

-- --------------------------------------------------------

--
-- Table structure for table `cart_item_inventories`
--

CREATE TABLE `cart_item_inventories` (
  `id` int(10) UNSIGNED NOT NULL,
  `qty` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `inventory_source_id` int(10) UNSIGNED DEFAULT NULL,
  `cart_item_id` int(10) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `cart_payment`
--

CREATE TABLE `cart_payment` (
  `id` int(10) UNSIGNED NOT NULL,
  `method` varchar(191) NOT NULL,
  `method_title` varchar(191) DEFAULT NULL,
  `cart_id` int(10) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `cart_rules`
--

CREATE TABLE `cart_rules` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(191) DEFAULT NULL,
  `description` varchar(191) DEFAULT NULL,
  `starts_from` datetime DEFAULT NULL,
  `ends_till` datetime DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 0,
  `coupon_type` int(11) NOT NULL DEFAULT 1,
  `use_auto_generation` tinyint(1) NOT NULL DEFAULT 0,
  `usage_per_customer` int(11) NOT NULL DEFAULT 0,
  `uses_per_coupon` int(11) NOT NULL DEFAULT 0,
  `times_used` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `condition_type` tinyint(1) NOT NULL DEFAULT 1,
  `conditions` longtext DEFAULT NULL CHECK (json_valid(`conditions`)),
  `end_other_rules` tinyint(1) NOT NULL DEFAULT 0,
  `uses_attribute_conditions` tinyint(1) NOT NULL DEFAULT 0,
  `action_type` varchar(191) DEFAULT NULL,
  `discount_amount` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `discount_quantity` int(11) NOT NULL DEFAULT 1,
  `discount_step` varchar(191) NOT NULL DEFAULT '1',
  `apply_to_shipping` tinyint(1) NOT NULL DEFAULT 0,
  `free_shipping` tinyint(1) NOT NULL DEFAULT 0,
  `sort_order` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `cart_rule_channels`
--

CREATE TABLE `cart_rule_channels` (
  `cart_rule_id` int(10) UNSIGNED NOT NULL,
  `channel_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `cart_rule_coupons`
--

CREATE TABLE `cart_rule_coupons` (
  `id` int(10) UNSIGNED NOT NULL,
  `code` varchar(191) DEFAULT NULL,
  `usage_limit` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `usage_per_customer` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `times_used` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `type` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `is_primary` tinyint(1) NOT NULL DEFAULT 0,
  `expired_at` date DEFAULT NULL,
  `cart_rule_id` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `cart_rule_coupon_usage`
--

CREATE TABLE `cart_rule_coupon_usage` (
  `id` int(10) UNSIGNED NOT NULL,
  `times_used` int(11) NOT NULL DEFAULT 0,
  `cart_rule_coupon_id` int(10) UNSIGNED NOT NULL,
  `customer_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `cart_rule_customers`
--

CREATE TABLE `cart_rule_customers` (
  `id` int(10) UNSIGNED NOT NULL,
  `times_used` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `cart_rule_id` int(10) UNSIGNED NOT NULL,
  `customer_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `cart_rule_customer_groups`
--

CREATE TABLE `cart_rule_customer_groups` (
  `cart_rule_id` int(10) UNSIGNED NOT NULL,
  `customer_group_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `cart_rule_translations`
--

CREATE TABLE `cart_rule_translations` (
  `id` int(10) UNSIGNED NOT NULL,
  `locale` varchar(191) NOT NULL,
  `label` text DEFAULT NULL,
  `cart_rule_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `cart_shipping_rates`
--

CREATE TABLE `cart_shipping_rates` (
  `id` int(10) UNSIGNED NOT NULL,
  `carrier` varchar(191) NOT NULL,
  `carrier_title` varchar(191) NOT NULL,
  `method` varchar(191) NOT NULL,
  `method_title` varchar(191) NOT NULL,
  `method_description` varchar(191) DEFAULT NULL,
  `price` double DEFAULT 0,
  `base_price` double DEFAULT 0,
  `cart_address_id` int(10) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `discount_amount` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_discount_amount` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `is_calculate_tax` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `catalog_rules`
--

CREATE TABLE `catalog_rules` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(191) DEFAULT NULL,
  `description` varchar(191) DEFAULT NULL,
  `starts_from` date DEFAULT NULL,
  `ends_till` date DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 0,
  `condition_type` tinyint(1) NOT NULL DEFAULT 1,
  `conditions` longtext DEFAULT NULL CHECK (json_valid(`conditions`)),
  `end_other_rules` tinyint(1) NOT NULL DEFAULT 0,
  `action_type` varchar(191) DEFAULT NULL,
  `discount_amount` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `sort_order` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `catalog_rule_channels`
--

CREATE TABLE `catalog_rule_channels` (
  `catalog_rule_id` int(10) UNSIGNED NOT NULL,
  `channel_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `catalog_rule_customer_groups`
--

CREATE TABLE `catalog_rule_customer_groups` (
  `catalog_rule_id` int(10) UNSIGNED NOT NULL,
  `customer_group_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `catalog_rule_products`
--

CREATE TABLE `catalog_rule_products` (
  `id` int(10) UNSIGNED NOT NULL,
  `starts_from` datetime DEFAULT NULL,
  `ends_till` datetime DEFAULT NULL,
  `end_other_rules` tinyint(1) NOT NULL DEFAULT 0,
  `action_type` varchar(191) DEFAULT NULL,
  `discount_amount` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `sort_order` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `product_id` int(10) UNSIGNED NOT NULL,
  `customer_group_id` int(10) UNSIGNED NOT NULL,
  `catalog_rule_id` int(10) UNSIGNED NOT NULL,
  `channel_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `catalog_rule_product_prices`
--

CREATE TABLE `catalog_rule_product_prices` (
  `id` int(10) UNSIGNED NOT NULL,
  `price` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `rule_date` date NOT NULL,
  `starts_from` datetime DEFAULT NULL,
  `ends_till` datetime DEFAULT NULL,
  `product_id` int(10) UNSIGNED NOT NULL,
  `customer_group_id` int(10) UNSIGNED NOT NULL,
  `catalog_rule_id` int(10) UNSIGNED NOT NULL,
  `channel_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` int(10) UNSIGNED NOT NULL,
  `position` int(11) NOT NULL DEFAULT 0,
  `image` varchar(191) DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 0,
  `_lft` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `_rgt` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `parent_id` int(10) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `display_mode` varchar(191) DEFAULT 'products_and_description',
  `category_icon_path` text DEFAULT NULL,
  `additional` longtext DEFAULT NULL CHECK (json_valid(`additional`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `position`, `image`, `status`, `_lft`, `_rgt`, `parent_id`, `created_at`, `updated_at`, `display_mode`, `category_icon_path`, `additional`) VALUES
(1, 1, NULL, 1, 1, 22, NULL, '2021-02-17 20:04:55', '2021-02-17 20:04:55', 'products_and_description', NULL, NULL),
(3, 1, 'category/3/azRs4OsJl0v2j44BHjqrM78eKt5AJaTIx5GDDyHy.jpg', 1, 14, 15, 1, '2021-03-02 16:19:54', '2021-03-02 16:25:25', 'products_and_description', 'velocity/category_icon_path/3/mHewzg3EnX1pXISm28NmmQA7q29MwKPMl0VktSsZ.jpg', NULL),
(4, 1, 'category/4/J0B5cHc8aCLsOudCNishKv63ZP0jo6yzDCS132yA.jpg', 1, 16, 21, 1, '2021-03-02 16:37:53', '2021-03-02 16:39:12', 'products_and_description', 'velocity/category_icon_path/4/CIuLnC5TahJAd8H5p72gHGL2ai3mreIzpHJnNQ1g.jpg', NULL),
(5, 1, 'category/5/mrGoZ1JfZXAOTKoXx63iN2CW0u8EAw9U4Ccygh2V.jpg', 1, 17, 18, 4, '2021-03-02 17:12:06', '2021-03-02 17:12:06', 'products_and_description', NULL, NULL),
(6, 2, 'category/6/ioAITiS5wiLh4Mju1FJef2sYYIkEkukEVZUUIb3i.jpg', 1, 19, 20, 4, '2021-03-02 17:15:48', '2021-03-02 17:15:48', 'products_only', NULL, NULL);

--
-- Triggers `categories`
--
DELIMITER $$
CREATE TRIGGER `trig_categories_insert` AFTER INSERT ON `categories` FOR EACH ROW BEGIN
                            DECLARE urlPath VARCHAR(255);
            DECLARE localeCode VARCHAR(255);
            DECLARE done INT;
            DECLARE curs CURSOR FOR (SELECT category_translations.locale
                    FROM category_translations
                    WHERE category_id = NEW.id);
            DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;


            IF EXISTS (
                SELECT *
                FROM category_translations
                WHERE category_id = NEW.id
            )
            THEN

                OPEN curs;

            	SET done = 0;
                REPEAT
                	FETCH curs INTO localeCode;

                    SELECT get_url_path_of_category(NEW.id, localeCode) INTO urlPath;

                    IF NEW.parent_id IS NULL
                    THEN
                        SET urlPath = '';
                    END IF;

                    UPDATE category_translations
                    SET url_path = urlPath
                    WHERE
                        category_translations.category_id = NEW.id
                        AND category_translations.locale = localeCode;

                UNTIL done END REPEAT;

                CLOSE curs;

            END IF;
            END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trig_categories_update` AFTER UPDATE ON `categories` FOR EACH ROW BEGIN
                            DECLARE urlPath VARCHAR(255);
            DECLARE localeCode VARCHAR(255);
            DECLARE done INT;
            DECLARE curs CURSOR FOR (SELECT category_translations.locale
                    FROM category_translations
                    WHERE category_id = NEW.id);
            DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;


            IF EXISTS (
                SELECT *
                FROM category_translations
                WHERE category_id = NEW.id
            )
            THEN

                OPEN curs;

            	SET done = 0;
                REPEAT
                	FETCH curs INTO localeCode;

                    SELECT get_url_path_of_category(NEW.id, localeCode) INTO urlPath;

                    IF NEW.parent_id IS NULL
                    THEN
                        SET urlPath = '';
                    END IF;

                    UPDATE category_translations
                    SET url_path = urlPath
                    WHERE
                        category_translations.category_id = NEW.id
                        AND category_translations.locale = localeCode;

                UNTIL done END REPEAT;

                CLOSE curs;

            END IF;
            END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `category_filterable_attributes`
--

CREATE TABLE `category_filterable_attributes` (
  `category_id` int(10) UNSIGNED NOT NULL,
  `attribute_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `category_filterable_attributes`
--

INSERT INTO `category_filterable_attributes` (`category_id`, `attribute_id`) VALUES
(3, 11),
(3, 23),
(3, 25),
(4, 11),
(4, 23),
(4, 24),
(4, 25),
(5, 11),
(5, 23),
(5, 24),
(5, 25),
(6, 11),
(6, 23),
(6, 24),
(6, 25);

-- --------------------------------------------------------

--
-- Table structure for table `category_translations`
--

CREATE TABLE `category_translations` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` text NOT NULL,
  `slug` varchar(191) NOT NULL,
  `description` text DEFAULT NULL,
  `meta_title` text DEFAULT NULL,
  `meta_description` text DEFAULT NULL,
  `meta_keywords` text DEFAULT NULL,
  `category_id` int(10) UNSIGNED NOT NULL,
  `locale` varchar(191) NOT NULL,
  `locale_id` int(10) UNSIGNED DEFAULT NULL,
  `url_path` varchar(2048) NOT NULL COMMENT 'maintained by database triggers'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `category_translations`
--

INSERT INTO `category_translations` (`id`, `name`, `slug`, `description`, `meta_title`, `meta_description`, `meta_keywords`, `category_id`, `locale`, `locale_id`, `url_path`) VALUES
(1, 'Root', 'root', 'Root', '', '', '', 1, 'en', NULL, ''),
(6, 'Accessory', 'accessory', '<p style=\"margin: 0.5em 0px; color: #202122; font-family: sans-serif; font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">Skins and design&nbsp;<a class=\"extiw\" style=\"text-decoration: none; color: #3366bb; background: none;\" title=\"wikt:cover\" href=\"https://en.wiktionary.org/wiki/cover\">covers</a>&nbsp;can serve for protection and personalization. These are the result of the relatively \"naked\" designs produced by manufacturers such as Apple, where the metal and glass components of the device are exposed and vulnerable to damage. They are distinct from holsters, in allowing use of the device while in the&nbsp;<a class=\"extiw\" style=\"text-decoration: none; color: #3366bb; background: none;\" title=\"wikt:case\" href=\"https://en.wiktionary.org/wiki/case\">case</a>, but in many instances include a belt clip or other device giving it the functionality of a holster. They are made of hard plastic, rubber, silicone, leather, or adhesive-backed&nbsp;<a style=\"text-decoration: none; color: #0645ad; background: none;\" title=\"Polyvinyl chloride\" href=\"https://en.wikipedia.org/wiki/Polyvinyl_chloride\">vinyl</a>&nbsp;pieces. Vinyl material may be calendared or cast, with the latter being more expensive. Calendered vinyl is expected to only be used for short-mid duration (10 years), while cast vinyl is used on a more long-term basis.&nbsp;<a style=\"text-decoration: none; color: #0645ad; background: none;\" title=\"Calender\" href=\"https://en.wikipedia.org/wiki/Calender\">Calendered</a>&nbsp;vinyl also tends to shrink in the heat and can be shaped into any form (above 80 degrees Celsius), and may fade in direct sunlight.</p>\r\n<p><br class=\"Apple-interchange-newline\" /><br /></p>', '', '', '', 3, 'en', 1, 'accessory'),
(7, 'Accessory', 'accessory', '<p style=\"margin: 0.5em 0px; color: #202122; font-family: sans-serif; font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">Skins and design&nbsp;<a class=\"extiw\" style=\"text-decoration: none; color: #3366bb; background: none;\" title=\"wikt:cover\" href=\"https://en.wiktionary.org/wiki/cover\">covers</a>&nbsp;can serve for protection and personalization. These are the result of the relatively \"naked\" designs produced by manufacturers such as Apple, where the metal and glass components of the device are exposed and vulnerable to damage. They are distinct from holsters, in allowing use of the device while in the&nbsp;<a class=\"extiw\" style=\"text-decoration: none; color: #3366bb; background: none;\" title=\"wikt:case\" href=\"https://en.wiktionary.org/wiki/case\">case</a>, but in many instances include a belt clip or other device giving it the functionality of a holster. They are made of hard plastic, rubber, silicone, leather, or adhesive-backed&nbsp;<a style=\"text-decoration: none; color: #0645ad; background: none;\" title=\"Polyvinyl chloride\" href=\"https://en.wikipedia.org/wiki/Polyvinyl_chloride\">vinyl</a>&nbsp;pieces. Vinyl material may be calendared or cast, with the latter being more expensive. Calendered vinyl is expected to only be used for short-mid duration (10 years), while cast vinyl is used on a more long-term basis.&nbsp;<a style=\"text-decoration: none; color: #0645ad; background: none;\" title=\"Calender\" href=\"https://en.wikipedia.org/wiki/Calender\">Calendered</a>&nbsp;vinyl also tends to shrink in the heat and can be shaped into any form (above 80 degrees Celsius), and may fade in direct sunlight.</p>\r\n<p><br class=\"Apple-interchange-newline\" /><br /></p>', '', '', '', 3, 'fr', 2, 'accessory'),
(8, 'Accessory', 'accessory', '<p style=\"margin: 0.5em 0px; color: #202122; font-family: sans-serif; font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">Skins and design&nbsp;<a class=\"extiw\" style=\"text-decoration: none; color: #3366bb; background: none;\" title=\"wikt:cover\" href=\"https://en.wiktionary.org/wiki/cover\">covers</a>&nbsp;can serve for protection and personalization. These are the result of the relatively \"naked\" designs produced by manufacturers such as Apple, where the metal and glass components of the device are exposed and vulnerable to damage. They are distinct from holsters, in allowing use of the device while in the&nbsp;<a class=\"extiw\" style=\"text-decoration: none; color: #3366bb; background: none;\" title=\"wikt:case\" href=\"https://en.wiktionary.org/wiki/case\">case</a>, but in many instances include a belt clip or other device giving it the functionality of a holster. They are made of hard plastic, rubber, silicone, leather, or adhesive-backed&nbsp;<a style=\"text-decoration: none; color: #0645ad; background: none;\" title=\"Polyvinyl chloride\" href=\"https://en.wikipedia.org/wiki/Polyvinyl_chloride\">vinyl</a>&nbsp;pieces. Vinyl material may be calendared or cast, with the latter being more expensive. Calendered vinyl is expected to only be used for short-mid duration (10 years), while cast vinyl is used on a more long-term basis.&nbsp;<a style=\"text-decoration: none; color: #0645ad; background: none;\" title=\"Calender\" href=\"https://en.wikipedia.org/wiki/Calender\">Calendered</a>&nbsp;vinyl also tends to shrink in the heat and can be shaped into any form (above 80 degrees Celsius), and may fade in direct sunlight.</p>\r\n<p><br class=\"Apple-interchange-newline\" /><br /></p>', '', '', '', 3, 'nl', 3, 'accessory'),
(9, 'Accessory', 'accessory', '<p style=\"margin: 0.5em 0px; color: #202122; font-family: sans-serif; font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">Skins and design&nbsp;<a class=\"extiw\" style=\"text-decoration: none; color: #3366bb; background: none;\" title=\"wikt:cover\" href=\"https://en.wiktionary.org/wiki/cover\">covers</a>&nbsp;can serve for protection and personalization. These are the result of the relatively \"naked\" designs produced by manufacturers such as Apple, where the metal and glass components of the device are exposed and vulnerable to damage. They are distinct from holsters, in allowing use of the device while in the&nbsp;<a class=\"extiw\" style=\"text-decoration: none; color: #3366bb; background: none;\" title=\"wikt:case\" href=\"https://en.wiktionary.org/wiki/case\">case</a>, but in many instances include a belt clip or other device giving it the functionality of a holster. They are made of hard plastic, rubber, silicone, leather, or adhesive-backed&nbsp;<a style=\"text-decoration: none; color: #0645ad; background: none;\" title=\"Polyvinyl chloride\" href=\"https://en.wikipedia.org/wiki/Polyvinyl_chloride\">vinyl</a>&nbsp;pieces. Vinyl material may be calendared or cast, with the latter being more expensive. Calendered vinyl is expected to only be used for short-mid duration (10 years), while cast vinyl is used on a more long-term basis.&nbsp;<a style=\"text-decoration: none; color: #0645ad; background: none;\" title=\"Calender\" href=\"https://en.wikipedia.org/wiki/Calender\">Calendered</a>&nbsp;vinyl also tends to shrink in the heat and can be shaped into any form (above 80 degrees Celsius), and may fade in direct sunlight.</p>\r\n<p><br class=\"Apple-interchange-newline\" /><br /></p>', '', '', '', 3, 'tr', 4, 'accessory'),
(10, 'MEN', 'men', '<p><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">The&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">men\'s</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;dress&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">shirt</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;is a button-up&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">shirt</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;with a collar and long sleeves. It is cut differently than the sport&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">shirt</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">, which is made to be worn open-necked and looks awkward with a tie. The dress&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">shirt</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;is designed to carry a jacket and tie, but can be worn without one or the other orther.</span><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">The&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">men\'s</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;dress&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">shirt</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;is a button-up&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">shirt</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;with a collar and long sleeves. It is cut differently than the sport&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">shirt</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">, which is made to be worn open-necked and looks awkward with a tie. The dress&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">shirt</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;is designed to carry a jacket and tie, but can be worn without one or the other or with neither.</span></p>', '', '', '', 4, 'en', 1, 'men'),
(11, 'MEN T SHIRTS', 'men-t-shirts', '<p><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">The&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">men\'s</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;dress&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">shirt</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;is a button-up&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">shirt</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;with a collar and long sleeves. It is cut differently than the sport&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">shirt</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">, which is made to be worn open-necked and looks awkward with a tie. The dress&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">shirt</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;is designed to carry a jacket and tie, but can be worn without one or the other orther.</span><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">The&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">men\'s</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;dress&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">shirt</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;is a button-up&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">shirt</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;with a collar and long sleeves. It is cut differently than the sport&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">shirt</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">, which is made to be worn open-necked and looks awkward with a tie. The dress&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">shirt</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;is designed to carry a jacket and tie, but can be worn without one or the other or with neither.</span></p>', '', '', '', 4, 'fr', 2, 'men-t-shirts'),
(12, 'MEN T SHIRTS', 'men-t-shirts', '<p><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">The&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">men\'s</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;dress&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">shirt</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;is a button-up&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">shirt</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;with a collar and long sleeves. It is cut differently than the sport&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">shirt</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">, which is made to be worn open-necked and looks awkward with a tie. The dress&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">shirt</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;is designed to carry a jacket and tie, but can be worn without one or the other orther.</span><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">The&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">men\'s</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;dress&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">shirt</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;is a button-up&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">shirt</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;with a collar and long sleeves. It is cut differently than the sport&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">shirt</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">, which is made to be worn open-necked and looks awkward with a tie. The dress&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">shirt</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;is designed to carry a jacket and tie, but can be worn without one or the other or with neither.</span></p>', '', '', '', 4, 'nl', 3, 'men-t-shirts');
INSERT INTO `category_translations` (`id`, `name`, `slug`, `description`, `meta_title`, `meta_description`, `meta_keywords`, `category_id`, `locale`, `locale_id`, `url_path`) VALUES
(13, 'MEN T SHIRTS', 'men-t-shirts', '<p><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">The&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">men\'s</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;dress&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">shirt</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;is a button-up&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">shirt</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;with a collar and long sleeves. It is cut differently than the sport&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">shirt</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">, which is made to be worn open-necked and looks awkward with a tie. The dress&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">shirt</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;is designed to carry a jacket and tie, but can be worn without one or the other orther.</span><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">The&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">men\'s</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;dress&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">shirt</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;is a button-up&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">shirt</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;with a collar and long sleeves. It is cut differently than the sport&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">shirt</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">, which is made to be worn open-necked and looks awkward with a tie. The dress&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">shirt</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;is designed to carry a jacket and tie, but can be worn without one or the other or with neither.</span></p>', '', '', '', 4, 'tr', 4, 'men-t-shirts'),
(14, 'MEN Jeans', 'men-jeans', '<p><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">Straight through hip and thigh. Relaxed &ndash; A loose fit from the waist to the leg opening, a relaxed cut&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">denim</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;is not going to hug any part of your body. Loose &ndash; A baggy fit. The roomiest fit of&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">jeans</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">, provides plenty of space in the thighs, legs and butt for&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">men</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;who need it</span><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">Straight through hip and thigh. Relaxed &ndash; A loose fit from the waist to the leg opening, a relaxed cut&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">denim</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;is not going to hug any part of your body. Loose &ndash; A baggy fit. The roomiest fit of&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">jeans</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">, provides plenty of space in the thighs, legs and butt for&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">men</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;who need it</span></p>', '', '', '', 5, 'en', 1, 'men/men-jeans'),
(15, 'MEN Jeans', 'men-jeans', '<p><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">Straight through hip and thigh. Relaxed &ndash; A loose fit from the waist to the leg opening, a relaxed cut&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">denim</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;is not going to hug any part of your body. Loose &ndash; A baggy fit. The roomiest fit of&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">jeans</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">, provides plenty of space in the thighs, legs and butt for&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">men</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;who need it</span><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">Straight through hip and thigh. Relaxed &ndash; A loose fit from the waist to the leg opening, a relaxed cut&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">denim</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;is not going to hug any part of your body. Loose &ndash; A baggy fit. The roomiest fit of&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">jeans</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">, provides plenty of space in the thighs, legs and butt for&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">men</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;who need it</span></p>', '', '', '', 5, 'fr', 2, 'men-t-shirts/men-jeans'),
(16, 'MEN Jeans', 'men-jeans', '<p><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">Straight through hip and thigh. Relaxed &ndash; A loose fit from the waist to the leg opening, a relaxed cut&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">denim</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;is not going to hug any part of your body. Loose &ndash; A baggy fit. The roomiest fit of&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">jeans</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">, provides plenty of space in the thighs, legs and butt for&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">men</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;who need it</span><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">Straight through hip and thigh. Relaxed &ndash; A loose fit from the waist to the leg opening, a relaxed cut&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">denim</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;is not going to hug any part of your body. Loose &ndash; A baggy fit. The roomiest fit of&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">jeans</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">, provides plenty of space in the thighs, legs and butt for&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">men</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;who need it</span></p>', '', '', '', 5, 'nl', 3, 'men-t-shirts/men-jeans'),
(17, 'MEN Jeans', 'men-jeans', '<p><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">Straight through hip and thigh. Relaxed &ndash; A loose fit from the waist to the leg opening, a relaxed cut&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">denim</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;is not going to hug any part of your body. Loose &ndash; A baggy fit. The roomiest fit of&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">jeans</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">, provides plenty of space in the thighs, legs and butt for&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">men</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;who need it</span><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">Straight through hip and thigh. Relaxed &ndash; A loose fit from the waist to the leg opening, a relaxed cut&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">denim</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;is not going to hug any part of your body. Loose &ndash; A baggy fit. The roomiest fit of&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">jeans</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">, provides plenty of space in the thighs, legs and butt for&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">men</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;who need it</span></p>', '', '', '', 5, 'tr', 4, 'men-t-shirts/men-jeans'),
(18, 'MEN Shoes', 'men-shoes', '<p><span style=\"color: #202122; font-family: sans-serif; font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">A&nbsp;</span><strong style=\"color: #202122; font-family: sans-serif; font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">shoe</strong><span style=\"color: #202122; font-family: sans-serif; font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;is an item of&nbsp;</span><a style=\"text-decoration: none; color: #0645ad; background: none #ffffff; font-family: sans-serif; font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px;\" title=\"Footwear\" href=\"https://en.wikipedia.org/wiki/Footwear\">footwear</a><span style=\"color: #202122; font-family: sans-serif; font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;intended to protect and comfort the human foot. Shoes are also used as an item of decoration and&nbsp;</span><a style=\"text-decoration: none; color: #0645ad; background: none #ffffff; font-family: sans-serif; font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px;\" title=\"Fashion\" href=\"https://en.wikipedia.org/wiki/Fashion\">fashion</a><span style=\"color: #202122; font-family: sans-serif; font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">. The design of shoes has varied enormously through time and from culture to culture, with appearance originally being tied to function. Though the human foot is adapted to varied terrain and climate conditions, it is still vulnerable to environmental hazards such as sharp rocks and temperature extremes, which shoes protect against. Some shoes are worn as safety equipment, such as steel-soled boots which are required on construction sites.</span></p>', '', '', '', 6, 'en', 1, 'men/men-shoes');
INSERT INTO `category_translations` (`id`, `name`, `slug`, `description`, `meta_title`, `meta_description`, `meta_keywords`, `category_id`, `locale`, `locale_id`, `url_path`) VALUES
(19, 'MEN Shoes', 'men-shoes', '<p><span style=\"color: #202122; font-family: sans-serif; font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">A&nbsp;</span><strong style=\"color: #202122; font-family: sans-serif; font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">shoe</strong><span style=\"color: #202122; font-family: sans-serif; font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;is an item of&nbsp;</span><a style=\"text-decoration: none; color: #0645ad; background: none #ffffff; font-family: sans-serif; font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px;\" title=\"Footwear\" href=\"https://en.wikipedia.org/wiki/Footwear\">footwear</a><span style=\"color: #202122; font-family: sans-serif; font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;intended to protect and comfort the human foot. Shoes are also used as an item of decoration and&nbsp;</span><a style=\"text-decoration: none; color: #0645ad; background: none #ffffff; font-family: sans-serif; font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px;\" title=\"Fashion\" href=\"https://en.wikipedia.org/wiki/Fashion\">fashion</a><span style=\"color: #202122; font-family: sans-serif; font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">. The design of shoes has varied enormously through time and from culture to culture, with appearance originally being tied to function. Though the human foot is adapted to varied terrain and climate conditions, it is still vulnerable to environmental hazards such as sharp rocks and temperature extremes, which shoes protect against. Some shoes are worn as safety equipment, such as steel-soled boots which are required on construction sites.</span></p>', '', '', '', 6, 'fr', 2, 'men-t-shirts/men-shoes'),
(20, 'MEN Shoes', 'men-shoes', '<p><span style=\"color: #202122; font-family: sans-serif; font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">A&nbsp;</span><strong style=\"color: #202122; font-family: sans-serif; font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">shoe</strong><span style=\"color: #202122; font-family: sans-serif; font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;is an item of&nbsp;</span><a style=\"text-decoration: none; color: #0645ad; background: none #ffffff; font-family: sans-serif; font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px;\" title=\"Footwear\" href=\"https://en.wikipedia.org/wiki/Footwear\">footwear</a><span style=\"color: #202122; font-family: sans-serif; font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;intended to protect and comfort the human foot. Shoes are also used as an item of decoration and&nbsp;</span><a style=\"text-decoration: none; color: #0645ad; background: none #ffffff; font-family: sans-serif; font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px;\" title=\"Fashion\" href=\"https://en.wikipedia.org/wiki/Fashion\">fashion</a><span style=\"color: #202122; font-family: sans-serif; font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">. The design of shoes has varied enormously through time and from culture to culture, with appearance originally being tied to function. Though the human foot is adapted to varied terrain and climate conditions, it is still vulnerable to environmental hazards such as sharp rocks and temperature extremes, which shoes protect against. Some shoes are worn as safety equipment, such as steel-soled boots which are required on construction sites.</span></p>', '', '', '', 6, 'nl', 3, 'men-t-shirts/men-shoes'),
(21, 'MEN Shoes', 'men-shoes', '<p><span style=\"color: #202122; font-family: sans-serif; font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">A&nbsp;</span><strong style=\"color: #202122; font-family: sans-serif; font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">shoe</strong><span style=\"color: #202122; font-family: sans-serif; font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;is an item of&nbsp;</span><a style=\"text-decoration: none; color: #0645ad; background: none #ffffff; font-family: sans-serif; font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px;\" title=\"Footwear\" href=\"https://en.wikipedia.org/wiki/Footwear\">footwear</a><span style=\"color: #202122; font-family: sans-serif; font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;intended to protect and comfort the human foot. Shoes are also used as an item of decoration and&nbsp;</span><a style=\"text-decoration: none; color: #0645ad; background: none #ffffff; font-family: sans-serif; font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px;\" title=\"Fashion\" href=\"https://en.wikipedia.org/wiki/Fashion\">fashion</a><span style=\"color: #202122; font-family: sans-serif; font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">. The design of shoes has varied enormously through time and from culture to culture, with appearance originally being tied to function. Though the human foot is adapted to varied terrain and climate conditions, it is still vulnerable to environmental hazards such as sharp rocks and temperature extremes, which shoes protect against. Some shoes are worn as safety equipment, such as steel-soled boots which are required on construction sites.</span></p>', '', '', '', 6, 'tr', 4, 'men-t-shirts/men-shoes');

--
-- Triggers `category_translations`
--
DELIMITER $$
CREATE TRIGGER `trig_category_translations_insert` BEFORE INSERT ON `category_translations` FOR EACH ROW BEGIN
                            DECLARE parentUrlPath varchar(255);
            DECLARE urlPath varchar(255);

            IF NOT EXISTS (
                SELECT id
                FROM categories
                WHERE
                    id = NEW.category_id
                    AND parent_id IS NULL
            )
            THEN

                SELECT
                    GROUP_CONCAT(parent_translations.slug SEPARATOR '/') INTO parentUrlPath
                FROM
                    categories AS node,
                    categories AS parent
                    JOIN category_translations AS parent_translations ON parent.id = parent_translations.category_id
                WHERE
                    node._lft >= parent._lft
                    AND node._rgt <= parent._rgt
                    AND node.id = (SELECT parent_id FROM categories WHERE id = NEW.category_id)
                    AND node.parent_id IS NOT NULL
                    AND parent.parent_id IS NOT NULL
                    AND parent_translations.locale = NEW.locale
                GROUP BY
                    node.id;

                IF parentUrlPath IS NULL
                THEN
                    SET urlPath = NEW.slug;
                ELSE
                    SET urlPath = concat(parentUrlPath, '/', NEW.slug);
                END IF;

                SET NEW.url_path = urlPath;

            END IF;
            END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trig_category_translations_update` BEFORE UPDATE ON `category_translations` FOR EACH ROW BEGIN
                            DECLARE parentUrlPath varchar(255);
            DECLARE urlPath varchar(255);

            IF NOT EXISTS (
                SELECT id
                FROM categories
                WHERE
                    id = NEW.category_id
                    AND parent_id IS NULL
            )
            THEN

                SELECT
                    GROUP_CONCAT(parent_translations.slug SEPARATOR '/') INTO parentUrlPath
                FROM
                    categories AS node,
                    categories AS parent
                    JOIN category_translations AS parent_translations ON parent.id = parent_translations.category_id
                WHERE
                    node._lft >= parent._lft
                    AND node._rgt <= parent._rgt
                    AND node.id = (SELECT parent_id FROM categories WHERE id = NEW.category_id)
                    AND node.parent_id IS NOT NULL
                    AND parent.parent_id IS NOT NULL
                    AND parent_translations.locale = NEW.locale
                GROUP BY
                    node.id;

                IF parentUrlPath IS NULL
                THEN
                    SET urlPath = NEW.slug;
                ELSE
                    SET urlPath = concat(parentUrlPath, '/', NEW.slug);
                END IF;

                SET NEW.url_path = urlPath;

            END IF;
            END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `channels`
--

CREATE TABLE `channels` (
  `id` int(10) UNSIGNED NOT NULL,
  `code` varchar(191) NOT NULL,
  `timezone` varchar(191) DEFAULT NULL,
  `theme` varchar(191) DEFAULT NULL,
  `hostname` varchar(191) DEFAULT NULL,
  `logo` varchar(191) DEFAULT NULL,
  `favicon` varchar(191) DEFAULT NULL,
  `is_maintenance_on` tinyint(1) NOT NULL DEFAULT 0,
  `allowed_ips` text DEFAULT NULL,
  `default_locale_id` int(10) UNSIGNED NOT NULL,
  `base_currency_id` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `root_category_id` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `channels`
--

INSERT INTO `channels` (`id`, `code`, `timezone`, `theme`, `hostname`, `logo`, `favicon`, `is_maintenance_on`, `allowed_ips`, `default_locale_id`, `base_currency_id`, `created_at`, `updated_at`, `root_category_id`) VALUES
(1, 'default', NULL, 'velocity', 'http://localhost:8000', NULL, NULL, 0, NULL, 1, 1, NULL, NULL, 1);

-- --------------------------------------------------------

--
-- Table structure for table `channel_currencies`
--

CREATE TABLE `channel_currencies` (
  `channel_id` int(10) UNSIGNED NOT NULL,
  `currency_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `channel_currencies`
--

INSERT INTO `channel_currencies` (`channel_id`, `currency_id`) VALUES
(1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `channel_inventory_sources`
--

CREATE TABLE `channel_inventory_sources` (
  `channel_id` int(10) UNSIGNED NOT NULL,
  `inventory_source_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `channel_inventory_sources`
--

INSERT INTO `channel_inventory_sources` (`channel_id`, `inventory_source_id`) VALUES
(1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `channel_locales`
--

CREATE TABLE `channel_locales` (
  `channel_id` int(10) UNSIGNED NOT NULL,
  `locale_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `channel_locales`
--

INSERT INTO `channel_locales` (`channel_id`, `locale_id`) VALUES
(1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `channel_translations`
--

CREATE TABLE `channel_translations` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `channel_id` int(10) UNSIGNED NOT NULL,
  `locale` varchar(191) NOT NULL,
  `name` varchar(191) NOT NULL,
  `description` text DEFAULT NULL,
  `home_page_content` text DEFAULT NULL,
  `footer_content` text DEFAULT NULL,
  `maintenance_mode_text` text DEFAULT NULL,
  `home_seo` longtext DEFAULT NULL CHECK (json_valid(`home_seo`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `channel_translations`
--

INSERT INTO `channel_translations` (`id`, `channel_id`, `locale`, `name`, `description`, `home_page_content`, `footer_content`, `maintenance_mode_text`, `home_seo`, `created_at`, `updated_at`) VALUES
(1, 1, 'en', 'Default', NULL, '\n                    <p>@include(\"shop::home.slider\") @include(\"shop::home.featured-products\") @include(\"shop::home.new-products\")</p>\n                        <div class=\"banner-container\">\n                        <div class=\"left-banner\">\n                            <img src=http://localhost:8000/themes/default/assets/images/1.webp data-src=http://localhost:8000/themes/default/assets/images/1.webp class=\"lazyload\" alt=\"test\" width=\"720\" height=\"720\" />\n                        </div>\n                        <div class=\"right-banner\">\n                            <img src=http://localhost:8000/themes/default/assets/images/2.webp data-src=http://localhost:8000/themes/default/assets/images/2.webp class=\"lazyload\" alt=\"test\" width=\"460\" height=\"330\" />\n                            <img src=http://localhost:8000/themes/default/assets/images/3.webp data-src=http://localhost:8000/themes/default/assets/images/3.webp  class=\"lazyload\" alt=\"test\" width=\"460\" height=\"330\" />\n                        </div>\n                    </div>\n                ', '\n                    <div class=\"list-container\">\n                        <span class=\"list-heading\">Quick Links</span>\n                        <ul class=\"list-group\">\n                            <li><a href=\"@php echo route(\'shop.cms.page\', \'about-us\') @endphp\">About Us</a></li>\n                            <li><a href=\"@php echo route(\'shop.cms.page\', \'return-policy\') @endphp\">Return Policy</a></li>\n                            <li><a href=\"@php echo route(\'shop.cms.page\', \'refund-policy\') @endphp\">Refund Policy</a></li>\n                            <li><a href=\"@php echo route(\'shop.cms.page\', \'terms-conditions\') @endphp\">Terms and conditions</a></li>\n                            <li><a href=\"@php echo route(\'shop.cms.page\', \'terms-of-use\') @endphp\">Terms of Use</a></li><li><a href=\"@php echo route(\'shop.cms.page\', \'contact-us\') @endphp\">Contact Us</a></li>\n                        </ul>\n                    </div>\n                    <div class=\"list-container\">\n                        <span class=\"list-heading\">Connect With Us</span>\n                            <ul class=\"list-group\">\n                                <li><a href=\"#\"><span class=\"icon icon-facebook\"></span>Facebook </a></li>\n                                <li><a href=\"#\"><span class=\"icon icon-twitter\"></span> Twitter </a></li>\n                                <li><a href=\"#\"><span class=\"icon icon-instagram\"></span> Instagram </a></li>\n                                <li><a href=\"#\"> <span class=\"icon icon-google-plus\"></span>Google+ </a></li>\n                                <li><a href=\"#\"> <span class=\"icon icon-linkedin\"></span>LinkedIn </a></li>\n                            </ul>\n                        </div>\n                ', NULL, '{\"meta_title\": \"Demo store\", \"meta_keywords\": \"Demo store meta keyword\", \"meta_description\": \"Demo store meta description\"}', NULL, NULL),
(2, 1, 'fr', 'Default', NULL, '\n                    <p>@include(\"shop::home.slider\") @include(\"shop::home.featured-products\") @include(\"shop::home.new-products\")</p>\n                        <div class=\"banner-container\">\n                        <div class=\"left-banner\">\n                            <img src=http://localhost:8000/themes/default/assets/images/1.webp data-src=http://localhost:8000/themes/default/assets/images/1.webp class=\"lazyload\" alt=\"test\" width=\"720\" height=\"720\" />\n                        </div>\n                        <div class=\"right-banner\">\n                            <img src=http://localhost:8000/themes/default/assets/images/2.webp data-src=http://localhost:8000/themes/default/assets/images/2.webp class=\"lazyload\" alt=\"test\" width=\"460\" height=\"330\" />\n                            <img src=http://localhost:8000/themes/default/assets/images/3.webp data-src=http://localhost:8000/themes/default/assets/images/3.webp  class=\"lazyload\" alt=\"test\" width=\"460\" height=\"330\" />\n                        </div>\n                    </div>\n                ', '\n                    <div class=\"list-container\">\n                        <span class=\"list-heading\">Quick Links</span>\n                        <ul class=\"list-group\">\n                            <li><a href=\"@php echo route(\'shop.cms.page\', \'about-us\') @endphp\">About Us</a></li>\n                            <li><a href=\"@php echo route(\'shop.cms.page\', \'return-policy\') @endphp\">Return Policy</a></li>\n                            <li><a href=\"@php echo route(\'shop.cms.page\', \'refund-policy\') @endphp\">Refund Policy</a></li>\n                            <li><a href=\"@php echo route(\'shop.cms.page\', \'terms-conditions\') @endphp\">Terms and conditions</a></li>\n                            <li><a href=\"@php echo route(\'shop.cms.page\', \'terms-of-use\') @endphp\">Terms of Use</a></li><li><a href=\"@php echo route(\'shop.cms.page\', \'contact-us\') @endphp\">Contact Us</a></li>\n                        </ul>\n                    </div>\n                    <div class=\"list-container\">\n                        <span class=\"list-heading\">Connect With Us</span>\n                            <ul class=\"list-group\">\n                                <li><a href=\"#\"><span class=\"icon icon-facebook\"></span>Facebook </a></li>\n                                <li><a href=\"#\"><span class=\"icon icon-twitter\"></span> Twitter </a></li>\n                                <li><a href=\"#\"><span class=\"icon icon-instagram\"></span> Instagram </a></li>\n                                <li><a href=\"#\"> <span class=\"icon icon-google-plus\"></span>Google+ </a></li>\n                                <li><a href=\"#\"> <span class=\"icon icon-linkedin\"></span>LinkedIn </a></li>\n                            </ul>\n                        </div>\n                ', NULL, '{\"meta_title\": \"Demo store\", \"meta_keywords\": \"Demo store meta keyword\", \"meta_description\": \"Demo store meta description\"}', NULL, NULL),
(3, 1, 'nl', 'Default', NULL, '\n                    <p>@include(\"shop::home.slider\") @include(\"shop::home.featured-products\") @include(\"shop::home.new-products\")</p>\n                        <div class=\"banner-container\">\n                        <div class=\"left-banner\">\n                            <img src=http://localhost:8000/themes/default/assets/images/1.webp data-src=http://localhost:8000/themes/default/assets/images/1.webp class=\"lazyload\" alt=\"test\" width=\"720\" height=\"720\" />\n                        </div>\n                        <div class=\"right-banner\">\n                            <img src=http://localhost:8000/themes/default/assets/images/2.webp data-src=http://localhost:8000/themes/default/assets/images/2.webp class=\"lazyload\" alt=\"test\" width=\"460\" height=\"330\" />\n                            <img src=http://localhost:8000/themes/default/assets/images/3.webp data-src=http://localhost:8000/themes/default/assets/images/3.webp  class=\"lazyload\" alt=\"test\" width=\"460\" height=\"330\" />\n                        </div>\n                    </div>\n                ', '\n                    <div class=\"list-container\">\n                        <span class=\"list-heading\">Quick Links</span>\n                        <ul class=\"list-group\">\n                            <li><a href=\"@php echo route(\'shop.cms.page\', \'about-us\') @endphp\">About Us</a></li>\n                            <li><a href=\"@php echo route(\'shop.cms.page\', \'return-policy\') @endphp\">Return Policy</a></li>\n                            <li><a href=\"@php echo route(\'shop.cms.page\', \'refund-policy\') @endphp\">Refund Policy</a></li>\n                            <li><a href=\"@php echo route(\'shop.cms.page\', \'terms-conditions\') @endphp\">Terms and conditions</a></li>\n                            <li><a href=\"@php echo route(\'shop.cms.page\', \'terms-of-use\') @endphp\">Terms of Use</a></li><li><a href=\"@php echo route(\'shop.cms.page\', \'contact-us\') @endphp\">Contact Us</a></li>\n                        </ul>\n                    </div>\n                    <div class=\"list-container\">\n                        <span class=\"list-heading\">Connect With Us</span>\n                            <ul class=\"list-group\">\n                                <li><a href=\"#\"><span class=\"icon icon-facebook\"></span>Facebook </a></li>\n                                <li><a href=\"#\"><span class=\"icon icon-twitter\"></span> Twitter </a></li>\n                                <li><a href=\"#\"><span class=\"icon icon-instagram\"></span> Instagram </a></li>\n                                <li><a href=\"#\"> <span class=\"icon icon-google-plus\"></span>Google+ </a></li>\n                                <li><a href=\"#\"> <span class=\"icon icon-linkedin\"></span>LinkedIn </a></li>\n                            </ul>\n                        </div>\n                ', NULL, '{\"meta_title\": \"Demo store\", \"meta_keywords\": \"Demo store meta keyword\", \"meta_description\": \"Demo store meta description\"}', NULL, NULL),
(4, 1, 'tr', 'Default', NULL, '\n                    <p>@include(\"shop::home.slider\") @include(\"shop::home.featured-products\") @include(\"shop::home.new-products\")</p>\n                        <div class=\"banner-container\">\n                        <div class=\"left-banner\">\n                            <img src=http://localhost:8000/themes/default/assets/images/1.webp data-src=http://localhost:8000/themes/default/assets/images/1.webp class=\"lazyload\" alt=\"test\" width=\"720\" height=\"720\" />\n                        </div>\n                        <div class=\"right-banner\">\n                            <img src=http://localhost:8000/themes/default/assets/images/2.webp data-src=http://localhost:8000/themes/default/assets/images/2.webp class=\"lazyload\" alt=\"test\" width=\"460\" height=\"330\" />\n                            <img src=http://localhost:8000/themes/default/assets/images/3.webp data-src=http://localhost:8000/themes/default/assets/images/3.webp  class=\"lazyload\" alt=\"test\" width=\"460\" height=\"330\" />\n                        </div>\n                    </div>\n                ', '\n                    <div class=\"list-container\">\n                        <span class=\"list-heading\">Quick Links</span>\n                        <ul class=\"list-group\">\n                            <li><a href=\"@php echo route(\'shop.cms.page\', \'about-us\') @endphp\">About Us</a></li>\n                            <li><a href=\"@php echo route(\'shop.cms.page\', \'return-policy\') @endphp\">Return Policy</a></li>\n                            <li><a href=\"@php echo route(\'shop.cms.page\', \'refund-policy\') @endphp\">Refund Policy</a></li>\n                            <li><a href=\"@php echo route(\'shop.cms.page\', \'terms-conditions\') @endphp\">Terms and conditions</a></li>\n                            <li><a href=\"@php echo route(\'shop.cms.page\', \'terms-of-use\') @endphp\">Terms of Use</a></li><li><a href=\"@php echo route(\'shop.cms.page\', \'contact-us\') @endphp\">Contact Us</a></li>\n                        </ul>\n                    </div>\n                    <div class=\"list-container\">\n                        <span class=\"list-heading\">Connect With Us</span>\n                            <ul class=\"list-group\">\n                                <li><a href=\"#\"><span class=\"icon icon-facebook\"></span>Facebook </a></li>\n                                <li><a href=\"#\"><span class=\"icon icon-twitter\"></span> Twitter </a></li>\n                                <li><a href=\"#\"><span class=\"icon icon-instagram\"></span> Instagram </a></li>\n                                <li><a href=\"#\"> <span class=\"icon icon-google-plus\"></span>Google+ </a></li>\n                                <li><a href=\"#\"> <span class=\"icon icon-linkedin\"></span>LinkedIn </a></li>\n                            </ul>\n                        </div>\n                ', NULL, '{\"meta_title\": \"Demo store\", \"meta_keywords\": \"Demo store meta keyword\", \"meta_description\": \"Demo store meta description\"}', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `cms_pages`
--

CREATE TABLE `cms_pages` (
  `id` int(10) UNSIGNED NOT NULL,
  `layout` varchar(191) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `cms_pages`
--

INSERT INTO `cms_pages` (`id`, `layout`, `created_at`, `updated_at`) VALUES
(1, NULL, '2021-02-17 20:04:58', '2021-02-17 20:04:58'),
(2, NULL, '2021-02-17 20:04:58', '2021-02-17 20:04:58'),
(3, NULL, '2021-02-17 20:04:58', '2021-02-17 20:04:58'),
(4, NULL, '2021-02-17 20:04:58', '2021-02-17 20:04:58'),
(5, NULL, '2021-02-17 20:04:58', '2021-02-17 20:04:58'),
(6, NULL, '2021-02-17 20:04:58', '2021-02-17 20:04:58'),
(7, NULL, '2021-02-17 20:04:58', '2021-02-17 20:04:58'),
(8, NULL, '2021-02-17 20:04:58', '2021-02-17 20:04:58'),
(9, NULL, '2021-02-17 20:04:58', '2021-02-17 20:04:58'),
(10, NULL, '2021-02-17 20:04:58', '2021-02-17 20:04:58'),
(11, NULL, '2021-02-17 20:04:58', '2021-02-17 20:04:58');

-- --------------------------------------------------------

--
-- Table structure for table `cms_page_channels`
--

CREATE TABLE `cms_page_channels` (
  `cms_page_id` int(10) UNSIGNED NOT NULL,
  `channel_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `cms_page_translations`
--

CREATE TABLE `cms_page_translations` (
  `id` int(10) UNSIGNED NOT NULL,
  `page_title` varchar(191) NOT NULL,
  `url_key` varchar(191) NOT NULL,
  `html_content` longtext DEFAULT NULL,
  `meta_title` text DEFAULT NULL,
  `meta_description` text DEFAULT NULL,
  `meta_keywords` text DEFAULT NULL,
  `locale` varchar(191) NOT NULL,
  `cms_page_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `cms_page_translations`
--

INSERT INTO `cms_page_translations` (`id`, `page_title`, `url_key`, `html_content`, `meta_title`, `meta_description`, `meta_keywords`, `locale`, `cms_page_id`) VALUES
(12, 'About Us', 'about-us', '<div class=\"static-container\"><div class=\"mb-5\">About us page content</div></div>', 'about us', '', 'aboutus', 'en', 1),
(13, 'Return Policy', 'return-policy', '<div class=\"static-container\"><div class=\"mb-5\">Return policy page content</div></div>', 'return policy', '', 'return, policy', 'en', 2),
(14, 'Refund Policy', 'refund-policy', '<div class=\"static-container\"><div class=\"mb-5\">Refund policy page content</div></div>', 'Refund policy', '', 'refund, policy', 'en', 3),
(15, 'Terms & Conditions', 'terms-conditions', '<div class=\"static-container\"><div class=\"mb-5\">Terms & conditions page content</div></div>', 'Terms & Conditions', '', 'term, conditions', 'en', 4),
(16, 'Terms of use', 'terms-of-use', '<div class=\"static-container\"><div class=\"mb-5\">Terms of use page content</div></div>', 'Terms of use', '', 'term, use', 'en', 5),
(17, 'Contact Us', 'contact-us', '<div class=\"static-container\"><div class=\"mb-5\">Contact us page content</div></div>', 'Contact Us', '', 'contact, us', 'en', 6),
(18, 'Customer Service', 'cutomer-service', '<div class=\"static-container\"><div class=\"mb-5\">Customer service  page content</div></div>', 'Customer Service', '', 'customer, service', 'en', 7),
(19, 'What\'s New', 'whats-new', '<div class=\"static-container\"><div class=\"mb-5\">What\'s New page content</div></div>', 'What\'s New', '', 'new', 'en', 8),
(20, 'Payment Policy', 'payment-policy', '<div class=\"static-container\"><div class=\"mb-5\">Payment Policy page content</div></div>', 'Payment Policy', '', 'payment, policy', 'en', 9),
(21, 'Shipping Policy', 'shipping-policy', '<div class=\"static-container\"><div class=\"mb-5\">Shipping Policy  page content</div></div>', 'Shipping Policy', '', 'shipping, policy', 'en', 10),
(22, 'Privacy Policy', 'privacy-policy', '<div class=\"static-container\"><div class=\"mb-5\">Privacy Policy  page content</div></div>', 'Privacy Policy', '', 'privacy, policy', 'en', 11);

-- --------------------------------------------------------

--
-- Table structure for table `core_config`
--

CREATE TABLE `core_config` (
  `id` int(10) UNSIGNED NOT NULL,
  `code` varchar(191) NOT NULL,
  `value` text NOT NULL,
  `channel_code` varchar(191) DEFAULT NULL,
  `locale_code` varchar(191) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `core_config`
--

INSERT INTO `core_config` (`id`, `code`, `value`, `channel_code`, `locale_code`, `created_at`, `updated_at`) VALUES
(1, 'catalog.products.guest-checkout.allow-guest-checkout', '1', NULL, NULL, '2021-02-17 20:04:57', '2021-02-17 20:04:57'),
(2, 'emails.general.notifications.emails.general.notifications.verification', '1', NULL, NULL, '2021-02-17 20:04:57', '2021-02-17 20:04:57'),
(3, 'emails.general.notifications.emails.general.notifications.registration', '1', NULL, NULL, '2021-02-17 20:04:57', '2021-02-17 20:04:57'),
(4, 'emails.general.notifications.emails.general.notifications.customer', '1', NULL, NULL, '2021-02-17 20:04:57', '2021-02-17 20:04:57'),
(5, 'emails.general.notifications.emails.general.notifications.new-order', '1', NULL, NULL, '2021-02-17 20:04:57', '2021-02-17 20:04:57'),
(6, 'emails.general.notifications.emails.general.notifications.new-admin', '1', NULL, NULL, '2021-02-17 20:04:57', '2021-02-17 20:04:57'),
(7, 'emails.general.notifications.emails.general.notifications.new-invoice', '1', NULL, NULL, '2021-02-17 20:04:57', '2021-02-17 20:04:57'),
(8, 'emails.general.notifications.emails.general.notifications.new-refund', '1', NULL, NULL, '2021-02-17 20:04:57', '2021-02-17 20:04:57'),
(9, 'emails.general.notifications.emails.general.notifications.new-shipment', '1', NULL, NULL, '2021-02-17 20:04:57', '2021-02-17 20:04:57'),
(10, 'emails.general.notifications.emails.general.notifications.new-inventory-source', '1', NULL, NULL, '2021-02-17 20:04:57', '2021-02-17 20:04:57'),
(11, 'emails.general.notifications.emails.general.notifications.cancel-order', '1', NULL, NULL, '2021-02-17 20:04:57', '2021-02-17 20:04:57'),
(12, 'catalog.products.homepage.out_of_stock_items', '1', NULL, NULL, '2021-02-17 20:04:57', '2021-02-17 20:04:57'),
(29, 'customer.settings.social_login.enable_facebook', '1', 'default', NULL, '2021-02-17 20:04:58', '2021-02-17 20:04:58'),
(30, 'customer.settings.social_login.enable_twitter', '1', 'default', NULL, '2021-02-17 20:04:58', '2021-02-17 20:04:58'),
(31, 'customer.settings.social_login.enable_google', '1', 'default', NULL, '2021-02-17 20:04:58', '2021-02-17 20:04:58'),
(32, 'customer.settings.social_login.enable_linkedin', '1', 'default', NULL, '2021-02-17 20:04:58', '2021-02-17 20:04:58'),
(33, 'customer.settings.social_login.enable_github', '1', 'default', NULL, '2021-02-17 20:04:58', '2021-02-17 20:04:58'),
(34, 'general.content.shop.compare_option', '0', 'default', 'en', '2021-02-17 20:04:58', '2021-03-02 16:53:58'),
(35, 'general.content.shop.compare_option', '1', 'default', 'fr', '2021-02-17 20:04:58', '2021-02-17 20:04:58'),
(36, 'general.content.shop.compare_option', '1', 'default', 'ar', '2021-02-17 20:04:58', '2021-02-17 20:04:58'),
(37, 'general.content.shop.compare_option', '1', 'default', 'de', '2021-02-17 20:04:58', '2021-02-17 20:04:58'),
(38, 'general.content.shop.compare_option', '1', 'default', 'es', '2021-02-17 20:04:58', '2021-02-17 20:04:58'),
(39, 'general.content.shop.compare_option', '1', 'default', 'fa', '2021-02-17 20:04:58', '2021-02-17 20:04:58'),
(40, 'general.content.shop.compare_option', '1', 'default', 'it', '2021-02-17 20:04:58', '2021-02-17 20:04:58'),
(41, 'general.content.shop.compare_option', '1', 'default', 'ja', '2021-02-17 20:04:58', '2021-02-17 20:04:58'),
(42, 'general.content.shop.compare_option', '1', 'default', 'nl', '2021-02-17 20:04:58', '2021-02-17 20:04:58'),
(43, 'general.content.shop.compare_option', '1', 'default', 'pl', '2021-02-17 20:04:58', '2021-02-17 20:04:58'),
(44, 'general.content.shop.compare_option', '1', 'default', 'pt_BR', '2021-02-17 20:04:58', '2021-02-17 20:04:58'),
(45, 'general.content.shop.compare_option', '1', 'default', 'tr', '2021-02-17 20:04:58', '2021-02-17 20:04:58'),
(46, 'general.content.shop.wishlist_option', '1', 'default', 'en', '2021-02-17 20:04:58', '2021-03-02 19:49:05'),
(47, 'general.content.shop.wishlist_option', '1', 'default', 'fr', '2021-02-17 20:04:58', '2021-02-17 20:04:58'),
(48, 'general.content.shop.wishlist_option', '1', 'default', 'ar', '2021-02-17 20:04:58', '2021-02-17 20:04:58'),
(49, 'general.content.shop.wishlist_option', '1', 'default', 'de', '2021-02-17 20:04:58', '2021-02-17 20:04:58'),
(50, 'general.content.shop.wishlist_option', '1', 'default', 'es', '2021-02-17 20:04:58', '2021-02-17 20:04:58'),
(51, 'general.content.shop.wishlist_option', '1', 'default', 'fa', '2021-02-17 20:04:58', '2021-02-17 20:04:58'),
(52, 'general.content.shop.wishlist_option', '1', 'default', 'it', '2021-02-17 20:04:58', '2021-02-17 20:04:58'),
(53, 'general.content.shop.wishlist_option', '1', 'default', 'ja', '2021-02-17 20:04:58', '2021-02-17 20:04:58'),
(54, 'general.content.shop.wishlist_option', '1', 'default', 'nl', '2021-02-17 20:04:58', '2021-02-17 20:04:58'),
(55, 'general.content.shop.wishlist_option', '1', 'default', 'pl', '2021-02-17 20:04:58', '2021-02-17 20:04:58'),
(56, 'general.content.shop.wishlist_option', '1', 'default', 'pt_BR', '2021-02-17 20:04:58', '2021-02-17 20:04:58'),
(57, 'general.content.shop.wishlist_option', '1', 'default', 'tr', '2021-02-17 20:04:58', '2021-02-17 20:04:58'),
(58, 'general.content.shop.image_search', '0', 'default', 'en', '2021-02-17 20:04:58', '2021-03-02 16:53:58'),
(59, 'general.content.shop.image_search', '1', 'default', 'fr', '2021-02-17 20:04:58', '2021-02-17 20:04:58'),
(60, 'general.content.shop.image_search', '1', 'default', 'ar', '2021-02-17 20:04:58', '2021-02-17 20:04:58'),
(61, 'general.content.shop.image_search', '1', 'default', 'de', '2021-02-17 20:04:58', '2021-02-17 20:04:58'),
(62, 'general.content.shop.image_search', '1', 'default', 'es', '2021-02-17 20:04:58', '2021-02-17 20:04:58'),
(63, 'general.content.shop.image_search', '1', 'default', 'fa', '2021-02-17 20:04:58', '2021-02-17 20:04:58'),
(64, 'general.content.shop.image_search', '1', 'default', 'it', '2021-02-17 20:04:58', '2021-02-17 20:04:58'),
(65, 'general.content.shop.image_search', '1', 'default', 'ja', '2021-02-17 20:04:58', '2021-02-17 20:04:58'),
(66, 'general.content.shop.image_search', '1', 'default', 'nl', '2021-02-17 20:04:58', '2021-02-17 20:04:58'),
(67, 'general.content.shop.image_search', '1', 'default', 'pl', '2021-02-17 20:04:58', '2021-02-17 20:04:58'),
(68, 'general.content.shop.image_search', '1', 'default', 'pt_BR', '2021-02-17 20:04:58', '2021-02-17 20:04:58'),
(69, 'general.content.shop.image_search', '1', 'default', 'tr', '2021-02-17 20:04:58', '2021-02-17 20:04:58'),
(70, 'customer.settings.address.street_lines', '', 'default', NULL, '2021-03-02 16:52:17', '2021-03-02 16:52:17'),
(71, 'customer.settings.newsletter.subscription', '1', NULL, NULL, '2021-03-02 16:52:17', '2021-03-02 16:52:17'),
(72, 'customer.settings.email.verification', '0', NULL, NULL, '2021-03-02 16:52:17', '2021-03-02 16:52:17'),
(73, 'general.content.footer.footer_content', '', 'default', 'en', '2021-03-02 16:53:58', '2021-03-02 16:55:34'),
(74, 'general.content.footer.footer_toggle', '0', 'default', 'en', '2021-03-02 16:53:58', '2021-03-02 16:53:58'),
(75, 'general.content.custom_scripts.custom_css', '', 'default', NULL, '2021-03-02 16:53:58', '2021-03-02 16:53:58'),
(76, 'general.content.custom_scripts.custom_javascript', '', 'default', NULL, '2021-03-02 16:53:58', '2021-03-02 16:53:58'),
(77, 'catalog.products.homepage.no_of_new_product_homepage', '', NULL, NULL, '2021-03-02 16:56:41', '2021-03-02 16:56:41'),
(78, 'catalog.products.homepage.no_of_featured_product_homepage', '', NULL, NULL, '2021-03-02 16:56:41', '2021-03-02 16:56:41'),
(79, 'catalog.products.storefront.mode', 'grid', 'default', NULL, '2021-03-02 16:56:42', '2021-03-02 16:56:42'),
(80, 'catalog.products.storefront.products_per_page', '', 'default', NULL, '2021-03-02 16:56:42', '2021-03-02 16:56:42'),
(81, 'catalog.products.storefront.sort_by', 'name-asc', 'default', NULL, '2021-03-02 16:56:42', '2021-03-02 16:59:52'),
(82, 'catalog.products.storefront.buy_now_button_display', '1', NULL, NULL, '2021-03-02 16:56:42', '2021-03-02 16:59:52'),
(83, 'catalog.products.review.guest_review', '1', NULL, NULL, '2021-03-02 16:56:42', '2021-03-02 16:59:52'),
(84, 'catalog.products.attribute.image_attribute_upload_size', '', NULL, NULL, '2021-03-02 16:56:42', '2021-03-02 16:57:14'),
(85, 'catalog.products.attribute.file_attribute_upload_size', '', NULL, NULL, '2021-03-02 16:56:42', '2021-03-02 16:56:42'),
(86, 'catalog.products.social_share.enabled', '1', NULL, NULL, '2021-03-02 16:56:42', '2021-03-02 16:57:14'),
(87, 'catalog.products.social_share.facebook', '1', NULL, NULL, '2021-03-02 16:56:42', '2021-03-02 16:57:14'),
(88, 'catalog.products.social_share.twitter', '1', NULL, NULL, '2021-03-02 16:56:42', '2021-03-02 16:57:14'),
(89, 'catalog.products.social_share.pinterest', '1', NULL, NULL, '2021-03-02 16:56:42', '2021-03-02 16:57:14'),
(90, 'catalog.products.social_share.whatsapp', '1', NULL, NULL, '2021-03-02 16:56:42', '2021-03-02 16:57:14'),
(91, 'catalog.products.social_share.linkedin', '0', NULL, NULL, '2021-03-02 16:56:42', '2021-03-02 17:19:15'),
(92, 'catalog.products.social_share.email', '1', NULL, NULL, '2021-03-02 16:56:42', '2021-03-02 16:57:14'),
(93, 'catalog.products.social_share.share_message', '', NULL, NULL, '2021-03-02 16:56:42', '2021-03-02 16:56:42'),
(94, 'catalog.rich_snippets.products.enable', '1', NULL, NULL, '2021-03-02 17:00:31', '2021-03-02 17:00:31'),
(95, 'catalog.rich_snippets.products.show_sku', '0', NULL, NULL, '2021-03-02 17:00:31', '2021-03-02 17:00:31'),
(96, 'catalog.rich_snippets.products.show_weight', '0', NULL, NULL, '2021-03-02 17:00:31', '2021-03-02 17:00:31'),
(97, 'catalog.rich_snippets.products.show_categories', '1', NULL, NULL, '2021-03-02 17:00:31', '2021-03-02 17:00:31'),
(98, 'catalog.rich_snippets.products.show_images', '1', NULL, NULL, '2021-03-02 17:00:31', '2021-03-02 17:00:31'),
(99, 'catalog.rich_snippets.products.show_reviews', '1', NULL, NULL, '2021-03-02 17:00:31', '2021-03-02 17:00:31'),
(100, 'catalog.rich_snippets.products.show_ratings', '1', NULL, NULL, '2021-03-02 17:00:31', '2021-03-02 17:00:31'),
(101, 'catalog.rich_snippets.products.show_offers', '1', NULL, NULL, '2021-03-02 17:00:31', '2021-03-02 17:00:31'),
(102, 'catalog.rich_snippets.categories.enable', '1', NULL, NULL, '2021-03-02 17:00:31', '2021-03-02 17:00:31'),
(103, 'catalog.rich_snippets.categories.show_search_input_field', '1', NULL, NULL, '2021-03-02 17:00:31', '2021-03-02 17:00:31');

-- --------------------------------------------------------

--
-- Table structure for table `countries`
--

CREATE TABLE `countries` (
  `id` int(10) UNSIGNED NOT NULL,
  `code` varchar(191) NOT NULL,
  `name` varchar(191) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `countries`
--

INSERT INTO `countries` (`id`, `code`, `name`) VALUES
(1, 'AF', 'Afghanistan'),
(2, 'AX', 'Åland Islands'),
(3, 'AL', 'Albania'),
(4, 'DZ', 'Algeria'),
(5, 'AS', 'American Samoa'),
(6, 'AD', 'Andorra'),
(7, 'AO', 'Angola'),
(8, 'AI', 'Anguilla'),
(9, 'AQ', 'Antarctica'),
(10, 'AG', 'Antigua & Barbuda'),
(11, 'AR', 'Argentina'),
(12, 'AM', 'Armenia'),
(13, 'AW', 'Aruba'),
(14, 'AC', 'Ascension Island'),
(15, 'AU', 'Australia'),
(16, 'AT', 'Austria'),
(17, 'AZ', 'Azerbaijan'),
(18, 'BS', 'Bahamas'),
(19, 'BH', 'Bahrain'),
(20, 'BD', 'Bangladesh'),
(21, 'BB', 'Barbados'),
(22, 'BY', 'Belarus'),
(23, 'BE', 'Belgium'),
(24, 'BZ', 'Belize'),
(25, 'BJ', 'Benin'),
(26, 'BM', 'Bermuda'),
(27, 'BT', 'Bhutan'),
(28, 'BO', 'Bolivia'),
(29, 'BA', 'Bosnia & Herzegovina'),
(30, 'BW', 'Botswana'),
(31, 'BR', 'Brazil'),
(32, 'IO', 'British Indian Ocean Territory'),
(33, 'VG', 'British Virgin Islands'),
(34, 'BN', 'Brunei'),
(35, 'BG', 'Bulgaria'),
(36, 'BF', 'Burkina Faso'),
(37, 'BI', 'Burundi'),
(38, 'KH', 'Cambodia'),
(39, 'CM', 'Cameroon'),
(40, 'CA', 'Canada'),
(41, 'IC', 'Canary Islands'),
(42, 'CV', 'Cape Verde'),
(43, 'BQ', 'Caribbean Netherlands'),
(44, 'KY', 'Cayman Islands'),
(45, 'CF', 'Central African Republic'),
(46, 'EA', 'Ceuta & Melilla'),
(47, 'TD', 'Chad'),
(48, 'CL', 'Chile'),
(49, 'CN', 'China'),
(50, 'CX', 'Christmas Island'),
(51, 'CC', 'Cocos (Keeling) Islands'),
(52, 'CO', 'Colombia'),
(53, 'KM', 'Comoros'),
(54, 'CG', 'Congo - Brazzaville'),
(55, 'CD', 'Congo - Kinshasa'),
(56, 'CK', 'Cook Islands'),
(57, 'CR', 'Costa Rica'),
(58, 'CI', 'Côte d’Ivoire'),
(59, 'HR', 'Croatia'),
(60, 'CU', 'Cuba'),
(61, 'CW', 'Curaçao'),
(62, 'CY', 'Cyprus'),
(63, 'CZ', 'Czechia'),
(64, 'DK', 'Denmark'),
(65, 'DG', 'Diego Garcia'),
(66, 'DJ', 'Djibouti'),
(67, 'DM', 'Dominica'),
(68, 'DO', 'Dominican Republic'),
(69, 'EC', 'Ecuador'),
(70, 'EG', 'Egypt'),
(71, 'SV', 'El Salvador'),
(72, 'GQ', 'Equatorial Guinea'),
(73, 'ER', 'Eritrea'),
(74, 'EE', 'Estonia'),
(75, 'ET', 'Ethiopia'),
(76, 'EZ', 'Eurozone'),
(77, 'FK', 'Falkland Islands'),
(78, 'FO', 'Faroe Islands'),
(79, 'FJ', 'Fiji'),
(80, 'FI', 'Finland'),
(81, 'FR', 'France'),
(82, 'GF', 'French Guiana'),
(83, 'PF', 'French Polynesia'),
(84, 'TF', 'French Southern Territories'),
(85, 'GA', 'Gabon'),
(86, 'GM', 'Gambia'),
(87, 'GE', 'Georgia'),
(88, 'DE', 'Germany'),
(89, 'GH', 'Ghana'),
(90, 'GI', 'Gibraltar'),
(91, 'GR', 'Greece'),
(92, 'GL', 'Greenland'),
(93, 'GD', 'Grenada'),
(94, 'GP', 'Guadeloupe'),
(95, 'GU', 'Guam'),
(96, 'GT', 'Guatemala'),
(97, 'GG', 'Guernsey'),
(98, 'GN', 'Guinea'),
(99, 'GW', 'Guinea-Bissau'),
(100, 'GY', 'Guyana'),
(101, 'HT', 'Haiti'),
(102, 'HN', 'Honduras'),
(103, 'HK', 'Hong Kong SAR China'),
(104, 'HU', 'Hungary'),
(105, 'IS', 'Iceland'),
(106, 'IN', 'India'),
(107, 'ID', 'Indonesia'),
(108, 'IR', 'Iran'),
(109, 'IQ', 'Iraq'),
(110, 'IE', 'Ireland'),
(111, 'IM', 'Isle of Man'),
(112, 'IL', 'Israel'),
(113, 'IT', 'Italy'),
(114, 'JM', 'Jamaica'),
(115, 'JP', 'Japan'),
(116, 'JE', 'Jersey'),
(117, 'JO', 'Jordan'),
(118, 'KZ', 'Kazakhstan'),
(119, 'KE', 'Kenya'),
(120, 'KI', 'Kiribati'),
(121, 'XK', 'Kosovo'),
(122, 'KW', 'Kuwait'),
(123, 'KG', 'Kyrgyzstan'),
(124, 'LA', 'Laos'),
(125, 'LV', 'Latvia'),
(126, 'LB', 'Lebanon'),
(127, 'LS', 'Lesotho'),
(128, 'LR', 'Liberia'),
(129, 'LY', 'Libya'),
(130, 'LI', 'Liechtenstein'),
(131, 'LT', 'Lithuania'),
(132, 'LU', 'Luxembourg'),
(133, 'MO', 'Macau SAR China'),
(134, 'MK', 'Macedonia'),
(135, 'MG', 'Madagascar'),
(136, 'MW', 'Malawi'),
(137, 'MY', 'Malaysia'),
(138, 'MV', 'Maldives'),
(139, 'ML', 'Mali'),
(140, 'MT', 'Malta'),
(141, 'MH', 'Marshall Islands'),
(142, 'MQ', 'Martinique'),
(143, 'MR', 'Mauritania'),
(144, 'MU', 'Mauritius'),
(145, 'YT', 'Mayotte'),
(146, 'MX', 'Mexico'),
(147, 'FM', 'Micronesia'),
(148, 'MD', 'Moldova'),
(149, 'MC', 'Monaco'),
(150, 'MN', 'Mongolia'),
(151, 'ME', 'Montenegro'),
(152, 'MS', 'Montserrat'),
(153, 'MA', 'Morocco'),
(154, 'MZ', 'Mozambique'),
(155, 'MM', 'Myanmar (Burma)'),
(156, 'NA', 'Namibia'),
(157, 'NR', 'Nauru'),
(158, 'NP', 'Nepal'),
(159, 'NL', 'Netherlands'),
(160, 'NC', 'New Caledonia'),
(161, 'NZ', 'New Zealand'),
(162, 'NI', 'Nicaragua'),
(163, 'NE', 'Niger'),
(164, 'NG', 'Nigeria'),
(165, 'NU', 'Niue'),
(166, 'NF', 'Norfolk Island'),
(167, 'KP', 'North Korea'),
(168, 'MP', 'Northern Mariana Islands'),
(169, 'NO', 'Norway'),
(170, 'OM', 'Oman'),
(171, 'PK', 'Pakistan'),
(172, 'PW', 'Palau'),
(173, 'PS', 'Palestinian Territories'),
(174, 'PA', 'Panama'),
(175, 'PG', 'Papua New Guinea'),
(176, 'PY', 'Paraguay'),
(177, 'PE', 'Peru'),
(178, 'PH', 'Philippines'),
(179, 'PN', 'Pitcairn Islands'),
(180, 'PL', 'Poland'),
(181, 'PT', 'Portugal'),
(182, 'PR', 'Puerto Rico'),
(183, 'QA', 'Qatar'),
(184, 'RE', 'Réunion'),
(185, 'RO', 'Romania'),
(186, 'RU', 'Russia'),
(187, 'RW', 'Rwanda'),
(188, 'WS', 'Samoa'),
(189, 'SM', 'San Marino'),
(190, 'ST', 'São Tomé & Príncipe'),
(191, 'SA', 'Saudi Arabia'),
(192, 'SN', 'Senegal'),
(193, 'RS', 'Serbia'),
(194, 'SC', 'Seychelles'),
(195, 'SL', 'Sierra Leone'),
(196, 'SG', 'Singapore'),
(197, 'SX', 'Sint Maarten'),
(198, 'SK', 'Slovakia'),
(199, 'SI', 'Slovenia'),
(200, 'SB', 'Solomon Islands'),
(201, 'SO', 'Somalia'),
(202, 'ZA', 'South Africa'),
(203, 'GS', 'South Georgia & South Sandwich Islands'),
(204, 'KR', 'South Korea'),
(205, 'SS', 'South Sudan'),
(206, 'ES', 'Spain'),
(207, 'LK', 'Sri Lanka'),
(208, 'BL', 'St. Barthélemy'),
(209, 'SH', 'St. Helena'),
(210, 'KN', 'St. Kitts & Nevis'),
(211, 'LC', 'St. Lucia'),
(212, 'MF', 'St. Martin'),
(213, 'PM', 'St. Pierre & Miquelon'),
(214, 'VC', 'St. Vincent & Grenadines'),
(215, 'SD', 'Sudan'),
(216, 'SR', 'Suriname'),
(217, 'SJ', 'Svalbard & Jan Mayen'),
(218, 'SZ', 'Swaziland'),
(219, 'SE', 'Sweden'),
(220, 'CH', 'Switzerland'),
(221, 'SY', 'Syria'),
(222, 'TW', 'Taiwan'),
(223, 'TJ', 'Tajikistan'),
(224, 'TZ', 'Tanzania'),
(225, 'TH', 'Thailand'),
(226, 'TL', 'Timor-Leste'),
(227, 'TG', 'Togo'),
(228, 'TK', 'Tokelau'),
(229, 'TO', 'Tonga'),
(230, 'TT', 'Trinidad & Tobago'),
(231, 'TA', 'Tristan da Cunha'),
(232, 'TN', 'Tunisia'),
(233, 'TR', 'Turkey'),
(234, 'TM', 'Turkmenistan'),
(235, 'TC', 'Turks & Caicos Islands'),
(236, 'TV', 'Tuvalu'),
(237, 'UM', 'U.S. Outlying Islands'),
(238, 'VI', 'U.S. Virgin Islands'),
(239, 'UG', 'Uganda'),
(240, 'UA', 'Ukraine'),
(241, 'AE', 'United Arab Emirates'),
(242, 'GB', 'United Kingdom'),
(243, 'UN', 'United Nations'),
(244, 'US', 'United States'),
(245, 'UY', 'Uruguay'),
(246, 'UZ', 'Uzbekistan'),
(247, 'VU', 'Vanuatu'),
(248, 'VA', 'Vatican City'),
(249, 'VE', 'Venezuela'),
(250, 'VN', 'Vietnam'),
(251, 'WF', 'Wallis & Futuna'),
(252, 'EH', 'Western Sahara'),
(253, 'YE', 'Yemen'),
(254, 'ZM', 'Zambia'),
(255, 'ZW', 'Zimbabwe');

-- --------------------------------------------------------

--
-- Table structure for table `country_states`
--

CREATE TABLE `country_states` (
  `id` int(10) UNSIGNED NOT NULL,
  `country_code` varchar(191) DEFAULT NULL,
  `code` varchar(191) DEFAULT NULL,
  `default_name` varchar(191) DEFAULT NULL,
  `country_id` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `country_states`
--

INSERT INTO `country_states` (`id`, `country_code`, `code`, `default_name`, `country_id`) VALUES
(1, 'US', 'AL', 'Alabama', 244),
(2, 'US', 'AK', 'Alaska', 244),
(3, 'US', 'AS', 'American Samoa', 244),
(4, 'US', 'AZ', 'Arizona', 244),
(5, 'US', 'AR', 'Arkansas', 244),
(6, 'US', 'AE', 'Armed Forces Africa', 244),
(7, 'US', 'AA', 'Armed Forces Americas', 244),
(8, 'US', 'AE', 'Armed Forces Canada', 244),
(9, 'US', 'AE', 'Armed Forces Europe', 244),
(10, 'US', 'AE', 'Armed Forces Middle East', 244),
(11, 'US', 'AP', 'Armed Forces Pacific', 244),
(12, 'US', 'CA', 'California', 244),
(13, 'US', 'CO', 'Colorado', 244),
(14, 'US', 'CT', 'Connecticut', 244),
(15, 'US', 'DE', 'Delaware', 244),
(16, 'US', 'DC', 'District of Columbia', 244),
(17, 'US', 'FM', 'Federated States Of Micronesia', 244),
(18, 'US', 'FL', 'Florida', 244),
(19, 'US', 'GA', 'Georgia', 244),
(20, 'US', 'GU', 'Guam', 244),
(21, 'US', 'HI', 'Hawaii', 244),
(22, 'US', 'ID', 'Idaho', 244),
(23, 'US', 'IL', 'Illinois', 244),
(24, 'US', 'IN', 'Indiana', 244),
(25, 'US', 'IA', 'Iowa', 244),
(26, 'US', 'KS', 'Kansas', 244),
(27, 'US', 'KY', 'Kentucky', 244),
(28, 'US', 'LA', 'Louisiana', 244),
(29, 'US', 'ME', 'Maine', 244),
(30, 'US', 'MH', 'Marshall Islands', 244),
(31, 'US', 'MD', 'Maryland', 244),
(32, 'US', 'MA', 'Massachusetts', 244),
(33, 'US', 'MI', 'Michigan', 244),
(34, 'US', 'MN', 'Minnesota', 244),
(35, 'US', 'MS', 'Mississippi', 244),
(36, 'US', 'MO', 'Missouri', 244),
(37, 'US', 'MT', 'Montana', 244),
(38, 'US', 'NE', 'Nebraska', 244),
(39, 'US', 'NV', 'Nevada', 244),
(40, 'US', 'NH', 'New Hampshire', 244),
(41, 'US', 'NJ', 'New Jersey', 244),
(42, 'US', 'NM', 'New Mexico', 244),
(43, 'US', 'NY', 'New York', 244),
(44, 'US', 'NC', 'North Carolina', 244),
(45, 'US', 'ND', 'North Dakota', 244),
(46, 'US', 'MP', 'Northern Mariana Islands', 244),
(47, 'US', 'OH', 'Ohio', 244),
(48, 'US', 'OK', 'Oklahoma', 244),
(49, 'US', 'OR', 'Oregon', 244),
(50, 'US', 'PW', 'Palau', 244),
(51, 'US', 'PA', 'Pennsylvania', 244),
(52, 'US', 'PR', 'Puerto Rico', 244),
(53, 'US', 'RI', 'Rhode Island', 244),
(54, 'US', 'SC', 'South Carolina', 244),
(55, 'US', 'SD', 'South Dakota', 244),
(56, 'US', 'TN', 'Tennessee', 244),
(57, 'US', 'TX', 'Texas', 244),
(58, 'US', 'UT', 'Utah', 244),
(59, 'US', 'VT', 'Vermont', 244),
(60, 'US', 'VI', 'Virgin Islands', 244),
(61, 'US', 'VA', 'Virginia', 244),
(62, 'US', 'WA', 'Washington', 244),
(63, 'US', 'WV', 'West Virginia', 244),
(64, 'US', 'WI', 'Wisconsin', 244),
(65, 'US', 'WY', 'Wyoming', 244),
(66, 'CA', 'AB', 'Alberta', 40),
(67, 'CA', 'BC', 'British Columbia', 40),
(68, 'CA', 'MB', 'Manitoba', 40),
(69, 'CA', 'NL', 'Newfoundland and Labrador', 40),
(70, 'CA', 'NB', 'New Brunswick', 40),
(71, 'CA', 'NS', 'Nova Scotia', 40),
(72, 'CA', 'NT', 'Northwest Territories', 40),
(73, 'CA', 'NU', 'Nunavut', 40),
(74, 'CA', 'ON', 'Ontario', 40),
(75, 'CA', 'PE', 'Prince Edward Island', 40),
(76, 'CA', 'QC', 'Quebec', 40),
(77, 'CA', 'SK', 'Saskatchewan', 40),
(78, 'CA', 'YT', 'Yukon Territory', 40),
(79, 'DE', 'NDS', 'Niedersachsen', 88),
(80, 'DE', 'BAW', 'Baden-Württemberg', 88),
(81, 'DE', 'BAY', 'Bayern', 88),
(82, 'DE', 'BER', 'Berlin', 88),
(83, 'DE', 'BRG', 'Brandenburg', 88),
(84, 'DE', 'BRE', 'Bremen', 88),
(85, 'DE', 'HAM', 'Hamburg', 88),
(86, 'DE', 'HES', 'Hessen', 88),
(87, 'DE', 'MEC', 'Mecklenburg-Vorpommern', 88),
(88, 'DE', 'NRW', 'Nordrhein-Westfalen', 88),
(89, 'DE', 'RHE', 'Rheinland-Pfalz', 88),
(90, 'DE', 'SAR', 'Saarland', 88),
(91, 'DE', 'SAS', 'Sachsen', 88),
(92, 'DE', 'SAC', 'Sachsen-Anhalt', 88),
(93, 'DE', 'SCN', 'Schleswig-Holstein', 88),
(94, 'DE', 'THE', 'Thüringen', 88),
(95, 'AT', 'WI', 'Wien', 16),
(96, 'AT', 'NO', 'Niederösterreich', 16),
(97, 'AT', 'OO', 'Oberösterreich', 16),
(98, 'AT', 'SB', 'Salzburg', 16),
(99, 'AT', 'KN', 'Kärnten', 16),
(100, 'AT', 'ST', 'Steiermark', 16),
(101, 'AT', 'TI', 'Tirol', 16),
(102, 'AT', 'BL', 'Burgenland', 16),
(103, 'AT', 'VB', 'Vorarlberg', 16),
(104, 'CH', 'AG', 'Aargau', 220),
(105, 'CH', 'AI', 'Appenzell Innerrhoden', 220),
(106, 'CH', 'AR', 'Appenzell Ausserrhoden', 220),
(107, 'CH', 'BE', 'Bern', 220),
(108, 'CH', 'BL', 'Basel-Landschaft', 220),
(109, 'CH', 'BS', 'Basel-Stadt', 220),
(110, 'CH', 'FR', 'Freiburg', 220),
(111, 'CH', 'GE', 'Genf', 220),
(112, 'CH', 'GL', 'Glarus', 220),
(113, 'CH', 'GR', 'Graubünden', 220),
(114, 'CH', 'JU', 'Jura', 220),
(115, 'CH', 'LU', 'Luzern', 220),
(116, 'CH', 'NE', 'Neuenburg', 220),
(117, 'CH', 'NW', 'Nidwalden', 220),
(118, 'CH', 'OW', 'Obwalden', 220),
(119, 'CH', 'SG', 'St. Gallen', 220),
(120, 'CH', 'SH', 'Schaffhausen', 220),
(121, 'CH', 'SO', 'Solothurn', 220),
(122, 'CH', 'SZ', 'Schwyz', 220),
(123, 'CH', 'TG', 'Thurgau', 220),
(124, 'CH', 'TI', 'Tessin', 220),
(125, 'CH', 'UR', 'Uri', 220),
(126, 'CH', 'VD', 'Waadt', 220),
(127, 'CH', 'VS', 'Wallis', 220),
(128, 'CH', 'ZG', 'Zug', 220),
(129, 'CH', 'ZH', 'Zürich', 220),
(130, 'ES', 'A Coruсa', 'A Coruña', 206),
(131, 'ES', 'Alava', 'Alava', 206),
(132, 'ES', 'Albacete', 'Albacete', 206),
(133, 'ES', 'Alicante', 'Alicante', 206),
(134, 'ES', 'Almeria', 'Almeria', 206),
(135, 'ES', 'Asturias', 'Asturias', 206),
(136, 'ES', 'Avila', 'Avila', 206),
(137, 'ES', 'Badajoz', 'Badajoz', 206),
(138, 'ES', 'Baleares', 'Baleares', 206),
(139, 'ES', 'Barcelona', 'Barcelona', 206),
(140, 'ES', 'Burgos', 'Burgos', 206),
(141, 'ES', 'Caceres', 'Caceres', 206),
(142, 'ES', 'Cadiz', 'Cadiz', 206),
(143, 'ES', 'Cantabria', 'Cantabria', 206),
(144, 'ES', 'Castellon', 'Castellon', 206),
(145, 'ES', 'Ceuta', 'Ceuta', 206),
(146, 'ES', 'Ciudad Real', 'Ciudad Real', 206),
(147, 'ES', 'Cordoba', 'Cordoba', 206),
(148, 'ES', 'Cuenca', 'Cuenca', 206),
(149, 'ES', 'Girona', 'Girona', 206),
(150, 'ES', 'Granada', 'Granada', 206),
(151, 'ES', 'Guadalajara', 'Guadalajara', 206),
(152, 'ES', 'Guipuzcoa', 'Guipuzcoa', 206),
(153, 'ES', 'Huelva', 'Huelva', 206),
(154, 'ES', 'Huesca', 'Huesca', 206),
(155, 'ES', 'Jaen', 'Jaen', 206),
(156, 'ES', 'La Rioja', 'La Rioja', 206),
(157, 'ES', 'Las Palmas', 'Las Palmas', 206),
(158, 'ES', 'Leon', 'Leon', 206),
(159, 'ES', 'Lleida', 'Lleida', 206),
(160, 'ES', 'Lugo', 'Lugo', 206),
(161, 'ES', 'Madrid', 'Madrid', 206),
(162, 'ES', 'Malaga', 'Malaga', 206),
(163, 'ES', 'Melilla', 'Melilla', 206),
(164, 'ES', 'Murcia', 'Murcia', 206),
(165, 'ES', 'Navarra', 'Navarra', 206),
(166, 'ES', 'Ourense', 'Ourense', 206),
(167, 'ES', 'Palencia', 'Palencia', 206),
(168, 'ES', 'Pontevedra', 'Pontevedra', 206),
(169, 'ES', 'Salamanca', 'Salamanca', 206),
(170, 'ES', 'Santa Cruz de Tenerife', 'Santa Cruz de Tenerife', 206),
(171, 'ES', 'Segovia', 'Segovia', 206),
(172, 'ES', 'Sevilla', 'Sevilla', 206),
(173, 'ES', 'Soria', 'Soria', 206),
(174, 'ES', 'Tarragona', 'Tarragona', 206),
(175, 'ES', 'Teruel', 'Teruel', 206),
(176, 'ES', 'Toledo', 'Toledo', 206),
(177, 'ES', 'Valencia', 'Valencia', 206),
(178, 'ES', 'Valladolid', 'Valladolid', 206),
(179, 'ES', 'Vizcaya', 'Vizcaya', 206),
(180, 'ES', 'Zamora', 'Zamora', 206),
(181, 'ES', 'Zaragoza', 'Zaragoza', 206),
(182, 'FR', '1', 'Ain', 81),
(183, 'FR', '2', 'Aisne', 81),
(184, 'FR', '3', 'Allier', 81),
(185, 'FR', '4', 'Alpes-de-Haute-Provence', 81),
(186, 'FR', '5', 'Hautes-Alpes', 81),
(187, 'FR', '6', 'Alpes-Maritimes', 81),
(188, 'FR', '7', 'Ardèche', 81),
(189, 'FR', '8', 'Ardennes', 81),
(190, 'FR', '9', 'Ariège', 81),
(191, 'FR', '10', 'Aube', 81),
(192, 'FR', '11', 'Aude', 81),
(193, 'FR', '12', 'Aveyron', 81),
(194, 'FR', '13', 'Bouches-du-Rhône', 81),
(195, 'FR', '14', 'Calvados', 81),
(196, 'FR', '15', 'Cantal', 81),
(197, 'FR', '16', 'Charente', 81),
(198, 'FR', '17', 'Charente-Maritime', 81),
(199, 'FR', '18', 'Cher', 81),
(200, 'FR', '19', 'Corrèze', 81),
(201, 'FR', '2A', 'Corse-du-Sud', 81),
(202, 'FR', '2B', 'Haute-Corse', 81),
(203, 'FR', '21', 'Côte-d\'Or', 81),
(204, 'FR', '22', 'Côtes-d\'Armor', 81),
(205, 'FR', '23', 'Creuse', 81),
(206, 'FR', '24', 'Dordogne', 81),
(207, 'FR', '25', 'Doubs', 81),
(208, 'FR', '26', 'Drôme', 81),
(209, 'FR', '27', 'Eure', 81),
(210, 'FR', '28', 'Eure-et-Loir', 81),
(211, 'FR', '29', 'Finistère', 81),
(212, 'FR', '30', 'Gard', 81),
(213, 'FR', '31', 'Haute-Garonne', 81),
(214, 'FR', '32', 'Gers', 81),
(215, 'FR', '33', 'Gironde', 81),
(216, 'FR', '34', 'Hérault', 81),
(217, 'FR', '35', 'Ille-et-Vilaine', 81),
(218, 'FR', '36', 'Indre', 81),
(219, 'FR', '37', 'Indre-et-Loire', 81),
(220, 'FR', '38', 'Isère', 81),
(221, 'FR', '39', 'Jura', 81),
(222, 'FR', '40', 'Landes', 81),
(223, 'FR', '41', 'Loir-et-Cher', 81),
(224, 'FR', '42', 'Loire', 81),
(225, 'FR', '43', 'Haute-Loire', 81),
(226, 'FR', '44', 'Loire-Atlantique', 81),
(227, 'FR', '45', 'Loiret', 81),
(228, 'FR', '46', 'Lot', 81),
(229, 'FR', '47', 'Lot-et-Garonne', 81),
(230, 'FR', '48', 'Lozère', 81),
(231, 'FR', '49', 'Maine-et-Loire', 81),
(232, 'FR', '50', 'Manche', 81),
(233, 'FR', '51', 'Marne', 81),
(234, 'FR', '52', 'Haute-Marne', 81),
(235, 'FR', '53', 'Mayenne', 81),
(236, 'FR', '54', 'Meurthe-et-Moselle', 81),
(237, 'FR', '55', 'Meuse', 81),
(238, 'FR', '56', 'Morbihan', 81),
(239, 'FR', '57', 'Moselle', 81),
(240, 'FR', '58', 'Nièvre', 81),
(241, 'FR', '59', 'Nord', 81),
(242, 'FR', '60', 'Oise', 81),
(243, 'FR', '61', 'Orne', 81),
(244, 'FR', '62', 'Pas-de-Calais', 81),
(245, 'FR', '63', 'Puy-de-Dôme', 81),
(246, 'FR', '64', 'Pyrénées-Atlantiques', 81),
(247, 'FR', '65', 'Hautes-Pyrénées', 81),
(248, 'FR', '66', 'Pyrénées-Orientales', 81),
(249, 'FR', '67', 'Bas-Rhin', 81),
(250, 'FR', '68', 'Haut-Rhin', 81),
(251, 'FR', '69', 'Rhône', 81),
(252, 'FR', '70', 'Haute-Saône', 81),
(253, 'FR', '71', 'Saône-et-Loire', 81),
(254, 'FR', '72', 'Sarthe', 81),
(255, 'FR', '73', 'Savoie', 81),
(256, 'FR', '74', 'Haute-Savoie', 81),
(257, 'FR', '75', 'Paris', 81),
(258, 'FR', '76', 'Seine-Maritime', 81),
(259, 'FR', '77', 'Seine-et-Marne', 81),
(260, 'FR', '78', 'Yvelines', 81),
(261, 'FR', '79', 'Deux-Sèvres', 81),
(262, 'FR', '80', 'Somme', 81),
(263, 'FR', '81', 'Tarn', 81),
(264, 'FR', '82', 'Tarn-et-Garonne', 81),
(265, 'FR', '83', 'Var', 81),
(266, 'FR', '84', 'Vaucluse', 81),
(267, 'FR', '85', 'Vendée', 81),
(268, 'FR', '86', 'Vienne', 81),
(269, 'FR', '87', 'Haute-Vienne', 81),
(270, 'FR', '88', 'Vosges', 81),
(271, 'FR', '89', 'Yonne', 81),
(272, 'FR', '90', 'Territoire-de-Belfort', 81),
(273, 'FR', '91', 'Essonne', 81),
(274, 'FR', '92', 'Hauts-de-Seine', 81),
(275, 'FR', '93', 'Seine-Saint-Denis', 81),
(276, 'FR', '94', 'Val-de-Marne', 81),
(277, 'FR', '95', 'Val-d\'Oise', 81),
(278, 'RO', 'AB', 'Alba', 185),
(279, 'RO', 'AR', 'Arad', 185),
(280, 'RO', 'AG', 'Argeş', 185),
(281, 'RO', 'BC', 'Bacău', 185),
(282, 'RO', 'BH', 'Bihor', 185),
(283, 'RO', 'BN', 'Bistriţa-Năsăud', 185),
(284, 'RO', 'BT', 'Botoşani', 185),
(285, 'RO', 'BV', 'Braşov', 185),
(286, 'RO', 'BR', 'Brăila', 185),
(287, 'RO', 'B', 'Bucureşti', 185),
(288, 'RO', 'BZ', 'Buzău', 185),
(289, 'RO', 'CS', 'Caraş-Severin', 185),
(290, 'RO', 'CL', 'Călăraşi', 185),
(291, 'RO', 'CJ', 'Cluj', 185),
(292, 'RO', 'CT', 'Constanţa', 185),
(293, 'RO', 'CV', 'Covasna', 185),
(294, 'RO', 'DB', 'Dâmboviţa', 185),
(295, 'RO', 'DJ', 'Dolj', 185),
(296, 'RO', 'GL', 'Galaţi', 185),
(297, 'RO', 'GR', 'Giurgiu', 185),
(298, 'RO', 'GJ', 'Gorj', 185),
(299, 'RO', 'HR', 'Harghita', 185),
(300, 'RO', 'HD', 'Hunedoara', 185),
(301, 'RO', 'IL', 'Ialomiţa', 185),
(302, 'RO', 'IS', 'Iaşi', 185),
(303, 'RO', 'IF', 'Ilfov', 185),
(304, 'RO', 'MM', 'Maramureş', 185),
(305, 'RO', 'MH', 'Mehedinţi', 185),
(306, 'RO', 'MS', 'Mureş', 185),
(307, 'RO', 'NT', 'Neamţ', 185),
(308, 'RO', 'OT', 'Olt', 185),
(309, 'RO', 'PH', 'Prahova', 185),
(310, 'RO', 'SM', 'Satu-Mare', 185),
(311, 'RO', 'SJ', 'Sălaj', 185),
(312, 'RO', 'SB', 'Sibiu', 185),
(313, 'RO', 'SV', 'Suceava', 185),
(314, 'RO', 'TR', 'Teleorman', 185),
(315, 'RO', 'TM', 'Timiş', 185),
(316, 'RO', 'TL', 'Tulcea', 185),
(317, 'RO', 'VS', 'Vaslui', 185),
(318, 'RO', 'VL', 'Vâlcea', 185),
(319, 'RO', 'VN', 'Vrancea', 185),
(320, 'FI', 'Lappi', 'Lappi', 80),
(321, 'FI', 'Pohjois-Pohjanmaa', 'Pohjois-Pohjanmaa', 80),
(322, 'FI', 'Kainuu', 'Kainuu', 80),
(323, 'FI', 'Pohjois-Karjala', 'Pohjois-Karjala', 80),
(324, 'FI', 'Pohjois-Savo', 'Pohjois-Savo', 80),
(325, 'FI', 'Etelä-Savo', 'Etelä-Savo', 80),
(326, 'FI', 'Etelä-Pohjanmaa', 'Etelä-Pohjanmaa', 80),
(327, 'FI', 'Pohjanmaa', 'Pohjanmaa', 80),
(328, 'FI', 'Pirkanmaa', 'Pirkanmaa', 80),
(329, 'FI', 'Satakunta', 'Satakunta', 80),
(330, 'FI', 'Keski-Pohjanmaa', 'Keski-Pohjanmaa', 80),
(331, 'FI', 'Keski-Suomi', 'Keski-Suomi', 80),
(332, 'FI', 'Varsinais-Suomi', 'Varsinais-Suomi', 80),
(333, 'FI', 'Etelä-Karjala', 'Etelä-Karjala', 80),
(334, 'FI', 'Päijät-Häme', 'Päijät-Häme', 80),
(335, 'FI', 'Kanta-Häme', 'Kanta-Häme', 80),
(336, 'FI', 'Uusimaa', 'Uusimaa', 80),
(337, 'FI', 'Itä-Uusimaa', 'Itä-Uusimaa', 80),
(338, 'FI', 'Kymenlaakso', 'Kymenlaakso', 80),
(339, 'FI', 'Ahvenanmaa', 'Ahvenanmaa', 80),
(340, 'EE', 'EE-37', 'Harjumaa', 74),
(341, 'EE', 'EE-39', 'Hiiumaa', 74),
(342, 'EE', 'EE-44', 'Ida-Virumaa', 74),
(343, 'EE', 'EE-49', 'Jõgevamaa', 74),
(344, 'EE', 'EE-51', 'Järvamaa', 74),
(345, 'EE', 'EE-57', 'Läänemaa', 74),
(346, 'EE', 'EE-59', 'Lääne-Virumaa', 74),
(347, 'EE', 'EE-65', 'Põlvamaa', 74),
(348, 'EE', 'EE-67', 'Pärnumaa', 74),
(349, 'EE', 'EE-70', 'Raplamaa', 74),
(350, 'EE', 'EE-74', 'Saaremaa', 74),
(351, 'EE', 'EE-78', 'Tartumaa', 74),
(352, 'EE', 'EE-82', 'Valgamaa', 74),
(353, 'EE', 'EE-84', 'Viljandimaa', 74),
(354, 'EE', 'EE-86', 'Võrumaa', 74),
(355, 'LV', 'LV-DGV', 'Daugavpils', 125),
(356, 'LV', 'LV-JEL', 'Jelgava', 125),
(357, 'LV', 'Jēkabpils', 'Jēkabpils', 125),
(358, 'LV', 'LV-JUR', 'Jūrmala', 125),
(359, 'LV', 'LV-LPX', 'Liepāja', 125),
(360, 'LV', 'LV-LE', 'Liepājas novads', 125),
(361, 'LV', 'LV-REZ', 'Rēzekne', 125),
(362, 'LV', 'LV-RIX', 'Rīga', 125),
(363, 'LV', 'LV-RI', 'Rīgas novads', 125),
(364, 'LV', 'Valmiera', 'Valmiera', 125),
(365, 'LV', 'LV-VEN', 'Ventspils', 125),
(366, 'LV', 'Aglonas novads', 'Aglonas novads', 125),
(367, 'LV', 'LV-AI', 'Aizkraukles novads', 125),
(368, 'LV', 'Aizputes novads', 'Aizputes novads', 125),
(369, 'LV', 'Aknīstes novads', 'Aknīstes novads', 125),
(370, 'LV', 'Alojas novads', 'Alojas novads', 125),
(371, 'LV', 'Alsungas novads', 'Alsungas novads', 125),
(372, 'LV', 'LV-AL', 'Alūksnes novads', 125),
(373, 'LV', 'Amatas novads', 'Amatas novads', 125),
(374, 'LV', 'Apes novads', 'Apes novads', 125),
(375, 'LV', 'Auces novads', 'Auces novads', 125),
(376, 'LV', 'Babītes novads', 'Babītes novads', 125),
(377, 'LV', 'Baldones novads', 'Baldones novads', 125),
(378, 'LV', 'Baltinavas novads', 'Baltinavas novads', 125),
(379, 'LV', 'LV-BL', 'Balvu novads', 125),
(380, 'LV', 'LV-BU', 'Bauskas novads', 125),
(381, 'LV', 'Beverīnas novads', 'Beverīnas novads', 125),
(382, 'LV', 'Brocēnu novads', 'Brocēnu novads', 125),
(383, 'LV', 'Burtnieku novads', 'Burtnieku novads', 125),
(384, 'LV', 'Carnikavas novads', 'Carnikavas novads', 125),
(385, 'LV', 'Cesvaines novads', 'Cesvaines novads', 125),
(386, 'LV', 'Ciblas novads', 'Ciblas novads', 125),
(387, 'LV', 'LV-CE', 'Cēsu novads', 125),
(388, 'LV', 'Dagdas novads', 'Dagdas novads', 125),
(389, 'LV', 'LV-DA', 'Daugavpils novads', 125),
(390, 'LV', 'LV-DO', 'Dobeles novads', 125),
(391, 'LV', 'Dundagas novads', 'Dundagas novads', 125),
(392, 'LV', 'Durbes novads', 'Durbes novads', 125),
(393, 'LV', 'Engures novads', 'Engures novads', 125),
(394, 'LV', 'Garkalnes novads', 'Garkalnes novads', 125),
(395, 'LV', 'Grobiņas novads', 'Grobiņas novads', 125),
(396, 'LV', 'LV-GU', 'Gulbenes novads', 125),
(397, 'LV', 'Iecavas novads', 'Iecavas novads', 125),
(398, 'LV', 'Ikšķiles novads', 'Ikšķiles novads', 125),
(399, 'LV', 'Ilūkstes novads', 'Ilūkstes novads', 125),
(400, 'LV', 'Inčukalna novads', 'Inčukalna novads', 125),
(401, 'LV', 'Jaunjelgavas novads', 'Jaunjelgavas novads', 125),
(402, 'LV', 'Jaunpiebalgas novads', 'Jaunpiebalgas novads', 125),
(403, 'LV', 'Jaunpils novads', 'Jaunpils novads', 125),
(404, 'LV', 'LV-JL', 'Jelgavas novads', 125),
(405, 'LV', 'LV-JK', 'Jēkabpils novads', 125),
(406, 'LV', 'Kandavas novads', 'Kandavas novads', 125),
(407, 'LV', 'Kokneses novads', 'Kokneses novads', 125),
(408, 'LV', 'Krimuldas novads', 'Krimuldas novads', 125),
(409, 'LV', 'Krustpils novads', 'Krustpils novads', 125),
(410, 'LV', 'LV-KR', 'Krāslavas novads', 125),
(411, 'LV', 'LV-KU', 'Kuldīgas novads', 125),
(412, 'LV', 'Kārsavas novads', 'Kārsavas novads', 125),
(413, 'LV', 'Lielvārdes novads', 'Lielvārdes novads', 125),
(414, 'LV', 'LV-LM', 'Limbažu novads', 125),
(415, 'LV', 'Lubānas novads', 'Lubānas novads', 125),
(416, 'LV', 'LV-LU', 'Ludzas novads', 125),
(417, 'LV', 'Līgatnes novads', 'Līgatnes novads', 125),
(418, 'LV', 'Līvānu novads', 'Līvānu novads', 125),
(419, 'LV', 'LV-MA', 'Madonas novads', 125),
(420, 'LV', 'Mazsalacas novads', 'Mazsalacas novads', 125),
(421, 'LV', 'Mālpils novads', 'Mālpils novads', 125),
(422, 'LV', 'Mārupes novads', 'Mārupes novads', 125),
(423, 'LV', 'Naukšēnu novads', 'Naukšēnu novads', 125),
(424, 'LV', 'Neretas novads', 'Neretas novads', 125),
(425, 'LV', 'Nīcas novads', 'Nīcas novads', 125),
(426, 'LV', 'LV-OG', 'Ogres novads', 125),
(427, 'LV', 'Olaines novads', 'Olaines novads', 125),
(428, 'LV', 'Ozolnieku novads', 'Ozolnieku novads', 125),
(429, 'LV', 'LV-PR', 'Preiļu novads', 125),
(430, 'LV', 'Priekules novads', 'Priekules novads', 125),
(431, 'LV', 'Priekuļu novads', 'Priekuļu novads', 125),
(432, 'LV', 'Pārgaujas novads', 'Pārgaujas novads', 125),
(433, 'LV', 'Pāvilostas novads', 'Pāvilostas novads', 125),
(434, 'LV', 'Pļaviņu novads', 'Pļaviņu novads', 125),
(435, 'LV', 'Raunas novads', 'Raunas novads', 125),
(436, 'LV', 'Riebiņu novads', 'Riebiņu novads', 125),
(437, 'LV', 'Rojas novads', 'Rojas novads', 125),
(438, 'LV', 'Ropažu novads', 'Ropažu novads', 125),
(439, 'LV', 'Rucavas novads', 'Rucavas novads', 125),
(440, 'LV', 'Rugāju novads', 'Rugāju novads', 125),
(441, 'LV', 'Rundāles novads', 'Rundāles novads', 125),
(442, 'LV', 'LV-RE', 'Rēzeknes novads', 125),
(443, 'LV', 'Rūjienas novads', 'Rūjienas novads', 125),
(444, 'LV', 'Salacgrīvas novads', 'Salacgrīvas novads', 125),
(445, 'LV', 'Salas novads', 'Salas novads', 125),
(446, 'LV', 'Salaspils novads', 'Salaspils novads', 125),
(447, 'LV', 'LV-SA', 'Saldus novads', 125),
(448, 'LV', 'Saulkrastu novads', 'Saulkrastu novads', 125),
(449, 'LV', 'Siguldas novads', 'Siguldas novads', 125),
(450, 'LV', 'Skrundas novads', 'Skrundas novads', 125),
(451, 'LV', 'Skrīveru novads', 'Skrīveru novads', 125),
(452, 'LV', 'Smiltenes novads', 'Smiltenes novads', 125),
(453, 'LV', 'Stopiņu novads', 'Stopiņu novads', 125),
(454, 'LV', 'Strenču novads', 'Strenču novads', 125),
(455, 'LV', 'Sējas novads', 'Sējas novads', 125),
(456, 'LV', 'LV-TA', 'Talsu novads', 125),
(457, 'LV', 'LV-TU', 'Tukuma novads', 125),
(458, 'LV', 'Tērvetes novads', 'Tērvetes novads', 125),
(459, 'LV', 'Vaiņodes novads', 'Vaiņodes novads', 125),
(460, 'LV', 'LV-VK', 'Valkas novads', 125),
(461, 'LV', 'LV-VM', 'Valmieras novads', 125),
(462, 'LV', 'Varakļānu novads', 'Varakļānu novads', 125),
(463, 'LV', 'Vecpiebalgas novads', 'Vecpiebalgas novads', 125),
(464, 'LV', 'Vecumnieku novads', 'Vecumnieku novads', 125),
(465, 'LV', 'LV-VE', 'Ventspils novads', 125),
(466, 'LV', 'Viesītes novads', 'Viesītes novads', 125),
(467, 'LV', 'Viļakas novads', 'Viļakas novads', 125),
(468, 'LV', 'Viļānu novads', 'Viļānu novads', 125),
(469, 'LV', 'Vārkavas novads', 'Vārkavas novads', 125),
(470, 'LV', 'Zilupes novads', 'Zilupes novads', 125),
(471, 'LV', 'Ādažu novads', 'Ādažu novads', 125),
(472, 'LV', 'Ērgļu novads', 'Ērgļu novads', 125),
(473, 'LV', 'Ķeguma novads', 'Ķeguma novads', 125),
(474, 'LV', 'Ķekavas novads', 'Ķekavas novads', 125),
(475, 'LT', 'LT-AL', 'Alytaus Apskritis', 131),
(476, 'LT', 'LT-KU', 'Kauno Apskritis', 131),
(477, 'LT', 'LT-KL', 'Klaipėdos Apskritis', 131),
(478, 'LT', 'LT-MR', 'Marijampolės Apskritis', 131),
(479, 'LT', 'LT-PN', 'Panevėžio Apskritis', 131),
(480, 'LT', 'LT-SA', 'Šiaulių Apskritis', 131),
(481, 'LT', 'LT-TA', 'Tauragės Apskritis', 131),
(482, 'LT', 'LT-TE', 'Telšių Apskritis', 131),
(483, 'LT', 'LT-UT', 'Utenos Apskritis', 131),
(484, 'LT', 'LT-VL', 'Vilniaus Apskritis', 131),
(485, 'BR', 'AC', 'Acre', 31),
(486, 'BR', 'AL', 'Alagoas', 31),
(487, 'BR', 'AP', 'Amapá', 31),
(488, 'BR', 'AM', 'Amazonas', 31),
(489, 'BR', 'BA', 'Bahia', 31),
(490, 'BR', 'CE', 'Ceará', 31),
(491, 'BR', 'ES', 'Espírito Santo', 31),
(492, 'BR', 'GO', 'Goiás', 31),
(493, 'BR', 'MA', 'Maranhão', 31),
(494, 'BR', 'MT', 'Mato Grosso', 31),
(495, 'BR', 'MS', 'Mato Grosso do Sul', 31),
(496, 'BR', 'MG', 'Minas Gerais', 31),
(497, 'BR', 'PA', 'Pará', 31),
(498, 'BR', 'PB', 'Paraíba', 31),
(499, 'BR', 'PR', 'Paraná', 31),
(500, 'BR', 'PE', 'Pernambuco', 31),
(501, 'BR', 'PI', 'Piauí', 31),
(502, 'BR', 'RJ', 'Rio de Janeiro', 31),
(503, 'BR', 'RN', 'Rio Grande do Norte', 31),
(504, 'BR', 'RS', 'Rio Grande do Sul', 31),
(505, 'BR', 'RO', 'Rondônia', 31),
(506, 'BR', 'RR', 'Roraima', 31),
(507, 'BR', 'SC', 'Santa Catarina', 31),
(508, 'BR', 'SP', 'São Paulo', 31),
(509, 'BR', 'SE', 'Sergipe', 31),
(510, 'BR', 'TO', 'Tocantins', 31),
(511, 'BR', 'DF', 'Distrito Federal', 31),
(512, 'HR', 'HR-01', 'Zagrebačka županija', 59),
(513, 'HR', 'HR-02', 'Krapinsko-zagorska županija', 59),
(514, 'HR', 'HR-03', 'Sisačko-moslavačka županija', 59),
(515, 'HR', 'HR-04', 'Karlovačka županija', 59),
(516, 'HR', 'HR-05', 'Varaždinska županija', 59),
(517, 'HR', 'HR-06', 'Koprivničko-križevačka županija', 59),
(518, 'HR', 'HR-07', 'Bjelovarsko-bilogorska županija', 59),
(519, 'HR', 'HR-08', 'Primorsko-goranska županija', 59),
(520, 'HR', 'HR-09', 'Ličko-senjska županija', 59),
(521, 'HR', 'HR-10', 'Virovitičko-podravska županija', 59),
(522, 'HR', 'HR-11', 'Požeško-slavonska županija', 59),
(523, 'HR', 'HR-12', 'Brodsko-posavska županija', 59),
(524, 'HR', 'HR-13', 'Zadarska županija', 59),
(525, 'HR', 'HR-14', 'Osječko-baranjska županija', 59),
(526, 'HR', 'HR-15', 'Šibensko-kninska županija', 59),
(527, 'HR', 'HR-16', 'Vukovarsko-srijemska županija', 59),
(528, 'HR', 'HR-17', 'Splitsko-dalmatinska županija', 59),
(529, 'HR', 'HR-18', 'Istarska županija', 59),
(530, 'HR', 'HR-19', 'Dubrovačko-neretvanska županija', 59),
(531, 'HR', 'HR-20', 'Međimurska županija', 59),
(532, 'HR', 'HR-21', 'Grad Zagreb', 59),
(533, 'IN', 'AN', 'Andaman and Nicobar Islands', 106),
(534, 'IN', 'AP', 'Andhra Pradesh', 106),
(535, 'IN', 'AR', 'Arunachal Pradesh', 106),
(536, 'IN', 'AS', 'Assam', 106),
(537, 'IN', 'BR', 'Bihar', 106),
(538, 'IN', 'CH', 'Chandigarh', 106),
(539, 'IN', 'CT', 'Chhattisgarh', 106),
(540, 'IN', 'DN', 'Dadra and Nagar Haveli', 106),
(541, 'IN', 'DD', 'Daman and Diu', 106),
(542, 'IN', 'DL', 'Delhi', 106),
(543, 'IN', 'GA', 'Goa', 106),
(544, 'IN', 'GJ', 'Gujarat', 106),
(545, 'IN', 'HR', 'Haryana', 106),
(546, 'IN', 'HP', 'Himachal Pradesh', 106),
(547, 'IN', 'JK', 'Jammu and Kashmir', 106),
(548, 'IN', 'JH', 'Jharkhand', 106),
(549, 'IN', 'KA', 'Karnataka', 106),
(550, 'IN', 'KL', 'Kerala', 106),
(551, 'IN', 'LD', 'Lakshadweep', 106),
(552, 'IN', 'MP', 'Madhya Pradesh', 106),
(553, 'IN', 'MH', 'Maharashtra', 106),
(554, 'IN', 'MN', 'Manipur', 106),
(555, 'IN', 'ML', 'Meghalaya', 106),
(556, 'IN', 'MZ', 'Mizoram', 106),
(557, 'IN', 'NL', 'Nagaland', 106),
(558, 'IN', 'OR', 'Odisha', 106),
(559, 'IN', 'PY', 'Puducherry', 106),
(560, 'IN', 'PB', 'Punjab', 106),
(561, 'IN', 'RJ', 'Rajasthan', 106),
(562, 'IN', 'SK', 'Sikkim', 106),
(563, 'IN', 'TN', 'Tamil Nadu', 106),
(564, 'IN', 'TG', 'Telangana', 106),
(565, 'IN', 'TR', 'Tripura', 106),
(566, 'IN', 'UP', 'Uttar Pradesh', 106),
(567, 'IN', 'UT', 'Uttarakhand', 106),
(568, 'IN', 'WB', 'West Bengal', 106);

-- --------------------------------------------------------

--
-- Table structure for table `country_state_translations`
--

CREATE TABLE `country_state_translations` (
  `id` int(10) UNSIGNED NOT NULL,
  `locale` varchar(191) NOT NULL,
  `default_name` text DEFAULT NULL,
  `country_state_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `country_state_translations`
--

INSERT INTO `country_state_translations` (`id`, `locale`, `default_name`, `country_state_id`) VALUES
(1705, 'ar', 'ألاباما', 1),
(1706, 'ar', 'ألاسكا', 2),
(1707, 'ar', 'ساموا الأمريكية', 3),
(1708, 'ar', 'أريزونا', 4),
(1709, 'ar', 'أركنساس', 5),
(1710, 'ar', 'القوات المسلحة أفريقيا', 6),
(1711, 'ar', 'القوات المسلحة الأمريكية', 7),
(1712, 'ar', 'القوات المسلحة الكندية', 8),
(1713, 'ar', 'القوات المسلحة أوروبا', 9),
(1714, 'ar', 'القوات المسلحة الشرق الأوسط', 10),
(1715, 'ar', 'القوات المسلحة في المحيط الهادئ', 11),
(1716, 'ar', 'كاليفورنيا', 12),
(1717, 'ar', 'كولورادو', 13),
(1718, 'ar', 'كونيتيكت', 14),
(1719, 'ar', 'ديلاوير', 15),
(1720, 'ar', 'مقاطعة كولومبيا', 16),
(1721, 'ar', 'ولايات ميكرونيزيا الموحدة', 17),
(1722, 'ar', 'فلوريدا', 18),
(1723, 'ar', 'جورجيا', 19),
(1724, 'ar', 'غوام', 20),
(1725, 'ar', 'هاواي', 21),
(1726, 'ar', 'ايداهو', 22),
(1727, 'ar', 'إلينوي', 23),
(1728, 'ar', 'إنديانا', 24),
(1729, 'ar', 'أيوا', 25),
(1730, 'ar', 'كانساس', 26),
(1731, 'ar', 'كنتاكي', 27),
(1732, 'ar', 'لويزيانا', 28),
(1733, 'ar', 'مين', 29),
(1734, 'ar', 'جزر مارشال', 30),
(1735, 'ar', 'ماريلاند', 31),
(1736, 'ar', 'ماساتشوستس', 32),
(1737, 'ar', 'ميشيغان', 33),
(1738, 'ar', 'مينيسوتا', 34),
(1739, 'ar', 'ميسيسيبي', 35),
(1740, 'ar', 'ميسوري', 36),
(1741, 'ar', 'مونتانا', 37),
(1742, 'ar', 'نبراسكا', 38),
(1743, 'ar', 'نيفادا', 39),
(1744, 'ar', 'نيو هامبشاير', 40),
(1745, 'ar', 'نيو جيرسي', 41),
(1746, 'ar', 'المكسيك جديدة', 42),
(1747, 'ar', 'نيويورك', 43),
(1748, 'ar', 'شمال كارولينا', 44),
(1749, 'ar', 'شمال داكوتا', 45),
(1750, 'ar', 'جزر مريانا الشمالية', 46),
(1751, 'ar', 'أوهايو', 47),
(1752, 'ar', 'أوكلاهوما', 48),
(1753, 'ar', 'ولاية أوريغون', 49),
(1754, 'ar', 'بالاو', 50),
(1755, 'ar', 'بنسلفانيا', 51),
(1756, 'ar', 'بورتوريكو', 52),
(1757, 'ar', 'جزيرة رود', 53),
(1758, 'ar', 'كارولينا الجنوبية', 54),
(1759, 'ar', 'جنوب داكوتا', 55),
(1760, 'ar', 'تينيسي', 56),
(1761, 'ar', 'تكساس', 57),
(1762, 'ar', 'يوتا', 58),
(1763, 'ar', 'فيرمونت', 59),
(1764, 'ar', 'جزر فيرجن', 60),
(1765, 'ar', 'فرجينيا', 61),
(1766, 'ar', 'واشنطن', 62),
(1767, 'ar', 'فرجينيا الغربية', 63),
(1768, 'ar', 'ولاية ويسكونسن', 64),
(1769, 'ar', 'وايومنغ', 65),
(1770, 'ar', 'ألبرتا', 66),
(1771, 'ar', 'كولومبيا البريطانية', 67),
(1772, 'ar', 'مانيتوبا', 68),
(1773, 'ar', 'نيوفاوندلاند ولابرادور', 69),
(1774, 'ar', 'برونزيك جديد', 70),
(1775, 'ar', 'مقاطعة نفوفا سكوشيا', 71),
(1776, 'ar', 'الاقاليم الشمالية الغربية', 72),
(1777, 'ar', 'نونافوت', 73),
(1778, 'ar', 'أونتاريو', 74),
(1779, 'ar', 'جزيرة الأمير ادوارد', 75),
(1780, 'ar', 'كيبيك', 76),
(1781, 'ar', 'ساسكاتشوان', 77),
(1782, 'ar', 'إقليم يوكون', 78),
(1783, 'ar', 'Niedersachsen', 79),
(1784, 'ar', 'بادن فورتمبيرغ', 80),
(1785, 'ar', 'بايرن ميونيخ', 81),
(1786, 'ar', 'برلين', 82),
(1787, 'ar', 'براندنبورغ', 83),
(1788, 'ar', 'بريمن', 84),
(1789, 'ar', 'هامبورغ', 85),
(1790, 'ar', 'هيسن', 86),
(1791, 'ar', 'مكلنبورغ-فوربومرن', 87),
(1792, 'ar', 'نوردراين فيستفالن', 88),
(1793, 'ar', 'راينلاند-بفالز', 89),
(1794, 'ar', 'سارلاند', 90),
(1795, 'ar', 'ساكسن', 91),
(1796, 'ar', 'سكسونيا أنهالت', 92),
(1797, 'ar', 'شليسفيغ هولشتاين', 93),
(1798, 'ar', 'تورنغن', 94),
(1799, 'ar', 'فيينا', 95),
(1800, 'ar', 'النمسا السفلى', 96),
(1801, 'ar', 'النمسا العليا', 97),
(1802, 'ar', 'سالزبورغ', 98),
(1803, 'ar', 'Каринтия', 99),
(1804, 'ar', 'STEIERMARK', 100),
(1805, 'ar', 'تيرول', 101),
(1806, 'ar', 'بورغنلاند', 102),
(1807, 'ar', 'فورارلبرغ', 103),
(1808, 'ar', 'أرجاو', 104),
(1809, 'ar', 'Appenzell Innerrhoden', 105),
(1810, 'ar', 'أبنزل أوسيرهودن', 106),
(1811, 'ar', 'برن', 107),
(1812, 'ar', 'كانتون ريف بازل', 108),
(1813, 'ar', 'بازل شتات', 109),
(1814, 'ar', 'فرايبورغ', 110),
(1815, 'ar', 'Genf', 111),
(1816, 'ar', 'جلاروس', 112),
(1817, 'ar', 'غراوبوندن', 113),
(1818, 'ar', 'العصر الجوارسي أو الجوري', 114),
(1819, 'ar', 'لوزيرن', 115),
(1820, 'ar', 'في Neuenburg', 116),
(1821, 'ar', 'نيدوالدن', 117),
(1822, 'ar', 'أوبوالدن', 118),
(1823, 'ar', 'سانت غالن', 119),
(1824, 'ar', 'شافهاوزن', 120),
(1825, 'ar', 'سولوتورن', 121),
(1826, 'ar', 'شفيتس', 122),
(1827, 'ar', 'ثورجو', 123),
(1828, 'ar', 'تيتشينو', 124),
(1829, 'ar', 'أوري', 125),
(1830, 'ar', 'وادت', 126),
(1831, 'ar', 'اليس', 127),
(1832, 'ar', 'زوغ', 128),
(1833, 'ar', 'زيورخ', 129),
(1834, 'ar', 'Corunha', 130),
(1835, 'ar', 'ألافا', 131),
(1836, 'ar', 'الباسيتي', 132),
(1837, 'ar', 'اليكانتي', 133),
(1838, 'ar', 'الميريا', 134),
(1839, 'ar', 'أستورياس', 135),
(1840, 'ar', 'أفيلا', 136),
(1841, 'ar', 'بطليوس', 137),
(1842, 'ar', 'البليار', 138),
(1843, 'ar', 'برشلونة', 139),
(1844, 'ar', 'برغش', 140),
(1845, 'ar', 'كاسيريس', 141),
(1846, 'ar', 'كاديز', 142),
(1847, 'ar', 'كانتابريا', 143),
(1848, 'ar', 'كاستيلون', 144),
(1849, 'ar', 'سبتة', 145),
(1850, 'ar', 'سيوداد ريال', 146),
(1851, 'ar', 'قرطبة', 147),
(1852, 'ar', 'كوينكا', 148),
(1853, 'ar', 'جيرونا', 149),
(1854, 'ar', 'غرناطة', 150),
(1855, 'ar', 'غوادالاخارا', 151),
(1856, 'ar', 'بجويبوزكوا', 152),
(1857, 'ar', 'هويلفا', 153),
(1858, 'ar', 'هويسكا', 154),
(1859, 'ar', 'خاين', 155),
(1860, 'ar', 'لاريوخا', 156),
(1861, 'ar', 'لاس بالماس', 157),
(1862, 'ar', 'ليون', 158),
(1863, 'ar', 'يدا', 159),
(1864, 'ar', 'لوغو', 160),
(1865, 'ar', 'مدريد', 161),
(1866, 'ar', 'ملقة', 162),
(1867, 'ar', 'مليلية', 163),
(1868, 'ar', 'مورسيا', 164),
(1869, 'ar', 'نافارا', 165),
(1870, 'ar', 'أورينس', 166),
(1871, 'ar', 'بلنسية', 167),
(1872, 'ar', 'بونتيفيدرا', 168),
(1873, 'ar', 'سالامانكا', 169),
(1874, 'ar', 'سانتا كروز دي تينيريفي', 170),
(1875, 'ar', 'سيغوفيا', 171),
(1876, 'ar', 'اشبيلية', 172),
(1877, 'ar', 'سوريا', 173),
(1878, 'ar', 'تاراغونا', 174),
(1879, 'ar', 'تيرويل', 175),
(1880, 'ar', 'توليدو', 176),
(1881, 'ar', 'فالنسيا', 177),
(1882, 'ar', 'بلد الوليد', 178),
(1883, 'ar', 'فيزكايا', 179),
(1884, 'ar', 'زامورا', 180),
(1885, 'ar', 'سرقسطة', 181),
(1886, 'ar', 'عين', 182),
(1887, 'ar', 'أيسن', 183),
(1888, 'ar', 'اليي', 184),
(1889, 'ar', 'ألب البروفنس العليا', 185),
(1890, 'ar', 'أوتس ألب', 186),
(1891, 'ar', 'ألب ماريتيم', 187),
(1892, 'ar', 'ARDECHE', 188),
(1893, 'ar', 'Ardennes', 189),
(1894, 'ar', 'آردن', 190),
(1895, 'ar', 'أوب', 191),
(1896, 'ar', 'اود', 192),
(1897, 'ar', 'أفيرون', 193),
(1898, 'ar', 'بوكاس دو رون', 194),
(1899, 'ar', 'كالفادوس', 195),
(1900, 'ar', 'كانتال', 196),
(1901, 'ar', 'شارانت', 197),
(1902, 'ar', 'سيين إت مارن', 198),
(1903, 'ar', 'شير', 199),
(1904, 'ar', 'كوريز', 200),
(1905, 'ar', 'سود كورس-دو-', 201),
(1906, 'ar', 'هوت كورس', 202),
(1907, 'ar', 'كوستا دوركوريز', 203),
(1908, 'ar', 'كوتس دورمور', 204),
(1909, 'ar', 'كروز', 205),
(1910, 'ar', 'دوردوني', 206),
(1911, 'ar', 'دوبس', 207),
(1912, 'ar', 'DrômeFinistère', 208),
(1913, 'ar', 'أور', 209),
(1914, 'ar', 'أور ولوار', 210),
(1915, 'ar', 'فينيستير', 211),
(1916, 'ar', 'جارد', 212),
(1917, 'ar', 'هوت غارون', 213),
(1918, 'ar', 'الخيام', 214),
(1919, 'ar', 'جيروند', 215),
(1920, 'ar', 'هيرولت', 216),
(1921, 'ar', 'إيل وفيلان', 217),
(1922, 'ar', 'إندر', 218),
(1923, 'ar', 'أندر ولوار', 219),
(1924, 'ar', 'إيسر', 220),
(1925, 'ar', 'العصر الجوارسي أو الجوري', 221),
(1926, 'ar', 'اندز', 222),
(1927, 'ar', 'لوار وشير', 223),
(1928, 'ar', 'لوار', 224),
(1929, 'ar', 'هوت-لوار', 225),
(1930, 'ar', 'وار أتلانتيك', 226),
(1931, 'ar', 'لورا', 227),
(1932, 'ar', 'كثيرا', 228),
(1933, 'ar', 'الكثير غارون', 229),
(1934, 'ar', 'لوزر', 230),
(1935, 'ar', 'مين-إي-لوار', 231),
(1936, 'ar', 'المانش', 232),
(1937, 'ar', 'مارن', 233),
(1938, 'ar', 'هوت مارن', 234),
(1939, 'ar', 'مايين', 235),
(1940, 'ar', 'مورت وموزيل', 236),
(1941, 'ar', 'ميوز', 237),
(1942, 'ar', 'موربيهان', 238),
(1943, 'ar', 'موسيل', 239),
(1944, 'ar', 'نيفر', 240),
(1945, 'ar', 'نورد', 241),
(1946, 'ar', 'إيل دو فرانس', 242),
(1947, 'ar', 'أورن', 243),
(1948, 'ar', 'با-دو-كاليه', 244),
(1949, 'ar', 'بوي دي دوم', 245),
(1950, 'ar', 'البرانيس ​​الأطلسية', 246),
(1951, 'ar', 'أوتس-بيرينيهs', 247),
(1952, 'ar', 'بيرينيه-أورينتال', 248),
(1953, 'ar', 'بس رين', 249),
(1954, 'ar', 'أوت رين', 250),
(1955, 'ar', 'رون [3]', 251),
(1956, 'ar', 'هوت-سون', 252),
(1957, 'ar', 'سون ولوار', 253),
(1958, 'ar', 'سارت', 254),
(1959, 'ar', 'سافوا', 255),
(1960, 'ar', 'هاوت سافوي', 256),
(1961, 'ar', 'باريس', 257),
(1962, 'ar', 'سين البحرية', 258),
(1963, 'ar', 'سيين إت مارن', 259),
(1964, 'ar', 'إيفلين', 260),
(1965, 'ar', 'دوكس سفرس', 261),
(1966, 'ar', 'السوم', 262),
(1967, 'ar', 'تارن', 263),
(1968, 'ar', 'تارن وغارون', 264),
(1969, 'ar', 'فار', 265),
(1970, 'ar', 'فوكلوز', 266),
(1971, 'ar', 'تارن', 267),
(1972, 'ar', 'فيين', 268),
(1973, 'ar', 'هوت فيين', 269),
(1974, 'ar', 'الفوج', 270),
(1975, 'ar', 'يون', 271),
(1976, 'ar', 'تيريتوير-دي-بلفور', 272),
(1977, 'ar', 'إيسون', 273),
(1978, 'ar', 'هوت دو سين', 274),
(1979, 'ar', 'سين سان دوني', 275),
(1980, 'ar', 'فال دو مارن', 276),
(1981, 'ar', 'فال دواز', 277),
(1982, 'ar', 'ألبا', 278),
(1983, 'ar', 'اراد', 279),
(1984, 'ar', 'ARGES', 280),
(1985, 'ar', 'باكاو', 281),
(1986, 'ar', 'بيهور', 282),
(1987, 'ar', 'بيستريتا ناسود', 283),
(1988, 'ar', 'بوتوساني', 284),
(1989, 'ar', 'براشوف', 285),
(1990, 'ar', 'برايلا', 286),
(1991, 'ar', 'بوخارست', 287),
(1992, 'ar', 'بوزاو', 288),
(1993, 'ar', 'كاراس سيفيرين', 289),
(1994, 'ar', 'كالاراسي', 290),
(1995, 'ar', 'كلوج', 291),
(1996, 'ar', 'كونستانتا', 292),
(1997, 'ar', 'كوفاسنا', 293),
(1998, 'ar', 'دامبوفيتا', 294),
(1999, 'ar', 'دولج', 295),
(2000, 'ar', 'جالاتي', 296),
(2001, 'ar', 'Giurgiu', 297),
(2002, 'ar', 'غيورغيو', 298),
(2003, 'ar', 'هارغيتا', 299),
(2004, 'ar', 'هونيدوارا', 300),
(2005, 'ar', 'ايالوميتا', 301),
(2006, 'ar', 'ياشي', 302),
(2007, 'ar', 'إيلفوف', 303),
(2008, 'ar', 'مارامريس', 304),
(2009, 'ar', 'MEHEDINTI', 305),
(2010, 'ar', 'موريس', 306),
(2011, 'ar', 'نيامتس', 307),
(2012, 'ar', 'أولت', 308),
(2013, 'ar', 'براهوفا', 309),
(2014, 'ar', 'ساتو ماري', 310),
(2015, 'ar', 'سالاج', 311),
(2016, 'ar', 'سيبيو', 312),
(2017, 'ar', 'سوسيفا', 313),
(2018, 'ar', 'تيليورمان', 314),
(2019, 'ar', 'تيم هو', 315),
(2020, 'ar', 'تولسيا', 316),
(2021, 'ar', 'فاسلوي', 317),
(2022, 'ar', 'فالسيا', 318),
(2023, 'ar', 'فرانتشا', 319),
(2024, 'ar', 'Lappi', 320),
(2025, 'ar', 'Pohjois-Pohjanmaa', 321),
(2026, 'ar', 'كاينو', 322),
(2027, 'ar', 'Pohjois-كارجالا', 323),
(2028, 'ar', 'Pohjois-سافو', 324),
(2029, 'ar', 'Etelä-سافو', 325),
(2030, 'ar', 'Etelä-Pohjanmaa', 326),
(2031, 'ar', 'Pohjanmaa', 327),
(2032, 'ar', 'بيركنما', 328),
(2033, 'ar', 'ساتا كونتا', 329),
(2034, 'ar', 'كسكي-Pohjanmaa', 330),
(2035, 'ar', 'كسكي-سومي', 331),
(2036, 'ar', 'Varsinais-سومي', 332),
(2037, 'ar', 'Etelä-كارجالا', 333),
(2038, 'ar', 'Päijät-Häme', 334),
(2039, 'ar', 'كانتا-HAME', 335),
(2040, 'ar', 'أوسيما', 336),
(2041, 'ar', 'أوسيما', 337),
(2042, 'ar', 'كومنلاكسو', 338),
(2043, 'ar', 'Ahvenanmaa', 339),
(2044, 'ar', 'Harjumaa', 340),
(2045, 'ar', 'هيوما', 341),
(2046, 'ar', 'المؤسسة الدولية للتنمية فيروما', 342),
(2047, 'ar', 'جوغفما', 343),
(2048, 'ar', 'يارفا', 344),
(2049, 'ar', 'انيما', 345),
(2050, 'ar', 'اني فيريوما', 346),
(2051, 'ar', 'بولفاما', 347),
(2052, 'ar', 'بارنوما', 348),
(2053, 'ar', 'Raplamaa', 349),
(2054, 'ar', 'Saaremaa', 350),
(2055, 'ar', 'Tartumaa', 351),
(2056, 'ar', 'Valgamaa', 352),
(2057, 'ar', 'Viljandimaa', 353),
(2058, 'ar', 'روايات Salacgr novvas', 354),
(2059, 'ar', 'داوجافبيلس', 355),
(2060, 'ar', 'يلغافا', 356),
(2061, 'ar', 'يكاب', 357),
(2062, 'ar', 'يورمال', 358),
(2063, 'ar', 'يابايا', 359),
(2064, 'ar', 'ليباج أبريس', 360),
(2065, 'ar', 'ريزكن', 361),
(2066, 'ar', 'ريغا', 362),
(2067, 'ar', 'مقاطعة ريغا', 363),
(2068, 'ar', 'فالميرا', 364),
(2069, 'ar', 'فنتسبيلز', 365),
(2070, 'ar', 'روايات Aglonas', 366),
(2071, 'ar', 'Aizkraukles novads', 367),
(2072, 'ar', 'Aizkraukles novads', 368),
(2073, 'ar', 'Aknīstes novads', 369),
(2074, 'ar', 'Alojas novads', 370),
(2075, 'ar', 'روايات Alsungas', 371),
(2076, 'ar', 'ألكسنس أبريز', 372),
(2077, 'ar', 'روايات أماتاس', 373),
(2078, 'ar', 'قرود الروايات', 374),
(2079, 'ar', 'روايات أوسيس', 375),
(2080, 'ar', 'بابيت الروايات', 376),
(2081, 'ar', 'Baldones الروايات', 377),
(2082, 'ar', 'بالتينافاس الروايات', 378),
(2083, 'ar', 'روايات بالفو', 379),
(2084, 'ar', 'Bauskas الروايات', 380),
(2085, 'ar', 'Beverīnas novads', 381),
(2086, 'ar', 'Novads Brocēnu', 382),
(2087, 'ar', 'Novads Burtnieku', 383),
(2088, 'ar', 'Carnikavas novads', 384),
(2089, 'ar', 'Cesvaines novads', 385),
(2090, 'ar', 'Ciblas novads', 386),
(2091, 'ar', 'تسو أبريس', 387),
(2092, 'ar', 'Dagdas novads', 388),
(2093, 'ar', 'Daugavpils novads', 389),
(2094, 'ar', 'روايات دوبيليس', 390),
(2095, 'ar', 'ديربيس الروايات', 391),
(2096, 'ar', 'ديربيس الروايات', 392),
(2097, 'ar', 'يشرك الروايات', 393),
(2098, 'ar', 'Garkalnes novads', 394),
(2099, 'ar', 'Grobiņas novads', 395),
(2100, 'ar', 'غولبينيس الروايات', 396),
(2101, 'ar', 'إيكافاس روايات', 397),
(2102, 'ar', 'Ikškiles novads', 398),
(2103, 'ar', 'Ilūkstes novads', 399),
(2104, 'ar', 'روايات Inčukalna', 400),
(2105, 'ar', 'Jaunjelgavas novads', 401),
(2106, 'ar', 'Jaunpiebalgas novads', 402),
(2107, 'ar', 'روايات Jaunpiebalgas', 403),
(2108, 'ar', 'Jelgavas novads', 404),
(2109, 'ar', 'جيكابيلس أبريز', 405),
(2110, 'ar', 'روايات كاندافاس', 406),
(2111, 'ar', 'Kokneses الروايات', 407),
(2112, 'ar', 'Krimuldas novads', 408),
(2113, 'ar', 'Krustpils الروايات', 409),
(2114, 'ar', 'Krāslavas Apriņķis', 410),
(2115, 'ar', 'كولدوغاس أبريز', 411),
(2116, 'ar', 'Kārsavas novads', 412),
(2117, 'ar', 'روايات ييلفاريس', 413),
(2118, 'ar', 'ليمباو أبريز', 414),
(2119, 'ar', 'روايات لباناس', 415),
(2120, 'ar', 'روايات لودزاس', 416),
(2121, 'ar', 'مقاطعة ليجاتني', 417),
(2122, 'ar', 'مقاطعة ليفاني', 418),
(2123, 'ar', 'مادونا روايات', 419),
(2124, 'ar', 'Mazsalacas novads', 420),
(2125, 'ar', 'روايات مالبلز', 421),
(2126, 'ar', 'Mārupes novads', 422),
(2127, 'ar', 'نوفاو نوكشنو', 423),
(2128, 'ar', 'روايات نيريتاس', 424),
(2129, 'ar', 'روايات نيكاس', 425),
(2130, 'ar', 'أغنام الروايات', 426),
(2131, 'ar', 'أولينيس الروايات', 427),
(2132, 'ar', 'روايات Ozolnieku', 428),
(2133, 'ar', 'بريسيو أبرييس', 429),
(2134, 'ar', 'Priekules الروايات', 430),
(2135, 'ar', 'كوندادو دي بريكوي', 431),
(2136, 'ar', 'Pärgaujas novads', 432),
(2137, 'ar', 'روايات بافيلوستاس', 433),
(2138, 'ar', 'بلافيناس مقاطعة', 434),
(2139, 'ar', 'روناس روايات', 435),
(2140, 'ar', 'Riebiņu novads', 436),
(2141, 'ar', 'روجاس روايات', 437),
(2142, 'ar', 'Novads روباو', 438),
(2143, 'ar', 'روكافاس روايات', 439),
(2144, 'ar', 'روغاجو روايات', 440),
(2145, 'ar', 'رندلس الروايات', 441),
(2146, 'ar', 'Radzeknes novads', 442),
(2147, 'ar', 'Rūjienas novads', 443),
(2148, 'ar', 'بلدية سالاسغريفا', 444),
(2149, 'ar', 'روايات سالاس', 445),
(2150, 'ar', 'Salaspils novads', 446),
(2151, 'ar', 'روايات سالدوس', 447),
(2152, 'ar', 'Novuls Saulkrastu', 448),
(2153, 'ar', 'سيغولداس روايات', 449),
(2154, 'ar', 'Skrundas novads', 450),
(2155, 'ar', 'مقاطعة Skrīveri', 451),
(2156, 'ar', 'يبتسم الروايات', 452),
(2157, 'ar', 'روايات Stopiņu', 453),
(2158, 'ar', 'روايات Stren novu', 454),
(2159, 'ar', 'سجاس روايات', 455),
(2160, 'ar', 'روايات تالسو', 456),
(2161, 'ar', 'توكوما الروايات', 457),
(2162, 'ar', 'Tērvetes novads', 458),
(2163, 'ar', 'Vaiņodes novads', 459),
(2164, 'ar', 'فالكاس الروايات', 460),
(2165, 'ar', 'فالميراس الروايات', 461),
(2166, 'ar', 'مقاطعة فاكلاني', 462),
(2167, 'ar', 'Vecpiebalgas novads', 463),
(2168, 'ar', 'روايات Vecumnieku', 464),
(2169, 'ar', 'فنتسبيلس الروايات', 465),
(2170, 'ar', 'Viesītes Novads', 466),
(2171, 'ar', 'Viļakas novads', 467),
(2172, 'ar', 'روايات فيناو', 468),
(2173, 'ar', 'Vārkavas novads', 469),
(2174, 'ar', 'روايات زيلوبس', 470),
(2175, 'ar', 'مقاطعة أدازي', 471),
(2176, 'ar', 'مقاطعة Erglu', 472),
(2177, 'ar', 'مقاطعة كيغمس', 473),
(2178, 'ar', 'مقاطعة كيكافا', 474),
(2179, 'ar', 'Alytaus Apskritis', 475),
(2180, 'ar', 'كاونو ابكريتيس', 476),
(2181, 'ar', 'Klaipėdos apskritis', 477),
(2182, 'ar', 'Marijampol\'s apskritis', 478),
(2183, 'ar', 'Panevėžio apskritis', 479),
(2184, 'ar', 'uliaulių apskritis', 480),
(2185, 'ar', 'Taurag\'s apskritis', 481),
(2186, 'ar', 'Telšių apskritis', 482),
(2187, 'ar', 'Utenos apskritis', 483),
(2188, 'ar', 'فيلنياوس ابكريتيس', 484),
(2189, 'ar', 'فدان', 485),
(2190, 'ar', 'ألاغواس', 486),
(2191, 'ar', 'أمابا', 487),
(2192, 'ar', 'أمازوناس', 488),
(2193, 'ar', 'باهيا', 489),
(2194, 'ar', 'سيارا', 490),
(2195, 'ar', 'إسبيريتو سانتو', 491),
(2196, 'ar', 'غوياس', 492),
(2197, 'ar', 'مارانهاو', 493),
(2198, 'ar', 'ماتو جروسو', 494),
(2199, 'ar', 'ماتو جروسو دو سول', 495),
(2200, 'ar', 'ميناس جريس', 496),
(2201, 'ar', 'بارا', 497),
(2202, 'ar', 'بارايبا', 498),
(2203, 'ar', 'بارانا', 499),
(2204, 'ar', 'بيرنامبوكو', 500),
(2205, 'ar', 'بياوي', 501),
(2206, 'ar', 'ريو دي جانيرو', 502),
(2207, 'ar', 'ريو غراندي دو نورتي', 503),
(2208, 'ar', 'ريو غراندي دو سول', 504),
(2209, 'ar', 'روندونيا', 505),
(2210, 'ar', 'رورايما', 506),
(2211, 'ar', 'سانتا كاتارينا', 507),
(2212, 'ar', 'ساو باولو', 508),
(2213, 'ar', 'سيرغيبي', 509),
(2214, 'ar', 'توكانتينز', 510),
(2215, 'ar', 'وفي مقاطعة الاتحادية', 511),
(2216, 'ar', 'Zagrebačka زوبانيا', 512),
(2217, 'ar', 'Krapinsko-zagorska زوبانيا', 513),
(2218, 'ar', 'Sisačko-moslavačka زوبانيا', 514),
(2219, 'ar', 'كارلوفيتش شوبانيا', 515),
(2220, 'ar', 'فارادينسكا زوبانيجا', 516),
(2221, 'ar', 'Koprivničko-križevačka زوبانيجا', 517),
(2222, 'ar', 'بيلوفارسكو-بيلوجورسكا', 518),
(2223, 'ar', 'بريمورسكو غورانسكا سوبانيا', 519),
(2224, 'ar', 'ليكو سينيسكا زوبانيا', 520),
(2225, 'ar', 'Virovitičko-podravska زوبانيا', 521),
(2226, 'ar', 'Požeško-slavonska županija', 522),
(2227, 'ar', 'Brodsko-posavska županija', 523),
(2228, 'ar', 'زادارسكا زوبانيجا', 524),
(2229, 'ar', 'Osječko-baranjska županija', 525),
(2230, 'ar', 'شيبنسكو-كنينسكا سوبانيا', 526),
(2231, 'ar', 'Virovitičko-podravska زوبانيا', 527),
(2232, 'ar', 'Splitsko-dalmatinska زوبانيا', 528),
(2233, 'ar', 'Istarska زوبانيا', 529),
(2234, 'ar', 'Dubrovačko-neretvanska زوبانيا', 530),
(2235, 'ar', 'Međimurska زوبانيا', 531),
(2236, 'ar', 'غراد زغرب', 532),
(2237, 'ar', 'جزر أندامان ونيكوبار', 533),
(2238, 'ar', 'ولاية اندرا براديش', 534),
(2239, 'ar', 'اروناتشال براديش', 535),
(2240, 'ar', 'أسام', 536),
(2241, 'ar', 'بيهار', 537),
(2242, 'ar', 'شانديغار', 538),
(2243, 'ar', 'تشهاتيسجاره', 539),
(2244, 'ar', 'دادرا ونجار هافيلي', 540),
(2245, 'ar', 'دامان وديو', 541),
(2246, 'ar', 'دلهي', 542),
(2247, 'ar', 'غوا', 543),
(2248, 'ar', 'غوجارات', 544),
(2249, 'ar', 'هاريانا', 545),
(2250, 'ar', 'هيماشال براديش', 546),
(2251, 'ar', 'جامو وكشمير', 547),
(2252, 'ar', 'جهارخاند', 548),
(2253, 'ar', 'كارناتاكا', 549),
(2254, 'ar', 'ولاية كيرالا', 550),
(2255, 'ar', 'اكشادويب', 551),
(2256, 'ar', 'ماديا براديش', 552),
(2257, 'ar', 'ماهاراشترا', 553),
(2258, 'ar', 'مانيبور', 554),
(2259, 'ar', 'ميغالايا', 555),
(2260, 'ar', 'ميزورام', 556),
(2261, 'ar', 'ناجالاند', 557),
(2262, 'ar', 'أوديشا', 558),
(2263, 'ar', 'بودوتشيري', 559),
(2264, 'ar', 'البنجاب', 560),
(2265, 'ar', 'راجستان', 561),
(2266, 'ar', 'سيكيم', 562),
(2267, 'ar', 'تاميل نادو', 563),
(2268, 'ar', 'تيلانجانا', 564),
(2269, 'ar', 'تريبورا', 565),
(2270, 'ar', 'ولاية اوتار براديش', 566),
(2271, 'ar', 'أوتارانتشال', 567),
(2272, 'ar', 'البنغال الغربية', 568),
(2273, 'fa', 'آلاباما', 1),
(2274, 'fa', 'آلاسکا', 2),
(2275, 'fa', 'ساموآ آمریکایی', 3),
(2276, 'fa', 'آریزونا', 4),
(2277, 'fa', 'آرکانزاس', 5),
(2278, 'fa', 'نیروهای مسلح آفریقا', 6),
(2279, 'fa', 'Armed Forces America', 7),
(2280, 'fa', 'نیروهای مسلح کانادا', 8),
(2281, 'fa', 'نیروهای مسلح اروپا', 9),
(2282, 'fa', 'نیروهای مسلح خاورمیانه', 10),
(2283, 'fa', 'نیروهای مسلح اقیانوس آرام', 11),
(2284, 'fa', 'کالیفرنیا', 12),
(2285, 'fa', 'کلرادو', 13),
(2286, 'fa', 'کانکتیکات', 14),
(2287, 'fa', 'دلاور', 15),
(2288, 'fa', 'منطقه کلمبیا', 16),
(2289, 'fa', 'ایالات فدرال میکرونزی', 17),
(2290, 'fa', 'فلوریدا', 18),
(2291, 'fa', 'جورجیا', 19),
(2292, 'fa', 'گوام', 20),
(2293, 'fa', 'هاوایی', 21),
(2294, 'fa', 'آیداهو', 22),
(2295, 'fa', 'ایلینویز', 23),
(2296, 'fa', 'ایندیانا', 24),
(2297, 'fa', 'آیووا', 25),
(2298, 'fa', 'کانزاس', 26),
(2299, 'fa', 'کنتاکی', 27),
(2300, 'fa', 'لوئیزیانا', 28),
(2301, 'fa', 'ماین', 29),
(2302, 'fa', 'مای', 30),
(2303, 'fa', 'مریلند', 31),
(2304, 'fa', ' ', 32),
(2305, 'fa', 'میشیگان', 33),
(2306, 'fa', 'مینه سوتا', 34),
(2307, 'fa', 'می سی سی پی', 35),
(2308, 'fa', 'میسوری', 36),
(2309, 'fa', 'مونتانا', 37),
(2310, 'fa', 'نبراسکا', 38),
(2311, 'fa', 'نواد', 39),
(2312, 'fa', 'نیوهمپشایر', 40),
(2313, 'fa', 'نیوجرسی', 41),
(2314, 'fa', 'نیومکزیکو', 42),
(2315, 'fa', 'نیویورک', 43),
(2316, 'fa', 'کارولینای شمالی', 44),
(2317, 'fa', 'داکوتای شمالی', 45),
(2318, 'fa', 'جزایر ماریانای شمالی', 46),
(2319, 'fa', 'اوهایو', 47),
(2320, 'fa', 'اوکلاهما', 48),
(2321, 'fa', 'اورگان', 49),
(2322, 'fa', 'پالائو', 50),
(2323, 'fa', 'پنسیلوانیا', 51),
(2324, 'fa', 'پورتوریکو', 52),
(2325, 'fa', 'رود آیلند', 53),
(2326, 'fa', 'کارولینای جنوبی', 54),
(2327, 'fa', 'داکوتای جنوبی', 55),
(2328, 'fa', 'تنسی', 56),
(2329, 'fa', 'تگزاس', 57),
(2330, 'fa', 'یوتا', 58),
(2331, 'fa', 'ورمونت', 59),
(2332, 'fa', 'جزایر ویرجین', 60),
(2333, 'fa', 'ویرجینیا', 61),
(2334, 'fa', 'واشنگتن', 62),
(2335, 'fa', 'ویرجینیای غربی', 63),
(2336, 'fa', 'ویسکانسین', 64),
(2337, 'fa', 'وایومینگ', 65),
(2338, 'fa', 'آلبرتا', 66),
(2339, 'fa', 'بریتیش کلمبیا', 67),
(2340, 'fa', 'مانیتوبا', 68),
(2341, 'fa', 'نیوفاندلند و لابرادور', 69),
(2342, 'fa', 'نیوبرانزویک', 70),
(2343, 'fa', 'نوا اسکوشیا', 71),
(2344, 'fa', 'سرزمینهای شمال غربی', 72),
(2345, 'fa', 'نوناووت', 73),
(2346, 'fa', 'انتاریو', 74),
(2347, 'fa', 'جزیره پرنس ادوارد', 75),
(2348, 'fa', 'کبک', 76),
(2349, 'fa', 'ساسکاتچوان', 77),
(2350, 'fa', 'قلمرو یوکان', 78),
(2351, 'fa', 'نیدرزاکسن', 79),
(2352, 'fa', 'بادن-وورتمبرگ', 80),
(2353, 'fa', 'بایرن', 81),
(2354, 'fa', 'برلین', 82),
(2355, 'fa', 'براندنبورگ', 83),
(2356, 'fa', 'برمن', 84),
(2357, 'fa', 'هامبور', 85),
(2358, 'fa', 'هسن', 86),
(2359, 'fa', 'مکلنبورگ-وورپومرن', 87),
(2360, 'fa', 'نوردراین-وستفالن', 88),
(2361, 'fa', 'راینلاند-پلاتینات', 89),
(2362, 'fa', 'سارلند', 90),
(2363, 'fa', 'ساچسن', 91),
(2364, 'fa', 'ساچسن-آنهالت', 92),
(2365, 'fa', 'شلسویگ-هولشتاین', 93),
(2366, 'fa', 'تورینگی', 94),
(2367, 'fa', 'وین', 95),
(2368, 'fa', 'اتریش پایین', 96),
(2369, 'fa', 'اتریش فوقانی', 97),
(2370, 'fa', 'سالزبورگ', 98),
(2371, 'fa', 'کارنتا', 99),
(2372, 'fa', 'Steiermar', 100),
(2373, 'fa', 'تیرول', 101),
(2374, 'fa', 'بورگنلن', 102),
(2375, 'fa', 'Vorarlber', 103),
(2376, 'fa', 'آرگ', 104),
(2377, 'fa', '', 105),
(2378, 'fa', 'اپنزلسرهودن', 106),
(2379, 'fa', 'بر', 107),
(2380, 'fa', 'بازل-لندشفت', 108),
(2381, 'fa', 'بازل استاد', 109),
(2382, 'fa', 'فرایبورگ', 110),
(2383, 'fa', 'گنف', 111),
(2384, 'fa', 'گلاروس', 112),
(2385, 'fa', 'Graubünde', 113),
(2386, 'fa', 'ژورا', 114),
(2387, 'fa', 'لوزرن', 115),
(2388, 'fa', 'نوینبور', 116),
(2389, 'fa', 'نیدالد', 117),
(2390, 'fa', 'اوبولدن', 118),
(2391, 'fa', 'سنت گالن', 119),
(2392, 'fa', 'شافهاوز', 120),
(2393, 'fa', 'سولوتور', 121),
(2394, 'fa', 'شووی', 122),
(2395, 'fa', 'تورگاو', 123),
(2396, 'fa', 'تسسی', 124),
(2397, 'fa', 'اوری', 125),
(2398, 'fa', 'وادت', 126),
(2399, 'fa', 'والی', 127),
(2400, 'fa', 'ز', 128),
(2401, 'fa', 'زوریخ', 129),
(2402, 'fa', 'کورونا', 130),
(2403, 'fa', 'آلاوا', 131),
(2404, 'fa', 'آلبوم', 132),
(2405, 'fa', 'آلیکانت', 133),
(2406, 'fa', 'آلمریا', 134),
(2407, 'fa', 'آستوریا', 135),
(2408, 'fa', 'آویلا', 136),
(2409, 'fa', 'باداژوز', 137),
(2410, 'fa', 'ضرب و شتم', 138),
(2411, 'fa', 'بارسلون', 139),
(2412, 'fa', 'بورگو', 140),
(2413, 'fa', 'کاسر', 141),
(2414, 'fa', 'کادی', 142),
(2415, 'fa', 'کانتابریا', 143),
(2416, 'fa', 'کاستلون', 144),
(2417, 'fa', 'سوت', 145),
(2418, 'fa', 'سیوداد واقعی', 146),
(2419, 'fa', 'کوردوب', 147),
(2420, 'fa', 'Cuenc', 148),
(2421, 'fa', 'جیرون', 149),
(2422, 'fa', 'گراناد', 150),
(2423, 'fa', 'گوادالاجار', 151),
(2424, 'fa', 'Guipuzcoa', 152),
(2425, 'fa', 'هولوا', 153),
(2426, 'fa', 'هوسک', 154),
(2427, 'fa', 'جی', 155),
(2428, 'fa', 'لا ریوجا', 156),
(2429, 'fa', 'لاس پالماس', 157),
(2430, 'fa', 'لئو', 158),
(2431, 'fa', 'Lleid', 159),
(2432, 'fa', 'لوگ', 160),
(2433, 'fa', 'مادری', 161),
(2434, 'fa', 'مالاگ', 162),
(2435, 'fa', 'ملیلی', 163),
(2436, 'fa', 'مورسیا', 164),
(2437, 'fa', 'ناوار', 165),
(2438, 'fa', 'اورنس', 166),
(2439, 'fa', 'پالنسی', 167),
(2440, 'fa', 'پونتوودر', 168),
(2441, 'fa', 'سالامانک', 169),
(2442, 'fa', 'سانتا کروز د تنریفه', 170),
(2443, 'fa', 'سوگویا', 171),
(2444, 'fa', 'سوی', 172),
(2445, 'fa', 'سوریا', 173),
(2446, 'fa', 'تاراگونا', 174),
(2447, 'fa', 'ترئو', 175),
(2448, 'fa', 'تولدو', 176),
(2449, 'fa', 'والنسیا', 177),
(2450, 'fa', 'والادولی', 178),
(2451, 'fa', 'ویزکایا', 179),
(2452, 'fa', 'زامور', 180),
(2453, 'fa', 'ساراگوز', 181),
(2454, 'fa', 'عی', 182),
(2455, 'fa', 'آیز', 183),
(2456, 'fa', 'آلی', 184),
(2457, 'fa', 'آلپ-دو-هاوت-پرووانس', 185),
(2458, 'fa', 'هاوتس آلپ', 186),
(2459, 'fa', 'Alpes-Maritime', 187),
(2460, 'fa', 'اردچه', 188),
(2461, 'fa', 'آرد', 189),
(2462, 'fa', 'محاصر', 190),
(2463, 'fa', 'آبه', 191),
(2464, 'fa', 'Aud', 192),
(2465, 'fa', 'آویرون', 193),
(2466, 'fa', 'BOCAS DO Rhône', 194),
(2467, 'fa', 'نوعی عرق', 195),
(2468, 'fa', 'کانتینال', 196),
(2469, 'fa', 'چارنت', 197),
(2470, 'fa', 'چارنت-دریایی', 198),
(2471, 'fa', 'چ', 199),
(2472, 'fa', 'کور', 200),
(2473, 'fa', 'کرس دو ساد', 201),
(2474, 'fa', 'هاوت کورس', 202),
(2475, 'fa', 'کوستا دورکرز', 203),
(2476, 'fa', 'تخت دارمور', 204),
(2477, 'fa', 'درهم', 205),
(2478, 'fa', 'دوردگن', 206),
(2479, 'fa', 'دوب', 207),
(2480, 'fa', 'تعریف اول', 208),
(2481, 'fa', 'یور', 209),
(2482, 'fa', 'Eure-et-Loi', 210),
(2483, 'fa', 'فمینیست', 211),
(2484, 'fa', 'باغ', 212),
(2485, 'fa', 'اوت-گارون', 213),
(2486, 'fa', 'گر', 214),
(2487, 'fa', 'جیروند', 215),
(2488, 'fa', 'هیر', 216),
(2489, 'fa', 'هشدار داده می شود', 217),
(2490, 'fa', 'ایندور', 218),
(2491, 'fa', 'Indre-et-Loir', 219),
(2492, 'fa', 'ایزر', 220),
(2493, 'fa', 'یور', 221),
(2494, 'fa', 'لندز', 222),
(2495, 'fa', 'Loir-et-Che', 223),
(2496, 'fa', 'وام گرفتن', 224),
(2497, 'fa', 'Haute-Loir', 225),
(2498, 'fa', 'Loire-Atlantiqu', 226),
(2499, 'fa', 'لیرت', 227),
(2500, 'fa', 'لوط', 228),
(2501, 'fa', 'لوت و گارون', 229),
(2502, 'fa', 'لوزر', 230),
(2503, 'fa', 'ماین et-Loire', 231),
(2504, 'fa', 'مانچ', 232),
(2505, 'fa', 'مارن', 233),
(2506, 'fa', 'هاوت-مارن', 234),
(2507, 'fa', 'مایین', 235),
(2508, 'fa', 'مورته-et-Moselle', 236),
(2509, 'fa', 'مسخره کردن', 237),
(2510, 'fa', 'موربیان', 238),
(2511, 'fa', 'موزل', 239),
(2512, 'fa', 'Nièvr', 240),
(2513, 'fa', 'نورد', 241),
(2514, 'fa', 'اوی', 242),
(2515, 'fa', 'ارن', 243),
(2516, 'fa', 'پاس-کاله', 244),
(2517, 'fa', 'Puy-de-Dôm', 245),
(2518, 'fa', 'Pyrénées-Atlantiques', 246),
(2519, 'fa', 'Hautes-Pyrénée', 247),
(2520, 'fa', 'Pyrénées-Orientales', 248),
(2521, 'fa', 'بس راین', 249),
(2522, 'fa', 'هاوت-رین', 250),
(2523, 'fa', 'رو', 251),
(2524, 'fa', 'Haute-Saône', 252),
(2525, 'fa', 'Saône-et-Loire', 253),
(2526, 'fa', 'سارته', 254),
(2527, 'fa', 'ساووی', 255),
(2528, 'fa', 'هاو-ساووی', 256),
(2529, 'fa', 'پاری', 257),
(2530, 'fa', 'Seine-Maritime', 258),
(2531, 'fa', 'Seine-et-Marn', 259),
(2532, 'fa', 'ایولینز', 260),
(2533, 'fa', 'Deux-Sèvres', 261),
(2534, 'fa', 'سمی', 262),
(2535, 'fa', 'ضعف', 263),
(2536, 'fa', 'Tarn-et-Garonne', 264),
(2537, 'fa', 'وار', 265),
(2538, 'fa', 'ووکلوز', 266),
(2539, 'fa', 'وندیه', 267),
(2540, 'fa', 'وین', 268),
(2541, 'fa', 'هاوت-وین', 269),
(2542, 'fa', 'رأی دادن', 270),
(2543, 'fa', 'یون', 271),
(2544, 'fa', 'سرزمین-دو-بلفورت', 272),
(2545, 'fa', 'اسون', 273),
(2546, 'fa', 'هاوتز دی سی', 274),
(2547, 'fa', 'Seine-Saint-Deni', 275),
(2548, 'fa', 'والد مارن', 276),
(2549, 'fa', 'Val-d\'Ois', 277),
(2550, 'fa', 'آلبا', 278),
(2551, 'fa', 'آرا', 279),
(2552, 'fa', 'Argeș', 280),
(2553, 'fa', 'باکو', 281),
(2554, 'fa', 'بیهور', 282),
(2555, 'fa', 'بیستریا-نسوود', 283),
(2556, 'fa', 'بوتانی', 284),
(2557, 'fa', 'برازوف', 285),
(2558, 'fa', 'Brăila', 286),
(2559, 'fa', 'București', 287),
(2560, 'fa', 'بوز', 288),
(2561, 'fa', 'کارا- Severin', 289),
(2562, 'fa', 'کالیراسی', 290),
(2563, 'fa', 'كلوژ', 291),
(2564, 'fa', 'کنستانس', 292),
(2565, 'fa', 'کواسنا', 293),
(2566, 'fa', 'Dâmbovița', 294),
(2567, 'fa', 'دال', 295),
(2568, 'fa', 'گالشی', 296),
(2569, 'fa', 'جورجیو', 297),
(2570, 'fa', 'گور', 298),
(2571, 'fa', 'هارگیتا', 299),
(2572, 'fa', 'هوندهار', 300),
(2573, 'fa', 'ایالومیشا', 301),
(2574, 'fa', 'Iași', 302),
(2575, 'fa', 'Ilfo', 303),
(2576, 'fa', 'Maramureș', 304),
(2577, 'fa', 'Mehedinți', 305),
(2578, 'fa', 'Mureș', 306),
(2579, 'fa', 'Neamț', 307),
(2580, 'fa', 'اولت', 308),
(2581, 'fa', 'پرهوا', 309),
(2582, 'fa', 'ستو ماره', 310),
(2583, 'fa', 'سلاج', 311),
(2584, 'fa', 'سیبیو', 312),
(2585, 'fa', 'سوساو', 313),
(2586, 'fa', 'تلورمان', 314),
(2587, 'fa', 'تیمیچ', 315),
(2588, 'fa', 'تولسا', 316),
(2589, 'fa', 'واسلوئی', 317),
(2590, 'fa', 'Vâlcea', 318),
(2591, 'fa', 'ورانسا', 319),
(2592, 'fa', 'لاپی', 320),
(2593, 'fa', 'Pohjois-Pohjanmaa', 321),
(2594, 'fa', 'کائینو', 322),
(2595, 'fa', 'Pohjois-Karjala', 323),
(2596, 'fa', 'Pohjois-Savo', 324),
(2597, 'fa', 'اتل-ساوو', 325),
(2598, 'fa', 'کسکی-پوهانما', 326),
(2599, 'fa', 'Pohjanmaa', 327),
(2600, 'fa', 'پیرکانما', 328),
(2601, 'fa', 'ساتاکونتا', 329),
(2602, 'fa', 'کسکی-پوهانما', 330),
(2603, 'fa', 'کسکی-سوومی', 331),
(2604, 'fa', 'Varsinais-Suomi', 332),
(2605, 'fa', 'اتلی کرجالا', 333),
(2606, 'fa', 'Päijät-HAM', 334),
(2607, 'fa', 'کانتا-هوم', 335),
(2608, 'fa', 'یوسیما', 336),
(2609, 'fa', 'اوسیم', 337),
(2610, 'fa', 'کیمنلاکو', 338),
(2611, 'fa', 'آونوانما', 339),
(2612, 'fa', 'هارژوم', 340),
(2613, 'fa', 'سلا', 341),
(2614, 'fa', 'آیدا-ویروما', 342),
(2615, 'fa', 'Jõgevamaa', 343),
(2616, 'fa', 'جوروماا', 344),
(2617, 'fa', 'لونما', 345),
(2618, 'fa', 'لون-ویروما', 346),
(2619, 'fa', 'پالوماا', 347),
(2620, 'fa', 'پورنوما', 348),
(2621, 'fa', 'Raplama', 349),
(2622, 'fa', 'ساارما', 350),
(2623, 'fa', 'تارتوما', 351),
(2624, 'fa', 'والگام', 352),
(2625, 'fa', 'ویلجاندیم', 353),
(2626, 'fa', 'Võrumaa', 354),
(2627, 'fa', 'داگاوپیل', 355),
(2628, 'fa', 'جلگاو', 356),
(2629, 'fa', 'جکابیل', 357),
(2630, 'fa', 'جرمل', 358),
(2631, 'fa', 'لیپجا', 359),
(2632, 'fa', 'شهرستان لیپاج', 360),
(2633, 'fa', 'روژن', 361),
(2634, 'fa', 'راگ', 362),
(2635, 'fa', 'شهرستان ریگ', 363),
(2636, 'fa', 'والمییرا', 364),
(2637, 'fa', 'Ventspils', 365),
(2638, 'fa', 'آگلوناس نوادا', 366),
(2639, 'fa', 'تازه کاران آیزکرایکلس', 367),
(2640, 'fa', 'تازه واردان', 368),
(2641, 'fa', 'شهرستا', 369),
(2642, 'fa', 'نوازندگان آلوجاس', 370),
(2643, 'fa', 'تازه های آلسونگاس', 371),
(2644, 'fa', 'شهرستان آلوکس', 372),
(2645, 'fa', 'تازه کاران آماتاس', 373),
(2646, 'fa', 'میمون های تازه', 374),
(2647, 'fa', 'نوادا را آویز می کند', 375),
(2648, 'fa', 'شهرستان بابی', 376),
(2649, 'fa', 'Baldones novad', 377),
(2650, 'fa', 'نوین های بالتیناوا', 378),
(2651, 'fa', 'Balvu novad', 379),
(2652, 'fa', 'نوازندگان باسکاس', 380),
(2653, 'fa', 'شهرستان بورین', 381),
(2654, 'fa', 'شهرستان بروچن', 382),
(2655, 'fa', 'بوردنیکو نوآوران', 383),
(2656, 'fa', 'تازه کارنیکاوا', 384),
(2657, 'fa', 'نوازان سزوینس', 385),
(2658, 'fa', 'نوادگان Cibla', 386),
(2659, 'fa', 'شهرستان Cesis', 387),
(2660, 'fa', 'تازه های داگدا', 388),
(2661, 'fa', 'داوگاوپیلز نوادا', 389),
(2662, 'fa', 'دابل نوادی', 390),
(2663, 'fa', 'تازه کارهای دنداگاس', 391),
(2664, 'fa', 'نوباد دوربس', 392),
(2665, 'fa', 'مشغول تازه کارها است', 393),
(2666, 'fa', 'گرکالنس نواد', 394),
(2667, 'fa', 'یا شهرستان گروبی', 395),
(2668, 'fa', 'تازه های گلبنس', 396),
(2669, 'fa', 'Iecavas novads', 397),
(2670, 'fa', 'شهرستان ایسکل', 398),
(2671, 'fa', 'ایالت ایلکست', 399),
(2672, 'fa', 'کنددو د اینچوکالن', 400),
(2673, 'fa', 'نوجواد Jaunjelgavas', 401),
(2674, 'fa', 'تازه های Jaunpiebalgas', 402),
(2675, 'fa', 'شهرستان جونپیلس', 403),
(2676, 'fa', 'شهرستان جگلو', 404),
(2677, 'fa', 'شهرستان جکابیل', 405),
(2678, 'fa', 'شهرستان کنداوا', 406),
(2679, 'fa', 'شهرستان کوکنز', 407),
(2680, 'fa', 'شهرستان کریمولد', 408),
(2681, 'fa', 'شهرستان کرستپیل', 409),
(2682, 'fa', 'شهرستان کراسلاو', 410),
(2683, 'fa', 'کاندادو د کلدیگا', 411),
(2684, 'fa', 'کاندادو د کارساوا', 412),
(2685, 'fa', 'شهرستان لیولوارد', 413),
(2686, 'fa', 'شهرستان لیمباشی', 414),
(2687, 'fa', 'ای ولسوالی لوبون', 415),
(2688, 'fa', 'شهرستان لودزا', 416),
(2689, 'fa', 'شهرستان لیگات', 417),
(2690, 'fa', 'شهرستان لیوانی', 418),
(2691, 'fa', 'شهرستان مادونا', 419),
(2692, 'fa', 'شهرستان مازسال', 420),
(2693, 'fa', 'شهرستان مالپیلس', 421),
(2694, 'fa', 'شهرستان Mārupe', 422),
(2695, 'fa', 'ا کنددو د نوکشنی', 423),
(2696, 'fa', 'کاملاً یک شهرستان', 424),
(2697, 'fa', 'شهرستان نیکا', 425),
(2698, 'fa', 'شهرستان اوگر', 426),
(2699, 'fa', 'شهرستان اولین', 427),
(2700, 'fa', 'شهرستان اوزولنیکی', 428),
(2701, 'fa', 'شهرستان پرلیلی', 429),
(2702, 'fa', 'شهرستان Priekule', 430),
(2703, 'fa', 'Condado de Priekuļi', 431),
(2704, 'fa', 'شهرستان در حال حرکت', 432),
(2705, 'fa', 'شهرستان پاویلوستا', 433),
(2706, 'fa', 'شهرستان Plavinas', 4),
(2707, 'fa', 'شهرستان راونا', 435),
(2708, 'fa', 'شهرستان ریبیشی', 436),
(2709, 'fa', 'شهرستان روجا', 437),
(2710, 'fa', 'شهرستان روپازی', 438),
(2711, 'fa', 'شهرستان روساوا', 439),
(2712, 'fa', 'شهرستان روگی', 440),
(2713, 'fa', 'شهرستان راندل', 441),
(2714, 'fa', 'شهرستان ریزکن', 442),
(2715, 'fa', 'شهرستان روژینا', 443),
(2716, 'fa', 'شهرداری Salacgriva', 444),
(2717, 'fa', 'منطقه جزیره', 445),
(2718, 'fa', 'شهرستان Salaspils', 446),
(2719, 'fa', 'شهرستان سالدوس', 447),
(2720, 'fa', 'شهرستان ساولکرستی', 448),
(2721, 'fa', 'شهرستان سیگولدا', 449),
(2722, 'fa', 'شهرستان Skrunda', 450),
(2723, 'fa', 'شهرستان Skrīveri', 451),
(2724, 'fa', 'شهرستان Smiltene', 452),
(2725, 'fa', 'شهرستان ایستینی', 453),
(2726, 'fa', 'شهرستان استرنشی', 454),
(2727, 'fa', 'منطقه کاشت', 455),
(2728, 'fa', 'شهرستان تالسی', 456),
(2729, 'fa', 'توکومس', 457),
(2730, 'fa', 'شهرستان تورت', 458),
(2731, 'fa', 'یا شهرستان وایودود', 459),
(2732, 'fa', 'شهرستان والکا', 460),
(2733, 'fa', 'شهرستان Valmiera', 461),
(2734, 'fa', 'شهرستان وارکانی', 462),
(2735, 'fa', 'شهرستان Vecpiebalga', 463),
(2736, 'fa', 'شهرستان وکومنیکی', 464),
(2737, 'fa', 'شهرستان ونتسپیل', 465),
(2738, 'fa', 'کنددو د بازدید', 466),
(2739, 'fa', 'شهرستان ویلاکا', 467),
(2740, 'fa', 'شهرستان ویلانی', 468),
(2741, 'fa', 'شهرستان واركاوا', 469),
(2742, 'fa', 'شهرستان زیلوپ', 470),
(2743, 'fa', 'شهرستان آدازی', 471),
(2744, 'fa', 'شهرستان ارگلو', 472),
(2745, 'fa', 'شهرستان کگومس', 473),
(2746, 'fa', 'شهرستان ککاوا', 474),
(2747, 'fa', 'شهرستان Alytus', 475),
(2748, 'fa', 'شهرستان Kaunas', 476),
(2749, 'fa', 'شهرستان کلایپدا', 477),
(2750, 'fa', 'شهرستان ماریجامپولی', 478),
(2751, 'fa', 'شهرستان پانویسیز', 479),
(2752, 'fa', 'شهرستان سیاولیا', 480),
(2753, 'fa', 'شهرستان تاجیج', 481),
(2754, 'fa', 'شهرستان تلشیا', 482),
(2755, 'fa', 'شهرستان اوتنا', 483),
(2756, 'fa', 'شهرستان ویلنیوس', 484),
(2757, 'fa', 'جریب', 485),
(2758, 'fa', 'حالت', 486),
(2759, 'fa', 'آمپá', 487),
(2760, 'fa', 'آمازون', 488),
(2761, 'fa', 'باهی', 489),
(2762, 'fa', 'سارا', 490),
(2763, 'fa', 'روح القدس', 491),
(2764, 'fa', 'برو', 492),
(2765, 'fa', 'مارانهائ', 493),
(2766, 'fa', 'ماتو گروسو', 494),
(2767, 'fa', 'Mato Grosso do Sul', 495),
(2768, 'fa', 'ایالت میناس گرایس', 496),
(2769, 'fa', 'پار', 497),
(2770, 'fa', 'حالت', 498),
(2771, 'fa', 'پارانا', 499),
(2772, 'fa', 'حال', 500),
(2773, 'fa', 'پیازو', 501),
(2774, 'fa', 'ریو دوژانیرو', 502),
(2775, 'fa', 'ریو گراند دو نورته', 503),
(2776, 'fa', 'ریو گراند دو سول', 504),
(2777, 'fa', 'Rondôni', 505),
(2778, 'fa', 'Roraim', 506),
(2779, 'fa', 'سانتا کاتارینا', 507),
(2780, 'fa', 'پ', 508),
(2781, 'fa', 'Sergip', 509),
(2782, 'fa', 'توکانتین', 510),
(2783, 'fa', 'منطقه فدرال', 511),
(2784, 'fa', 'شهرستان زاگرب', 512),
(2785, 'fa', 'Condado de Krapina-Zagorj', 513),
(2786, 'fa', 'شهرستان سیساک-موسلاوینا', 514),
(2787, 'fa', 'شهرستان کارلوواک', 515),
(2788, 'fa', 'شهرداری واراžدین', 516),
(2789, 'fa', 'Condo de Koprivnica-Križevci', 517),
(2790, 'fa', 'محل سکونت د بیلوار-بلوگورا', 518),
(2791, 'fa', 'Condado de Primorje-Gorski kotar', 519),
(2792, 'fa', 'شهرستان لیکا-سنج', 520),
(2793, 'fa', 'Condado de Virovitica-Podravina', 521),
(2794, 'fa', 'شهرستان پوژگا-اسلاونیا', 522),
(2795, 'fa', 'Condado de Brod-Posavina', 523),
(2796, 'fa', 'شهرستان زجر', 524),
(2797, 'fa', 'Condado de Osijek-Baranja', 525),
(2798, 'fa', 'Condo de Sibenik-Knin', 526),
(2799, 'fa', 'Condado de Vukovar-Srijem', 527),
(2800, 'fa', 'شهرستان اسپلیت-Dalmatia', 528),
(2801, 'fa', 'شهرستان ایستیا', 529),
(2802, 'fa', 'Condado de Dubrovnik-Neretva', 530),
(2803, 'fa', 'شهرستان Međimurje', 531),
(2804, 'fa', 'شهر زاگرب', 532),
(2805, 'fa', 'جزایر آندامان و نیکوبار', 533),
(2806, 'fa', 'آندرا پرادش', 534),
(2807, 'fa', 'آروناچال پرادش', 535),
(2808, 'fa', 'آسام', 536),
(2809, 'fa', 'Biha', 537),
(2810, 'fa', 'چاندیگار', 538),
(2811, 'fa', 'چاتیسگار', 539),
(2812, 'fa', 'دادرا و نگار هاولی', 540),
(2813, 'fa', 'دامان و دیو', 541),
(2814, 'fa', 'دهلی', 542),
(2815, 'fa', 'گوا', 543),
(2816, 'fa', 'گجرات', 544),
(2817, 'fa', 'هاریانا', 545),
(2818, 'fa', 'هیماچال پرادش', 546),
(2819, 'fa', 'جامو و کشمیر', 547),
(2820, 'fa', 'جهخند', 548),
(2821, 'fa', 'کارناتاکا', 549),
(2822, 'fa', 'کرال', 550),
(2823, 'fa', 'لاکشادوپ', 551),
(2824, 'fa', 'مادیا پرادش', 552),
(2825, 'fa', 'ماهاراشترا', 553),
(2826, 'fa', 'مانی پور', 554),
(2827, 'fa', 'مگالایا', 555),
(2828, 'fa', 'مزورام', 556),
(2829, 'fa', 'ناگلند', 557),
(2830, 'fa', 'ادیشا', 558),
(2831, 'fa', 'میناکاری', 559),
(2832, 'fa', 'پنجا', 560),
(2833, 'fa', 'راجستان', 561),
(2834, 'fa', 'سیکیم', 562),
(2835, 'fa', 'تامیل نادو', 563),
(2836, 'fa', 'تلنگانا', 564),
(2837, 'fa', 'تریپورا', 565),
(2838, 'fa', 'اوتار پرادش', 566),
(2839, 'fa', 'اوتاراکند', 567),
(2840, 'fa', 'بنگال غرب', 568),
(2841, 'pt_BR', 'Alabama', 1),
(2842, 'pt_BR', 'Alaska', 2),
(2843, 'pt_BR', 'Samoa Americana', 3),
(2844, 'pt_BR', 'Arizona', 4),
(2845, 'pt_BR', 'Arkansas', 5),
(2846, 'pt_BR', 'Forças Armadas da África', 6),
(2847, 'pt_BR', 'Forças Armadas das Américas', 7),
(2848, 'pt_BR', 'Forças Armadas do Canadá', 8),
(2849, 'pt_BR', 'Forças Armadas da Europa', 9),
(2850, 'pt_BR', 'Forças Armadas do Oriente Médio', 10),
(2851, 'pt_BR', 'Forças Armadas do Pacífico', 11),
(2852, 'pt_BR', 'California', 12),
(2853, 'pt_BR', 'Colorado', 13),
(2854, 'pt_BR', 'Connecticut', 14),
(2855, 'pt_BR', 'Delaware', 15),
(2856, 'pt_BR', 'Distrito de Columbia', 16),
(2857, 'pt_BR', 'Estados Federados da Micronésia', 17),
(2858, 'pt_BR', 'Florida', 18),
(2859, 'pt_BR', 'Geórgia', 19),
(2860, 'pt_BR', 'Guam', 20),
(2861, 'pt_BR', 'Havaí', 21),
(2862, 'pt_BR', 'Idaho', 22),
(2863, 'pt_BR', 'Illinois', 23),
(2864, 'pt_BR', 'Indiana', 24),
(2865, 'pt_BR', 'Iowa', 25),
(2866, 'pt_BR', 'Kansas', 26),
(2867, 'pt_BR', 'Kentucky', 27),
(2868, 'pt_BR', 'Louisiana', 28),
(2869, 'pt_BR', 'Maine', 29),
(2870, 'pt_BR', 'Ilhas Marshall', 30),
(2871, 'pt_BR', 'Maryland', 31),
(2872, 'pt_BR', 'Massachusetts', 32),
(2873, 'pt_BR', 'Michigan', 33),
(2874, 'pt_BR', 'Minnesota', 34),
(2875, 'pt_BR', 'Mississippi', 35),
(2876, 'pt_BR', 'Missouri', 36),
(2877, 'pt_BR', 'Montana', 37),
(2878, 'pt_BR', 'Nebraska', 38),
(2879, 'pt_BR', 'Nevada', 39),
(2880, 'pt_BR', 'New Hampshire', 40),
(2881, 'pt_BR', 'Nova Jersey', 41),
(2882, 'pt_BR', 'Novo México', 42),
(2883, 'pt_BR', 'Nova York', 43),
(2884, 'pt_BR', 'Carolina do Norte', 44),
(2885, 'pt_BR', 'Dakota do Norte', 45),
(2886, 'pt_BR', 'Ilhas Marianas do Norte', 46),
(2887, 'pt_BR', 'Ohio', 47),
(2888, 'pt_BR', 'Oklahoma', 48),
(2889, 'pt_BR', 'Oregon', 4),
(2890, 'pt_BR', 'Palau', 50),
(2891, 'pt_BR', 'Pensilvânia', 51),
(2892, 'pt_BR', 'Porto Rico', 52),
(2893, 'pt_BR', 'Rhode Island', 53),
(2894, 'pt_BR', 'Carolina do Sul', 54),
(2895, 'pt_BR', 'Dakota do Sul', 55),
(2896, 'pt_BR', 'Tennessee', 56),
(2897, 'pt_BR', 'Texas', 57),
(2898, 'pt_BR', 'Utah', 58),
(2899, 'pt_BR', 'Vermont', 59),
(2900, 'pt_BR', 'Ilhas Virgens', 60),
(2901, 'pt_BR', 'Virginia', 61),
(2902, 'pt_BR', 'Washington', 62),
(2903, 'pt_BR', 'West Virginia', 63),
(2904, 'pt_BR', 'Wisconsin', 64),
(2905, 'pt_BR', 'Wyoming', 65),
(2906, 'pt_BR', 'Alberta', 66),
(2907, 'pt_BR', 'Colúmbia Britânica', 67),
(2908, 'pt_BR', 'Manitoba', 68),
(2909, 'pt_BR', 'Terra Nova e Labrador', 69),
(2910, 'pt_BR', 'New Brunswick', 70),
(2911, 'pt_BR', 'Nova Escócia', 7),
(2912, 'pt_BR', 'Territórios do Noroeste', 72),
(2913, 'pt_BR', 'Nunavut', 73),
(2914, 'pt_BR', 'Ontario', 74),
(2915, 'pt_BR', 'Ilha do Príncipe Eduardo', 75),
(2916, 'pt_BR', 'Quebec', 76),
(2917, 'pt_BR', 'Saskatchewan', 77),
(2918, 'pt_BR', 'Território yukon', 78),
(2919, 'pt_BR', 'Niedersachsen', 79),
(2920, 'pt_BR', 'Baden-Wurttemberg', 80),
(2921, 'pt_BR', 'Bayern', 81),
(2922, 'pt_BR', 'Berlim', 82),
(2923, 'pt_BR', 'Brandenburg', 83),
(2924, 'pt_BR', 'Bremen', 84),
(2925, 'pt_BR', 'Hamburgo', 85),
(2926, 'pt_BR', 'Hessen', 86),
(2927, 'pt_BR', 'Mecklenburg-Vorpommern', 87),
(2928, 'pt_BR', 'Nordrhein-Westfalen', 88),
(2929, 'pt_BR', 'Renânia-Palatinado', 8),
(2930, 'pt_BR', 'Sarre', 90),
(2931, 'pt_BR', 'Sachsen', 91),
(2932, 'pt_BR', 'Sachsen-Anhalt', 92),
(2933, 'pt_BR', 'Schleswig-Holstein', 93),
(2934, 'pt_BR', 'Turíngia', 94),
(2935, 'pt_BR', 'Viena', 95),
(2936, 'pt_BR', 'Baixa Áustria', 96),
(2937, 'pt_BR', 'Oberösterreich', 97),
(2938, 'pt_BR', 'Salzburg', 98),
(2939, 'pt_BR', 'Caríntia', 99),
(2940, 'pt_BR', 'Steiermark', 100),
(2941, 'pt_BR', 'Tirol', 101),
(2942, 'pt_BR', 'Burgenland', 102),
(2943, 'pt_BR', 'Vorarlberg', 103),
(2944, 'pt_BR', 'Aargau', 104),
(2945, 'pt_BR', 'Appenzell Innerrhoden', 105),
(2946, 'pt_BR', 'Appenzell Ausserrhoden', 106),
(2947, 'pt_BR', 'Bern', 107),
(2948, 'pt_BR', 'Basel-Landschaft', 108),
(2949, 'pt_BR', 'Basel-Stadt', 109),
(2950, 'pt_BR', 'Freiburg', 110),
(2951, 'pt_BR', 'Genf', 111),
(2952, 'pt_BR', 'Glarus', 112),
(2953, 'pt_BR', 'Grisons', 113),
(2954, 'pt_BR', 'Jura', 114),
(2955, 'pt_BR', 'Luzern', 115),
(2956, 'pt_BR', 'Neuenburg', 116),
(2957, 'pt_BR', 'Nidwalden', 117),
(2958, 'pt_BR', 'Obwalden', 118),
(2959, 'pt_BR', 'St. Gallen', 119),
(2960, 'pt_BR', 'Schaffhausen', 120),
(2961, 'pt_BR', 'Solothurn', 121),
(2962, 'pt_BR', 'Schwyz', 122),
(2963, 'pt_BR', 'Thurgau', 123),
(2964, 'pt_BR', 'Tessin', 124),
(2965, 'pt_BR', 'Uri', 125),
(2966, 'pt_BR', 'Waadt', 126),
(2967, 'pt_BR', 'Wallis', 127),
(2968, 'pt_BR', 'Zug', 128),
(2969, 'pt_BR', 'Zurique', 129),
(2970, 'pt_BR', 'Corunha', 130),
(2971, 'pt_BR', 'Álava', 131),
(2972, 'pt_BR', 'Albacete', 132),
(2973, 'pt_BR', 'Alicante', 133),
(2974, 'pt_BR', 'Almeria', 134),
(2975, 'pt_BR', 'Astúrias', 135),
(2976, 'pt_BR', 'Avila', 136),
(2977, 'pt_BR', 'Badajoz', 137),
(2978, 'pt_BR', 'Baleares', 138),
(2979, 'pt_BR', 'Barcelona', 139),
(2980, 'pt_BR', 'Burgos', 140),
(2981, 'pt_BR', 'Caceres', 141),
(2982, 'pt_BR', 'Cadiz', 142),
(2983, 'pt_BR', 'Cantábria', 143),
(2984, 'pt_BR', 'Castellon', 144),
(2985, 'pt_BR', 'Ceuta', 145),
(2986, 'pt_BR', 'Ciudad Real', 146),
(2987, 'pt_BR', 'Cordoba', 147),
(2988, 'pt_BR', 'Cuenca', 148),
(2989, 'pt_BR', 'Girona', 149),
(2990, 'pt_BR', 'Granada', 150),
(2991, 'pt_BR', 'Guadalajara', 151),
(2992, 'pt_BR', 'Guipuzcoa', 152),
(2993, 'pt_BR', 'Huelva', 153),
(2994, 'pt_BR', 'Huesca', 154),
(2995, 'pt_BR', 'Jaen', 155),
(2996, 'pt_BR', 'La Rioja', 156),
(2997, 'pt_BR', 'Las Palmas', 157),
(2998, 'pt_BR', 'Leon', 158),
(2999, 'pt_BR', 'Lleida', 159),
(3000, 'pt_BR', 'Lugo', 160),
(3001, 'pt_BR', 'Madri', 161),
(3002, 'pt_BR', 'Málaga', 162),
(3003, 'pt_BR', 'Melilla', 163),
(3004, 'pt_BR', 'Murcia', 164),
(3005, 'pt_BR', 'Navarra', 165),
(3006, 'pt_BR', 'Ourense', 166),
(3007, 'pt_BR', 'Palencia', 167),
(3008, 'pt_BR', 'Pontevedra', 168),
(3009, 'pt_BR', 'Salamanca', 169),
(3010, 'pt_BR', 'Santa Cruz de Tenerife', 170),
(3011, 'pt_BR', 'Segovia', 171),
(3012, 'pt_BR', 'Sevilla', 172),
(3013, 'pt_BR', 'Soria', 173),
(3014, 'pt_BR', 'Tarragona', 174),
(3015, 'pt_BR', 'Teruel', 175),
(3016, 'pt_BR', 'Toledo', 176),
(3017, 'pt_BR', 'Valencia', 177),
(3018, 'pt_BR', 'Valladolid', 178),
(3019, 'pt_BR', 'Vizcaya', 179),
(3020, 'pt_BR', 'Zamora', 180),
(3021, 'pt_BR', 'Zaragoza', 181),
(3022, 'pt_BR', 'Ain', 182),
(3023, 'pt_BR', 'Aisne', 183),
(3024, 'pt_BR', 'Allier', 184),
(3025, 'pt_BR', 'Alpes da Alta Provença', 185),
(3026, 'pt_BR', 'Altos Alpes', 186),
(3027, 'pt_BR', 'Alpes-Maritimes', 187),
(3028, 'pt_BR', 'Ardèche', 188),
(3029, 'pt_BR', 'Ardennes', 189),
(3030, 'pt_BR', 'Ariege', 190),
(3031, 'pt_BR', 'Aube', 191),
(3032, 'pt_BR', 'Aude', 192),
(3033, 'pt_BR', 'Aveyron', 193),
(3034, 'pt_BR', 'BOCAS DO Rhône', 194),
(3035, 'pt_BR', 'Calvados', 195),
(3036, 'pt_BR', 'Cantal', 196),
(3037, 'pt_BR', 'Charente', 197),
(3038, 'pt_BR', 'Charente-Maritime', 198),
(3039, 'pt_BR', 'Cher', 199),
(3040, 'pt_BR', 'Corrèze', 200),
(3041, 'pt_BR', 'Corse-du-Sud', 201),
(3042, 'pt_BR', 'Alta Córsega', 202),
(3043, 'pt_BR', 'Costa d\'OrCorrèze', 203),
(3044, 'pt_BR', 'Cotes d\'Armor', 204),
(3045, 'pt_BR', 'Creuse', 205),
(3046, 'pt_BR', 'Dordogne', 206),
(3047, 'pt_BR', 'Doubs', 207),
(3048, 'pt_BR', 'DrômeFinistère', 208),
(3049, 'pt_BR', 'Eure', 209),
(3050, 'pt_BR', 'Eure-et-Loir', 210),
(3051, 'pt_BR', 'Finistère', 211),
(3052, 'pt_BR', 'Gard', 212),
(3053, 'pt_BR', 'Haute-Garonne', 213),
(3054, 'pt_BR', 'Gers', 214),
(3055, 'pt_BR', 'Gironde', 215),
(3056, 'pt_BR', 'Hérault', 216),
(3057, 'pt_BR', 'Ille-et-Vilaine', 217),
(3058, 'pt_BR', 'Indre', 218),
(3059, 'pt_BR', 'Indre-et-Loire', 219),
(3060, 'pt_BR', 'Isère', 220),
(3061, 'pt_BR', 'Jura', 221),
(3062, 'pt_BR', 'Landes', 222),
(3063, 'pt_BR', 'Loir-et-Cher', 223),
(3064, 'pt_BR', 'Loire', 224),
(3065, 'pt_BR', 'Haute-Loire', 22),
(3066, 'pt_BR', 'Loire-Atlantique', 226),
(3067, 'pt_BR', 'Loiret', 227),
(3068, 'pt_BR', 'Lot', 228),
(3069, 'pt_BR', 'Lot e Garona', 229),
(3070, 'pt_BR', 'Lozère', 230),
(3071, 'pt_BR', 'Maine-et-Loire', 231),
(3072, 'pt_BR', 'Manche', 232),
(3073, 'pt_BR', 'Marne', 233),
(3074, 'pt_BR', 'Haute-Marne', 234),
(3075, 'pt_BR', 'Mayenne', 235),
(3076, 'pt_BR', 'Meurthe-et-Moselle', 236),
(3077, 'pt_BR', 'Meuse', 237),
(3078, 'pt_BR', 'Morbihan', 238),
(3079, 'pt_BR', 'Moselle', 239),
(3080, 'pt_BR', 'Nièvre', 240),
(3081, 'pt_BR', 'Nord', 241),
(3082, 'pt_BR', 'Oise', 242),
(3083, 'pt_BR', 'Orne', 243),
(3084, 'pt_BR', 'Pas-de-Calais', 244),
(3085, 'pt_BR', 'Puy-de-Dôme', 24),
(3086, 'pt_BR', 'Pirineus Atlânticos', 246),
(3087, 'pt_BR', 'Hautes-Pyrénées', 247),
(3088, 'pt_BR', 'Pirineus Orientais', 248),
(3089, 'pt_BR', 'Bas-Rhin', 249),
(3090, 'pt_BR', 'Alto Reno', 250),
(3091, 'pt_BR', 'Rhône', 251),
(3092, 'pt_BR', 'Haute-Saône', 252),
(3093, 'pt_BR', 'Saône-et-Loire', 253),
(3094, 'pt_BR', 'Sarthe', 25),
(3095, 'pt_BR', 'Savoie', 255),
(3096, 'pt_BR', 'Alta Sabóia', 256),
(3097, 'pt_BR', 'Paris', 257),
(3098, 'pt_BR', 'Seine-Maritime', 258),
(3099, 'pt_BR', 'Seine-et-Marne', 259),
(3100, 'pt_BR', 'Yvelines', 260),
(3101, 'pt_BR', 'Deux-Sèvres', 261),
(3102, 'pt_BR', 'Somme', 262),
(3103, 'pt_BR', 'Tarn', 263),
(3104, 'pt_BR', 'Tarn-et-Garonne', 264),
(3105, 'pt_BR', 'Var', 265),
(3106, 'pt_BR', 'Vaucluse', 266),
(3107, 'pt_BR', 'Compradora', 267),
(3108, 'pt_BR', 'Vienne', 268),
(3109, 'pt_BR', 'Haute-Vienne', 269),
(3110, 'pt_BR', 'Vosges', 270),
(3111, 'pt_BR', 'Yonne', 271),
(3112, 'pt_BR', 'Território de Belfort', 272),
(3113, 'pt_BR', 'Essonne', 273),
(3114, 'pt_BR', 'Altos do Sena', 274),
(3115, 'pt_BR', 'Seine-Saint-Denis', 275),
(3116, 'pt_BR', 'Val-de-Marne', 276),
(3117, 'pt_BR', 'Val-d\'Oise', 277),
(3118, 'pt_BR', 'Alba', 278),
(3119, 'pt_BR', 'Arad', 279),
(3120, 'pt_BR', 'Arges', 280),
(3121, 'pt_BR', 'Bacau', 281),
(3122, 'pt_BR', 'Bihor', 282),
(3123, 'pt_BR', 'Bistrita-Nasaud', 283),
(3124, 'pt_BR', 'Botosani', 284),
(3125, 'pt_BR', 'Brașov', 285),
(3126, 'pt_BR', 'Braila', 286),
(3127, 'pt_BR', 'Bucareste', 287),
(3128, 'pt_BR', 'Buzau', 288),
(3129, 'pt_BR', 'Caras-Severin', 289),
(3130, 'pt_BR', 'Călărași', 290),
(3131, 'pt_BR', 'Cluj', 291),
(3132, 'pt_BR', 'Constanta', 292),
(3133, 'pt_BR', 'Covasna', 29),
(3134, 'pt_BR', 'Dambovita', 294),
(3135, 'pt_BR', 'Dolj', 295),
(3136, 'pt_BR', 'Galati', 296),
(3137, 'pt_BR', 'Giurgiu', 297),
(3138, 'pt_BR', 'Gorj', 298),
(3139, 'pt_BR', 'Harghita', 299),
(3140, 'pt_BR', 'Hunedoara', 300),
(3141, 'pt_BR', 'Ialomita', 301),
(3142, 'pt_BR', 'Iasi', 302),
(3143, 'pt_BR', 'Ilfov', 303),
(3144, 'pt_BR', 'Maramures', 304),
(3145, 'pt_BR', 'Maramures', 305),
(3146, 'pt_BR', 'Mures', 306),
(3147, 'pt_BR', 'alemão', 307),
(3148, 'pt_BR', 'Olt', 308),
(3149, 'pt_BR', 'Prahova', 309),
(3150, 'pt_BR', 'Satu-Mare', 310),
(3151, 'pt_BR', 'Salaj', 311),
(3152, 'pt_BR', 'Sibiu', 312),
(3153, 'pt_BR', 'Suceava', 313),
(3154, 'pt_BR', 'Teleorman', 314),
(3155, 'pt_BR', 'Timis', 315),
(3156, 'pt_BR', 'Tulcea', 316),
(3157, 'pt_BR', 'Vaslui', 317),
(3158, 'pt_BR', 'dale', 318),
(3159, 'pt_BR', 'Vrancea', 319),
(3160, 'pt_BR', 'Lappi', 320),
(3161, 'pt_BR', 'Pohjois-Pohjanmaa', 321),
(3162, 'pt_BR', 'Kainuu', 322),
(3163, 'pt_BR', 'Pohjois-Karjala', 323),
(3164, 'pt_BR', 'Pohjois-Savo', 324),
(3165, 'pt_BR', 'Sul Savo', 325),
(3166, 'pt_BR', 'Ostrobothnia do sul', 326),
(3167, 'pt_BR', 'Pohjanmaa', 327),
(3168, 'pt_BR', 'Pirkanmaa', 328),
(3169, 'pt_BR', 'Satakunta', 329),
(3170, 'pt_BR', 'Keski-Pohjanmaa', 330),
(3171, 'pt_BR', 'Keski-Suomi', 331),
(3172, 'pt_BR', 'Varsinais-Suomi', 332),
(3173, 'pt_BR', 'Carélia do Sul', 333),
(3174, 'pt_BR', 'Päijät-Häme', 334),
(3175, 'pt_BR', 'Kanta-Häme', 335),
(3176, 'pt_BR', 'Uusimaa', 336),
(3177, 'pt_BR', 'Uusimaa', 337),
(3178, 'pt_BR', 'Kymenlaakso', 338),
(3179, 'pt_BR', 'Ahvenanmaa', 339),
(3180, 'pt_BR', 'Harjumaa', 340),
(3181, 'pt_BR', 'Hiiumaa', 341),
(3182, 'pt_BR', 'Ida-Virumaa', 342),
(3183, 'pt_BR', 'Condado de Jõgeva', 343),
(3184, 'pt_BR', 'Condado de Järva', 344),
(3185, 'pt_BR', 'Läänemaa', 345),
(3186, 'pt_BR', 'Condado de Lääne-Viru', 346),
(3187, 'pt_BR', 'Condado de Põlva', 347),
(3188, 'pt_BR', 'Condado de Pärnu', 348),
(3189, 'pt_BR', 'Raplamaa', 349),
(3190, 'pt_BR', 'Saaremaa', 350),
(3191, 'pt_BR', 'Tartumaa', 351),
(3192, 'pt_BR', 'Valgamaa', 352),
(3193, 'pt_BR', 'Viljandimaa', 353),
(3194, 'pt_BR', 'Võrumaa', 354),
(3195, 'pt_BR', 'Daugavpils', 355),
(3196, 'pt_BR', 'Jelgava', 356),
(3197, 'pt_BR', 'Jekabpils', 357),
(3198, 'pt_BR', 'Jurmala', 358),
(3199, 'pt_BR', 'Liepaja', 359),
(3200, 'pt_BR', 'Liepaja County', 360),
(3201, 'pt_BR', 'Rezekne', 361),
(3202, 'pt_BR', 'Riga', 362),
(3203, 'pt_BR', 'Condado de Riga', 363),
(3204, 'pt_BR', 'Valmiera', 364),
(3205, 'pt_BR', 'Ventspils', 365),
(3206, 'pt_BR', 'Aglonas novads', 366),
(3207, 'pt_BR', 'Aizkraukles novads', 367),
(3208, 'pt_BR', 'Aizputes novads', 368),
(3209, 'pt_BR', 'Condado de Akniste', 369),
(3210, 'pt_BR', 'Alojas novads', 370),
(3211, 'pt_BR', 'Alsungas novads', 371),
(3212, 'pt_BR', 'Aluksne County', 372),
(3213, 'pt_BR', 'Amatas novads', 373),
(3214, 'pt_BR', 'Macacos novads', 374),
(3215, 'pt_BR', 'Auces novads', 375),
(3216, 'pt_BR', 'Babītes novads', 376),
(3217, 'pt_BR', 'Baldones novads', 377),
(3218, 'pt_BR', 'Baltinavas novads', 378),
(3219, 'pt_BR', 'Balvu novads', 379),
(3220, 'pt_BR', 'Bauskas novads', 380),
(3221, 'pt_BR', 'Condado de Beverina', 381),
(3222, 'pt_BR', 'Condado de Broceni', 382),
(3223, 'pt_BR', 'Burtnieku novads', 383),
(3224, 'pt_BR', 'Carnikavas novads', 384),
(3225, 'pt_BR', 'Cesvaines novads', 385),
(3226, 'pt_BR', 'Ciblas novads', 386),
(3227, 'pt_BR', 'Cesis county', 387),
(3228, 'pt_BR', 'Dagdas novads', 388),
(3229, 'pt_BR', 'Daugavpils novads', 389),
(3230, 'pt_BR', 'Dobeles novads', 390),
(3231, 'pt_BR', 'Dundagas novads', 391),
(3232, 'pt_BR', 'Durbes novads', 392),
(3233, 'pt_BR', 'Engad novads', 393),
(3234, 'pt_BR', 'Garkalnes novads', 394),
(3235, 'pt_BR', 'O condado de Grobiņa', 395),
(3236, 'pt_BR', 'Gulbenes novads', 396),
(3237, 'pt_BR', 'Iecavas novads', 397),
(3238, 'pt_BR', 'Ikskile county', 398),
(3239, 'pt_BR', 'Ilūkste county', 399),
(3240, 'pt_BR', 'Condado de Inčukalns', 400),
(3241, 'pt_BR', 'Jaunjelgavas novads', 401),
(3242, 'pt_BR', 'Jaunpiebalgas novads', 402),
(3243, 'pt_BR', 'Jaunpils novads', 403),
(3244, 'pt_BR', 'Jelgavas novads', 404),
(3245, 'pt_BR', 'Jekabpils county', 405),
(3246, 'pt_BR', 'Kandavas novads', 406),
(3247, 'pt_BR', 'Kokneses novads', 407),
(3248, 'pt_BR', 'Krimuldas novads', 408),
(3249, 'pt_BR', 'Krustpils novads', 409),
(3250, 'pt_BR', 'Condado de Kraslava', 410),
(3251, 'pt_BR', 'Condado de Kuldīga', 411),
(3252, 'pt_BR', 'Condado de Kārsava', 412),
(3253, 'pt_BR', 'Condado de Lielvarde', 413),
(3254, 'pt_BR', 'Condado de Limbaži', 414),
(3255, 'pt_BR', 'O distrito de Lubāna', 415),
(3256, 'pt_BR', 'Ludzas novads', 416),
(3257, 'pt_BR', 'Ligatne county', 417),
(3258, 'pt_BR', 'Livani county', 418),
(3259, 'pt_BR', 'Madonas novads', 419),
(3260, 'pt_BR', 'Mazsalacas novads', 420),
(3261, 'pt_BR', 'Mālpils county', 421),
(3262, 'pt_BR', 'Mārupe county', 422),
(3263, 'pt_BR', 'O condado de Naukšēni', 423),
(3264, 'pt_BR', 'Neretas novads', 424),
(3265, 'pt_BR', 'Nīca county', 425),
(3266, 'pt_BR', 'Ogres novads', 426),
(3267, 'pt_BR', 'Olaines novads', 427),
(3268, 'pt_BR', 'Ozolnieku novads', 428),
(3269, 'pt_BR', 'Preiļi county', 429),
(3270, 'pt_BR', 'Priekules novads', 430),
(3271, 'pt_BR', 'Condado de Priekuļi', 431),
(3272, 'pt_BR', 'Moving county', 432),
(3273, 'pt_BR', 'Condado de Pavilosta', 433),
(3274, 'pt_BR', 'Condado de Plavinas', 434);
INSERT INTO `country_state_translations` (`id`, `locale`, `default_name`, `country_state_id`) VALUES
(3275, 'pt_BR', 'Raunas novads', 435),
(3276, 'pt_BR', 'Condado de Riebiņi', 436),
(3277, 'pt_BR', 'Rojas novads', 437),
(3278, 'pt_BR', 'Ropazi county', 438),
(3279, 'pt_BR', 'Rucavas novads', 439),
(3280, 'pt_BR', 'Rugāji county', 440),
(3281, 'pt_BR', 'Rundāle county', 441),
(3282, 'pt_BR', 'Rezekne county', 442),
(3283, 'pt_BR', 'Rūjiena county', 443),
(3284, 'pt_BR', 'O município de Salacgriva', 444),
(3285, 'pt_BR', 'Salas novads', 445),
(3286, 'pt_BR', 'Salaspils novads', 446),
(3287, 'pt_BR', 'Saldus novads', 447),
(3288, 'pt_BR', 'Saulkrastu novads', 448),
(3289, 'pt_BR', 'Siguldas novads', 449),
(3290, 'pt_BR', 'Skrundas novads', 450),
(3291, 'pt_BR', 'Skrīveri county', 451),
(3292, 'pt_BR', 'Smiltenes novads', 452),
(3293, 'pt_BR', 'Condado de Stopini', 453),
(3294, 'pt_BR', 'Condado de Strenči', 454),
(3295, 'pt_BR', 'Região de semeadura', 455),
(3296, 'pt_BR', 'Talsu novads', 456),
(3297, 'pt_BR', 'Tukuma novads', 457),
(3298, 'pt_BR', 'Condado de Tērvete', 458),
(3299, 'pt_BR', 'O condado de Vaiņode', 459),
(3300, 'pt_BR', 'Valkas novads', 460),
(3301, 'pt_BR', 'Valmieras novads', 461),
(3302, 'pt_BR', 'Varaklani county', 462),
(3303, 'pt_BR', 'Vecpiebalgas novads', 463),
(3304, 'pt_BR', 'Vecumnieku novads', 464),
(3305, 'pt_BR', 'Ventspils novads', 465),
(3306, 'pt_BR', 'Condado de Viesite', 466),
(3307, 'pt_BR', 'Condado de Vilaka', 467),
(3308, 'pt_BR', 'Vilani county', 468),
(3309, 'pt_BR', 'Condado de Varkava', 469),
(3310, 'pt_BR', 'Zilupes novads', 470),
(3311, 'pt_BR', 'Adazi county', 471),
(3312, 'pt_BR', 'Erglu county', 472),
(3313, 'pt_BR', 'Kegums county', 473),
(3314, 'pt_BR', 'Kekava county', 474),
(3315, 'pt_BR', 'Alytaus Apskritis', 475),
(3316, 'pt_BR', 'Kauno Apskritis', 476),
(3317, 'pt_BR', 'Condado de Klaipeda', 477),
(3318, 'pt_BR', 'Marijampolė county', 478),
(3319, 'pt_BR', 'Panevezys county', 479),
(3320, 'pt_BR', 'Siauliai county', 480),
(3321, 'pt_BR', 'Taurage county', 481),
(3322, 'pt_BR', 'Telšiai county', 482),
(3323, 'pt_BR', 'Utenos Apskritis', 483),
(3324, 'pt_BR', 'Vilniaus Apskritis', 484),
(3325, 'pt_BR', 'Acre', 485),
(3326, 'pt_BR', 'Alagoas', 486),
(3327, 'pt_BR', 'Amapá', 487),
(3328, 'pt_BR', 'Amazonas', 488),
(3329, 'pt_BR', 'Bahia', 489),
(3330, 'pt_BR', 'Ceará', 490),
(3331, 'pt_BR', 'Espírito Santo', 491),
(3332, 'pt_BR', 'Goiás', 492),
(3333, 'pt_BR', 'Maranhão', 493),
(3334, 'pt_BR', 'Mato Grosso', 494),
(3335, 'pt_BR', 'Mato Grosso do Sul', 495),
(3336, 'pt_BR', 'Minas Gerais', 496),
(3337, 'pt_BR', 'Pará', 497),
(3338, 'pt_BR', 'Paraíba', 498),
(3339, 'pt_BR', 'Paraná', 499),
(3340, 'pt_BR', 'Pernambuco', 500),
(3341, 'pt_BR', 'Piauí', 501),
(3342, 'pt_BR', 'Rio de Janeiro', 502),
(3343, 'pt_BR', 'Rio Grande do Norte', 503),
(3344, 'pt_BR', 'Rio Grande do Sul', 504),
(3345, 'pt_BR', 'Rondônia', 505),
(3346, 'pt_BR', 'Roraima', 506),
(3347, 'pt_BR', 'Santa Catarina', 507),
(3348, 'pt_BR', 'São Paulo', 508),
(3349, 'pt_BR', 'Sergipe', 509),
(3350, 'pt_BR', 'Tocantins', 510),
(3351, 'pt_BR', 'Distrito Federal', 511),
(3352, 'pt_BR', 'Condado de Zagreb', 512),
(3353, 'pt_BR', 'Condado de Krapina-Zagorje', 513),
(3354, 'pt_BR', 'Condado de Sisak-Moslavina', 514),
(3355, 'pt_BR', 'Condado de Karlovac', 515),
(3356, 'pt_BR', 'Concelho de Varaždin', 516),
(3357, 'pt_BR', 'Condado de Koprivnica-Križevci', 517),
(3358, 'pt_BR', 'Condado de Bjelovar-Bilogora', 518),
(3359, 'pt_BR', 'Condado de Primorje-Gorski kotar', 519),
(3360, 'pt_BR', 'Condado de Lika-Senj', 520),
(3361, 'pt_BR', 'Condado de Virovitica-Podravina', 521),
(3362, 'pt_BR', 'Condado de Požega-Slavonia', 522),
(3363, 'pt_BR', 'Condado de Brod-Posavina', 523),
(3364, 'pt_BR', 'Condado de Zadar', 524),
(3365, 'pt_BR', 'Condado de Osijek-Baranja', 525),
(3366, 'pt_BR', 'Condado de Šibenik-Knin', 526),
(3367, 'pt_BR', 'Condado de Vukovar-Srijem', 527),
(3368, 'pt_BR', 'Condado de Split-Dalmácia', 528),
(3369, 'pt_BR', 'Condado de Ístria', 529),
(3370, 'pt_BR', 'Condado de Dubrovnik-Neretva', 530),
(3371, 'pt_BR', 'Međimurska županija', 531),
(3372, 'pt_BR', 'Grad Zagreb', 532),
(3373, 'pt_BR', 'Ilhas Andaman e Nicobar', 533),
(3374, 'pt_BR', 'Andhra Pradesh', 534),
(3375, 'pt_BR', 'Arunachal Pradesh', 535),
(3376, 'pt_BR', 'Assam', 536),
(3377, 'pt_BR', 'Bihar', 537),
(3378, 'pt_BR', 'Chandigarh', 538),
(3379, 'pt_BR', 'Chhattisgarh', 539),
(3380, 'pt_BR', 'Dadra e Nagar Haveli', 540),
(3381, 'pt_BR', 'Daman e Diu', 541),
(3382, 'pt_BR', 'Delhi', 542),
(3383, 'pt_BR', 'Goa', 543),
(3384, 'pt_BR', 'Gujarat', 544),
(3385, 'pt_BR', 'Haryana', 545),
(3386, 'pt_BR', 'Himachal Pradesh', 546),
(3387, 'pt_BR', 'Jammu e Caxemira', 547),
(3388, 'pt_BR', 'Jharkhand', 548),
(3389, 'pt_BR', 'Karnataka', 549),
(3390, 'pt_BR', 'Kerala', 550),
(3391, 'pt_BR', 'Lakshadweep', 551),
(3392, 'pt_BR', 'Madhya Pradesh', 552),
(3393, 'pt_BR', 'Maharashtra', 553),
(3394, 'pt_BR', 'Manipur', 554),
(3395, 'pt_BR', 'Meghalaya', 555),
(3396, 'pt_BR', 'Mizoram', 556),
(3397, 'pt_BR', 'Nagaland', 557),
(3398, 'pt_BR', 'Odisha', 558),
(3399, 'pt_BR', 'Puducherry', 559),
(3400, 'pt_BR', 'Punjab', 560),
(3401, 'pt_BR', 'Rajasthan', 561),
(3402, 'pt_BR', 'Sikkim', 562),
(3403, 'pt_BR', 'Tamil Nadu', 563),
(3404, 'pt_BR', 'Telangana', 564),
(3405, 'pt_BR', 'Tripura', 565),
(3406, 'pt_BR', 'Uttar Pradesh', 566),
(3407, 'pt_BR', 'Uttarakhand', 567),
(3408, 'pt_BR', 'Bengala Ocidental', 568);

-- --------------------------------------------------------

--
-- Table structure for table `country_translations`
--

CREATE TABLE `country_translations` (
  `id` int(10) UNSIGNED NOT NULL,
  `locale` varchar(191) NOT NULL,
  `name` text DEFAULT NULL,
  `country_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `country_translations`
--

INSERT INTO `country_translations` (`id`, `locale`, `name`, `country_id`) VALUES
(766, 'ar', 'أفغانستان', 1),
(767, 'ar', 'جزر آلاند', 2),
(768, 'ar', 'ألبانيا', 3),
(769, 'ar', 'الجزائر', 4),
(770, 'ar', 'ساموا الأمريكية', 5),
(771, 'ar', 'أندورا', 6),
(772, 'ar', 'أنغولا', 7),
(773, 'ar', 'أنغيلا', 8),
(774, 'ar', 'القارة القطبية الجنوبية', 9),
(775, 'ar', 'أنتيغوا وبربودا', 10),
(776, 'ar', 'الأرجنتين', 11),
(777, 'ar', 'أرمينيا', 12),
(778, 'ar', 'أروبا', 13),
(779, 'ar', 'جزيرة الصعود', 14),
(780, 'ar', 'أستراليا', 15),
(781, 'ar', 'النمسا', 16),
(782, 'ar', 'أذربيجان', 17),
(783, 'ar', 'الباهاما', 18),
(784, 'ar', 'البحرين', 19),
(785, 'ar', 'بنغلاديش', 20),
(786, 'ar', 'بربادوس', 21),
(787, 'ar', 'روسيا البيضاء', 22),
(788, 'ar', 'بلجيكا', 23),
(789, 'ar', 'بليز', 24),
(790, 'ar', 'بنين', 25),
(791, 'ar', 'برمودا', 26),
(792, 'ar', 'بوتان', 27),
(793, 'ar', 'بوليفيا', 28),
(794, 'ar', 'البوسنة والهرسك', 29),
(795, 'ar', 'بوتسوانا', 30),
(796, 'ar', 'البرازيل', 31),
(797, 'ar', 'إقليم المحيط البريطاني الهندي', 32),
(798, 'ar', 'جزر فيرجن البريطانية', 33),
(799, 'ar', 'بروناي', 34),
(800, 'ar', 'بلغاريا', 35),
(801, 'ar', 'بوركينا فاسو', 36),
(802, 'ar', 'بوروندي', 37),
(803, 'ar', 'كمبوديا', 38),
(804, 'ar', 'الكاميرون', 39),
(805, 'ar', 'كندا', 40),
(806, 'ar', 'جزر الكناري', 41),
(807, 'ar', 'الرأس الأخضر', 42),
(808, 'ar', 'الكاريبي هولندا', 43),
(809, 'ar', 'جزر كايمان', 44),
(810, 'ar', 'جمهورية افريقيا الوسطى', 45),
(811, 'ar', 'سبتة ومليلية', 46),
(812, 'ar', 'تشاد', 47),
(813, 'ar', 'تشيلي', 48),
(814, 'ar', 'الصين', 49),
(815, 'ar', 'جزيرة الكريسماس', 50),
(816, 'ar', 'جزر كوكوس (كيلينغ)', 51),
(817, 'ar', 'كولومبيا', 52),
(818, 'ar', 'جزر القمر', 53),
(819, 'ar', 'الكونغو - برازافيل', 54),
(820, 'ar', 'الكونغو - كينشاسا', 55),
(821, 'ar', 'جزر كوك', 56),
(822, 'ar', 'كوستاريكا', 57),
(823, 'ar', 'ساحل العاج', 58),
(824, 'ar', 'كرواتيا', 59),
(825, 'ar', 'كوبا', 60),
(826, 'ar', 'كوراساو', 61),
(827, 'ar', 'قبرص', 62),
(828, 'ar', 'التشيك', 63),
(829, 'ar', 'الدنمارك', 64),
(830, 'ar', 'دييغو غارسيا', 65),
(831, 'ar', 'جيبوتي', 66),
(832, 'ar', 'دومينيكا', 67),
(833, 'ar', 'جمهورية الدومنيكان', 68),
(834, 'ar', 'الإكوادور', 69),
(835, 'ar', 'مصر', 70),
(836, 'ar', 'السلفادور', 71),
(837, 'ar', 'غينيا الإستوائية', 72),
(838, 'ar', 'إريتريا', 73),
(839, 'ar', 'استونيا', 74),
(840, 'ar', 'أثيوبيا', 75),
(841, 'ar', 'منطقة اليورو', 76),
(842, 'ar', 'جزر فوكلاند', 77),
(843, 'ar', 'جزر فاروس', 78),
(844, 'ar', 'فيجي', 79),
(845, 'ar', 'فنلندا', 80),
(846, 'ar', 'فرنسا', 81),
(847, 'ar', 'غيانا الفرنسية', 82),
(848, 'ar', 'بولينيزيا الفرنسية', 83),
(849, 'ar', 'المناطق الجنوبية لفرنسا', 84),
(850, 'ar', 'الغابون', 85),
(851, 'ar', 'غامبيا', 86),
(852, 'ar', 'جورجيا', 87),
(853, 'ar', 'ألمانيا', 88),
(854, 'ar', 'غانا', 89),
(855, 'ar', 'جبل طارق', 90),
(856, 'ar', 'اليونان', 91),
(857, 'ar', 'الأرض الخضراء', 92),
(858, 'ar', 'غرينادا', 93),
(859, 'ar', 'جوادلوب', 94),
(860, 'ar', 'غوام', 95),
(861, 'ar', 'غواتيمالا', 96),
(862, 'ar', 'غيرنسي', 97),
(863, 'ar', 'غينيا', 98),
(864, 'ar', 'غينيا بيساو', 99),
(865, 'ar', 'غيانا', 100),
(866, 'ar', 'هايتي', 101),
(867, 'ar', 'هندوراس', 102),
(868, 'ar', 'هونج كونج SAR الصين', 103),
(869, 'ar', 'هنغاريا', 104),
(870, 'ar', 'أيسلندا', 105),
(871, 'ar', 'الهند', 106),
(872, 'ar', 'إندونيسيا', 107),
(873, 'ar', 'إيران', 108),
(874, 'ar', 'العراق', 109),
(875, 'ar', 'أيرلندا', 110),
(876, 'ar', 'جزيرة آيل أوف مان', 111),
(877, 'ar', 'إسرائيل', 112),
(878, 'ar', 'إيطاليا', 113),
(879, 'ar', 'جامايكا', 114),
(880, 'ar', 'اليابان', 115),
(881, 'ar', 'جيرسي', 116),
(882, 'ar', 'الأردن', 117),
(883, 'ar', 'كازاخستان', 118),
(884, 'ar', 'كينيا', 119),
(885, 'ar', 'كيريباس', 120),
(886, 'ar', 'كوسوفو', 121),
(887, 'ar', 'الكويت', 122),
(888, 'ar', 'قرغيزستان', 123),
(889, 'ar', 'لاوس', 124),
(890, 'ar', 'لاتفيا', 125),
(891, 'ar', 'لبنان', 126),
(892, 'ar', 'ليسوتو', 127),
(893, 'ar', 'ليبيريا', 128),
(894, 'ar', 'ليبيا', 129),
(895, 'ar', 'ليختنشتاين', 130),
(896, 'ar', 'ليتوانيا', 131),
(897, 'ar', 'لوكسمبورغ', 132),
(898, 'ar', 'ماكاو SAR الصين', 133),
(899, 'ar', 'مقدونيا', 134),
(900, 'ar', 'مدغشقر', 135),
(901, 'ar', 'مالاوي', 136),
(902, 'ar', 'ماليزيا', 137),
(903, 'ar', 'جزر المالديف', 138),
(904, 'ar', 'مالي', 139),
(905, 'ar', 'مالطا', 140),
(906, 'ar', 'جزر مارشال', 141),
(907, 'ar', 'مارتينيك', 142),
(908, 'ar', 'موريتانيا', 143),
(909, 'ar', 'موريشيوس', 144),
(910, 'ar', 'ضائع', 145),
(911, 'ar', 'المكسيك', 146),
(912, 'ar', 'ميكرونيزيا', 147),
(913, 'ar', 'مولدوفا', 148),
(914, 'ar', 'موناكو', 149),
(915, 'ar', 'منغوليا', 150),
(916, 'ar', 'الجبل الأسود', 151),
(917, 'ar', 'مونتسيرات', 152),
(918, 'ar', 'المغرب', 153),
(919, 'ar', 'موزمبيق', 154),
(920, 'ar', 'ميانمار (بورما)', 155),
(921, 'ar', 'ناميبيا', 156),
(922, 'ar', 'ناورو', 157),
(923, 'ar', 'نيبال', 158),
(924, 'ar', 'نيبال', 159),
(925, 'ar', 'كاليدونيا الجديدة', 160),
(926, 'ar', 'نيوزيلاندا', 161),
(927, 'ar', 'نيكاراغوا', 162),
(928, 'ar', 'النيجر', 163),
(929, 'ar', 'نيجيريا', 164),
(930, 'ar', 'نيوي', 165),
(931, 'ar', 'جزيرة نورفولك', 166),
(932, 'ar', 'كوريا الشماليه', 167),
(933, 'ar', 'جزر مريانا الشمالية', 168),
(934, 'ar', 'النرويج', 169),
(935, 'ar', 'سلطنة عمان', 170),
(936, 'ar', 'باكستان', 171),
(937, 'ar', 'بالاو', 172),
(938, 'ar', 'الاراضي الفلسطينية', 173),
(939, 'ar', 'بناما', 174),
(940, 'ar', 'بابوا غينيا الجديدة', 175),
(941, 'ar', 'باراغواي', 176),
(942, 'ar', 'بيرو', 177),
(943, 'ar', 'الفلبين', 178),
(944, 'ar', 'جزر بيتكيرن', 179),
(945, 'ar', 'بولندا', 180),
(946, 'ar', 'البرتغال', 181),
(947, 'ar', 'بورتوريكو', 182),
(948, 'ar', 'دولة قطر', 183),
(949, 'ar', 'جمع شمل', 184),
(950, 'ar', 'رومانيا', 185),
(951, 'ar', 'روسيا', 186),
(952, 'ar', 'رواندا', 187),
(953, 'ar', 'ساموا', 188),
(954, 'ar', 'سان مارينو', 189),
(955, 'ar', 'سانت كيتس ونيفيس', 190),
(956, 'ar', 'المملكة العربية السعودية', 191),
(957, 'ar', 'السنغال', 192),
(958, 'ar', 'صربيا', 193),
(959, 'ar', 'سيشيل', 194),
(960, 'ar', 'سيراليون', 195),
(961, 'ar', 'سنغافورة', 196),
(962, 'ar', 'سينت مارتن', 197),
(963, 'ar', 'سلوفاكيا', 198),
(964, 'ar', 'سلوفينيا', 199),
(965, 'ar', 'جزر سليمان', 200),
(966, 'ar', 'الصومال', 201),
(967, 'ar', 'جنوب أفريقيا', 202),
(968, 'ar', 'جورجيا الجنوبية وجزر ساندويتش الجنوبية', 203),
(969, 'ar', 'كوريا الجنوبية', 204),
(970, 'ar', 'جنوب السودان', 205),
(971, 'ar', 'إسبانيا', 206),
(972, 'ar', 'سيريلانكا', 207),
(973, 'ar', 'سانت بارتيليمي', 208),
(974, 'ar', 'سانت هيلانة', 209),
(975, 'ar', 'سانت كيتس ونيفيس', 210),
(976, 'ar', 'شارع لوسيا', 211),
(977, 'ar', 'سانت مارتن', 212),
(978, 'ar', 'سانت بيير وميكلون', 213),
(979, 'ar', 'سانت فنسنت وجزر غرينادين', 214),
(980, 'ar', 'السودان', 215),
(981, 'ar', 'سورينام', 216),
(982, 'ar', 'سفالبارد وجان ماين', 217),
(983, 'ar', 'سوازيلاند', 218),
(984, 'ar', 'السويد', 219),
(985, 'ar', 'سويسرا', 220),
(986, 'ar', 'سوريا', 221),
(987, 'ar', 'تايوان', 222),
(988, 'ar', 'طاجيكستان', 223),
(989, 'ar', 'تنزانيا', 224),
(990, 'ar', 'تايلاند', 225),
(991, 'ar', 'تيمور', 226),
(992, 'ar', 'توجو', 227),
(993, 'ar', 'توكيلاو', 228),
(994, 'ar', 'تونغا', 229),
(995, 'ar', 'ترينيداد وتوباغو', 230),
(996, 'ar', 'تريستان دا كونها', 231),
(997, 'ar', 'تونس', 232),
(998, 'ar', 'ديك رومي', 233),
(999, 'ar', 'تركمانستان', 234),
(1000, 'ar', 'جزر تركس وكايكوس', 235),
(1001, 'ar', 'توفالو', 236),
(1002, 'ar', 'جزر الولايات المتحدة البعيدة', 237),
(1003, 'ar', 'جزر فيرجن الأمريكية', 238),
(1004, 'ar', 'أوغندا', 239),
(1005, 'ar', 'أوكرانيا', 240),
(1006, 'ar', 'الإمارات العربية المتحدة', 241),
(1007, 'ar', 'المملكة المتحدة', 242),
(1008, 'ar', 'الأمم المتحدة', 243),
(1009, 'ar', 'الولايات المتحدة الأمريكية', 244),
(1010, 'ar', 'أوروغواي', 245),
(1011, 'ar', 'أوزبكستان', 246),
(1012, 'ar', 'فانواتو', 247),
(1013, 'ar', 'مدينة الفاتيكان', 248),
(1014, 'ar', 'فنزويلا', 249),
(1015, 'ar', 'فيتنام', 250),
(1016, 'ar', 'واليس وفوتونا', 251),
(1017, 'ar', 'الصحراء الغربية', 252),
(1018, 'ar', 'اليمن', 253),
(1019, 'ar', 'زامبيا', 254),
(1020, 'ar', 'زيمبابوي', 255),
(1021, 'fa', 'افغانستان', 1),
(1022, 'fa', 'جزایر الند', 2),
(1023, 'fa', 'آلبانی', 3),
(1024, 'fa', 'الجزایر', 4),
(1025, 'fa', 'ساموآ آمریکایی', 5),
(1026, 'fa', 'آندورا', 6),
(1027, 'fa', 'آنگولا', 7),
(1028, 'fa', 'آنگولا', 8),
(1029, 'fa', 'جنوبگان', 9),
(1030, 'fa', 'آنتیگوا و باربودا', 10),
(1031, 'fa', 'آرژانتین', 11),
(1032, 'fa', 'ارمنستان', 12),
(1033, 'fa', 'آروبا', 13),
(1034, 'fa', 'جزیره صعود', 14),
(1035, 'fa', 'استرالیا', 15),
(1036, 'fa', 'اتریش', 16),
(1037, 'fa', 'آذربایجان', 17),
(1038, 'fa', 'باهاما', 18),
(1039, 'fa', 'بحرین', 19),
(1040, 'fa', 'بنگلادش', 20),
(1041, 'fa', 'باربادوس', 21),
(1042, 'fa', 'بلاروس', 22),
(1043, 'fa', 'بلژیک', 23),
(1044, 'fa', 'بلژیک', 24),
(1045, 'fa', 'بنین', 25),
(1046, 'fa', 'برمودا', 26),
(1047, 'fa', 'بوتان', 27),
(1048, 'fa', 'بولیوی', 28),
(1049, 'fa', 'بوسنی و هرزگوین', 29),
(1050, 'fa', 'بوتسوانا', 30),
(1051, 'fa', 'برزیل', 31),
(1052, 'fa', 'قلمرو اقیانوس هند انگلیس', 32),
(1053, 'fa', 'جزایر ویرجین انگلیس', 33),
(1054, 'fa', 'برونئی', 34),
(1055, 'fa', 'بلغارستان', 35),
(1056, 'fa', 'بورکینا فاسو', 36),
(1057, 'fa', 'بوروندی', 37),
(1058, 'fa', 'کامبوج', 38),
(1059, 'fa', 'کامرون', 39),
(1060, 'fa', 'کانادا', 40),
(1061, 'fa', 'جزایر قناری', 41),
(1062, 'fa', 'کیپ ورد', 42),
(1063, 'fa', 'کارائیب هلند', 43),
(1064, 'fa', 'Cayman Islands', 44),
(1065, 'fa', 'جمهوری آفریقای مرکزی', 45),
(1066, 'fa', 'سوتا و ملیلا', 46),
(1067, 'fa', 'چاد', 47),
(1068, 'fa', 'شیلی', 48),
(1069, 'fa', 'چین', 49),
(1070, 'fa', 'جزیره کریسمس', 50),
(1071, 'fa', 'جزایر کوکو (Keeling)', 51),
(1072, 'fa', 'کلمبیا', 52),
(1073, 'fa', 'کومور', 53),
(1074, 'fa', 'کنگو - برزاویل', 54),
(1075, 'fa', 'کنگو - کینشاسا', 55),
(1076, 'fa', 'جزایر کوک', 56),
(1077, 'fa', 'کاستاریکا', 57),
(1078, 'fa', 'ساحل عاج', 58),
(1079, 'fa', 'کرواسی', 59),
(1080, 'fa', 'کوبا', 60),
(1081, 'fa', 'کوراسائو', 61),
(1082, 'fa', 'قبرس', 62),
(1083, 'fa', 'چک', 63),
(1084, 'fa', 'دانمارک', 64),
(1085, 'fa', 'دیگو گارسیا', 65),
(1086, 'fa', 'جیبوتی', 66),
(1087, 'fa', 'دومینیکا', 67),
(1088, 'fa', 'جمهوری دومینیکن', 68),
(1089, 'fa', 'اکوادور', 69),
(1090, 'fa', 'مصر', 70),
(1091, 'fa', 'السالوادور', 71),
(1092, 'fa', 'گینه استوایی', 72),
(1093, 'fa', 'اریتره', 73),
(1094, 'fa', 'استونی', 74),
(1095, 'fa', 'اتیوپی', 75),
(1096, 'fa', 'منطقه یورو', 76),
(1097, 'fa', 'جزایر فالکلند', 77),
(1098, 'fa', 'جزایر فارو', 78),
(1099, 'fa', 'فیجی', 79),
(1100, 'fa', 'فنلاند', 80),
(1101, 'fa', 'فرانسه', 81),
(1102, 'fa', 'گویان فرانسه', 82),
(1103, 'fa', 'پلی‌نزی فرانسه', 83),
(1104, 'fa', 'سرزمین های جنوبی فرانسه', 84),
(1105, 'fa', 'گابن', 85),
(1106, 'fa', 'گامبیا', 86),
(1107, 'fa', 'جورجیا', 87),
(1108, 'fa', 'آلمان', 88),
(1109, 'fa', 'غنا', 89),
(1110, 'fa', 'جبل الطارق', 90),
(1111, 'fa', 'یونان', 91),
(1112, 'fa', 'گرینلند', 92),
(1113, 'fa', 'گرنادا', 93),
(1114, 'fa', 'گوادلوپ', 94),
(1115, 'fa', 'گوام', 95),
(1116, 'fa', 'گواتمالا', 96),
(1117, 'fa', 'گورنسی', 97),
(1118, 'fa', 'گینه', 98),
(1119, 'fa', 'گینه بیسائو', 99),
(1120, 'fa', 'گویان', 100),
(1121, 'fa', 'هائیتی', 101),
(1122, 'fa', 'هندوراس', 102),
(1123, 'fa', 'هنگ کنگ SAR چین', 103),
(1124, 'fa', 'مجارستان', 104),
(1125, 'fa', 'ایسلند', 105),
(1126, 'fa', 'هند', 106),
(1127, 'fa', 'اندونزی', 107),
(1128, 'fa', 'ایران', 108),
(1129, 'fa', 'عراق', 109),
(1130, 'fa', 'ایرلند', 110),
(1131, 'fa', 'جزیره من', 111),
(1132, 'fa', 'اسرائيل', 112),
(1133, 'fa', 'ایتالیا', 113),
(1134, 'fa', 'جامائیکا', 114),
(1135, 'fa', 'ژاپن', 115),
(1136, 'fa', 'پیراهن ورزشی', 116),
(1137, 'fa', 'اردن', 117),
(1138, 'fa', 'قزاقستان', 118),
(1139, 'fa', 'کنیا', 119),
(1140, 'fa', 'کیریباتی', 120),
(1141, 'fa', 'کوزوو', 121),
(1142, 'fa', 'کویت', 122),
(1143, 'fa', 'قرقیزستان', 123),
(1144, 'fa', 'لائوس', 124),
(1145, 'fa', 'لتونی', 125),
(1146, 'fa', 'لبنان', 126),
(1147, 'fa', 'لسوتو', 127),
(1148, 'fa', 'لیبریا', 128),
(1149, 'fa', 'لیبی', 129),
(1150, 'fa', 'لیختن اشتاین', 130),
(1151, 'fa', 'لیتوانی', 131),
(1152, 'fa', 'لوکزامبورگ', 132),
(1153, 'fa', 'ماکائو SAR چین', 133),
(1154, 'fa', 'مقدونیه', 134),
(1155, 'fa', 'ماداگاسکار', 135),
(1156, 'fa', 'مالاوی', 136),
(1157, 'fa', 'مالزی', 137),
(1158, 'fa', 'مالدیو', 138),
(1159, 'fa', 'مالی', 139),
(1160, 'fa', 'مالت', 140),
(1161, 'fa', 'جزایر مارشال', 141),
(1162, 'fa', 'مارتینیک', 142),
(1163, 'fa', 'موریتانی', 143),
(1164, 'fa', 'موریس', 144),
(1165, 'fa', 'گمشده', 145),
(1166, 'fa', 'مکزیک', 146),
(1167, 'fa', 'میکرونزی', 147),
(1168, 'fa', 'مولداوی', 148),
(1169, 'fa', 'موناکو', 149),
(1170, 'fa', 'مغولستان', 150),
(1171, 'fa', 'مونته نگرو', 151),
(1172, 'fa', 'مونتسرات', 152),
(1173, 'fa', 'مراکش', 153),
(1174, 'fa', 'موزامبیک', 154),
(1175, 'fa', 'میانمار (برمه)', 155),
(1176, 'fa', 'ناميبيا', 156),
(1177, 'fa', 'نائورو', 157),
(1178, 'fa', 'نپال', 158),
(1179, 'fa', 'هلند', 159),
(1180, 'fa', 'کالدونیای جدید', 160),
(1181, 'fa', 'نیوزلند', 161),
(1182, 'fa', 'نیکاراگوئه', 162),
(1183, 'fa', 'نیجر', 163),
(1184, 'fa', 'نیجریه', 164),
(1185, 'fa', 'نیو', 165),
(1186, 'fa', 'جزیره نورفولک', 166),
(1187, 'fa', 'کره شمالی', 167),
(1188, 'fa', 'جزایر ماریانای شمالی', 168),
(1189, 'fa', 'نروژ', 169),
(1190, 'fa', 'عمان', 170),
(1191, 'fa', 'پاکستان', 171),
(1192, 'fa', 'پالائو', 172),
(1193, 'fa', 'سرزمین های فلسطینی', 173),
(1194, 'fa', 'پاناما', 174),
(1195, 'fa', 'پاپوا گینه نو', 175),
(1196, 'fa', 'پاراگوئه', 176),
(1197, 'fa', 'پرو', 177),
(1198, 'fa', 'فیلیپین', 178),
(1199, 'fa', 'جزایر پیکریرن', 179),
(1200, 'fa', 'لهستان', 180),
(1201, 'fa', 'کشور پرتغال', 181),
(1202, 'fa', 'پورتوریکو', 182),
(1203, 'fa', 'قطر', 183),
(1204, 'fa', 'تجدید دیدار', 184),
(1205, 'fa', 'رومانی', 185),
(1206, 'fa', 'روسیه', 186),
(1207, 'fa', 'رواندا', 187),
(1208, 'fa', 'ساموآ', 188),
(1209, 'fa', 'سان مارینو', 189),
(1210, 'fa', 'سنت کیتس و نوویس', 190),
(1211, 'fa', 'عربستان سعودی', 191),
(1212, 'fa', 'سنگال', 192),
(1213, 'fa', 'صربستان', 193),
(1214, 'fa', 'سیشل', 194),
(1215, 'fa', 'سیرالئون', 195),
(1216, 'fa', 'سنگاپور', 196),
(1217, 'fa', 'سینت ماارتن', 197),
(1218, 'fa', 'اسلواکی', 198),
(1219, 'fa', 'اسلوونی', 199),
(1220, 'fa', 'جزایر سلیمان', 200),
(1221, 'fa', 'سومالی', 201),
(1222, 'fa', 'آفریقای جنوبی', 202),
(1223, 'fa', 'جزایر جورجیا جنوبی و جزایر ساندویچ جنوبی', 203),
(1224, 'fa', 'کره جنوبی', 204),
(1225, 'fa', 'سودان جنوبی', 205),
(1226, 'fa', 'اسپانیا', 206),
(1227, 'fa', 'سری لانکا', 207),
(1228, 'fa', 'سنت بارتلی', 208),
(1229, 'fa', 'سنت هلنا', 209),
(1230, 'fa', 'سنت کیتز و نوویس', 210),
(1231, 'fa', 'سنت لوسیا', 211),
(1232, 'fa', 'سنت مارتین', 212),
(1233, 'fa', 'سنت پیر و میکلون', 213),
(1234, 'fa', 'سنت وینسنت و گرنادینها', 214),
(1235, 'fa', 'سودان', 215),
(1236, 'fa', 'سورینام', 216),
(1237, 'fa', 'اسوالبارد و جان ماین', 217),
(1238, 'fa', 'سوازیلند', 218),
(1239, 'fa', 'سوئد', 219),
(1240, 'fa', 'سوئیس', 220),
(1241, 'fa', 'سوریه', 221),
(1242, 'fa', 'تایوان', 222),
(1243, 'fa', 'تاجیکستان', 223),
(1244, 'fa', 'تانزانیا', 224),
(1245, 'fa', 'تایلند', 225),
(1246, 'fa', 'تیمور-لست', 226),
(1247, 'fa', 'رفتن', 227),
(1248, 'fa', 'توکلو', 228),
(1249, 'fa', 'تونگا', 229),
(1250, 'fa', 'ترینیداد و توباگو', 230),
(1251, 'fa', 'تریستان دا کانونا', 231),
(1252, 'fa', 'تونس', 232),
(1253, 'fa', 'بوقلمون', 233),
(1254, 'fa', 'ترکمنستان', 234),
(1255, 'fa', 'جزایر تورکس و کایکوس', 235),
(1256, 'fa', 'تووالو', 236),
(1257, 'fa', 'جزایر دور افتاده ایالات متحده آمریکا', 237),
(1258, 'fa', 'جزایر ویرجین ایالات متحده', 238),
(1259, 'fa', 'اوگاندا', 239),
(1260, 'fa', 'اوکراین', 240),
(1261, 'fa', 'امارات متحده عربی', 241),
(1262, 'fa', 'انگلستان', 242),
(1263, 'fa', 'سازمان ملل', 243),
(1264, 'fa', 'ایالات متحده', 244),
(1265, 'fa', 'اروگوئه', 245),
(1266, 'fa', 'ازبکستان', 246),
(1267, 'fa', 'وانواتو', 247),
(1268, 'fa', 'شهر واتیکان', 248),
(1269, 'fa', 'ونزوئلا', 249),
(1270, 'fa', 'ویتنام', 250),
(1271, 'fa', 'والیس و فوتونا', 251),
(1272, 'fa', 'صحرای غربی', 252),
(1273, 'fa', 'یمن', 253),
(1274, 'fa', 'زامبیا', 254),
(1275, 'fa', 'زیمبابوه', 255),
(1276, 'pt_BR', 'Afeganistão', 1),
(1277, 'pt_BR', 'Ilhas Åland', 2),
(1278, 'pt_BR', 'Albânia', 3),
(1279, 'pt_BR', 'Argélia', 4),
(1280, 'pt_BR', 'Samoa Americana', 5),
(1281, 'pt_BR', 'Andorra', 6),
(1282, 'pt_BR', 'Angola', 7),
(1283, 'pt_BR', 'Angola', 8),
(1284, 'pt_BR', 'Antártico', 9),
(1285, 'pt_BR', 'Antígua e Barbuda', 10),
(1286, 'pt_BR', 'Argentina', 11),
(1287, 'pt_BR', 'Armênia', 12),
(1288, 'pt_BR', 'Aruba', 13),
(1289, 'pt_BR', 'Ilha de escalada', 14),
(1290, 'pt_BR', 'Austrália', 15),
(1291, 'pt_BR', 'Áustria', 16),
(1292, 'pt_BR', 'Azerbaijão', 17),
(1293, 'pt_BR', 'Bahamas', 18),
(1294, 'pt_BR', 'Bahrain', 19),
(1295, 'pt_BR', 'Bangladesh', 20),
(1296, 'pt_BR', 'Barbados', 21),
(1297, 'pt_BR', 'Bielorrússia', 22),
(1298, 'pt_BR', 'Bélgica', 23),
(1299, 'pt_BR', 'Bélgica', 24),
(1300, 'pt_BR', 'Benin', 25),
(1301, 'pt_BR', 'Bermuda', 26),
(1302, 'pt_BR', 'Butão', 27),
(1303, 'pt_BR', 'Bolívia', 28),
(1304, 'pt_BR', 'Bósnia e Herzegovina', 29),
(1305, 'pt_BR', 'Botsuana', 30),
(1306, 'pt_BR', 'Brasil', 31),
(1307, 'pt_BR', 'Território Britânico do Oceano Índico', 32),
(1308, 'pt_BR', 'Ilhas Virgens Britânicas', 33),
(1309, 'pt_BR', 'Brunei', 34),
(1310, 'pt_BR', 'Bulgária', 35),
(1311, 'pt_BR', 'Burkina Faso', 36),
(1312, 'pt_BR', 'Burundi', 37),
(1313, 'pt_BR', 'Camboja', 38),
(1314, 'pt_BR', 'Camarões', 39),
(1315, 'pt_BR', 'Canadá', 40),
(1316, 'pt_BR', 'Ilhas Canárias', 41),
(1317, 'pt_BR', 'Cabo Verde', 42),
(1318, 'pt_BR', 'Holanda do Caribe', 43),
(1319, 'pt_BR', 'Ilhas Cayman', 44),
(1320, 'pt_BR', 'República Centro-Africana', 45),
(1321, 'pt_BR', 'Ceuta e Melilla', 46),
(1322, 'pt_BR', 'Chade', 47),
(1323, 'pt_BR', 'Chile', 48),
(1324, 'pt_BR', 'China', 49),
(1325, 'pt_BR', 'Ilha Christmas', 50),
(1326, 'pt_BR', 'Ilhas Cocos (Keeling)', 51),
(1327, 'pt_BR', 'Colômbia', 52),
(1328, 'pt_BR', 'Comores', 53),
(1329, 'pt_BR', 'Congo - Brazzaville', 54),
(1330, 'pt_BR', 'Congo - Kinshasa', 55),
(1331, 'pt_BR', 'Ilhas Cook', 56),
(1332, 'pt_BR', 'Costa Rica', 57),
(1333, 'pt_BR', 'Costa do Marfim', 58),
(1334, 'pt_BR', 'Croácia', 59),
(1335, 'pt_BR', 'Cuba', 60),
(1336, 'pt_BR', 'Curaçao', 61),
(1337, 'pt_BR', 'Chipre', 62),
(1338, 'pt_BR', 'Czechia', 63),
(1339, 'pt_BR', 'Dinamarca', 64),
(1340, 'pt_BR', 'Diego Garcia', 65),
(1341, 'pt_BR', 'Djibuti', 66),
(1342, 'pt_BR', 'Dominica', 67),
(1343, 'pt_BR', 'República Dominicana', 68),
(1344, 'pt_BR', 'Equador', 69),
(1345, 'pt_BR', 'Egito', 70),
(1346, 'pt_BR', 'El Salvador', 71),
(1347, 'pt_BR', 'Guiné Equatorial', 72),
(1348, 'pt_BR', 'Eritreia', 73),
(1349, 'pt_BR', 'Estônia', 74),
(1350, 'pt_BR', 'Etiópia', 75),
(1351, 'pt_BR', 'Zona Euro', 76),
(1352, 'pt_BR', 'Ilhas Malvinas', 77),
(1353, 'pt_BR', 'Ilhas Faroe', 78),
(1354, 'pt_BR', 'Fiji', 79),
(1355, 'pt_BR', 'Finlândia', 80),
(1356, 'pt_BR', 'França', 81),
(1357, 'pt_BR', 'Guiana Francesa', 82),
(1358, 'pt_BR', 'Polinésia Francesa', 83),
(1359, 'pt_BR', 'Territórios Franceses do Sul', 84),
(1360, 'pt_BR', 'Gabão', 85),
(1361, 'pt_BR', 'Gâmbia', 86),
(1362, 'pt_BR', 'Geórgia', 87),
(1363, 'pt_BR', 'Alemanha', 88),
(1364, 'pt_BR', 'Gana', 89),
(1365, 'pt_BR', 'Gibraltar', 90),
(1366, 'pt_BR', 'Grécia', 91),
(1367, 'pt_BR', 'Gronelândia', 92),
(1368, 'pt_BR', 'Granada', 93),
(1369, 'pt_BR', 'Guadalupe', 94),
(1370, 'pt_BR', 'Guam', 95),
(1371, 'pt_BR', 'Guatemala', 96),
(1372, 'pt_BR', 'Guernsey', 97),
(1373, 'pt_BR', 'Guiné', 98),
(1374, 'pt_BR', 'Guiné-Bissau', 99),
(1375, 'pt_BR', 'Guiana', 100),
(1376, 'pt_BR', 'Haiti', 101),
(1377, 'pt_BR', 'Honduras', 102),
(1378, 'pt_BR', 'Região Administrativa Especial de Hong Kong, China', 103),
(1379, 'pt_BR', 'Hungria', 104),
(1380, 'pt_BR', 'Islândia', 105),
(1381, 'pt_BR', 'Índia', 106),
(1382, 'pt_BR', 'Indonésia', 107),
(1383, 'pt_BR', 'Irã', 108),
(1384, 'pt_BR', 'Iraque', 109),
(1385, 'pt_BR', 'Irlanda', 110),
(1386, 'pt_BR', 'Ilha de Man', 111),
(1387, 'pt_BR', 'Israel', 112),
(1388, 'pt_BR', 'Itália', 113),
(1389, 'pt_BR', 'Jamaica', 114),
(1390, 'pt_BR', 'Japão', 115),
(1391, 'pt_BR', 'Jersey', 116),
(1392, 'pt_BR', 'Jordânia', 117),
(1393, 'pt_BR', 'Cazaquistão', 118),
(1394, 'pt_BR', 'Quênia', 119),
(1395, 'pt_BR', 'Quiribati', 120),
(1396, 'pt_BR', 'Kosovo', 121),
(1397, 'pt_BR', 'Kuwait', 122),
(1398, 'pt_BR', 'Quirguistão', 123),
(1399, 'pt_BR', 'Laos', 124),
(1400, 'pt_BR', 'Letônia', 125),
(1401, 'pt_BR', 'Líbano', 126),
(1402, 'pt_BR', 'Lesoto', 127),
(1403, 'pt_BR', 'Libéria', 128),
(1404, 'pt_BR', 'Líbia', 129),
(1405, 'pt_BR', 'Liechtenstein', 130),
(1406, 'pt_BR', 'Lituânia', 131),
(1407, 'pt_BR', 'Luxemburgo', 132),
(1408, 'pt_BR', 'Macau SAR China', 133),
(1409, 'pt_BR', 'Macedônia', 134),
(1410, 'pt_BR', 'Madagascar', 135),
(1411, 'pt_BR', 'Malawi', 136),
(1412, 'pt_BR', 'Malásia', 137),
(1413, 'pt_BR', 'Maldivas', 138),
(1414, 'pt_BR', 'Mali', 139),
(1415, 'pt_BR', 'Malta', 140),
(1416, 'pt_BR', 'Ilhas Marshall', 141),
(1417, 'pt_BR', 'Martinica', 142),
(1418, 'pt_BR', 'Mauritânia', 143),
(1419, 'pt_BR', 'Maurício', 144),
(1420, 'pt_BR', 'Maiote', 145),
(1421, 'pt_BR', 'México', 146),
(1422, 'pt_BR', 'Micronésia', 147),
(1423, 'pt_BR', 'Moldávia', 148),
(1424, 'pt_BR', 'Mônaco', 149),
(1425, 'pt_BR', 'Mongólia', 150),
(1426, 'pt_BR', 'Montenegro', 151),
(1427, 'pt_BR', 'Montserrat', 152),
(1428, 'pt_BR', 'Marrocos', 153),
(1429, 'pt_BR', 'Moçambique', 154),
(1430, 'pt_BR', 'Mianmar (Birmânia)', 155),
(1431, 'pt_BR', 'Namíbia', 156),
(1432, 'pt_BR', 'Nauru', 157),
(1433, 'pt_BR', 'Nepal', 158),
(1434, 'pt_BR', 'Holanda', 159),
(1435, 'pt_BR', 'Nova Caledônia', 160),
(1436, 'pt_BR', 'Nova Zelândia', 161),
(1437, 'pt_BR', 'Nicarágua', 162),
(1438, 'pt_BR', 'Níger', 163),
(1439, 'pt_BR', 'Nigéria', 164),
(1440, 'pt_BR', 'Niue', 165),
(1441, 'pt_BR', 'Ilha Norfolk', 166),
(1442, 'pt_BR', 'Coréia do Norte', 167),
(1443, 'pt_BR', 'Ilhas Marianas do Norte', 168),
(1444, 'pt_BR', 'Noruega', 169),
(1445, 'pt_BR', 'Omã', 170),
(1446, 'pt_BR', 'Paquistão', 171),
(1447, 'pt_BR', 'Palau', 172),
(1448, 'pt_BR', 'Territórios Palestinos', 173),
(1449, 'pt_BR', 'Panamá', 174),
(1450, 'pt_BR', 'Papua Nova Guiné', 175),
(1451, 'pt_BR', 'Paraguai', 176),
(1452, 'pt_BR', 'Peru', 177),
(1453, 'pt_BR', 'Filipinas', 178),
(1454, 'pt_BR', 'Ilhas Pitcairn', 179),
(1455, 'pt_BR', 'Polônia', 180),
(1456, 'pt_BR', 'Portugal', 181),
(1457, 'pt_BR', 'Porto Rico', 182),
(1458, 'pt_BR', 'Catar', 183),
(1459, 'pt_BR', 'Reunião', 184),
(1460, 'pt_BR', 'Romênia', 185),
(1461, 'pt_BR', 'Rússia', 186),
(1462, 'pt_BR', 'Ruanda', 187),
(1463, 'pt_BR', 'Samoa', 188),
(1464, 'pt_BR', 'São Marinho', 189),
(1465, 'pt_BR', 'São Cristóvão e Nevis', 190),
(1466, 'pt_BR', 'Arábia Saudita', 191),
(1467, 'pt_BR', 'Senegal', 192),
(1468, 'pt_BR', 'Sérvia', 193),
(1469, 'pt_BR', 'Seychelles', 194),
(1470, 'pt_BR', 'Serra Leoa', 195),
(1471, 'pt_BR', 'Cingapura', 196),
(1472, 'pt_BR', 'São Martinho', 197),
(1473, 'pt_BR', 'Eslováquia', 198),
(1474, 'pt_BR', 'Eslovênia', 199),
(1475, 'pt_BR', 'Ilhas Salomão', 200),
(1476, 'pt_BR', 'Somália', 201),
(1477, 'pt_BR', 'África do Sul', 202),
(1478, 'pt_BR', 'Ilhas Geórgia do Sul e Sandwich do Sul', 203),
(1479, 'pt_BR', 'Coréia do Sul', 204),
(1480, 'pt_BR', 'Sudão do Sul', 205),
(1481, 'pt_BR', 'Espanha', 206),
(1482, 'pt_BR', 'Sri Lanka', 207),
(1483, 'pt_BR', 'São Bartolomeu', 208),
(1484, 'pt_BR', 'Santa Helena', 209),
(1485, 'pt_BR', 'São Cristóvão e Nevis', 210),
(1486, 'pt_BR', 'Santa Lúcia', 211),
(1487, 'pt_BR', 'São Martinho', 212),
(1488, 'pt_BR', 'São Pedro e Miquelon', 213),
(1489, 'pt_BR', 'São Vicente e Granadinas', 214),
(1490, 'pt_BR', 'Sudão', 215),
(1491, 'pt_BR', 'Suriname', 216),
(1492, 'pt_BR', 'Svalbard e Jan Mayen', 217),
(1493, 'pt_BR', 'Suazilândia', 218),
(1494, 'pt_BR', 'Suécia', 219),
(1495, 'pt_BR', 'Suíça', 220),
(1496, 'pt_BR', 'Síria', 221),
(1497, 'pt_BR', 'Taiwan', 222),
(1498, 'pt_BR', 'Tajiquistão', 223),
(1499, 'pt_BR', 'Tanzânia', 224),
(1500, 'pt_BR', 'Tailândia', 225),
(1501, 'pt_BR', 'Timor-Leste', 226),
(1502, 'pt_BR', 'Togo', 227),
(1503, 'pt_BR', 'Tokelau', 228),
(1504, 'pt_BR', 'Tonga', 229),
(1505, 'pt_BR', 'Trinidad e Tobago', 230),
(1506, 'pt_BR', 'Tristan da Cunha', 231),
(1507, 'pt_BR', 'Tunísia', 232),
(1508, 'pt_BR', 'Turquia', 233),
(1509, 'pt_BR', 'Turquemenistão', 234),
(1510, 'pt_BR', 'Ilhas Turks e Caicos', 235),
(1511, 'pt_BR', 'Tuvalu', 236),
(1512, 'pt_BR', 'Ilhas periféricas dos EUA', 237),
(1513, 'pt_BR', 'Ilhas Virgens dos EUA', 238),
(1514, 'pt_BR', 'Uganda', 239),
(1515, 'pt_BR', 'Ucrânia', 240),
(1516, 'pt_BR', 'Emirados Árabes Unidos', 241),
(1517, 'pt_BR', 'Reino Unido', 242),
(1518, 'pt_BR', 'Nações Unidas', 243),
(1519, 'pt_BR', 'Estados Unidos', 244),
(1520, 'pt_BR', 'Uruguai', 245),
(1521, 'pt_BR', 'Uzbequistão', 246),
(1522, 'pt_BR', 'Vanuatu', 247),
(1523, 'pt_BR', 'Cidade do Vaticano', 248),
(1524, 'pt_BR', 'Venezuela', 249),
(1525, 'pt_BR', 'Vietnã', 250),
(1526, 'pt_BR', 'Wallis e Futuna', 251),
(1527, 'pt_BR', 'Saara Ocidental', 252),
(1528, 'pt_BR', 'Iêmen', 253),
(1529, 'pt_BR', 'Zâmbia', 254),
(1530, 'pt_BR', 'Zimbábue', 255);

-- --------------------------------------------------------

--
-- Table structure for table `currencies`
--

CREATE TABLE `currencies` (
  `id` int(10) UNSIGNED NOT NULL,
  `code` varchar(191) NOT NULL,
  `name` varchar(191) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `symbol` varchar(191) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `currencies`
--

INSERT INTO `currencies` (`id`, `code`, `name`, `created_at`, `updated_at`, `symbol`) VALUES
(1, 'USD', 'US Dollar', NULL, NULL, '$'),
(2, 'EUR', 'Euro', NULL, NULL, '€');

-- --------------------------------------------------------

--
-- Table structure for table `currency_exchange_rates`
--

CREATE TABLE `currency_exchange_rates` (
  `id` int(10) UNSIGNED NOT NULL,
  `rate` decimal(24,12) NOT NULL,
  `target_currency` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

CREATE TABLE `customers` (
  `id` int(10) UNSIGNED NOT NULL,
  `first_name` varchar(191) NOT NULL,
  `last_name` varchar(191) NOT NULL,
  `gender` varchar(50) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `email` varchar(191) DEFAULT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 1,
  `password` varchar(191) DEFAULT NULL,
  `api_token` varchar(80) DEFAULT NULL,
  `customer_group_id` int(10) UNSIGNED DEFAULT NULL,
  `subscribed_to_news_letter` tinyint(1) NOT NULL DEFAULT 0,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `is_verified` tinyint(1) NOT NULL DEFAULT 0,
  `token` varchar(191) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `phone` varchar(191) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`id`, `first_name`, `last_name`, `gender`, `date_of_birth`, `email`, `status`, `password`, `api_token`, `customer_group_id`, `subscribed_to_news_letter`, `remember_token`, `created_at`, `updated_at`, `is_verified`, `token`, `notes`, `phone`) VALUES
(1, 'hassan', 'sadiq', NULL, NULL, 'hassanar426@gmail.com', 1, '$2y$10$SpUuZVxfsRrFFHWl9JZB9.TumWPXx5GB/b..qCnKm4QKbHfAhlWTG', 'XPZriLvqPKpTBb2zxp95bS1D9VOZgpW0wah9YcHPd50GGeWnCln6fyfJEssOFa8hjFA8Lu0dOLpGGNlB', 2, 0, NULL, '2021-02-10 14:21:43', '2021-02-10 14:21:43', 1, 'a7144e0b3141c5d2646e6a8be90e662a', NULL, NULL),
(2, 'hassan', 'sadiq', NULL, NULL, 'bcsf15m542@pucit.edu.pk', 1, '$2y$10$JreXWFWkyupVjAyK8mMNVetRE39/tij3P6SZd5y.XWe7FCpiIaVli', 'o3dOFtO3IzR4p04ChIDTVFhjYVhHELneEkhiYIzWS6q7DjO3gmRin7jDOwueStMPk8OIi41hInAiAyjy', 2, 0, NULL, '2021-03-02 20:04:17', '2021-03-02 20:04:17', 1, 'accd7d0e2f7d40d093b045cc6f163625', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `customer_groups`
--

CREATE TABLE `customer_groups` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(191) NOT NULL,
  `is_user_defined` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `code` varchar(191) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `customer_groups`
--

INSERT INTO `customer_groups` (`id`, `name`, `is_user_defined`, `created_at`, `updated_at`, `code`) VALUES
(1, 'Guest', 0, NULL, NULL, 'guest'),
(2, 'General', 0, NULL, NULL, 'general'),
(3, 'Wholesale', 0, NULL, NULL, 'wholesale');

-- --------------------------------------------------------

--
-- Table structure for table `customer_password_resets`
--

CREATE TABLE `customer_password_resets` (
  `email` varchar(191) NOT NULL,
  `token` varchar(191) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `customer_password_resets`
--

INSERT INTO `customer_password_resets` (`email`, `token`, `created_at`) VALUES
('hassanar426@gmail.com', '$2y$10$WdB.gYBO4X7R5IPtIkQwKuhuVAxpuXkxCcKiCrF0YtZF6va2ouRxa', '2021-03-03 15:01:24');

-- --------------------------------------------------------

--
-- Table structure for table `customer_social_accounts`
--

CREATE TABLE `customer_social_accounts` (
  `id` int(10) UNSIGNED NOT NULL,
  `provider_name` varchar(191) DEFAULT NULL,
  `provider_id` varchar(191) DEFAULT NULL,
  `customer_id` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `downloadable_link_purchased`
--

CREATE TABLE `downloadable_link_purchased` (
  `id` int(10) UNSIGNED NOT NULL,
  `product_name` varchar(191) DEFAULT NULL,
  `name` varchar(191) DEFAULT NULL,
  `url` varchar(191) DEFAULT NULL,
  `file` varchar(191) DEFAULT NULL,
  `file_name` varchar(191) DEFAULT NULL,
  `type` varchar(191) NOT NULL,
  `download_bought` int(11) NOT NULL DEFAULT 0,
  `download_used` int(11) NOT NULL DEFAULT 0,
  `status` varchar(191) DEFAULT NULL,
  `customer_id` int(10) UNSIGNED NOT NULL,
  `order_id` int(10) UNSIGNED NOT NULL,
  `order_item_id` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `download_canceled` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `inventory_sources`
--

CREATE TABLE `inventory_sources` (
  `id` int(10) UNSIGNED NOT NULL,
  `code` varchar(191) NOT NULL,
  `name` varchar(191) NOT NULL,
  `description` text DEFAULT NULL,
  `contact_name` varchar(191) NOT NULL,
  `contact_email` varchar(191) NOT NULL,
  `contact_number` varchar(191) NOT NULL,
  `contact_fax` varchar(191) DEFAULT NULL,
  `country` varchar(191) NOT NULL,
  `state` varchar(191) NOT NULL,
  `city` varchar(191) NOT NULL,
  `street` varchar(191) NOT NULL,
  `postcode` varchar(191) NOT NULL,
  `priority` int(11) NOT NULL DEFAULT 0,
  `latitude` decimal(10,5) DEFAULT NULL,
  `longitude` decimal(10,5) DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `inventory_sources`
--

INSERT INTO `inventory_sources` (`id`, `code`, `name`, `description`, `contact_name`, `contact_email`, `contact_number`, `contact_fax`, `country`, `state`, `city`, `street`, `postcode`, `priority`, `latitude`, `longitude`, `status`, `created_at`, `updated_at`) VALUES
(1, 'default', 'Default', NULL, 'Detroit Warehouse', 'warehouse@example.com', '1234567899', NULL, 'US', 'MI', 'Detroit', '12th Street', '48127', 0, NULL, NULL, 1, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `invoices`
--

CREATE TABLE `invoices` (
  `id` int(10) UNSIGNED NOT NULL,
  `increment_id` varchar(191) DEFAULT NULL,
  `state` varchar(191) DEFAULT NULL,
  `email_sent` tinyint(1) NOT NULL DEFAULT 0,
  `total_qty` int(11) DEFAULT NULL,
  `base_currency_code` varchar(191) DEFAULT NULL,
  `channel_currency_code` varchar(191) DEFAULT NULL,
  `order_currency_code` varchar(191) DEFAULT NULL,
  `sub_total` decimal(12,4) DEFAULT 0.0000,
  `base_sub_total` decimal(12,4) DEFAULT 0.0000,
  `grand_total` decimal(12,4) DEFAULT 0.0000,
  `base_grand_total` decimal(12,4) DEFAULT 0.0000,
  `shipping_amount` decimal(12,4) DEFAULT 0.0000,
  `base_shipping_amount` decimal(12,4) DEFAULT 0.0000,
  `tax_amount` decimal(12,4) DEFAULT 0.0000,
  `base_tax_amount` decimal(12,4) DEFAULT 0.0000,
  `discount_amount` decimal(12,4) DEFAULT 0.0000,
  `base_discount_amount` decimal(12,4) DEFAULT 0.0000,
  `order_id` int(10) UNSIGNED DEFAULT NULL,
  `order_address_id` int(10) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `transaction_id` varchar(191) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `invoice_items`
--

CREATE TABLE `invoice_items` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(191) DEFAULT NULL,
  `description` varchar(191) DEFAULT NULL,
  `sku` varchar(191) DEFAULT NULL,
  `qty` int(11) DEFAULT NULL,
  `price` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_price` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `total` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_total` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `tax_amount` decimal(12,4) DEFAULT 0.0000,
  `base_tax_amount` decimal(12,4) DEFAULT 0.0000,
  `product_id` int(10) UNSIGNED DEFAULT NULL,
  `product_type` varchar(191) DEFAULT NULL,
  `order_item_id` int(10) UNSIGNED DEFAULT NULL,
  `invoice_id` int(10) UNSIGNED DEFAULT NULL,
  `parent_id` int(10) UNSIGNED DEFAULT NULL,
  `additional` longtext DEFAULT NULL CHECK (json_valid(`additional`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `discount_percent` decimal(12,4) DEFAULT 0.0000,
  `discount_amount` decimal(12,4) DEFAULT 0.0000,
  `base_discount_amount` decimal(12,4) DEFAULT 0.0000
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(191) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `locales`
--

CREATE TABLE `locales` (
  `id` int(10) UNSIGNED NOT NULL,
  `code` varchar(191) NOT NULL,
  `name` varchar(191) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `direction` enum('ltr','rtl') NOT NULL DEFAULT 'ltr',
  `locale_image` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `locales`
--

INSERT INTO `locales` (`id`, `code`, `name`, `created_at`, `updated_at`, `direction`, `locale_image`) VALUES
(1, 'en', 'English', NULL, NULL, 'ltr', NULL),
(2, 'fr', 'French', NULL, NULL, 'ltr', NULL),
(3, 'nl', 'Dutch', NULL, NULL, 'ltr', NULL),
(4, 'tr', 'Türkçe', NULL, NULL, 'ltr', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `marketing_campaigns`
--

CREATE TABLE `marketing_campaigns` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(191) NOT NULL,
  `subject` varchar(191) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 0,
  `type` varchar(191) NOT NULL,
  `mail_to` varchar(191) NOT NULL,
  `spooling` varchar(191) DEFAULT NULL,
  `channel_id` int(10) UNSIGNED DEFAULT NULL,
  `customer_group_id` int(10) UNSIGNED DEFAULT NULL,
  `marketing_template_id` int(10) UNSIGNED DEFAULT NULL,
  `marketing_event_id` int(10) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `marketing_events`
--

CREATE TABLE `marketing_events` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(191) NOT NULL,
  `description` text DEFAULT NULL,
  `date` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `marketing_events`
--

INSERT INTO `marketing_events` (`id`, `name`, `description`, `date`, `created_at`, `updated_at`) VALUES
(1, 'Birthday', 'Birthday', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `marketing_templates`
--

CREATE TABLE `marketing_templates` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(191) NOT NULL,
  `status` varchar(191) NOT NULL,
  `content` text NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(191) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2014_10_12_000000_create_users_table', 1),
(2, '2014_10_12_100000_create_admin_password_resets_table', 1),
(3, '2014_10_12_100000_create_password_resets_table', 1),
(4, '2018_06_12_111907_create_admins_table', 1),
(5, '2018_06_13_055341_create_roles_table', 1),
(6, '2018_07_05_130148_create_attributes_table', 1),
(7, '2018_07_05_132854_create_attribute_translations_table', 1),
(8, '2018_07_05_135150_create_attribute_families_table', 1),
(9, '2018_07_05_135152_create_attribute_groups_table', 1),
(10, '2018_07_05_140832_create_attribute_options_table', 1),
(11, '2018_07_05_140856_create_attribute_option_translations_table', 1),
(12, '2018_07_05_142820_create_categories_table', 1),
(13, '2018_07_10_055143_create_locales_table', 1),
(14, '2018_07_20_054426_create_countries_table', 1),
(15, '2018_07_20_054502_create_currencies_table', 1),
(16, '2018_07_20_054542_create_currency_exchange_rates_table', 1),
(17, '2018_07_20_064849_create_channels_table', 1),
(18, '2018_07_21_142836_create_category_translations_table', 1),
(19, '2018_07_23_110040_create_inventory_sources_table', 1),
(20, '2018_07_24_082635_create_customer_groups_table', 1),
(21, '2018_07_24_082930_create_customers_table', 1),
(22, '2018_07_24_083025_create_customer_addresses_table', 1),
(23, '2018_07_27_065727_create_products_table', 1),
(24, '2018_07_27_070011_create_product_attribute_values_table', 1),
(25, '2018_07_27_092623_create_product_reviews_table', 1),
(26, '2018_07_27_113941_create_product_images_table', 1),
(27, '2018_07_27_113956_create_product_inventories_table', 1),
(28, '2018_08_03_114203_create_sliders_table', 1),
(29, '2018_08_30_064755_create_tax_categories_table', 1),
(30, '2018_08_30_065042_create_tax_rates_table', 1),
(31, '2018_08_30_065840_create_tax_mappings_table', 1),
(32, '2018_09_05_150444_create_cart_table', 1),
(33, '2018_09_05_150915_create_cart_items_table', 1),
(34, '2018_09_11_064045_customer_password_resets', 1),
(35, '2018_09_19_092845_create_cart_address', 1),
(36, '2018_09_19_093453_create_cart_payment', 1),
(37, '2018_09_19_093508_create_cart_shipping_rates_table', 1),
(38, '2018_09_20_060658_create_core_config_table', 1),
(39, '2018_09_27_113154_create_orders_table', 1),
(40, '2018_09_27_113207_create_order_items_table', 1),
(41, '2018_09_27_113405_create_order_address_table', 1),
(42, '2018_09_27_115022_create_shipments_table', 1),
(43, '2018_09_27_115029_create_shipment_items_table', 1),
(44, '2018_09_27_115135_create_invoices_table', 1),
(45, '2018_09_27_115144_create_invoice_items_table', 1),
(46, '2018_10_01_095504_create_order_payment_table', 1),
(47, '2018_10_03_025230_create_wishlist_table', 1),
(48, '2018_10_12_101803_create_country_translations_table', 1),
(49, '2018_10_12_101913_create_country_states_table', 1),
(50, '2018_10_12_101923_create_country_state_translations_table', 1),
(51, '2018_11_15_153257_alter_order_table', 1),
(52, '2018_11_15_163729_alter_invoice_table', 1),
(53, '2018_11_16_173504_create_subscribers_list_table', 1),
(54, '2018_11_17_165758_add_is_verified_column_in_customers_table', 1),
(55, '2018_11_21_144411_create_cart_item_inventories_table', 1),
(56, '2018_11_26_110500_change_gender_column_in_customers_table', 1),
(57, '2018_11_27_174449_change_content_column_in_sliders_table', 1),
(58, '2018_12_05_132625_drop_foreign_key_core_config_table', 1),
(59, '2018_12_05_132629_alter_core_config_table', 1),
(60, '2018_12_06_185202_create_product_flat_table', 1),
(61, '2018_12_21_101307_alter_channels_table', 1),
(62, '2018_12_24_123812_create_channel_inventory_sources_table', 1),
(63, '2018_12_24_184402_alter_shipments_table', 1),
(64, '2018_12_26_165327_create_product_ordered_inventories_table', 1),
(65, '2018_12_31_161114_alter_channels_category_table', 1),
(66, '2019_01_11_122452_add_vendor_id_column_in_product_inventories_table', 1),
(67, '2019_01_25_124522_add_updated_at_column_in_product_flat_table', 1),
(68, '2019_01_29_123053_add_min_price_and_max_price_column_in_product_flat_table', 1),
(69, '2019_01_31_164117_update_value_column_type_to_text_in_core_config_table', 1),
(70, '2019_02_21_145238_alter_product_reviews_table', 1),
(71, '2019_02_21_152709_add_swatch_type_column_in_attributes_table', 1),
(72, '2019_02_21_153035_alter_customer_id_in_product_reviews_table', 1),
(73, '2019_02_21_153851_add_swatch_value_columns_in_attribute_options_table', 1),
(74, '2019_03_15_123337_add_display_mode_column_in_categories_table', 1),
(75, '2019_03_28_103658_add_notes_column_in_customers_table', 1),
(76, '2019_04_24_155820_alter_product_flat_table', 1),
(77, '2019_05_13_024320_remove_tables', 1),
(78, '2019_05_13_024321_create_cart_rules_table', 1),
(79, '2019_05_13_024322_create_cart_rule_channels_table', 1),
(80, '2019_05_13_024323_create_cart_rule_customer_groups_table', 1),
(81, '2019_05_13_024324_create_cart_rule_translations_table', 1),
(82, '2019_05_13_024325_create_cart_rule_customers_table', 1),
(83, '2019_05_13_024326_create_cart_rule_coupons_table', 1),
(84, '2019_05_13_024327_create_cart_rule_coupon_usage_table', 1),
(85, '2019_05_22_165833_update_zipcode_column_type_to_varchar_in_cart_address_table', 1),
(86, '2019_05_23_113407_add_remaining_column_in_product_flat_table', 1),
(87, '2019_05_23_155520_add_discount_columns_in_invoice_items_table', 1),
(88, '2019_05_23_184029_rename_discount_columns_in_cart_table', 1),
(89, '2019_06_04_114009_add_phone_column_in_customers_table', 1),
(90, '2019_06_06_195905_update_custom_price_to_nullable_in_cart_items', 1),
(91, '2019_06_15_183412_add_code_column_in_customer_groups_table', 1),
(92, '2019_06_17_180258_create_product_downloadable_samples_table', 1),
(93, '2019_06_17_180314_create_product_downloadable_sample_translations_table', 1),
(94, '2019_06_17_180325_create_product_downloadable_links_table', 1),
(95, '2019_06_17_180346_create_product_downloadable_link_translations_table', 1),
(96, '2019_06_19_162817_remove_unique_in_phone_column_in_customers_table', 1),
(97, '2019_06_21_130512_update_weight_column_deafult_value_in_cart_items_table', 1),
(98, '2019_06_21_202249_create_downloadable_link_purchased_table', 1),
(99, '2019_07_02_180307_create_booking_products_table', 1),
(100, '2019_07_05_114157_add_symbol_column_in_currencies_table', 1),
(101, '2019_07_05_154415_create_booking_product_default_slots_table', 1),
(102, '2019_07_05_154429_create_booking_product_appointment_slots_table', 1),
(103, '2019_07_05_154440_create_booking_product_event_tickets_table', 1),
(104, '2019_07_05_154451_create_booking_product_rental_slots_table', 1),
(105, '2019_07_05_154502_create_booking_product_table_slots_table', 1),
(106, '2019_07_11_151210_add_locale_id_in_category_translations', 1),
(107, '2019_07_23_033128_alter_locales_table', 1),
(108, '2019_07_23_174708_create_velocity_contents_table', 1),
(109, '2019_07_23_175212_create_velocity_contents_translations_table', 1),
(110, '2019_07_29_142734_add_use_in_flat_column_in_attributes_table', 1),
(111, '2019_07_30_153530_create_cms_pages_table', 1),
(112, '2019_07_31_143339_create_category_filterable_attributes_table', 1),
(113, '2019_08_02_105320_create_product_grouped_products_table', 1),
(114, '2019_08_12_184925_add_additional_cloumn_in_wishlist_table', 1),
(115, '2019_08_20_170510_create_product_bundle_options_table', 1),
(116, '2019_08_20_170520_create_product_bundle_option_translations_table', 1),
(117, '2019_08_20_170528_create_product_bundle_option_products_table', 1),
(118, '2019_08_21_123707_add_seo_column_in_channels_table', 1),
(119, '2019_09_11_184511_create_refunds_table', 1),
(120, '2019_09_11_184519_create_refund_items_table', 1),
(121, '2019_09_26_163950_remove_channel_id_from_customers_table', 1),
(122, '2019_10_03_105451_change_rate_column_in_currency_exchange_rates_table', 1),
(123, '2019_10_21_105136_order_brands', 1),
(124, '2019_10_24_173358_change_postcode_column_type_in_order_address_table', 1),
(125, '2019_10_24_173437_change_postcode_column_type_in_cart_address_table', 1),
(126, '2019_10_24_173507_change_postcode_column_type_in_customer_addresses_table', 1),
(127, '2019_11_21_194541_add_column_url_path_to_category_translations', 1),
(128, '2019_11_21_194608_add_stored_function_to_get_url_path_of_category', 1),
(129, '2019_11_21_194627_add_trigger_to_category_translations', 1),
(130, '2019_11_21_194648_add_url_path_to_existing_category_translations', 1),
(131, '2019_11_21_194703_add_trigger_to_categories', 1),
(132, '2019_11_25_171136_add_applied_cart_rule_ids_column_in_cart_table', 1),
(133, '2019_11_25_171208_add_applied_cart_rule_ids_column_in_cart_items_table', 1),
(134, '2019_11_30_124437_add_applied_cart_rule_ids_column_in_orders_table', 1),
(135, '2019_11_30_165644_add_discount_columns_in_cart_shipping_rates_table', 1),
(136, '2019_12_03_175253_create_remove_catalog_rule_tables', 1),
(137, '2019_12_03_184613_create_catalog_rules_table', 1),
(138, '2019_12_03_184651_create_catalog_rule_channels_table', 1),
(139, '2019_12_03_184732_create_catalog_rule_customer_groups_table', 1),
(140, '2019_12_06_101110_create_catalog_rule_products_table', 1),
(141, '2019_12_06_110507_create_catalog_rule_product_prices_table', 1),
(142, '2019_12_30_155256_create_velocity_meta_data', 1),
(143, '2020_01_02_201029_add_api_token_columns', 1),
(144, '2020_01_06_173505_alter_trigger_category_translations', 1),
(145, '2020_01_06_173524_alter_stored_function_url_path_category', 1),
(146, '2020_01_06_195305_alter_trigger_on_categories', 1),
(147, '2020_01_09_154851_add_shipping_discount_columns_in_orders_table', 1),
(148, '2020_01_09_202815_add_inventory_source_name_column_in_shipments_table', 1),
(149, '2020_01_10_122226_update_velocity_meta_data', 1),
(150, '2020_01_10_151902_customer_address_improvements', 1),
(151, '2020_01_13_131431_alter_float_value_column_type_in_product_attribute_values_table', 1),
(152, '2020_01_13_155803_add_velocity_locale_icon', 1),
(153, '2020_01_13_192149_add_category_velocity_meta_data', 1),
(154, '2020_01_14_191854_create_cms_page_translations_table', 1),
(155, '2020_01_14_192206_remove_columns_from_cms_pages_table', 1),
(156, '2020_01_15_130209_create_cms_page_channels_table', 1),
(157, '2020_01_15_145637_add_product_policy', 1),
(158, '2020_01_15_152121_add_banner_link', 1),
(159, '2020_01_28_102422_add_new_column_and_rename_name_column_in_customer_addresses_table', 1),
(160, '2020_01_29_124748_alter_name_column_in_country_state_translations_table', 1),
(161, '2020_02_18_165639_create_bookings_table', 1),
(162, '2020_02_21_121201_create_booking_product_event_ticket_translations_table', 1),
(163, '2020_02_24_190025_add_is_comparable_column_in_attributes_table', 1),
(164, '2020_02_25_181902_propagate_company_name', 1),
(165, '2020_02_26_163908_change_column_type_in_cart_rules_table', 1),
(166, '2020_02_28_105104_fix_order_columns', 1),
(167, '2020_02_28_111958_create_customer_compare_products_table', 1),
(168, '2020_03_23_201431_alter_booking_products_table', 1),
(169, '2020_04_13_224524_add_locale_in_sliders_table', 1),
(170, '2020_04_16_130351_remove_channel_from_tax_category', 1),
(171, '2020_04_16_185147_add_table_addresses', 1),
(172, '2020_05_06_171638_create_order_comments_table', 1),
(173, '2020_05_21_171500_create_product_customer_group_prices_table', 1),
(174, '2020_06_08_161708_add_sale_prices_to_booking_product_event_tickets', 1),
(175, '2020_06_10_201453_add_locale_velocity_meta_data', 1),
(176, '2020_06_25_162154_create_customer_social_accounts_table', 1),
(177, '2020_06_25_162340_change_email_password_columns_in_customers_table', 1),
(178, '2020_06_30_163510_remove_unique_name_in_tax_categories_table', 1),
(179, '2020_07_31_142021_update_cms_page_translations_table_field_html_content', 1),
(180, '2020_08_01_132239_add_header_content_count_velocity_meta_data_table', 1),
(181, '2020_08_12_114128_removing_foriegn_key', 1),
(182, '2020_08_17_104228_add_channel_to_velocity_meta_data_table', 1),
(183, '2020_09_07_120413_add_unique_index_to_increment_id_in_orders_table', 1),
(184, '2020_09_07_195157_add_additional_to_category', 1),
(185, '2020_11_10_174816_add_product_number_column_in_product_flat_table', 2),
(186, '2020_11_19_112228_create_product_videos_table', 2),
(187, '2020_11_20_105353_add_columns_in_channels_table', 2),
(188, '2020_11_26_141455_create_marketing_templates_table', 2),
(189, '2020_11_26_150534_create_marketing_events_table', 2),
(190, '2020_11_26_150644_create_marketing_campaigns_table', 2),
(191, '2020_12_18_122826_add_is_tax_calculation_column_to_cart_shipping_rates_table', 2),
(192, '2020_12_21_000200_create_channel_translations_table', 2),
(193, '2020_12_21_140151_remove_columns_from_channels_table', 2),
(194, '2020_12_24_131004_add_customer_id_column_in_subscribers_list_table', 2),
(195, '2020_12_27_121950_create_jobs_table', 2),
(196, '2021_02_03_104907_add_adittional_data_to_order_payment_table', 2),
(197, '2021_02_04_150033_add_download_canceled_column_in_downloadable_link_purchased_table', 2);

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` int(10) UNSIGNED NOT NULL,
  `increment_id` varchar(191) NOT NULL,
  `status` varchar(191) DEFAULT NULL,
  `channel_name` varchar(191) DEFAULT NULL,
  `is_guest` tinyint(1) DEFAULT NULL,
  `customer_email` varchar(191) DEFAULT NULL,
  `customer_first_name` varchar(191) DEFAULT NULL,
  `customer_last_name` varchar(191) DEFAULT NULL,
  `customer_company_name` varchar(191) DEFAULT NULL,
  `customer_vat_id` varchar(191) DEFAULT NULL,
  `shipping_method` varchar(191) DEFAULT NULL,
  `shipping_title` varchar(191) DEFAULT NULL,
  `shipping_description` varchar(191) DEFAULT NULL,
  `coupon_code` varchar(191) DEFAULT NULL,
  `is_gift` tinyint(1) NOT NULL DEFAULT 0,
  `total_item_count` int(11) DEFAULT NULL,
  `total_qty_ordered` int(11) DEFAULT NULL,
  `base_currency_code` varchar(191) DEFAULT NULL,
  `channel_currency_code` varchar(191) DEFAULT NULL,
  `order_currency_code` varchar(191) DEFAULT NULL,
  `grand_total` decimal(12,4) DEFAULT 0.0000,
  `base_grand_total` decimal(12,4) DEFAULT 0.0000,
  `grand_total_invoiced` decimal(12,4) DEFAULT 0.0000,
  `base_grand_total_invoiced` decimal(12,4) DEFAULT 0.0000,
  `grand_total_refunded` decimal(12,4) DEFAULT 0.0000,
  `base_grand_total_refunded` decimal(12,4) DEFAULT 0.0000,
  `sub_total` decimal(12,4) DEFAULT 0.0000,
  `base_sub_total` decimal(12,4) DEFAULT 0.0000,
  `sub_total_invoiced` decimal(12,4) DEFAULT 0.0000,
  `base_sub_total_invoiced` decimal(12,4) DEFAULT 0.0000,
  `sub_total_refunded` decimal(12,4) DEFAULT 0.0000,
  `base_sub_total_refunded` decimal(12,4) DEFAULT 0.0000,
  `discount_percent` decimal(12,4) DEFAULT 0.0000,
  `discount_amount` decimal(12,4) DEFAULT 0.0000,
  `base_discount_amount` decimal(12,4) DEFAULT 0.0000,
  `discount_invoiced` decimal(12,4) DEFAULT 0.0000,
  `base_discount_invoiced` decimal(12,4) DEFAULT 0.0000,
  `discount_refunded` decimal(12,4) DEFAULT 0.0000,
  `base_discount_refunded` decimal(12,4) DEFAULT 0.0000,
  `tax_amount` decimal(12,4) DEFAULT 0.0000,
  `base_tax_amount` decimal(12,4) DEFAULT 0.0000,
  `tax_amount_invoiced` decimal(12,4) DEFAULT 0.0000,
  `base_tax_amount_invoiced` decimal(12,4) DEFAULT 0.0000,
  `tax_amount_refunded` decimal(12,4) DEFAULT 0.0000,
  `base_tax_amount_refunded` decimal(12,4) DEFAULT 0.0000,
  `shipping_amount` decimal(12,4) DEFAULT 0.0000,
  `base_shipping_amount` decimal(12,4) DEFAULT 0.0000,
  `shipping_invoiced` decimal(12,4) DEFAULT 0.0000,
  `base_shipping_invoiced` decimal(12,4) DEFAULT 0.0000,
  `shipping_refunded` decimal(12,4) DEFAULT 0.0000,
  `base_shipping_refunded` decimal(12,4) DEFAULT 0.0000,
  `customer_id` int(10) UNSIGNED DEFAULT NULL,
  `customer_type` varchar(191) DEFAULT NULL,
  `channel_id` int(10) UNSIGNED DEFAULT NULL,
  `channel_type` varchar(191) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `cart_id` int(11) DEFAULT NULL,
  `applied_cart_rule_ids` varchar(191) DEFAULT NULL,
  `shipping_discount_amount` decimal(12,4) DEFAULT 0.0000,
  `base_shipping_discount_amount` decimal(12,4) DEFAULT 0.0000
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `order_brands`
--

CREATE TABLE `order_brands` (
  `id` int(10) UNSIGNED NOT NULL,
  `order_id` int(10) UNSIGNED DEFAULT NULL,
  `order_item_id` int(10) UNSIGNED DEFAULT NULL,
  `product_id` int(10) UNSIGNED DEFAULT NULL,
  `brand` int(10) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `order_comments`
--

CREATE TABLE `order_comments` (
  `id` int(10) UNSIGNED NOT NULL,
  `comment` text NOT NULL,
  `customer_notified` tinyint(1) NOT NULL DEFAULT 0,
  `order_id` int(10) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `id` int(10) UNSIGNED NOT NULL,
  `sku` varchar(191) DEFAULT NULL,
  `type` varchar(191) DEFAULT NULL,
  `name` varchar(191) DEFAULT NULL,
  `coupon_code` varchar(191) DEFAULT NULL,
  `weight` decimal(12,4) DEFAULT 0.0000,
  `total_weight` decimal(12,4) DEFAULT 0.0000,
  `qty_ordered` int(11) DEFAULT 0,
  `qty_shipped` int(11) DEFAULT 0,
  `qty_invoiced` int(11) DEFAULT 0,
  `qty_canceled` int(11) DEFAULT 0,
  `qty_refunded` int(11) DEFAULT 0,
  `price` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_price` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `total` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_total` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `total_invoiced` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_total_invoiced` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `amount_refunded` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_amount_refunded` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `discount_percent` decimal(12,4) DEFAULT 0.0000,
  `discount_amount` decimal(12,4) DEFAULT 0.0000,
  `base_discount_amount` decimal(12,4) DEFAULT 0.0000,
  `discount_invoiced` decimal(12,4) DEFAULT 0.0000,
  `base_discount_invoiced` decimal(12,4) DEFAULT 0.0000,
  `discount_refunded` decimal(12,4) DEFAULT 0.0000,
  `base_discount_refunded` decimal(12,4) DEFAULT 0.0000,
  `tax_percent` decimal(12,4) DEFAULT 0.0000,
  `tax_amount` decimal(12,4) DEFAULT 0.0000,
  `base_tax_amount` decimal(12,4) DEFAULT 0.0000,
  `tax_amount_invoiced` decimal(12,4) DEFAULT 0.0000,
  `base_tax_amount_invoiced` decimal(12,4) DEFAULT 0.0000,
  `tax_amount_refunded` decimal(12,4) DEFAULT 0.0000,
  `base_tax_amount_refunded` decimal(12,4) DEFAULT 0.0000,
  `product_id` int(10) UNSIGNED DEFAULT NULL,
  `product_type` varchar(191) DEFAULT NULL,
  `order_id` int(10) UNSIGNED DEFAULT NULL,
  `parent_id` int(10) UNSIGNED DEFAULT NULL,
  `additional` longtext DEFAULT NULL CHECK (json_valid(`additional`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `order_payment`
--

CREATE TABLE `order_payment` (
  `id` int(10) UNSIGNED NOT NULL,
  `method` varchar(191) NOT NULL,
  `method_title` varchar(191) DEFAULT NULL,
  `order_id` int(10) UNSIGNED DEFAULT NULL,
  `additional` longtext DEFAULT NULL CHECK (json_valid(`additional`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `password_resets`
--

CREATE TABLE `password_resets` (
  `email` varchar(191) NOT NULL,
  `token` varchar(191) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` int(10) UNSIGNED NOT NULL,
  `sku` varchar(191) NOT NULL,
  `type` varchar(191) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `parent_id` int(10) UNSIGNED DEFAULT NULL,
  `attribute_family_id` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `sku`, `type`, `created_at`, `updated_at`, `parent_id`, `attribute_family_id`) VALUES
(1, '123456', 'simple', '2021-02-24 17:39:20', '2021-02-24 17:39:20', NULL, 1),
(2, '1122', 'downloadable', '2021-03-02 16:28:11', '2021-03-02 16:28:11', NULL, 1);

-- --------------------------------------------------------

--
-- Table structure for table `product_attribute_values`
--

CREATE TABLE `product_attribute_values` (
  `id` int(10) UNSIGNED NOT NULL,
  `locale` varchar(191) DEFAULT NULL,
  `channel` varchar(191) DEFAULT NULL,
  `text_value` text DEFAULT NULL,
  `boolean_value` tinyint(1) DEFAULT NULL,
  `integer_value` int(11) DEFAULT NULL,
  `float_value` decimal(12,4) DEFAULT NULL,
  `datetime_value` datetime DEFAULT NULL,
  `date_value` date DEFAULT NULL,
  `json_value` longtext DEFAULT NULL CHECK (json_valid(`json_value`)),
  `product_id` int(10) UNSIGNED NOT NULL,
  `attribute_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `product_attribute_values`
--

INSERT INTO `product_attribute_values` (`id`, `locale`, `channel`, `text_value`, `boolean_value`, `integer_value`, `float_value`, `datetime_value`, `date_value`, `json_value`, `product_id`, `attribute_id`) VALUES
(1, 'en', 'default', '<p>A <strong>T-shirt</strong>, or <strong>tee shirt</strong>, is a style of fabric named after the T shape of its body and sleeves. Traditionally, it has short sleeves and a round neckline, known as a which lacks a collar.</p>', NULL, NULL, NULL, NULL, NULL, NULL, 1, 9),
(2, 'en', 'default', '<p>A <strong>T-shirt</strong>, or <strong>tee shirt</strong>, is a style of fabricnamed after the T shape of its body and sleeves. Traditionally, it has short sleeves and a round neckline, known as a , which lacks a collar. T-shirts are generally made of a stretchy, light and inexpensive fabric and are easy to clean.</p>\r\n<p>Typically made of cotton textile, it has a distinctively pliable texture compared to shirts made of woven cloth.</p>\r\n<p>Some modern versions have a body made from a continuously knitted tube, produced, such that the torso has no side seams. The manufacture of T-shirts has become highly automated and may include cutting fabric.</p>\r\n<p>The T-shirt evolved fromused in the 19th century and, in the mid-20th century, transitioned from undergarment to general-use casual clothing.</p>\r\n<p>A V-neck T-shirt has a V-shaped, as opposed to the round neckline of the more common crew neck shirt (also called a U-neck). V-necks were introduced so that the neckline of the shirt does not show when worn beneath an outer shirt, as would that of a crew neck shirt</p>', NULL, NULL, NULL, NULL, NULL, NULL, 1, 10),
(3, NULL, NULL, '123456', NULL, NULL, NULL, NULL, NULL, NULL, 1, 1),
(4, 'en', 'default', 'MAN', NULL, NULL, NULL, NULL, NULL, NULL, 1, 2),
(5, NULL, NULL, 'man', NULL, NULL, NULL, NULL, NULL, NULL, 1, 3),
(6, NULL, 'default', NULL, NULL, 0, NULL, NULL, NULL, NULL, 1, 4),
(7, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, 1, 5),
(8, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, 1, 6),
(9, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, 1, 7),
(10, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, 1, 8),
(11, NULL, NULL, NULL, NULL, 3, NULL, NULL, NULL, NULL, 1, 23),
(12, NULL, NULL, NULL, NULL, 6, NULL, NULL, NULL, NULL, 1, 24),
(13, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, 1, 26),
(14, NULL, NULL, '123', NULL, NULL, NULL, NULL, NULL, NULL, 1, 27),
(15, 'en', 'default', '', NULL, NULL, NULL, NULL, NULL, NULL, 1, 16),
(16, 'en', 'default', '', NULL, NULL, NULL, NULL, NULL, NULL, 1, 17),
(17, 'en', 'default', '', NULL, NULL, NULL, NULL, NULL, NULL, 1, 18),
(18, NULL, NULL, NULL, NULL, NULL, '300.0000', NULL, NULL, NULL, 1, 11),
(19, NULL, 'default', NULL, NULL, NULL, '450.0000', NULL, NULL, NULL, 1, 12),
(20, NULL, NULL, NULL, NULL, NULL, '250.0000', NULL, NULL, NULL, 1, 13),
(21, NULL, 'default', NULL, NULL, NULL, NULL, NULL, '2021-02-24', NULL, 1, 14),
(22, NULL, 'default', NULL, NULL, NULL, NULL, NULL, '2021-02-26', NULL, 1, 15),
(23, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, 1, 19),
(24, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, 1, 20),
(25, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, 1, 21),
(26, NULL, NULL, '50', NULL, NULL, NULL, NULL, NULL, NULL, 1, 22),
(27, 'en', 'default', '<p><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">The&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">men\'s</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;dress&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">shirt</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;is a button-up&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">shirt</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;with a collar and long sleeves it is cut differently</span><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">.</span></p>', NULL, NULL, NULL, NULL, NULL, NULL, 2, 9),
(28, 'en', 'default', '<p><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">The&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">men\'s</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;dress&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">shirt</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;is a button-up&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">shirt</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;with a collar and long sleeves. It is cut differently than the sport&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">shirt</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">, which is made to be worn open-necked and looks awkward with a tie. The dress&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">shirt</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;is designed to carry a jacket and tie, but can be worn without one or the other or with neither.</span></p>', NULL, NULL, NULL, NULL, NULL, NULL, 2, 10),
(29, NULL, NULL, '1122', NULL, NULL, NULL, NULL, NULL, NULL, 2, 1),
(30, 'en', 'default', 'MEN SHIRTS', NULL, NULL, NULL, NULL, NULL, NULL, 2, 2),
(31, NULL, NULL, 'men-shirts', NULL, NULL, NULL, NULL, NULL, NULL, 2, 3),
(32, NULL, 'default', NULL, NULL, 0, NULL, NULL, NULL, NULL, 2, 4),
(33, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, 2, 5),
(34, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, 2, 6),
(35, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, 2, 7),
(36, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, 2, 8),
(37, NULL, NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, 2, 23),
(38, NULL, NULL, NULL, NULL, 9, NULL, NULL, NULL, NULL, 2, 24),
(39, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, 2, 26),
(40, NULL, NULL, 'MEN1122', NULL, NULL, NULL, NULL, NULL, NULL, 2, 27),
(41, 'en', 'default', '', NULL, NULL, NULL, NULL, NULL, NULL, 2, 16),
(42, 'en', 'default', '', NULL, NULL, NULL, NULL, NULL, NULL, 2, 17),
(43, 'en', 'default', '', NULL, NULL, NULL, NULL, NULL, NULL, 2, 18),
(44, NULL, NULL, NULL, NULL, NULL, '30.0000', NULL, NULL, NULL, 2, 11),
(45, NULL, 'default', NULL, NULL, NULL, '35.0000', NULL, NULL, NULL, 2, 12),
(46, NULL, NULL, NULL, NULL, NULL, '25.0000', NULL, NULL, NULL, 2, 13),
(47, NULL, 'default', NULL, NULL, NULL, NULL, NULL, '2021-03-02', NULL, 2, 14),
(48, NULL, 'default', NULL, NULL, NULL, NULL, NULL, '2021-03-04', NULL, 2, 15);

-- --------------------------------------------------------

--
-- Table structure for table `product_bundle_options`
--

CREATE TABLE `product_bundle_options` (
  `id` int(10) UNSIGNED NOT NULL,
  `type` varchar(191) NOT NULL,
  `is_required` tinyint(1) NOT NULL DEFAULT 1,
  `sort_order` int(11) NOT NULL DEFAULT 0,
  `product_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `product_bundle_option_products`
--

CREATE TABLE `product_bundle_option_products` (
  `id` int(10) UNSIGNED NOT NULL,
  `qty` int(11) NOT NULL DEFAULT 0,
  `is_user_defined` tinyint(1) NOT NULL DEFAULT 1,
  `is_default` tinyint(1) NOT NULL DEFAULT 0,
  `sort_order` int(11) NOT NULL DEFAULT 0,
  `product_bundle_option_id` int(10) UNSIGNED NOT NULL,
  `product_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `product_bundle_option_translations`
--

CREATE TABLE `product_bundle_option_translations` (
  `id` int(10) UNSIGNED NOT NULL,
  `locale` varchar(191) NOT NULL,
  `label` text DEFAULT NULL,
  `product_bundle_option_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `product_categories`
--

CREATE TABLE `product_categories` (
  `product_id` int(10) UNSIGNED NOT NULL,
  `category_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `product_categories`
--

INSERT INTO `product_categories` (`product_id`, `category_id`) VALUES
(1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `product_cross_sells`
--

CREATE TABLE `product_cross_sells` (
  `parent_id` int(10) UNSIGNED NOT NULL,
  `child_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `product_customer_group_prices`
--

CREATE TABLE `product_customer_group_prices` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `qty` int(11) NOT NULL DEFAULT 0,
  `value_type` varchar(191) NOT NULL,
  `value` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `product_id` int(10) UNSIGNED NOT NULL,
  `customer_group_id` int(10) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `product_customer_group_prices`
--

INSERT INTO `product_customer_group_prices` (`id`, `qty`, `value_type`, `value`, `product_id`, `customer_group_id`, `created_at`, `updated_at`) VALUES
(1, 20, 'discount', '20.0000', 1, NULL, '2021-02-24 17:52:10', '2021-02-24 17:52:10'),
(2, 20, 'fixed', '22.0000', 2, NULL, '2021-03-02 16:33:24', '2021-03-02 16:33:24');

-- --------------------------------------------------------

--
-- Table structure for table `product_downloadable_links`
--

CREATE TABLE `product_downloadable_links` (
  `id` int(10) UNSIGNED NOT NULL,
  `url` varchar(191) DEFAULT NULL,
  `file` varchar(191) DEFAULT NULL,
  `file_name` varchar(191) DEFAULT NULL,
  `type` varchar(191) NOT NULL,
  `price` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `sample_url` varchar(191) DEFAULT NULL,
  `sample_file` varchar(191) DEFAULT NULL,
  `sample_file_name` varchar(191) DEFAULT NULL,
  `sample_type` varchar(191) DEFAULT NULL,
  `downloads` int(11) NOT NULL DEFAULT 0,
  `sort_order` int(11) DEFAULT NULL,
  `product_id` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `product_downloadable_link_translations`
--

CREATE TABLE `product_downloadable_link_translations` (
  `id` int(10) UNSIGNED NOT NULL,
  `locale` varchar(191) NOT NULL,
  `title` text DEFAULT NULL,
  `product_downloadable_link_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `product_downloadable_samples`
--

CREATE TABLE `product_downloadable_samples` (
  `id` int(10) UNSIGNED NOT NULL,
  `url` varchar(191) DEFAULT NULL,
  `file` varchar(191) DEFAULT NULL,
  `file_name` varchar(191) DEFAULT NULL,
  `type` varchar(191) NOT NULL,
  `sort_order` int(11) DEFAULT NULL,
  `product_id` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `product_downloadable_sample_translations`
--

CREATE TABLE `product_downloadable_sample_translations` (
  `id` int(10) UNSIGNED NOT NULL,
  `locale` varchar(191) NOT NULL,
  `title` text DEFAULT NULL,
  `product_downloadable_sample_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `product_flat`
--

CREATE TABLE `product_flat` (
  `id` int(10) UNSIGNED NOT NULL,
  `sku` varchar(191) NOT NULL,
  `product_number` varchar(191) DEFAULT NULL,
  `name` varchar(191) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `url_key` varchar(191) DEFAULT NULL,
  `new` tinyint(1) DEFAULT NULL,
  `featured` tinyint(1) DEFAULT NULL,
  `status` tinyint(1) DEFAULT NULL,
  `thumbnail` varchar(191) DEFAULT NULL,
  `price` decimal(12,4) DEFAULT NULL,
  `cost` decimal(12,4) DEFAULT NULL,
  `special_price` decimal(12,4) DEFAULT NULL,
  `special_price_from` date DEFAULT NULL,
  `special_price_to` date DEFAULT NULL,
  `weight` decimal(12,4) DEFAULT NULL,
  `color` int(11) DEFAULT NULL,
  `color_label` varchar(191) DEFAULT NULL,
  `size` int(11) DEFAULT NULL,
  `size_label` varchar(191) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `locale` varchar(191) DEFAULT NULL,
  `channel` varchar(191) DEFAULT NULL,
  `product_id` int(10) UNSIGNED NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `parent_id` int(10) UNSIGNED DEFAULT NULL,
  `visible_individually` tinyint(1) DEFAULT NULL,
  `min_price` decimal(12,4) DEFAULT NULL,
  `max_price` decimal(12,4) DEFAULT NULL,
  `short_description` text DEFAULT NULL,
  `meta_title` text DEFAULT NULL,
  `meta_keywords` text DEFAULT NULL,
  `meta_description` text DEFAULT NULL,
  `width` decimal(12,4) DEFAULT NULL,
  `height` decimal(12,4) DEFAULT NULL,
  `depth` decimal(12,4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `product_flat`
--

INSERT INTO `product_flat` (`id`, `sku`, `product_number`, `name`, `description`, `url_key`, `new`, `featured`, `status`, `thumbnail`, `price`, `cost`, `special_price`, `special_price_from`, `special_price_to`, `weight`, `color`, `color_label`, `size`, `size_label`, `created_at`, `locale`, `channel`, `product_id`, `updated_at`, `parent_id`, `visible_individually`, `min_price`, `max_price`, `short_description`, `meta_title`, `meta_keywords`, `meta_description`, `width`, `height`, `depth`) VALUES
(1, '123456', '123', 'MAN', '<p>A <strong>T-shirt</strong>, or <strong>tee shirt</strong>, is a style of fabricnamed after the T shape of its body and sleeves. Traditionally, it has short sleeves and a round neckline, known as a , which lacks a collar. T-shirts are generally made of a stretchy, light and inexpensive fabric and are easy to clean.</p>\r\n<p>Typically made of cotton textile, it has a distinctively pliable texture compared to shirts made of woven cloth.</p>\r\n<p>Some modern versions have a body made from a continuously knitted tube, produced, such that the torso has no side seams. The manufacture of T-shirts has become highly automated and may include cutting fabric.</p>\r\n<p>The T-shirt evolved fromused in the 19th century and, in the mid-20th century, transitioned from undergarment to general-use casual clothing.</p>\r\n<p>A V-neck T-shirt has a V-shaped, as opposed to the round neckline of the more common crew neck shirt (also called a U-neck). V-necks were introduced so that the neckline of the shirt does not show when worn beneath an outer shirt, as would that of a crew neck shirt</p>', 'man', 1, 0, 1, NULL, '300.0000', '450.0000', '250.0000', '2021-02-24', '2021-02-26', '50.0000', 3, 'Yellow', 6, 'S', '2021-02-24 22:39:20', 'en', 'default', 1, '2021-02-24 22:39:20', NULL, 1, '300.0000', '300.0000', '<p>A <strong>T-shirt</strong>, or <strong>tee shirt</strong>, is a style of fabric named after the T shape of its body and sleeves. Traditionally, it has short sleeves and a round neckline, known as a which lacks a collar.</p>', '', '', '', '0.0000', '0.0000', '0.0000'),
(2, '1122', 'MEN1122', 'MEN SHIRTS', '<p><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">The&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">men\'s</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;dress&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">shirt</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;is a button-up&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">shirt</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;with a collar and long sleeves. It is cut differently than the sport&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">shirt</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">, which is made to be worn open-necked and looks awkward with a tie. The dress&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">shirt</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;is designed to carry a jacket and tie, but can be worn without one or the other or with neither.</span></p>', 'men-shirts', 1, 1, 1, NULL, '30.0000', '35.0000', '25.0000', '2021-03-02', '2021-03-04', NULL, 2, 'Green', 9, 'XL', '2021-03-02 21:28:11', 'en', 'default', 2, '2021-03-02 21:28:11', NULL, 1, '25.0000', '25.0000', '<p><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">The&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">men\'s</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;dress&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">shirt</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;is a button-up&nbsp;</span><strong style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">shirt</strong><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;with a collar and long sleeves it is cut differently</span><span style=\"color: #202124; font-family: arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">.</span></p>', '', '', '', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `product_grouped_products`
--

CREATE TABLE `product_grouped_products` (
  `id` int(10) UNSIGNED NOT NULL,
  `qty` int(11) NOT NULL DEFAULT 0,
  `sort_order` int(11) NOT NULL DEFAULT 0,
  `product_id` int(10) UNSIGNED NOT NULL,
  `associated_product_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `product_images`
--

CREATE TABLE `product_images` (
  `id` int(10) UNSIGNED NOT NULL,
  `type` varchar(191) DEFAULT NULL,
  `path` varchar(191) NOT NULL,
  `product_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `product_images`
--

INSERT INTO `product_images` (`id`, `type`, `path`, `product_id`) VALUES
(1, NULL, 'product/1/ss9ptVtsbQ3AOgAsec0PeSCZhFgdTeuQy87c3YpG.jpg', 1),
(2, NULL, 'product/1/83IaPRWO6lfisnBVAfzs9nHdIKC1PLLEQnLhmZJ5.jpg', 1),
(3, NULL, 'product/2/2ePx73MNfR8wB2EnhOKwiAgf6GYCrJJPHiARVQTb.jpg', 2);

-- --------------------------------------------------------

--
-- Table structure for table `product_inventories`
--

CREATE TABLE `product_inventories` (
  `id` int(10) UNSIGNED NOT NULL,
  `qty` int(11) NOT NULL DEFAULT 0,
  `product_id` int(10) UNSIGNED NOT NULL,
  `inventory_source_id` int(10) UNSIGNED NOT NULL,
  `vendor_id` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `product_inventories`
--

INSERT INTO `product_inventories` (`id`, `qty`, `product_id`, `inventory_source_id`, `vendor_id`) VALUES
(1, 50, 1, 1, 0);

-- --------------------------------------------------------

--
-- Table structure for table `product_ordered_inventories`
--

CREATE TABLE `product_ordered_inventories` (
  `id` int(10) UNSIGNED NOT NULL,
  `qty` int(11) NOT NULL DEFAULT 0,
  `product_id` int(10) UNSIGNED NOT NULL,
  `channel_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `product_relations`
--

CREATE TABLE `product_relations` (
  `parent_id` int(10) UNSIGNED NOT NULL,
  `child_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `product_relations`
--

INSERT INTO `product_relations` (`parent_id`, `child_id`) VALUES
(1, 2);

-- --------------------------------------------------------

--
-- Table structure for table `product_reviews`
--

CREATE TABLE `product_reviews` (
  `id` int(10) UNSIGNED NOT NULL,
  `title` varchar(191) NOT NULL,
  `rating` int(11) NOT NULL,
  `comment` text DEFAULT NULL,
  `status` varchar(191) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `product_id` int(10) UNSIGNED NOT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `name` varchar(191) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `product_reviews`
--

INSERT INTO `product_reviews` (`id`, `title`, `rating`, `comment`, `status`, `created_at`, `updated_at`, `product_id`, `customer_id`, `name`) VALUES
(1, 'good ', 3, 'not excellent', 'approved', '2021-03-02 17:05:56', '2021-03-02 19:45:50', 1, NULL, 'ali');

-- --------------------------------------------------------

--
-- Table structure for table `product_super_attributes`
--

CREATE TABLE `product_super_attributes` (
  `product_id` int(10) UNSIGNED NOT NULL,
  `attribute_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `product_up_sells`
--

CREATE TABLE `product_up_sells` (
  `parent_id` int(10) UNSIGNED NOT NULL,
  `child_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `product_videos`
--

CREATE TABLE `product_videos` (
  `id` int(10) UNSIGNED NOT NULL,
  `type` varchar(191) DEFAULT NULL,
  `path` varchar(191) NOT NULL,
  `product_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `refunds`
--

CREATE TABLE `refunds` (
  `id` int(10) UNSIGNED NOT NULL,
  `increment_id` varchar(191) DEFAULT NULL,
  `state` varchar(191) DEFAULT NULL,
  `email_sent` tinyint(1) NOT NULL DEFAULT 0,
  `total_qty` int(11) DEFAULT NULL,
  `base_currency_code` varchar(191) DEFAULT NULL,
  `channel_currency_code` varchar(191) DEFAULT NULL,
  `order_currency_code` varchar(191) DEFAULT NULL,
  `adjustment_refund` decimal(12,4) DEFAULT 0.0000,
  `base_adjustment_refund` decimal(12,4) DEFAULT 0.0000,
  `adjustment_fee` decimal(12,4) DEFAULT 0.0000,
  `base_adjustment_fee` decimal(12,4) DEFAULT 0.0000,
  `sub_total` decimal(12,4) DEFAULT 0.0000,
  `base_sub_total` decimal(12,4) DEFAULT 0.0000,
  `grand_total` decimal(12,4) DEFAULT 0.0000,
  `base_grand_total` decimal(12,4) DEFAULT 0.0000,
  `shipping_amount` decimal(12,4) DEFAULT 0.0000,
  `base_shipping_amount` decimal(12,4) DEFAULT 0.0000,
  `tax_amount` decimal(12,4) DEFAULT 0.0000,
  `base_tax_amount` decimal(12,4) DEFAULT 0.0000,
  `discount_percent` decimal(12,4) DEFAULT 0.0000,
  `discount_amount` decimal(12,4) DEFAULT 0.0000,
  `base_discount_amount` decimal(12,4) DEFAULT 0.0000,
  `order_id` int(10) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `refund_items`
--

CREATE TABLE `refund_items` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(191) DEFAULT NULL,
  `description` varchar(191) DEFAULT NULL,
  `sku` varchar(191) DEFAULT NULL,
  `qty` int(11) DEFAULT NULL,
  `price` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_price` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `total` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_total` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `tax_amount` decimal(12,4) DEFAULT 0.0000,
  `base_tax_amount` decimal(12,4) DEFAULT 0.0000,
  `discount_percent` decimal(12,4) DEFAULT 0.0000,
  `discount_amount` decimal(12,4) DEFAULT 0.0000,
  `base_discount_amount` decimal(12,4) DEFAULT 0.0000,
  `product_id` int(10) UNSIGNED DEFAULT NULL,
  `product_type` varchar(191) DEFAULT NULL,
  `order_item_id` int(10) UNSIGNED DEFAULT NULL,
  `refund_id` int(10) UNSIGNED DEFAULT NULL,
  `parent_id` int(10) UNSIGNED DEFAULT NULL,
  `additional` longtext DEFAULT NULL CHECK (json_valid(`additional`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(191) NOT NULL,
  `description` varchar(191) DEFAULT NULL,
  `permission_type` varchar(191) NOT NULL,
  `permissions` longtext DEFAULT NULL CHECK (json_valid(`permissions`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `name`, `description`, `permission_type`, `permissions`, `created_at`, `updated_at`) VALUES
(1, 'Administrator', 'Administrator role', 'all', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `shipments`
--

CREATE TABLE `shipments` (
  `id` int(10) UNSIGNED NOT NULL,
  `status` varchar(191) DEFAULT NULL,
  `total_qty` int(11) DEFAULT NULL,
  `total_weight` int(11) DEFAULT NULL,
  `carrier_code` varchar(191) DEFAULT NULL,
  `carrier_title` varchar(191) DEFAULT NULL,
  `track_number` text DEFAULT NULL,
  `email_sent` tinyint(1) NOT NULL DEFAULT 0,
  `customer_id` int(10) UNSIGNED DEFAULT NULL,
  `customer_type` varchar(191) DEFAULT NULL,
  `order_id` int(10) UNSIGNED NOT NULL,
  `order_address_id` int(10) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `inventory_source_id` int(10) UNSIGNED DEFAULT NULL,
  `inventory_source_name` varchar(191) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `shipment_items`
--

CREATE TABLE `shipment_items` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(191) DEFAULT NULL,
  `description` varchar(191) DEFAULT NULL,
  `sku` varchar(191) DEFAULT NULL,
  `qty` int(11) DEFAULT NULL,
  `weight` int(11) DEFAULT NULL,
  `price` decimal(12,4) DEFAULT 0.0000,
  `base_price` decimal(12,4) DEFAULT 0.0000,
  `total` decimal(12,4) DEFAULT 0.0000,
  `base_total` decimal(12,4) DEFAULT 0.0000,
  `product_id` int(10) UNSIGNED DEFAULT NULL,
  `product_type` varchar(191) DEFAULT NULL,
  `order_item_id` int(10) UNSIGNED DEFAULT NULL,
  `shipment_id` int(10) UNSIGNED NOT NULL,
  `additional` longtext DEFAULT NULL CHECK (json_valid(`additional`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `sliders`
--

CREATE TABLE `sliders` (
  `id` int(10) UNSIGNED NOT NULL,
  `title` varchar(191) NOT NULL,
  `path` varchar(191) NOT NULL,
  `content` text DEFAULT NULL,
  `channel_id` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `slider_path` text DEFAULT NULL,
  `locale` varchar(191) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `subscribers_list`
--

CREATE TABLE `subscribers_list` (
  `id` int(10) UNSIGNED NOT NULL,
  `email` varchar(191) NOT NULL,
  `is_subscribed` tinyint(1) NOT NULL DEFAULT 0,
  `token` varchar(191) DEFAULT NULL,
  `channel_id` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `customer_id` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `tax_categories`
--

CREATE TABLE `tax_categories` (
  `id` int(10) UNSIGNED NOT NULL,
  `code` varchar(191) NOT NULL,
  `name` varchar(191) NOT NULL,
  `description` longtext NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `tax_categories_tax_rates`
--

CREATE TABLE `tax_categories_tax_rates` (
  `id` int(10) UNSIGNED NOT NULL,
  `tax_category_id` int(10) UNSIGNED NOT NULL,
  `tax_rate_id` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `tax_rates`
--

CREATE TABLE `tax_rates` (
  `id` int(10) UNSIGNED NOT NULL,
  `identifier` varchar(191) NOT NULL,
  `is_zip` tinyint(1) NOT NULL DEFAULT 0,
  `zip_code` varchar(191) DEFAULT NULL,
  `zip_from` varchar(191) DEFAULT NULL,
  `zip_to` varchar(191) DEFAULT NULL,
  `state` varchar(191) NOT NULL,
  `country` varchar(191) NOT NULL,
  `tax_rate` decimal(12,4) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(191) NOT NULL,
  `email` varchar(191) NOT NULL,
  `password` varchar(191) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `velocity_contents`
--

CREATE TABLE `velocity_contents` (
  `id` int(10) UNSIGNED NOT NULL,
  `content_type` varchar(100) DEFAULT NULL,
  `position` int(10) UNSIGNED DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `velocity_contents`
--

INSERT INTO `velocity_contents` (`id`, `content_type`, `position`, `status`, `created_at`, `updated_at`) VALUES
(1, 'category', 1, 1, '2021-03-02 19:18:34', '2021-03-02 19:24:10'),
(2, 'category', 2, 1, '2021-03-02 19:34:23', '2021-03-02 19:34:23');

-- --------------------------------------------------------

--
-- Table structure for table `velocity_contents_translations`
--

CREATE TABLE `velocity_contents_translations` (
  `id` int(10) UNSIGNED NOT NULL,
  `content_id` int(10) UNSIGNED DEFAULT NULL,
  `title` varchar(100) DEFAULT NULL,
  `custom_title` varchar(100) DEFAULT NULL,
  `custom_heading` varchar(250) DEFAULT NULL,
  `page_link` varchar(500) DEFAULT NULL,
  `link_target` tinyint(1) NOT NULL DEFAULT 0,
  `catalog_type` varchar(100) DEFAULT NULL,
  `products` text DEFAULT NULL,
  `description` text DEFAULT NULL,
  `locale` varchar(191) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `velocity_contents_translations`
--

INSERT INTO `velocity_contents_translations` (`id`, `content_id`, `title`, `custom_title`, `custom_heading`, `page_link`, `link_target`, `catalog_type`, `products`, `description`, `locale`, `created_at`, `updated_at`) VALUES
(1, 1, 'MEN', NULL, NULL, 'men', 1, NULL, NULL, NULL, 'en', NULL, NULL),
(2, 1, 'MEN', NULL, NULL, NULL, 0, NULL, NULL, NULL, 'fr', NULL, NULL),
(3, 1, 'MEN', NULL, NULL, NULL, 0, NULL, NULL, NULL, 'nl', NULL, NULL),
(4, 1, 'MEN', NULL, NULL, NULL, 0, NULL, NULL, NULL, 'tr', NULL, NULL),
(5, 2, 'WOMEN', NULL, NULL, 'women', 0, NULL, NULL, NULL, 'en', NULL, NULL),
(6, 2, 'WOMEN', NULL, NULL, NULL, 0, NULL, NULL, NULL, 'fr', NULL, NULL),
(7, 2, 'WOMEN', NULL, NULL, NULL, 0, NULL, NULL, NULL, 'nl', NULL, NULL),
(8, 2, 'WOMEN', NULL, NULL, NULL, 0, NULL, NULL, NULL, 'tr', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `velocity_customer_compare_products`
--

CREATE TABLE `velocity_customer_compare_products` (
  `id` int(10) UNSIGNED NOT NULL,
  `product_flat_id` int(10) UNSIGNED NOT NULL,
  `customer_id` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `velocity_meta_data`
--

CREATE TABLE `velocity_meta_data` (
  `id` int(10) UNSIGNED NOT NULL,
  `home_page_content` text NOT NULL,
  `footer_left_content` text NOT NULL,
  `footer_middle_content` text NOT NULL,
  `slider` tinyint(1) NOT NULL DEFAULT 0,
  `advertisement` longtext DEFAULT NULL CHECK (json_valid(`advertisement`)),
  `sidebar_category_count` int(11) NOT NULL DEFAULT 9,
  `featured_product_count` int(11) NOT NULL DEFAULT 10,
  `new_products_count` int(11) NOT NULL DEFAULT 10,
  `subscription_bar_content` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `product_view_images` longtext DEFAULT NULL CHECK (json_valid(`product_view_images`)),
  `product_policy` text DEFAULT NULL,
  `locale` text NOT NULL,
  `channel` text NOT NULL,
  `header_content_count` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `velocity_meta_data`
--

INSERT INTO `velocity_meta_data` (`id`, `home_page_content`, `footer_left_content`, `footer_middle_content`, `slider`, `advertisement`, `sidebar_category_count`, `featured_product_count`, `new_products_count`, `subscription_bar_content`, `created_at`, `updated_at`, `product_view_images`, `product_policy`, `locale`, `channel`, `header_content_count`) VALUES
(1, '<p>@include(\'shop::home.advertisements.advertisement-four\')@include(\'shop::home.featured-products\') @include(\'shop::home.product-policy\') @include(\'shop::home.advertisements.advertisement-three\') @include(\'shop::home.new-products\') @include(\'shop::home.advertisements.advertisement-two\')</p>', '<p>We love to craft softwares and solve the real world problems with the binaries. We are highly committed to our goals. We invest our resources to create world class easy to use softwares and applications for the enterprise business with the top notch, on the edge technology expertise.</p>', '<div class=\"col-lg-6 col-md-12 col-sm-12 no-padding\"><ul type=\"none\"><li><a href=\"{!! url(\'page/about-us\') !!}\">About Us</a></li><li><a href=\"{!! url(\'page/cutomer-service\') !!}\">Customer Service</a></li><li><a href=\"{!! url(\'page/whats-new\') !!}\">What&rsquo;s New</a></li><li><a href=\"{!! url(\'page/contact-us\') !!}\">Contact Us </a></li></ul></div><div class=\"col-lg-6 col-md-12 col-sm-12 no-padding\"><ul type=\"none\"><li><a href=\"{!! url(\'page/return-policy\') !!}\"> Order and Returns </a></li><li><a href=\"{!! url(\'page/payment-policy\') !!}\"> Payment Policy </a></li><li><a href=\"{!! url(\'page/shipping-policy\') !!}\"> Shipping Policy</a></li><li><a href=\"{!! url(\'page/privacy-policy\') !!}\"> Privacy and Cookies Policy </a></li></ul></div>', 1, NULL, 9, 10, 10, '<div class=\"social-icons col-lg-6\"><a href=\"https://webkul.com\" target=\"_blank\" class=\"unset\" rel=\"noopener noreferrer\"><i class=\"fs24 within-circle rango-facebook\" title=\"facebook\"></i> </a> <a href=\"https://webkul.com\" target=\"_blank\" class=\"unset\" rel=\"noopener noreferrer\"><i class=\"fs24 within-circle rango-twitter\" title=\"twitter\"></i> </a> <a href=\"https://webkul.com\" target=\"_blank\" class=\"unset\" rel=\"noopener noreferrer\"><i class=\"fs24 within-circle rango-linked-in\" title=\"linkedin\"></i> </a> <a href=\"https://webkul.com\" target=\"_blank\" class=\"unset\" rel=\"noopener noreferrer\"><i class=\"fs24 within-circle rango-pintrest\" title=\"Pinterest\"></i> </a> <a href=\"https://webkul.com\" target=\"_blank\" class=\"unset\" rel=\"noopener noreferrer\"><i class=\"fs24 within-circle rango-youtube\" title=\"Youtube\"></i> </a> <a href=\"https://webkul.com\" target=\"_blank\" class=\"unset\" rel=\"noopener noreferrer\"><i class=\"fs24 within-circle rango-instagram\" title=\"instagram\"></i></a></div>', NULL, NULL, NULL, '<div class=\"row col-12 remove-padding-margin\"><div class=\"col-lg-4 col-sm-12 product-policy-wrapper\"><div class=\"card\"><div class=\"policy\"><div class=\"left\"><i class=\"rango-van-ship fs40\"></i></div> <div class=\"right\"><span class=\"font-setting fs20\">Free Shipping on Order $20 or More</span></div></div></div></div> <div class=\"col-lg-4 col-sm-12 product-policy-wrapper\"><div class=\"card\"><div class=\"policy\"><div class=\"left\"><i class=\"rango-exchnage fs40\"></i></div> <div class=\"right\"><span class=\"font-setting fs20\">Product Replace &amp; Return Available </span></div></div></div></div> <div class=\"col-lg-4 col-sm-12 product-policy-wrapper\"><div class=\"card\"><div class=\"policy\"><div class=\"left\"><i class=\"rango-exchnage fs40\"></i></div> <div class=\"right\"><span class=\"font-setting fs20\">Product Exchange and EMI Available </span></div></div></div></div></div>', 'en', 'default', '5');

-- --------------------------------------------------------

--
-- Table structure for table `wishlist`
--

CREATE TABLE `wishlist` (
  `id` int(10) UNSIGNED NOT NULL,
  `channel_id` int(10) UNSIGNED NOT NULL,
  `product_id` int(10) UNSIGNED NOT NULL,
  `customer_id` int(10) UNSIGNED NOT NULL,
  `item_options` longtext DEFAULT NULL CHECK (json_valid(`item_options`)),
  `moved_to_cart` date DEFAULT NULL,
  `shared` tinyint(1) DEFAULT NULL,
  `time_of_moving` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `additional` longtext DEFAULT NULL CHECK (json_valid(`additional`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `addresses`
--
ALTER TABLE `addresses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `addresses_customer_id_foreign` (`customer_id`),
  ADD KEY `addresses_cart_id_foreign` (`cart_id`),
  ADD KEY `addresses_order_id_foreign` (`order_id`);

--
-- Indexes for table `admins`
--
ALTER TABLE `admins`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `admins_email_unique` (`email`),
  ADD UNIQUE KEY `admins_api_token_unique` (`api_token`);

--
-- Indexes for table `admin_password_resets`
--
ALTER TABLE `admin_password_resets`
  ADD KEY `admin_password_resets_email_index` (`email`);

--
-- Indexes for table `attributes`
--
ALTER TABLE `attributes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `attributes_code_unique` (`code`);

--
-- Indexes for table `attribute_families`
--
ALTER TABLE `attribute_families`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `attribute_groups`
--
ALTER TABLE `attribute_groups`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `attribute_groups_attribute_family_id_name_unique` (`attribute_family_id`,`name`);

--
-- Indexes for table `attribute_group_mappings`
--
ALTER TABLE `attribute_group_mappings`
  ADD PRIMARY KEY (`attribute_id`,`attribute_group_id`),
  ADD KEY `attribute_group_mappings_attribute_group_id_foreign` (`attribute_group_id`);

--
-- Indexes for table `attribute_options`
--
ALTER TABLE `attribute_options`
  ADD PRIMARY KEY (`id`),
  ADD KEY `attribute_options_attribute_id_foreign` (`attribute_id`);

--
-- Indexes for table `attribute_option_translations`
--
ALTER TABLE `attribute_option_translations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `attribute_option_translations_attribute_option_id_locale_unique` (`attribute_option_id`,`locale`);

--
-- Indexes for table `attribute_translations`
--
ALTER TABLE `attribute_translations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `attribute_translations_attribute_id_locale_unique` (`attribute_id`,`locale`);

--
-- Indexes for table `bookings`
--
ALTER TABLE `bookings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `bookings_order_id_foreign` (`order_id`),
  ADD KEY `bookings_product_id_foreign` (`product_id`);

--
-- Indexes for table `booking_products`
--
ALTER TABLE `booking_products`
  ADD PRIMARY KEY (`id`),
  ADD KEY `booking_products_product_id_foreign` (`product_id`);

--
-- Indexes for table `booking_product_appointment_slots`
--
ALTER TABLE `booking_product_appointment_slots`
  ADD PRIMARY KEY (`id`),
  ADD KEY `booking_product_appointment_slots_booking_product_id_foreign` (`booking_product_id`);

--
-- Indexes for table `booking_product_default_slots`
--
ALTER TABLE `booking_product_default_slots`
  ADD PRIMARY KEY (`id`),
  ADD KEY `booking_product_default_slots_booking_product_id_foreign` (`booking_product_id`);

--
-- Indexes for table `booking_product_event_tickets`
--
ALTER TABLE `booking_product_event_tickets`
  ADD PRIMARY KEY (`id`),
  ADD KEY `booking_product_event_tickets_booking_product_id_foreign` (`booking_product_id`);

--
-- Indexes for table `booking_product_event_ticket_translations`
--
ALTER TABLE `booking_product_event_ticket_translations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `booking_product_event_ticket_translations_locale_unique` (`booking_product_event_ticket_id`,`locale`);

--
-- Indexes for table `booking_product_rental_slots`
--
ALTER TABLE `booking_product_rental_slots`
  ADD PRIMARY KEY (`id`),
  ADD KEY `booking_product_rental_slots_booking_product_id_foreign` (`booking_product_id`);

--
-- Indexes for table `booking_product_table_slots`
--
ALTER TABLE `booking_product_table_slots`
  ADD PRIMARY KEY (`id`),
  ADD KEY `booking_product_table_slots_booking_product_id_foreign` (`booking_product_id`);

--
-- Indexes for table `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`id`),
  ADD KEY `cart_customer_id_foreign` (`customer_id`),
  ADD KEY `cart_channel_id_foreign` (`channel_id`);

--
-- Indexes for table `cart_items`
--
ALTER TABLE `cart_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `cart_items_product_id_foreign` (`product_id`),
  ADD KEY `cart_items_cart_id_foreign` (`cart_id`),
  ADD KEY `cart_items_tax_category_id_foreign` (`tax_category_id`),
  ADD KEY `cart_items_parent_id_foreign` (`parent_id`);

--
-- Indexes for table `cart_item_inventories`
--
ALTER TABLE `cart_item_inventories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cart_payment`
--
ALTER TABLE `cart_payment`
  ADD PRIMARY KEY (`id`),
  ADD KEY `cart_payment_cart_id_foreign` (`cart_id`);

--
-- Indexes for table `cart_rules`
--
ALTER TABLE `cart_rules`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cart_rule_channels`
--
ALTER TABLE `cart_rule_channels`
  ADD PRIMARY KEY (`cart_rule_id`,`channel_id`),
  ADD KEY `cart_rule_channels_channel_id_foreign` (`channel_id`);

--
-- Indexes for table `cart_rule_coupons`
--
ALTER TABLE `cart_rule_coupons`
  ADD PRIMARY KEY (`id`),
  ADD KEY `cart_rule_coupons_cart_rule_id_foreign` (`cart_rule_id`);

--
-- Indexes for table `cart_rule_coupon_usage`
--
ALTER TABLE `cart_rule_coupon_usage`
  ADD PRIMARY KEY (`id`),
  ADD KEY `cart_rule_coupon_usage_cart_rule_coupon_id_foreign` (`cart_rule_coupon_id`),
  ADD KEY `cart_rule_coupon_usage_customer_id_foreign` (`customer_id`);

--
-- Indexes for table `cart_rule_customers`
--
ALTER TABLE `cart_rule_customers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `cart_rule_customers_cart_rule_id_foreign` (`cart_rule_id`),
  ADD KEY `cart_rule_customers_customer_id_foreign` (`customer_id`);

--
-- Indexes for table `cart_rule_customer_groups`
--
ALTER TABLE `cart_rule_customer_groups`
  ADD PRIMARY KEY (`cart_rule_id`,`customer_group_id`),
  ADD KEY `cart_rule_customer_groups_customer_group_id_foreign` (`customer_group_id`);

--
-- Indexes for table `cart_rule_translations`
--
ALTER TABLE `cart_rule_translations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `cart_rule_translations_cart_rule_id_locale_unique` (`cart_rule_id`,`locale`);

--
-- Indexes for table `cart_shipping_rates`
--
ALTER TABLE `cart_shipping_rates`
  ADD PRIMARY KEY (`id`),
  ADD KEY `cart_shipping_rates_cart_address_id_foreign` (`cart_address_id`);

--
-- Indexes for table `catalog_rules`
--
ALTER TABLE `catalog_rules`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `catalog_rule_channels`
--
ALTER TABLE `catalog_rule_channels`
  ADD PRIMARY KEY (`catalog_rule_id`,`channel_id`),
  ADD KEY `catalog_rule_channels_channel_id_foreign` (`channel_id`);

--
-- Indexes for table `catalog_rule_customer_groups`
--
ALTER TABLE `catalog_rule_customer_groups`
  ADD PRIMARY KEY (`catalog_rule_id`,`customer_group_id`),
  ADD KEY `catalog_rule_customer_groups_customer_group_id_foreign` (`customer_group_id`);

--
-- Indexes for table `catalog_rule_products`
--
ALTER TABLE `catalog_rule_products`
  ADD PRIMARY KEY (`id`),
  ADD KEY `catalog_rule_products_product_id_foreign` (`product_id`),
  ADD KEY `catalog_rule_products_customer_group_id_foreign` (`customer_group_id`),
  ADD KEY `catalog_rule_products_catalog_rule_id_foreign` (`catalog_rule_id`),
  ADD KEY `catalog_rule_products_channel_id_foreign` (`channel_id`);

--
-- Indexes for table `catalog_rule_product_prices`
--
ALTER TABLE `catalog_rule_product_prices`
  ADD PRIMARY KEY (`id`),
  ADD KEY `catalog_rule_product_prices_product_id_foreign` (`product_id`),
  ADD KEY `catalog_rule_product_prices_customer_group_id_foreign` (`customer_group_id`),
  ADD KEY `catalog_rule_product_prices_catalog_rule_id_foreign` (`catalog_rule_id`),
  ADD KEY `catalog_rule_product_prices_channel_id_foreign` (`channel_id`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `categories__lft__rgt_parent_id_index` (`_lft`,`_rgt`,`parent_id`);

--
-- Indexes for table `category_filterable_attributes`
--
ALTER TABLE `category_filterable_attributes`
  ADD KEY `category_filterable_attributes_category_id_foreign` (`category_id`),
  ADD KEY `category_filterable_attributes_attribute_id_foreign` (`attribute_id`);

--
-- Indexes for table `category_translations`
--
ALTER TABLE `category_translations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `category_translations_category_id_slug_locale_unique` (`category_id`,`slug`,`locale`),
  ADD KEY `category_translations_locale_id_foreign` (`locale_id`);

--
-- Indexes for table `channels`
--
ALTER TABLE `channels`
  ADD PRIMARY KEY (`id`),
  ADD KEY `channels_default_locale_id_foreign` (`default_locale_id`),
  ADD KEY `channels_base_currency_id_foreign` (`base_currency_id`),
  ADD KEY `channels_root_category_id_foreign` (`root_category_id`);

--
-- Indexes for table `channel_currencies`
--
ALTER TABLE `channel_currencies`
  ADD PRIMARY KEY (`channel_id`,`currency_id`),
  ADD KEY `channel_currencies_currency_id_foreign` (`currency_id`);

--
-- Indexes for table `channel_inventory_sources`
--
ALTER TABLE `channel_inventory_sources`
  ADD UNIQUE KEY `channel_inventory_sources_channel_id_inventory_source_id_unique` (`channel_id`,`inventory_source_id`),
  ADD KEY `channel_inventory_sources_inventory_source_id_foreign` (`inventory_source_id`);

--
-- Indexes for table `channel_locales`
--
ALTER TABLE `channel_locales`
  ADD PRIMARY KEY (`channel_id`,`locale_id`),
  ADD KEY `channel_locales_locale_id_foreign` (`locale_id`);

--
-- Indexes for table `channel_translations`
--
ALTER TABLE `channel_translations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `channel_translations_channel_id_locale_unique` (`channel_id`,`locale`),
  ADD KEY `channel_translations_locale_index` (`locale`);

--
-- Indexes for table `cms_pages`
--
ALTER TABLE `cms_pages`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cms_page_channels`
--
ALTER TABLE `cms_page_channels`
  ADD UNIQUE KEY `cms_page_channels_cms_page_id_channel_id_unique` (`cms_page_id`,`channel_id`),
  ADD KEY `cms_page_channels_channel_id_foreign` (`channel_id`);

--
-- Indexes for table `cms_page_translations`
--
ALTER TABLE `cms_page_translations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `cms_page_translations_cms_page_id_url_key_locale_unique` (`cms_page_id`,`url_key`,`locale`);

--
-- Indexes for table `core_config`
--
ALTER TABLE `core_config`
  ADD PRIMARY KEY (`id`),
  ADD KEY `core_config_channel_id_foreign` (`channel_code`);

--
-- Indexes for table `countries`
--
ALTER TABLE `countries`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `country_states`
--
ALTER TABLE `country_states`
  ADD PRIMARY KEY (`id`),
  ADD KEY `country_states_country_id_foreign` (`country_id`);

--
-- Indexes for table `country_state_translations`
--
ALTER TABLE `country_state_translations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `country_state_translations_country_state_id_foreign` (`country_state_id`);

--
-- Indexes for table `country_translations`
--
ALTER TABLE `country_translations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `country_translations_country_id_foreign` (`country_id`);

--
-- Indexes for table `currencies`
--
ALTER TABLE `currencies`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `currency_exchange_rates`
--
ALTER TABLE `currency_exchange_rates`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `currency_exchange_rates_target_currency_unique` (`target_currency`);

--
-- Indexes for table `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `customers_email_unique` (`email`),
  ADD UNIQUE KEY `customers_api_token_unique` (`api_token`),
  ADD KEY `customers_customer_group_id_foreign` (`customer_group_id`);

--
-- Indexes for table `customer_groups`
--
ALTER TABLE `customer_groups`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `customer_groups_code_unique` (`code`);

--
-- Indexes for table `customer_password_resets`
--
ALTER TABLE `customer_password_resets`
  ADD KEY `customer_password_resets_email_index` (`email`);

--
-- Indexes for table `customer_social_accounts`
--
ALTER TABLE `customer_social_accounts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `customer_social_accounts_provider_id_unique` (`provider_id`),
  ADD KEY `customer_social_accounts_customer_id_foreign` (`customer_id`);

--
-- Indexes for table `downloadable_link_purchased`
--
ALTER TABLE `downloadable_link_purchased`
  ADD PRIMARY KEY (`id`),
  ADD KEY `downloadable_link_purchased_customer_id_foreign` (`customer_id`),
  ADD KEY `downloadable_link_purchased_order_id_foreign` (`order_id`),
  ADD KEY `downloadable_link_purchased_order_item_id_foreign` (`order_item_id`);

--
-- Indexes for table `inventory_sources`
--
ALTER TABLE `inventory_sources`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `inventory_sources_code_unique` (`code`);

--
-- Indexes for table `invoices`
--
ALTER TABLE `invoices`
  ADD PRIMARY KEY (`id`),
  ADD KEY `invoices_order_id_foreign` (`order_id`),
  ADD KEY `invoices_order_address_id_foreign` (`order_address_id`);

--
-- Indexes for table `invoice_items`
--
ALTER TABLE `invoice_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `invoice_items_invoice_id_foreign` (`invoice_id`),
  ADD KEY `invoice_items_parent_id_foreign` (`parent_id`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indexes for table `locales`
--
ALTER TABLE `locales`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `locales_code_unique` (`code`);

--
-- Indexes for table `marketing_campaigns`
--
ALTER TABLE `marketing_campaigns`
  ADD PRIMARY KEY (`id`),
  ADD KEY `marketing_campaigns_channel_id_foreign` (`channel_id`),
  ADD KEY `marketing_campaigns_customer_group_id_foreign` (`customer_group_id`),
  ADD KEY `marketing_campaigns_marketing_template_id_foreign` (`marketing_template_id`),
  ADD KEY `marketing_campaigns_marketing_event_id_foreign` (`marketing_event_id`);

--
-- Indexes for table `marketing_events`
--
ALTER TABLE `marketing_events`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `marketing_templates`
--
ALTER TABLE `marketing_templates`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `orders_increment_id_unique` (`increment_id`),
  ADD KEY `orders_customer_id_foreign` (`customer_id`),
  ADD KEY `orders_channel_id_foreign` (`channel_id`);

--
-- Indexes for table `order_brands`
--
ALTER TABLE `order_brands`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_brands_order_id_foreign` (`order_id`),
  ADD KEY `order_brands_order_item_id_foreign` (`order_item_id`),
  ADD KEY `order_brands_product_id_foreign` (`product_id`),
  ADD KEY `order_brands_brand_foreign` (`brand`);

--
-- Indexes for table `order_comments`
--
ALTER TABLE `order_comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_comments_order_id_foreign` (`order_id`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_items_order_id_foreign` (`order_id`),
  ADD KEY `order_items_parent_id_foreign` (`parent_id`);

--
-- Indexes for table `order_payment`
--
ALTER TABLE `order_payment`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_payment_order_id_foreign` (`order_id`);

--
-- Indexes for table `password_resets`
--
ALTER TABLE `password_resets`
  ADD KEY `password_resets_email_index` (`email`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `products_sku_unique` (`sku`),
  ADD KEY `products_attribute_family_id_foreign` (`attribute_family_id`),
  ADD KEY `products_parent_id_foreign` (`parent_id`);

--
-- Indexes for table `product_attribute_values`
--
ALTER TABLE `product_attribute_values`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `chanel_locale_attribute_value_index_unique` (`channel`,`locale`,`attribute_id`,`product_id`),
  ADD KEY `product_attribute_values_product_id_foreign` (`product_id`),
  ADD KEY `product_attribute_values_attribute_id_foreign` (`attribute_id`);

--
-- Indexes for table `product_bundle_options`
--
ALTER TABLE `product_bundle_options`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_bundle_options_product_id_foreign` (`product_id`);

--
-- Indexes for table `product_bundle_option_products`
--
ALTER TABLE `product_bundle_option_products`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_bundle_option_products_product_bundle_option_id_foreign` (`product_bundle_option_id`),
  ADD KEY `product_bundle_option_products_product_id_foreign` (`product_id`);

--
-- Indexes for table `product_bundle_option_translations`
--
ALTER TABLE `product_bundle_option_translations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `product_bundle_option_translations_option_id_locale_unique` (`product_bundle_option_id`,`locale`);

--
-- Indexes for table `product_categories`
--
ALTER TABLE `product_categories`
  ADD KEY `product_categories_product_id_foreign` (`product_id`),
  ADD KEY `product_categories_category_id_foreign` (`category_id`);

--
-- Indexes for table `product_cross_sells`
--
ALTER TABLE `product_cross_sells`
  ADD KEY `product_cross_sells_parent_id_foreign` (`parent_id`),
  ADD KEY `product_cross_sells_child_id_foreign` (`child_id`);

--
-- Indexes for table `product_customer_group_prices`
--
ALTER TABLE `product_customer_group_prices`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_customer_group_prices_product_id_foreign` (`product_id`),
  ADD KEY `product_customer_group_prices_customer_group_id_foreign` (`customer_group_id`);

--
-- Indexes for table `product_downloadable_links`
--
ALTER TABLE `product_downloadable_links`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_downloadable_links_product_id_foreign` (`product_id`);

--
-- Indexes for table `product_downloadable_link_translations`
--
ALTER TABLE `product_downloadable_link_translations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `link_translations_link_id_foreign` (`product_downloadable_link_id`);

--
-- Indexes for table `product_downloadable_samples`
--
ALTER TABLE `product_downloadable_samples`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_downloadable_samples_product_id_foreign` (`product_id`);

--
-- Indexes for table `product_downloadable_sample_translations`
--
ALTER TABLE `product_downloadable_sample_translations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sample_translations_sample_id_foreign` (`product_downloadable_sample_id`);

--
-- Indexes for table `product_flat`
--
ALTER TABLE `product_flat`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `product_flat_unique_index` (`product_id`,`channel`,`locale`),
  ADD KEY `product_flat_parent_id_foreign` (`parent_id`);

--
-- Indexes for table `product_grouped_products`
--
ALTER TABLE `product_grouped_products`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_grouped_products_product_id_foreign` (`product_id`),
  ADD KEY `product_grouped_products_associated_product_id_foreign` (`associated_product_id`);

--
-- Indexes for table `product_images`
--
ALTER TABLE `product_images`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_images_product_id_foreign` (`product_id`);

--
-- Indexes for table `product_inventories`
--
ALTER TABLE `product_inventories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `product_source_vendor_index_unique` (`product_id`,`inventory_source_id`,`vendor_id`),
  ADD KEY `product_inventories_inventory_source_id_foreign` (`inventory_source_id`);

--
-- Indexes for table `product_ordered_inventories`
--
ALTER TABLE `product_ordered_inventories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `product_ordered_inventories_product_id_channel_id_unique` (`product_id`,`channel_id`),
  ADD KEY `product_ordered_inventories_channel_id_foreign` (`channel_id`);

--
-- Indexes for table `product_relations`
--
ALTER TABLE `product_relations`
  ADD KEY `product_relations_parent_id_foreign` (`parent_id`),
  ADD KEY `product_relations_child_id_foreign` (`child_id`);

--
-- Indexes for table `product_reviews`
--
ALTER TABLE `product_reviews`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_reviews_product_id_foreign` (`product_id`),
  ADD KEY `product_reviews_customer_id_foreign` (`customer_id`);

--
-- Indexes for table `product_super_attributes`
--
ALTER TABLE `product_super_attributes`
  ADD KEY `product_super_attributes_product_id_foreign` (`product_id`),
  ADD KEY `product_super_attributes_attribute_id_foreign` (`attribute_id`);

--
-- Indexes for table `product_up_sells`
--
ALTER TABLE `product_up_sells`
  ADD KEY `product_up_sells_parent_id_foreign` (`parent_id`),
  ADD KEY `product_up_sells_child_id_foreign` (`child_id`);

--
-- Indexes for table `product_videos`
--
ALTER TABLE `product_videos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_videos_product_id_foreign` (`product_id`);

--
-- Indexes for table `refunds`
--
ALTER TABLE `refunds`
  ADD PRIMARY KEY (`id`),
  ADD KEY `refunds_order_id_foreign` (`order_id`);

--
-- Indexes for table `refund_items`
--
ALTER TABLE `refund_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `refund_items_order_item_id_foreign` (`order_item_id`),
  ADD KEY `refund_items_refund_id_foreign` (`refund_id`),
  ADD KEY `refund_items_parent_id_foreign` (`parent_id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `shipments`
--
ALTER TABLE `shipments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `shipments_order_id_foreign` (`order_id`),
  ADD KEY `shipments_inventory_source_id_foreign` (`inventory_source_id`),
  ADD KEY `shipments_order_address_id_foreign` (`order_address_id`);

--
-- Indexes for table `shipment_items`
--
ALTER TABLE `shipment_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `shipment_items_shipment_id_foreign` (`shipment_id`);

--
-- Indexes for table `sliders`
--
ALTER TABLE `sliders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sliders_channel_id_foreign` (`channel_id`);

--
-- Indexes for table `subscribers_list`
--
ALTER TABLE `subscribers_list`
  ADD PRIMARY KEY (`id`),
  ADD KEY `subscribers_list_channel_id_foreign` (`channel_id`),
  ADD KEY `subscribers_list_customer_id_foreign` (`customer_id`);

--
-- Indexes for table `tax_categories`
--
ALTER TABLE `tax_categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `tax_categories_code_unique` (`code`);

--
-- Indexes for table `tax_categories_tax_rates`
--
ALTER TABLE `tax_categories_tax_rates`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `tax_map_index_unique` (`tax_category_id`,`tax_rate_id`),
  ADD KEY `tax_categories_tax_rates_tax_rate_id_foreign` (`tax_rate_id`);

--
-- Indexes for table `tax_rates`
--
ALTER TABLE `tax_rates`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `tax_rates_identifier_unique` (`identifier`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- Indexes for table `velocity_contents`
--
ALTER TABLE `velocity_contents`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `velocity_contents_translations`
--
ALTER TABLE `velocity_contents_translations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `velocity_contents_translations_content_id_foreign` (`content_id`);

--
-- Indexes for table `velocity_customer_compare_products`
--
ALTER TABLE `velocity_customer_compare_products`
  ADD PRIMARY KEY (`id`),
  ADD KEY `velocity_customer_compare_products_product_flat_id_foreign` (`product_flat_id`),
  ADD KEY `velocity_customer_compare_products_customer_id_foreign` (`customer_id`);

--
-- Indexes for table `velocity_meta_data`
--
ALTER TABLE `velocity_meta_data`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `wishlist`
--
ALTER TABLE `wishlist`
  ADD PRIMARY KEY (`id`),
  ADD KEY `wishlist_channel_id_foreign` (`channel_id`),
  ADD KEY `wishlist_product_id_foreign` (`product_id`),
  ADD KEY `wishlist_customer_id_foreign` (`customer_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `addresses`
--
ALTER TABLE `addresses`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `admins`
--
ALTER TABLE `admins`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `attributes`
--
ALTER TABLE `attributes`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `attribute_families`
--
ALTER TABLE `attribute_families`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `attribute_groups`
--
ALTER TABLE `attribute_groups`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `attribute_options`
--
ALTER TABLE `attribute_options`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `attribute_option_translations`
--
ALTER TABLE `attribute_option_translations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `attribute_translations`
--
ALTER TABLE `attribute_translations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `bookings`
--
ALTER TABLE `bookings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `booking_products`
--
ALTER TABLE `booking_products`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `booking_product_appointment_slots`
--
ALTER TABLE `booking_product_appointment_slots`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `booking_product_default_slots`
--
ALTER TABLE `booking_product_default_slots`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `booking_product_event_tickets`
--
ALTER TABLE `booking_product_event_tickets`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `booking_product_event_ticket_translations`
--
ALTER TABLE `booking_product_event_ticket_translations`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `booking_product_rental_slots`
--
ALTER TABLE `booking_product_rental_slots`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `booking_product_table_slots`
--
ALTER TABLE `booking_product_table_slots`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cart`
--
ALTER TABLE `cart`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `cart_items`
--
ALTER TABLE `cart_items`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `cart_item_inventories`
--
ALTER TABLE `cart_item_inventories`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cart_payment`
--
ALTER TABLE `cart_payment`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cart_rules`
--
ALTER TABLE `cart_rules`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cart_rule_coupons`
--
ALTER TABLE `cart_rule_coupons`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cart_rule_coupon_usage`
--
ALTER TABLE `cart_rule_coupon_usage`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cart_rule_customers`
--
ALTER TABLE `cart_rule_customers`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cart_rule_translations`
--
ALTER TABLE `cart_rule_translations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cart_shipping_rates`
--
ALTER TABLE `cart_shipping_rates`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `catalog_rules`
--
ALTER TABLE `catalog_rules`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `catalog_rule_products`
--
ALTER TABLE `catalog_rule_products`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `catalog_rule_product_prices`
--
ALTER TABLE `catalog_rule_product_prices`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `category_translations`
--
ALTER TABLE `category_translations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `channels`
--
ALTER TABLE `channels`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `channel_translations`
--
ALTER TABLE `channel_translations`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `cms_pages`
--
ALTER TABLE `cms_pages`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `cms_page_translations`
--
ALTER TABLE `cms_page_translations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `core_config`
--
ALTER TABLE `core_config`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=104;

--
-- AUTO_INCREMENT for table `countries`
--
ALTER TABLE `countries`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=256;

--
-- AUTO_INCREMENT for table `country_states`
--
ALTER TABLE `country_states`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=569;

--
-- AUTO_INCREMENT for table `country_state_translations`
--
ALTER TABLE `country_state_translations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3409;

--
-- AUTO_INCREMENT for table `country_translations`
--
ALTER TABLE `country_translations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1531;

--
-- AUTO_INCREMENT for table `currencies`
--
ALTER TABLE `currencies`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `currency_exchange_rates`
--
ALTER TABLE `currency_exchange_rates`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `customers`
--
ALTER TABLE `customers`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `customer_groups`
--
ALTER TABLE `customer_groups`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `customer_social_accounts`
--
ALTER TABLE `customer_social_accounts`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `downloadable_link_purchased`
--
ALTER TABLE `downloadable_link_purchased`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `inventory_sources`
--
ALTER TABLE `inventory_sources`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `invoices`
--
ALTER TABLE `invoices`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `invoice_items`
--
ALTER TABLE `invoice_items`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `locales`
--
ALTER TABLE `locales`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `marketing_campaigns`
--
ALTER TABLE `marketing_campaigns`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `marketing_events`
--
ALTER TABLE `marketing_events`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `marketing_templates`
--
ALTER TABLE `marketing_templates`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=198;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `order_brands`
--
ALTER TABLE `order_brands`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `order_comments`
--
ALTER TABLE `order_comments`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `order_payment`
--
ALTER TABLE `order_payment`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `product_attribute_values`
--
ALTER TABLE `product_attribute_values`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49;

--
-- AUTO_INCREMENT for table `product_bundle_options`
--
ALTER TABLE `product_bundle_options`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `product_bundle_option_products`
--
ALTER TABLE `product_bundle_option_products`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `product_bundle_option_translations`
--
ALTER TABLE `product_bundle_option_translations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `product_customer_group_prices`
--
ALTER TABLE `product_customer_group_prices`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `product_downloadable_links`
--
ALTER TABLE `product_downloadable_links`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `product_downloadable_link_translations`
--
ALTER TABLE `product_downloadable_link_translations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `product_downloadable_samples`
--
ALTER TABLE `product_downloadable_samples`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `product_downloadable_sample_translations`
--
ALTER TABLE `product_downloadable_sample_translations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `product_flat`
--
ALTER TABLE `product_flat`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `product_grouped_products`
--
ALTER TABLE `product_grouped_products`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `product_images`
--
ALTER TABLE `product_images`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `product_inventories`
--
ALTER TABLE `product_inventories`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `product_ordered_inventories`
--
ALTER TABLE `product_ordered_inventories`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `product_reviews`
--
ALTER TABLE `product_reviews`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `product_videos`
--
ALTER TABLE `product_videos`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `refunds`
--
ALTER TABLE `refunds`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `refund_items`
--
ALTER TABLE `refund_items`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `shipments`
--
ALTER TABLE `shipments`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `shipment_items`
--
ALTER TABLE `shipment_items`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `sliders`
--
ALTER TABLE `sliders`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `subscribers_list`
--
ALTER TABLE `subscribers_list`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tax_categories`
--
ALTER TABLE `tax_categories`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tax_categories_tax_rates`
--
ALTER TABLE `tax_categories_tax_rates`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tax_rates`
--
ALTER TABLE `tax_rates`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `velocity_contents`
--
ALTER TABLE `velocity_contents`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `velocity_contents_translations`
--
ALTER TABLE `velocity_contents_translations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `velocity_customer_compare_products`
--
ALTER TABLE `velocity_customer_compare_products`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `velocity_meta_data`
--
ALTER TABLE `velocity_meta_data`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `wishlist`
--
ALTER TABLE `wishlist`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `addresses`
--
ALTER TABLE `addresses`
  ADD CONSTRAINT `addresses_cart_id_foreign` FOREIGN KEY (`cart_id`) REFERENCES `cart` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `addresses_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `addresses_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `attribute_groups`
--
ALTER TABLE `attribute_groups`
  ADD CONSTRAINT `attribute_groups_attribute_family_id_foreign` FOREIGN KEY (`attribute_family_id`) REFERENCES `attribute_families` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `attribute_group_mappings`
--
ALTER TABLE `attribute_group_mappings`
  ADD CONSTRAINT `attribute_group_mappings_attribute_group_id_foreign` FOREIGN KEY (`attribute_group_id`) REFERENCES `attribute_groups` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `attribute_group_mappings_attribute_id_foreign` FOREIGN KEY (`attribute_id`) REFERENCES `attributes` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `attribute_options`
--
ALTER TABLE `attribute_options`
  ADD CONSTRAINT `attribute_options_attribute_id_foreign` FOREIGN KEY (`attribute_id`) REFERENCES `attributes` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `attribute_option_translations`
--
ALTER TABLE `attribute_option_translations`
  ADD CONSTRAINT `attribute_option_translations_attribute_option_id_foreign` FOREIGN KEY (`attribute_option_id`) REFERENCES `attribute_options` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `attribute_translations`
--
ALTER TABLE `attribute_translations`
  ADD CONSTRAINT `attribute_translations_attribute_id_foreign` FOREIGN KEY (`attribute_id`) REFERENCES `attributes` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `bookings`
--
ALTER TABLE `bookings`
  ADD CONSTRAINT `bookings_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `bookings_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `booking_products`
--
ALTER TABLE `booking_products`
  ADD CONSTRAINT `booking_products_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `booking_product_appointment_slots`
--
ALTER TABLE `booking_product_appointment_slots`
  ADD CONSTRAINT `booking_product_appointment_slots_booking_product_id_foreign` FOREIGN KEY (`booking_product_id`) REFERENCES `booking_products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `booking_product_default_slots`
--
ALTER TABLE `booking_product_default_slots`
  ADD CONSTRAINT `booking_product_default_slots_booking_product_id_foreign` FOREIGN KEY (`booking_product_id`) REFERENCES `booking_products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `booking_product_event_tickets`
--
ALTER TABLE `booking_product_event_tickets`
  ADD CONSTRAINT `booking_product_event_tickets_booking_product_id_foreign` FOREIGN KEY (`booking_product_id`) REFERENCES `booking_products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `booking_product_event_ticket_translations`
--
ALTER TABLE `booking_product_event_ticket_translations`
  ADD CONSTRAINT `booking_product_event_ticket_translations_locale_foreign` FOREIGN KEY (`booking_product_event_ticket_id`) REFERENCES `booking_product_event_tickets` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `booking_product_rental_slots`
--
ALTER TABLE `booking_product_rental_slots`
  ADD CONSTRAINT `booking_product_rental_slots_booking_product_id_foreign` FOREIGN KEY (`booking_product_id`) REFERENCES `booking_products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `booking_product_table_slots`
--
ALTER TABLE `booking_product_table_slots`
  ADD CONSTRAINT `booking_product_table_slots_booking_product_id_foreign` FOREIGN KEY (`booking_product_id`) REFERENCES `booking_products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `cart`
--
ALTER TABLE `cart`
  ADD CONSTRAINT `cart_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `cart_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `cart_items`
--
ALTER TABLE `cart_items`
  ADD CONSTRAINT `cart_items_cart_id_foreign` FOREIGN KEY (`cart_id`) REFERENCES `cart` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `cart_items_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `cart_items` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `cart_items_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `cart_items_tax_category_id_foreign` FOREIGN KEY (`tax_category_id`) REFERENCES `tax_categories` (`id`);

--
-- Constraints for table `cart_payment`
--
ALTER TABLE `cart_payment`
  ADD CONSTRAINT `cart_payment_cart_id_foreign` FOREIGN KEY (`cart_id`) REFERENCES `cart` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `cart_rule_channels`
--
ALTER TABLE `cart_rule_channels`
  ADD CONSTRAINT `cart_rule_channels_cart_rule_id_foreign` FOREIGN KEY (`cart_rule_id`) REFERENCES `cart_rules` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `cart_rule_channels_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `cart_rule_coupons`
--
ALTER TABLE `cart_rule_coupons`
  ADD CONSTRAINT `cart_rule_coupons_cart_rule_id_foreign` FOREIGN KEY (`cart_rule_id`) REFERENCES `cart_rules` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `cart_rule_coupon_usage`
--
ALTER TABLE `cart_rule_coupon_usage`
  ADD CONSTRAINT `cart_rule_coupon_usage_cart_rule_coupon_id_foreign` FOREIGN KEY (`cart_rule_coupon_id`) REFERENCES `cart_rule_coupons` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `cart_rule_coupon_usage_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `cart_rule_customers`
--
ALTER TABLE `cart_rule_customers`
  ADD CONSTRAINT `cart_rule_customers_cart_rule_id_foreign` FOREIGN KEY (`cart_rule_id`) REFERENCES `cart_rules` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `cart_rule_customers_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `cart_rule_customer_groups`
--
ALTER TABLE `cart_rule_customer_groups`
  ADD CONSTRAINT `cart_rule_customer_groups_cart_rule_id_foreign` FOREIGN KEY (`cart_rule_id`) REFERENCES `cart_rules` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `cart_rule_customer_groups_customer_group_id_foreign` FOREIGN KEY (`customer_group_id`) REFERENCES `customer_groups` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `cart_rule_translations`
--
ALTER TABLE `cart_rule_translations`
  ADD CONSTRAINT `cart_rule_translations_cart_rule_id_foreign` FOREIGN KEY (`cart_rule_id`) REFERENCES `cart_rules` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `cart_shipping_rates`
--
ALTER TABLE `cart_shipping_rates`
  ADD CONSTRAINT `cart_shipping_rates_cart_address_id_foreign` FOREIGN KEY (`cart_address_id`) REFERENCES `addresses` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `catalog_rule_channels`
--
ALTER TABLE `catalog_rule_channels`
  ADD CONSTRAINT `catalog_rule_channels_catalog_rule_id_foreign` FOREIGN KEY (`catalog_rule_id`) REFERENCES `catalog_rules` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `catalog_rule_channels_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `catalog_rule_customer_groups`
--
ALTER TABLE `catalog_rule_customer_groups`
  ADD CONSTRAINT `catalog_rule_customer_groups_catalog_rule_id_foreign` FOREIGN KEY (`catalog_rule_id`) REFERENCES `catalog_rules` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `catalog_rule_customer_groups_customer_group_id_foreign` FOREIGN KEY (`customer_group_id`) REFERENCES `customer_groups` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `catalog_rule_products`
--
ALTER TABLE `catalog_rule_products`
  ADD CONSTRAINT `catalog_rule_products_catalog_rule_id_foreign` FOREIGN KEY (`catalog_rule_id`) REFERENCES `catalog_rules` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `catalog_rule_products_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `catalog_rule_products_customer_group_id_foreign` FOREIGN KEY (`customer_group_id`) REFERENCES `customer_groups` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `catalog_rule_products_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `catalog_rule_product_prices`
--
ALTER TABLE `catalog_rule_product_prices`
  ADD CONSTRAINT `catalog_rule_product_prices_catalog_rule_id_foreign` FOREIGN KEY (`catalog_rule_id`) REFERENCES `catalog_rules` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `catalog_rule_product_prices_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `catalog_rule_product_prices_customer_group_id_foreign` FOREIGN KEY (`customer_group_id`) REFERENCES `customer_groups` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `catalog_rule_product_prices_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `category_filterable_attributes`
--
ALTER TABLE `category_filterable_attributes`
  ADD CONSTRAINT `category_filterable_attributes_attribute_id_foreign` FOREIGN KEY (`attribute_id`) REFERENCES `attributes` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `category_filterable_attributes_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `category_translations`
--
ALTER TABLE `category_translations`
  ADD CONSTRAINT `category_translations_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `category_translations_locale_id_foreign` FOREIGN KEY (`locale_id`) REFERENCES `locales` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `channels`
--
ALTER TABLE `channels`
  ADD CONSTRAINT `channels_base_currency_id_foreign` FOREIGN KEY (`base_currency_id`) REFERENCES `currencies` (`id`),
  ADD CONSTRAINT `channels_default_locale_id_foreign` FOREIGN KEY (`default_locale_id`) REFERENCES `locales` (`id`),
  ADD CONSTRAINT `channels_root_category_id_foreign` FOREIGN KEY (`root_category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `channel_currencies`
--
ALTER TABLE `channel_currencies`
  ADD CONSTRAINT `channel_currencies_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `channel_currencies_currency_id_foreign` FOREIGN KEY (`currency_id`) REFERENCES `currencies` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `channel_inventory_sources`
--
ALTER TABLE `channel_inventory_sources`
  ADD CONSTRAINT `channel_inventory_sources_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `channel_inventory_sources_inventory_source_id_foreign` FOREIGN KEY (`inventory_source_id`) REFERENCES `inventory_sources` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `channel_locales`
--
ALTER TABLE `channel_locales`
  ADD CONSTRAINT `channel_locales_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `channel_locales_locale_id_foreign` FOREIGN KEY (`locale_id`) REFERENCES `locales` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `channel_translations`
--
ALTER TABLE `channel_translations`
  ADD CONSTRAINT `channel_translations_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `cms_page_channels`
--
ALTER TABLE `cms_page_channels`
  ADD CONSTRAINT `cms_page_channels_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `cms_page_channels_cms_page_id_foreign` FOREIGN KEY (`cms_page_id`) REFERENCES `cms_pages` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `cms_page_translations`
--
ALTER TABLE `cms_page_translations`
  ADD CONSTRAINT `cms_page_translations_cms_page_id_foreign` FOREIGN KEY (`cms_page_id`) REFERENCES `cms_pages` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `country_states`
--
ALTER TABLE `country_states`
  ADD CONSTRAINT `country_states_country_id_foreign` FOREIGN KEY (`country_id`) REFERENCES `countries` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `country_state_translations`
--
ALTER TABLE `country_state_translations`
  ADD CONSTRAINT `country_state_translations_country_state_id_foreign` FOREIGN KEY (`country_state_id`) REFERENCES `country_states` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `country_translations`
--
ALTER TABLE `country_translations`
  ADD CONSTRAINT `country_translations_country_id_foreign` FOREIGN KEY (`country_id`) REFERENCES `countries` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `currency_exchange_rates`
--
ALTER TABLE `currency_exchange_rates`
  ADD CONSTRAINT `currency_exchange_rates_target_currency_foreign` FOREIGN KEY (`target_currency`) REFERENCES `currencies` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `customers`
--
ALTER TABLE `customers`
  ADD CONSTRAINT `customers_customer_group_id_foreign` FOREIGN KEY (`customer_group_id`) REFERENCES `customer_groups` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `customer_social_accounts`
--
ALTER TABLE `customer_social_accounts`
  ADD CONSTRAINT `customer_social_accounts_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `downloadable_link_purchased`
--
ALTER TABLE `downloadable_link_purchased`
  ADD CONSTRAINT `downloadable_link_purchased_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `downloadable_link_purchased_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `downloadable_link_purchased_order_item_id_foreign` FOREIGN KEY (`order_item_id`) REFERENCES `order_items` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `invoices`
--
ALTER TABLE `invoices`
  ADD CONSTRAINT `invoices_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `invoice_items`
--
ALTER TABLE `invoice_items`
  ADD CONSTRAINT `invoice_items_invoice_id_foreign` FOREIGN KEY (`invoice_id`) REFERENCES `invoices` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `invoice_items_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `invoice_items` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `marketing_campaigns`
--
ALTER TABLE `marketing_campaigns`
  ADD CONSTRAINT `marketing_campaigns_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `marketing_campaigns_customer_group_id_foreign` FOREIGN KEY (`customer_group_id`) REFERENCES `customer_groups` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `marketing_campaigns_marketing_event_id_foreign` FOREIGN KEY (`marketing_event_id`) REFERENCES `marketing_events` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `marketing_campaigns_marketing_template_id_foreign` FOREIGN KEY (`marketing_template_id`) REFERENCES `marketing_templates` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `orders_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `order_brands`
--
ALTER TABLE `order_brands`
  ADD CONSTRAINT `order_brands_brand_foreign` FOREIGN KEY (`brand`) REFERENCES `attribute_options` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `order_brands_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `order_brands_order_item_id_foreign` FOREIGN KEY (`order_item_id`) REFERENCES `order_items` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `order_brands_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `order_comments`
--
ALTER TABLE `order_comments`
  ADD CONSTRAINT `order_comments_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `order_items_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `order_items` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `order_payment`
--
ALTER TABLE `order_payment`
  ADD CONSTRAINT `order_payment_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_attribute_family_id_foreign` FOREIGN KEY (`attribute_family_id`) REFERENCES `attribute_families` (`id`),
  ADD CONSTRAINT `products_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `product_attribute_values`
--
ALTER TABLE `product_attribute_values`
  ADD CONSTRAINT `product_attribute_values_attribute_id_foreign` FOREIGN KEY (`attribute_id`) REFERENCES `attributes` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `product_attribute_values_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `product_bundle_options`
--
ALTER TABLE `product_bundle_options`
  ADD CONSTRAINT `product_bundle_options_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `product_bundle_option_products`
--
ALTER TABLE `product_bundle_option_products`
  ADD CONSTRAINT `product_bundle_option_products_product_bundle_option_id_foreign` FOREIGN KEY (`product_bundle_option_id`) REFERENCES `product_bundle_options` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `product_bundle_option_products_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `product_bundle_option_translations`
--
ALTER TABLE `product_bundle_option_translations`
  ADD CONSTRAINT `product_bundle_option_translations_option_id_foreign` FOREIGN KEY (`product_bundle_option_id`) REFERENCES `product_bundle_options` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `product_categories`
--
ALTER TABLE `product_categories`
  ADD CONSTRAINT `product_categories_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `product_categories_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `product_cross_sells`
--
ALTER TABLE `product_cross_sells`
  ADD CONSTRAINT `product_cross_sells_child_id_foreign` FOREIGN KEY (`child_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `product_cross_sells_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `product_customer_group_prices`
--
ALTER TABLE `product_customer_group_prices`
  ADD CONSTRAINT `product_customer_group_prices_customer_group_id_foreign` FOREIGN KEY (`customer_group_id`) REFERENCES `customer_groups` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `product_customer_group_prices_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `product_downloadable_links`
--
ALTER TABLE `product_downloadable_links`
  ADD CONSTRAINT `product_downloadable_links_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `product_downloadable_link_translations`
--
ALTER TABLE `product_downloadable_link_translations`
  ADD CONSTRAINT `link_translations_link_id_foreign` FOREIGN KEY (`product_downloadable_link_id`) REFERENCES `product_downloadable_links` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `product_downloadable_samples`
--
ALTER TABLE `product_downloadable_samples`
  ADD CONSTRAINT `product_downloadable_samples_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `product_downloadable_sample_translations`
--
ALTER TABLE `product_downloadable_sample_translations`
  ADD CONSTRAINT `sample_translations_sample_id_foreign` FOREIGN KEY (`product_downloadable_sample_id`) REFERENCES `product_downloadable_samples` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `product_flat`
--
ALTER TABLE `product_flat`
  ADD CONSTRAINT `product_flat_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `product_flat` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `product_flat_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `product_grouped_products`
--
ALTER TABLE `product_grouped_products`
  ADD CONSTRAINT `product_grouped_products_associated_product_id_foreign` FOREIGN KEY (`associated_product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `product_grouped_products_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `product_images`
--
ALTER TABLE `product_images`
  ADD CONSTRAINT `product_images_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `product_inventories`
--
ALTER TABLE `product_inventories`
  ADD CONSTRAINT `product_inventories_inventory_source_id_foreign` FOREIGN KEY (`inventory_source_id`) REFERENCES `inventory_sources` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `product_inventories_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `product_ordered_inventories`
--
ALTER TABLE `product_ordered_inventories`
  ADD CONSTRAINT `product_ordered_inventories_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `product_ordered_inventories_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `product_relations`
--
ALTER TABLE `product_relations`
  ADD CONSTRAINT `product_relations_child_id_foreign` FOREIGN KEY (`child_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `product_relations_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `product_reviews`
--
ALTER TABLE `product_reviews`
  ADD CONSTRAINT `product_reviews_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `product_super_attributes`
--
ALTER TABLE `product_super_attributes`
  ADD CONSTRAINT `product_super_attributes_attribute_id_foreign` FOREIGN KEY (`attribute_id`) REFERENCES `attributes` (`id`),
  ADD CONSTRAINT `product_super_attributes_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `product_up_sells`
--
ALTER TABLE `product_up_sells`
  ADD CONSTRAINT `product_up_sells_child_id_foreign` FOREIGN KEY (`child_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `product_up_sells_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `product_videos`
--
ALTER TABLE `product_videos`
  ADD CONSTRAINT `product_videos_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `refunds`
--
ALTER TABLE `refunds`
  ADD CONSTRAINT `refunds_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `refund_items`
--
ALTER TABLE `refund_items`
  ADD CONSTRAINT `refund_items_order_item_id_foreign` FOREIGN KEY (`order_item_id`) REFERENCES `order_items` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `refund_items_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `refund_items` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `refund_items_refund_id_foreign` FOREIGN KEY (`refund_id`) REFERENCES `refunds` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `shipments`
--
ALTER TABLE `shipments`
  ADD CONSTRAINT `shipments_inventory_source_id_foreign` FOREIGN KEY (`inventory_source_id`) REFERENCES `inventory_sources` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `shipments_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `shipment_items`
--
ALTER TABLE `shipment_items`
  ADD CONSTRAINT `shipment_items_shipment_id_foreign` FOREIGN KEY (`shipment_id`) REFERENCES `shipments` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `sliders`
--
ALTER TABLE `sliders`
  ADD CONSTRAINT `sliders_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `subscribers_list`
--
ALTER TABLE `subscribers_list`
  ADD CONSTRAINT `subscribers_list_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `subscribers_list_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `tax_categories_tax_rates`
--
ALTER TABLE `tax_categories_tax_rates`
  ADD CONSTRAINT `tax_categories_tax_rates_tax_category_id_foreign` FOREIGN KEY (`tax_category_id`) REFERENCES `tax_categories` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `tax_categories_tax_rates_tax_rate_id_foreign` FOREIGN KEY (`tax_rate_id`) REFERENCES `tax_rates` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `velocity_contents_translations`
--
ALTER TABLE `velocity_contents_translations`
  ADD CONSTRAINT `velocity_contents_translations_content_id_foreign` FOREIGN KEY (`content_id`) REFERENCES `velocity_contents` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `velocity_customer_compare_products`
--
ALTER TABLE `velocity_customer_compare_products`
  ADD CONSTRAINT `velocity_customer_compare_products_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `velocity_customer_compare_products_product_flat_id_foreign` FOREIGN KEY (`product_flat_id`) REFERENCES `product_flat` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `wishlist`
--
ALTER TABLE `wishlist`
  ADD CONSTRAINT `wishlist_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `wishlist_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `wishlist_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
