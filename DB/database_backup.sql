/*
 Navicat Premium Data Transfer

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 50719
 Source Host           : localhost:3306
 Source Schema         : menakaproducts

 Target Server Type    : MySQL
 Target Server Version : 50719
 File Encoding         : 65001

 Date: 26/11/2018 12:22:01
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for cart
-- ----------------------------
DROP TABLE IF EXISTS `cart`;
CREATE TABLE `cart`  (
  `idcart` int(11) NOT NULL AUTO_INCREMENT,
  `user_iduser` int(11) NOT NULL,
  PRIMARY KEY (`idcart`) USING BTREE,
  INDEX `fk_cart_user1_idx`(`user_iduser`) USING BTREE,
  CONSTRAINT `fk_cart_user1` FOREIGN KEY (`user_iduser`) REFERENCES `user` (`iduser`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cart
-- ----------------------------
INSERT INTO `cart` VALUES (13, 38);
INSERT INTO `cart` VALUES (4, 39);
INSERT INTO `cart` VALUES (5, 40);
INSERT INTO `cart` VALUES (6, 41);
INSERT INTO `cart` VALUES (7, 42);
INSERT INTO `cart` VALUES (8, 44);
INSERT INTO `cart` VALUES (9, 47);
INSERT INTO `cart` VALUES (10, 48);
INSERT INTO `cart` VALUES (11, 49);
INSERT INTO `cart` VALUES (12, 50);
INSERT INTO `cart` VALUES (14, 51);

-- ----------------------------
-- Table structure for cart_has_item
-- ----------------------------
DROP TABLE IF EXISTS `cart_has_item`;
CREATE TABLE `cart_has_item`  (
  `id_cartItem` int(11) NOT NULL AUTO_INCREMENT,
  `cart_idcart` int(11) NOT NULL,
  `item_iditem` int(11) NOT NULL,
  `qty` double NULL DEFAULT NULL,
  `status` enum('pending','closed','paid') CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'pending',
  `date` date NULL DEFAULT NULL,
  PRIMARY KEY (`id_cartItem`) USING BTREE,
  INDEX `fk_cart_has_item_item1_idx`(`item_iditem`) USING BTREE,
  INDEX `fk_cart_has_item_cart1_idx`(`cart_idcart`) USING BTREE,
  CONSTRAINT `fk_cart_has_item_cart1` FOREIGN KEY (`cart_idcart`) REFERENCES `cart` (`idcart`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_cart_has_item_item1` FOREIGN KEY (`item_iditem`) REFERENCES `loose_stock` (`iditem`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 37 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cart_has_item
-- ----------------------------
INSERT INTO `cart_has_item` VALUES (15, 4, 2, 0.5, 'closed', '2018-07-06');
INSERT INTO `cart_has_item` VALUES (16, 4, 3, 0.25, 'closed', '2018-07-06');
INSERT INTO `cart_has_item` VALUES (17, 5, 3, 5, 'paid', '2018-11-19');
INSERT INTO `cart_has_item` VALUES (18, 5, 5, 5, 'paid', '2018-11-19');
INSERT INTO `cart_has_item` VALUES (19, 6, 5, 45, 'paid', '2018-11-24');
INSERT INTO `cart_has_item` VALUES (20, 6, 3, 70, 'paid', '2018-11-24');
INSERT INTO `cart_has_item` VALUES (21, 6, 3, 19.75, 'pending', '2018-11-24');
INSERT INTO `cart_has_item` VALUES (23, 8, 2, 1, 'pending', '2018-11-25');
INSERT INTO `cart_has_item` VALUES (24, 8, 12, 0.5, 'pending', '2018-11-24');
INSERT INTO `cart_has_item` VALUES (25, 8, 11, 1, 'pending', '2018-11-24');
INSERT INTO `cart_has_item` VALUES (26, 9, 2, 200, 'paid', '2018-11-24');
INSERT INTO `cart_has_item` VALUES (27, 11, 3, 5, 'paid', '2018-11-25');
INSERT INTO `cart_has_item` VALUES (28, 11, 13, 0.25, 'paid', '2018-11-25');
INSERT INTO `cart_has_item` VALUES (29, 5, 2, 0.5, 'paid', '2018-11-25');
INSERT INTO `cart_has_item` VALUES (30, 5, 14, 0.5, 'paid', '2018-11-25');
INSERT INTO `cart_has_item` VALUES (31, 13, 14, NULL, 'pending', '2018-11-25');
INSERT INTO `cart_has_item` VALUES (32, 13, 10, NULL, 'pending', '2018-11-25');
INSERT INTO `cart_has_item` VALUES (33, 13, 9, NULL, 'pending', '2018-11-25');
INSERT INTO `cart_has_item` VALUES (34, 12, 15, 5, 'pending', '2018-11-25');
INSERT INTO `cart_has_item` VALUES (36, 14, 7, 5, 'pending', '2018-11-26');

-- ----------------------------
-- Table structure for cart_has_packages
-- ----------------------------
DROP TABLE IF EXISTS `cart_has_packages`;
CREATE TABLE `cart_has_packages`  (
  `id` int(11) NOT NULL,
  `cart_idcart` int(11) NOT NULL,
  `packages_idpackages` int(11) NOT NULL,
  `qty` int(11) NULL DEFAULT NULL,
  `status` enum('pending','closed','paid') CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'pending',
  `date` date NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_cart_has_packages_packages1_idx`(`packages_idpackages`) USING BTREE,
  INDEX `fk_cart_has_packages_cart1_idx`(`cart_idcart`) USING BTREE,
  CONSTRAINT `fk_cart_has_packages_cart1` FOREIGN KEY (`cart_idcart`) REFERENCES `cart` (`idcart`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_cart_has_packages_packages1` FOREIGN KEY (`packages_idpackages`) REFERENCES `packages` (`idpackages`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cart_has_packages
-- ----------------------------
INSERT INTO `cart_has_packages` VALUES (1, 4, 1, 3, 'closed', '2018-07-06');
INSERT INTO `cart_has_packages` VALUES (2, 5, 1, 2, 'paid', '2018-10-29');
INSERT INTO `cart_has_packages` VALUES (3, 12, 2, 1, 'pending', '2018-11-25');
INSERT INTO `cart_has_packages` VALUES (4, 12, 1, 4, 'pending', '2018-11-25');

-- ----------------------------
-- Table structure for cart_has_packets
-- ----------------------------
DROP TABLE IF EXISTS `cart_has_packets`;
CREATE TABLE `cart_has_packets`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cart_idcart` int(11) NOT NULL,
  `packet_stock_id` int(11) NOT NULL,
  `qty` int(11) NULL DEFAULT NULL,
  `status` enum('pending','closed','paid') CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'pending',
  `date` date NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_cart_has_packet_stock_packet_stock1_idx`(`packet_stock_id`) USING BTREE,
  INDEX `fk_cart_has_packet_stock_cart1_idx`(`cart_idcart`) USING BTREE,
  CONSTRAINT `fk_cart_has_packet_stock_cart1` FOREIGN KEY (`cart_idcart`) REFERENCES `cart` (`idcart`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_cart_has_packet_stock_packet_stock1` FOREIGN KEY (`packet_stock_id`) REFERENCES `packet_stock` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cart_has_packets
-- ----------------------------
INSERT INTO `cart_has_packets` VALUES (4, 4, 4, 5, 'closed', '2018-07-06');
INSERT INTO `cart_has_packets` VALUES (5, 5, 2, 126, 'paid', '2018-10-29');
INSERT INTO `cart_has_packets` VALUES (6, 5, 3, 344, 'paid', '2018-11-19');
INSERT INTO `cart_has_packets` VALUES (7, 6, 2, 3, 'paid', '2018-11-24');
INSERT INTO `cart_has_packets` VALUES (8, 10, 4, 2, 'pending', '2018-11-25');
INSERT INTO `cart_has_packets` VALUES (9, 10, 3, 2, 'pending', '2018-11-25');
INSERT INTO `cart_has_packets` VALUES (10, 8, 2, 3, 'pending', '2018-11-25');
INSERT INTO `cart_has_packets` VALUES (11, 5, 1, 2, 'paid', '2018-11-25');

-- ----------------------------
-- Table structure for category
-- ----------------------------
DROP TABLE IF EXISTS `category`;
CREATE TABLE `category`  (
  `idcategory` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `status` enum('available','na') CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'available',
  PRIMARY KEY (`idcategory`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of category
-- ----------------------------
INSERT INTO `category` VALUES (1, 'monthly', 'available');
INSERT INTO `category` VALUES (2, 'weekly', 'available');

-- ----------------------------
-- Table structure for deliverydata
-- ----------------------------
DROP TABLE IF EXISTS `deliverydata`;
CREATE TABLE `deliverydata`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `deliveryType` enum('zip','km') CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `chargePerKm` double NULL DEFAULT NULL,
  `minKm` double NULL DEFAULT NULL,
  `deliveryPoint` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of deliverydata
-- ----------------------------
INSERT INTO `deliverydata` VALUES (1, 'km', 20, 45, '6.896926,79.860329');

-- ----------------------------
-- Table structure for discount_codes
-- ----------------------------
DROP TABLE IF EXISTS `discount_codes`;
CREATE TABLE `discount_codes`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `message` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `expDate` date NULL DEFAULT NULL,
  `code` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `value` double NULL DEFAULT NULL,
  `user_iduser` int(11) NOT NULL,
  `status` enum('available','na') CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'available',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_discount_user1_idx`(`user_iduser`) USING BTREE,
  CONSTRAINT `fk_discount_user1` FOREIGN KEY (`user_iduser`) REFERENCES `user` (`iduser`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of discount_codes
-- ----------------------------
INSERT INTO `discount_codes` VALUES (1, 'wow', '2018-11-27', '35ad47aa64532e5a817c0b0dc6981369', 300, 39, 'available');
INSERT INTO `discount_codes` VALUES (2, 'wow', '2018-11-27', '34b86fb0eec10fcb409e84711aca20e4', 300, 40, 'na');
INSERT INTO `discount_codes` VALUES (3, 'wow', '2018-11-27', '0c14d2e9b93658b968e5cd19e2328b5e', 300, 41, 'available');
INSERT INTO `discount_codes` VALUES (4, 'wow', '2018-11-27', 'e8c7c617652b37002259059121e41f54', 300, 42, 'available');
INSERT INTO `discount_codes` VALUES (5, 'wow', '2018-11-27', '788e2871d91db279715ef106058b6190', 300, 43, 'available');
INSERT INTO `discount_codes` VALUES (6, 'wow', '2018-11-27', '2a1c47dee6d10c457da561e6e3633b0a', 300, 44, 'available');
INSERT INTO `discount_codes` VALUES (7, 'wow', '2018-11-27', '34af9704f503da8d36fb3f663eec1ec2', 300, 45, 'available');
INSERT INTO `discount_codes` VALUES (8, 'wow', '2018-11-27', '75ce2fd1eab507ffc3aecb575844350e', 300, 46, 'available');
INSERT INTO `discount_codes` VALUES (9, 'wow', '2018-11-27', '79af27f57cfa260755985659d5c1799f', 300, 47, 'available');
INSERT INTO `discount_codes` VALUES (10, 'wow', '2018-11-27', '3260adde54e3e407091b94a00b2bb492', 300, 48, 'available');
INSERT INTO `discount_codes` VALUES (11, 'wow', '2018-11-27', '88872333f62678ad1e7a1446321d59c0', 300, 49, 'available');

-- ----------------------------
-- Table structure for interfaces
-- ----------------------------
DROP TABLE IF EXISTS `interfaces`;
CREATE TABLE `interfaces`  (
  `idinterface` int(11) NOT NULL AUTO_INCREMENT,
  `url` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `iterfaceName` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  PRIMARY KEY (`idinterface`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of interfaces
-- ----------------------------
INSERT INTO `interfaces` VALUES (1, NULL, 'index.jsp');
INSERT INTO `interfaces` VALUES (2, NULL, 'products.jsp');

-- ----------------------------
-- Table structure for invicephoto
-- ----------------------------
DROP TABLE IF EXISTS `invicephoto`;
CREATE TABLE `invicephoto`  (
  `idinvicePhoto` int(11) NOT NULL AUTO_INCREMENT,
  `imageUrl` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `invoice_idinvoice` int(11) NOT NULL,
  `user_iduser` int(11) NOT NULL,
  PRIMARY KEY (`idinvicePhoto`) USING BTREE,
  INDEX `fk_invicePhoto_invoice1_idx`(`invoice_idinvoice`) USING BTREE,
  INDEX `fk_invicePhoto_user1_idx`(`user_iduser`) USING BTREE,
  CONSTRAINT `fk_invicePhoto_invoice1` FOREIGN KEY (`invoice_idinvoice`) REFERENCES `invoice` (`idinvoice`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_invicePhoto_user1` FOREIGN KEY (`user_iduser`) REFERENCES `user` (`iduser`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of invicephoto
-- ----------------------------
INSERT INTO `invicephoto` VALUES (3, 'img\\invoices\\INV_3_2018-07-06', 3, 38);

-- ----------------------------
-- Table structure for invoice
-- ----------------------------
DROP TABLE IF EXISTS `invoice`;
CREATE TABLE `invoice`  (
  `idinvoice` int(11) NOT NULL AUTO_INCREMENT,
  `date` date NULL DEFAULT NULL,
  `netTotal` double NULL DEFAULT NULL,
  `discount` double NULL DEFAULT NULL,
  `subTotal` double NULL DEFAULT NULL,
  `location_idlocation` int(11) NOT NULL,
  `user_iduser` int(11) NOT NULL,
  `status` enum('paid','closed') CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`idinvoice`) USING BTREE,
  INDEX `fk_invoice_location1_idx`(`location_idlocation`) USING BTREE,
  INDEX `fk_invoice_user1_idx`(`user_iduser`) USING BTREE,
  CONSTRAINT `fk_invoice_location1` FOREIGN KEY (`location_idlocation`) REFERENCES `location` (`idlocation`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_invoice_user1` FOREIGN KEY (`user_iduser`) REFERENCES `user` (`iduser`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of invoice
-- ----------------------------
INSERT INTO `invoice` VALUES (3, '2018-07-06', 2166.5, 0, 2062.5, 4, 39, 'closed');
INSERT INTO `invoice` VALUES (4, '2018-11-19', 7824, 0, 7800, 6, 40, 'paid');
INSERT INTO `invoice` VALUES (5, '2018-11-24', 5950, 0, 5900, 7, 41, 'paid');
INSERT INTO `invoice` VALUES (6, '2018-11-24', 20050, 0, 20000, 8, 47, 'paid');
INSERT INTO `invoice` VALUES (7, '2018-11-25', 396.5, 0, 262.5, 9, 49, 'paid');
INSERT INTO `invoice` VALUES (8, '2018-11-25', 17274, 0, 17250, 6, 40, 'paid');
INSERT INTO `invoice` VALUES (9, '2018-11-25', 899.5, 0, 599.5, 5, 40, 'paid');

-- ----------------------------
-- Table structure for invoice_has_cart_has_packets
-- ----------------------------
DROP TABLE IF EXISTS `invoice_has_cart_has_packets`;
CREATE TABLE `invoice_has_cart_has_packets`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `invoice_idinvoice` int(11) NOT NULL,
  `cart_has_packets_id` int(11) NOT NULL,
  `qty` int(11) NULL DEFAULT NULL,
  `price` double(10, 2) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_invoice_has_cart_has_packets_cart_has_packets1_idx`(`cart_has_packets_id`) USING BTREE,
  INDEX `fk_invoice_has_cart_has_packets_invoice1_idx`(`invoice_idinvoice`) USING BTREE,
  CONSTRAINT `fk_invoice_has_cart_has_packets_cart_has_packets1` FOREIGN KEY (`cart_has_packets_id`) REFERENCES `cart_has_packets` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_invoice_has_cart_has_packets_invoice1` FOREIGN KEY (`invoice_idinvoice`) REFERENCES `invoice` (`idinvoice`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of invoice_has_cart_has_packets
-- ----------------------------
INSERT INTO `invoice_has_cart_has_packets` VALUES (2, 3, 4, 5, 500.00);
INSERT INTO `invoice_has_cart_has_packets` VALUES (3, 4, 5, 126, 6300.00);
INSERT INTO `invoice_has_cart_has_packets` VALUES (4, 5, 7, 3, 150.00);
INSERT INTO `invoice_has_cart_has_packets` VALUES (5, 8, 6, 344, 17200.00);
INSERT INTO `invoice_has_cart_has_packets` VALUES (6, 9, 11, 2, 100.00);

-- ----------------------------
-- Table structure for invoice_has_cart_item
-- ----------------------------
DROP TABLE IF EXISTS `invoice_has_cart_item`;
CREATE TABLE `invoice_has_cart_item`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `invoice_idinvoice` int(11) NOT NULL,
  `cart_has_item_id_cartItem` int(11) NOT NULL,
  `qty` double NULL DEFAULT NULL,
  `price` double(10, 2) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_invoice_has_cart_has_item_cart_has_item1_idx`(`cart_has_item_id_cartItem`) USING BTREE,
  INDEX `fk_invoice_has_cart_has_item_invoice1_idx`(`invoice_idinvoice`) USING BTREE,
  CONSTRAINT `fk_invoice_has_cart_has_item_cart_has_item1` FOREIGN KEY (`cart_has_item_id_cartItem`) REFERENCES `cart_has_item` (`id_cartItem`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_invoice_has_cart_has_item_invoice1` FOREIGN KEY (`invoice_idinvoice`) REFERENCES `invoice` (`idinvoice`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of invoice_has_cart_item
-- ----------------------------
INSERT INTO `invoice_has_cart_item` VALUES (4, 3, 15, 0.5, 50.00);
INSERT INTO `invoice_has_cart_item` VALUES (5, 3, 16, 0.25, 12.50);
INSERT INTO `invoice_has_cart_item` VALUES (6, 4, 17, 5, 250.00);
INSERT INTO `invoice_has_cart_item` VALUES (7, 4, 18, 5, 250.00);
INSERT INTO `invoice_has_cart_item` VALUES (8, 5, 19, 45, 2250.00);
INSERT INTO `invoice_has_cart_item` VALUES (9, 5, 20, 70, 3500.00);
INSERT INTO `invoice_has_cart_item` VALUES (10, 6, 26, 200, 20000.00);
INSERT INTO `invoice_has_cart_item` VALUES (11, 7, 27, 5, 250.00);
INSERT INTO `invoice_has_cart_item` VALUES (12, 7, 28, 0.25, 12.50);
INSERT INTO `invoice_has_cart_item` VALUES (13, 8, 29, 0.5, 50.00);
INSERT INTO `invoice_has_cart_item` VALUES (14, 9, 30, 0.5, 499.50);

-- ----------------------------
-- Table structure for invoice_has_cart_packages
-- ----------------------------
DROP TABLE IF EXISTS `invoice_has_cart_packages`;
CREATE TABLE `invoice_has_cart_packages`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `invoice_idinvoice` int(11) NOT NULL,
  `cart_has_packages_id` int(11) NOT NULL,
  `qty` int(11) NULL DEFAULT NULL,
  `price` double(10, 2) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_invoice_has_cart_has_packages_cart_has_packages1_idx`(`cart_has_packages_id`) USING BTREE,
  INDEX `fk_invoice_has_cart_has_packages_invoice1_idx`(`invoice_idinvoice`) USING BTREE,
  CONSTRAINT `fk_invoice_has_cart_has_packages_cart_has_packages1` FOREIGN KEY (`cart_has_packages_id`) REFERENCES `cart_has_packages` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_invoice_has_cart_has_packages_invoice1` FOREIGN KEY (`invoice_idinvoice`) REFERENCES `invoice` (`idinvoice`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of invoice_has_cart_packages
-- ----------------------------
INSERT INTO `invoice_has_cart_packages` VALUES (1, 3, 1, 3, 1500.00);
INSERT INTO `invoice_has_cart_packages` VALUES (2, 4, 2, 2, 1000.00);

-- ----------------------------
-- Table structure for limit
-- ----------------------------
DROP TABLE IF EXISTS `limit`;
CREATE TABLE `limit`  (
  `idlimit` int(11) NOT NULL AUTO_INCREMENT,
  `totalQty` double NULL DEFAULT NULL,
  `totalPrice` double NULL DEFAULT NULL,
  `usertype_idusertype` int(11) NOT NULL,
  PRIMARY KEY (`idlimit`) USING BTREE,
  INDEX `fk_limit_usertype1_idx`(`usertype_idusertype`) USING BTREE,
  CONSTRAINT `fk_limit_usertype1` FOREIGN KEY (`usertype_idusertype`) REFERENCES `usertype` (`idusertype`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of limit
-- ----------------------------
INSERT INTO `limit` VALUES (1, 50, 1500, 3);
INSERT INTO `limit` VALUES (2, 5, 20, 2);

-- ----------------------------
-- Table structure for location
-- ----------------------------
DROP TABLE IF EXISTS `location`;
CREATE TABLE `location`  (
  `idlocation` int(11) NOT NULL AUTO_INCREMENT,
  `street` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `address` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `lang` double NULL DEFAULT NULL,
  `lat` double NULL DEFAULT NULL,
  `tel` int(11) NULL DEFAULT NULL,
  `user_iduser` int(11) NOT NULL,
  `zip_idzip` int(11) NOT NULL,
  PRIMARY KEY (`idlocation`) USING BTREE,
  INDEX `fk_location_user1_idx`(`user_iduser`) USING BTREE,
  INDEX `fk_location_zip1_idx`(`zip_idzip`) USING BTREE,
  CONSTRAINT `fk_location_user1` FOREIGN KEY (`user_iduser`) REFERENCES `user` (`iduser`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_location_zip1` FOREIGN KEY (`zip_idzip`) REFERENCES `zip` (`idzip`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of location
-- ----------------------------
INSERT INTO `location` VALUES (3, 'Baker Street', '221b, baker st', 0, 0, 767806377, 39, 3);
INSERT INTO `location` VALUES (4, 'Baker Street', 'Colombo', 79.86124300000006, 6.927078600000002, 767806377, 39, 3);
INSERT INTO `location` VALUES (5, 'baker st.', '221b', 0, 0, 712345677, 40, 1);
INSERT INTO `location` VALUES (6, 'lol', 'fsw', 79.86055409999994, 6.8956642, 77296554, 40, 1);
INSERT INTO `location` VALUES (7, 'borella st.', 'colombo 06', 0, 0, 767806377, 41, 3);
INSERT INTO `location` VALUES (8, '22b', 'fgrdr', 0, 0, 767806377, 47, 3);
INSERT INTO `location` VALUES (9, 'kent road ', '64/1 ', 79.87998549999998, 6.9330365, 115175176, 49, 1);
INSERT INTO `location` VALUES (10, 'fes', 'vd', 0, 0, 777806377, 44, 1);

-- ----------------------------
-- Table structure for login_session
-- ----------------------------
DROP TABLE IF EXISTS `login_session`;
CREATE TABLE `login_session`  (
  `idlogin_session` int(11) NOT NULL AUTO_INCREMENT,
  `ip_address` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `in_time` timestamp(0) NULL DEFAULT NULL,
  `out_time` timestamp(0) NULL DEFAULT NULL,
  `user_login_iduser_login` int(11) NOT NULL,
  PRIMARY KEY (`idlogin_session`) USING BTREE,
  INDEX `fk_login_session_user_login1_idx`(`user_login_iduser_login`) USING BTREE,
  CONSTRAINT `fk_login_session_user_login1` FOREIGN KEY (`user_login_iduser_login`) REFERENCES `user_login` (`iduser_login`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for loose_stock
-- ----------------------------
DROP TABLE IF EXISTS `loose_stock`;
CREATE TABLE `loose_stock`  (
  `iditem` int(11) NOT NULL AUTO_INCREMENT,
  `qty` double NULL DEFAULT NULL,
  `status` enum('available','na','delete') CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'available',
  `uPrice` double NOT NULL,
  `product_idproduct` int(11) NOT NULL,
  PRIMARY KEY (`iditem`) USING BTREE,
  INDEX `fk_item_product1_idx`(`product_idproduct`) USING BTREE,
  CONSTRAINT `fk_item_product1` FOREIGN KEY (`product_idproduct`) REFERENCES `product` (`idproduct`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of loose_stock
-- ----------------------------
INSERT INTO `loose_stock` VALUES (1, 1000, 'delete', 100, 2);
INSERT INTO `loose_stock` VALUES (2, 498, 'available', 1000, 10);
INSERT INTO `loose_stock` VALUES (3, 14.75, 'available', 50, 7);
INSERT INTO `loose_stock` VALUES (4, 50, 'delete', 50, 2);
INSERT INTO `loose_stock` VALUES (5, 0, 'na', 50, 5);
INSERT INTO `loose_stock` VALUES (6, 2050, 'available', 50, 14);
INSERT INTO `loose_stock` VALUES (7, 1000, 'available', 50, 6);
INSERT INTO `loose_stock` VALUES (8, 1000, 'available', 50, 14);
INSERT INTO `loose_stock` VALUES (9, 1000, 'available', 50, 13);
INSERT INTO `loose_stock` VALUES (10, 1000, 'available', 50, 12);
INSERT INTO `loose_stock` VALUES (11, 1000, 'available', 50, 11);
INSERT INTO `loose_stock` VALUES (12, 1000, 'available', 50, 10);
INSERT INTO `loose_stock` VALUES (13, 999.75, 'available', 50, 8);
INSERT INTO `loose_stock` VALUES (14, 98.5, 'available', 999, 2);
INSERT INTO `loose_stock` VALUES (15, 200, 'available', 400, 15);

-- ----------------------------
-- Table structure for package_review
-- ----------------------------
DROP TABLE IF EXISTS `package_review`;
CREATE TABLE `package_review`  (
  `idpackage_review` int(11) UNSIGNED ZEROFILL NOT NULL AUTO_INCREMENT,
  `rate` int(11) NULL DEFAULT NULL,
  `description` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `user_iduser` int(11) NOT NULL,
  `packages_idpackages` int(11) NOT NULL,
  PRIMARY KEY (`idpackage_review`) USING BTREE,
  INDEX `fk_package_review_user1_idx`(`user_iduser`) USING BTREE,
  INDEX `fk_package_review_packages2_idx`(`packages_idpackages`) USING BTREE,
  CONSTRAINT `fk_package_review_packages2` FOREIGN KEY (`packages_idpackages`) REFERENCES `packages` (`idpackages`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_package_review_user1` FOREIGN KEY (`user_iduser`) REFERENCES `user` (`iduser`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for packages
-- ----------------------------
DROP TABLE IF EXISTS `packages`;
CREATE TABLE `packages`  (
  `idpackages` int(11) NOT NULL AUTO_INCREMENT,
  `packageName` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `packageImage` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `status` enum('available','na','delete') CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `category_idcategory` int(11) NOT NULL,
  `description` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `price` double NULL DEFAULT NULL,
  PRIMARY KEY (`idpackages`) USING BTREE,
  INDEX `fk_packages_category1_idx`(`category_idcategory`) USING BTREE,
  CONSTRAINT `fk_packages_category1` FOREIGN KEY (`category_idcategory`) REFERENCES `category` (`idcategory`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of packages
-- ----------------------------
INSERT INTO `packages` VALUES (1, 'weekly mini package', 'img\\itemImages\\herbs--spices-spoons-wallpapers_53660_1920x1200.jpg', 'available', 1, 'this is a mini package', 500);
INSERT INTO `packages` VALUES (2, 'monthly mini package', 'img\\itemImages\\loose.jpg', 'available', 1, 'this is a mini package', 3000);
INSERT INTO `packages` VALUES (3, 'monthly mid package', 'img\\itemImages\\loose.jpg', 'available', 1, 'this is a mini package', 4000);
INSERT INTO `packages` VALUES (4, 'weekly mid package', 'img\\itemImages\\pexels-photo-94438.jpg', 'available', 2, 'this is a mid package', 2000);

-- ----------------------------
-- Table structure for packages_has_product
-- ----------------------------
DROP TABLE IF EXISTS `packages_has_product`;
CREATE TABLE `packages_has_product`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `packages_idpackages` int(11) NOT NULL,
  `product_idproduct` int(11) NOT NULL,
  `qty` double NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_packages_has_product_product1_idx`(`product_idproduct`) USING BTREE,
  INDEX `fk_packages_has_product_packages1_idx`(`packages_idpackages`) USING BTREE,
  CONSTRAINT `fk_packages_has_product_packages1` FOREIGN KEY (`packages_idpackages`) REFERENCES `packages` (`idpackages`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_packages_has_product_product1` FOREIGN KEY (`product_idproduct`) REFERENCES `product` (`idproduct`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of packages_has_product
-- ----------------------------
INSERT INTO `packages_has_product` VALUES (1, 1, 2, 61);
INSERT INTO `packages_has_product` VALUES (2, 1, 4, 29);
INSERT INTO `packages_has_product` VALUES (3, 1, 3, 20);
INSERT INTO `packages_has_product` VALUES (5, 2, 3, 1);
INSERT INTO `packages_has_product` VALUES (6, 2, 5, 34);
INSERT INTO `packages_has_product` VALUES (7, 2, 8, 34);

-- ----------------------------
-- Table structure for packet
-- ----------------------------
DROP TABLE IF EXISTS `packet`;
CREATE TABLE `packet`  (
  `idpacket` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `weight` double NULL DEFAULT NULL,
  `status` enum('available','na') CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'available',
  `img` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `type` enum('powder','pieces') CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`idpacket`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of packet
-- ----------------------------
INSERT INTO `packet` VALUES (1, 'corninder 200g', 200, 'available', 'img/itemImages/1355c158fc40ae24b7cd31a7941260a11466cd7e.jpg', 'powder');
INSERT INTO `packet` VALUES (3, 'corninder 300g', 200, 'available', 'img/itemImages/1355c158fc40ae24b7cd31a7941260a11466cd7e.jpg', 'powder');
INSERT INTO `packet` VALUES (5, 'clove 250g', 250, 'available', 'img/itemImages/6b31dd420a2aceae8f45e70e7730566b0c928d69.jpg', 'pieces');

-- ----------------------------
-- Table structure for packet_stock
-- ----------------------------
DROP TABLE IF EXISTS `packet_stock`;
CREATE TABLE `packet_stock`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `packet_idpacket` int(11) NOT NULL,
  `qty` int(11) NULL DEFAULT NULL,
  `exp` date NULL DEFAULT NULL,
  `man` date NULL DEFAULT NULL,
  `price` double NULL DEFAULT NULL,
  `status` enum('available','na','delete') CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'available',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_product_has_packet_packet1_idx`(`packet_idpacket`) USING BTREE,
  CONSTRAINT `fk_product_has_packet_packet1` FOREIGN KEY (`packet_idpacket`) REFERENCES `packet` (`idpacket`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of packet_stock
-- ----------------------------
INSERT INTO `packet_stock` VALUES (1, 1, 1998, '2018-07-18', '2018-07-17', 50, 'available');
INSERT INTO `packet_stock` VALUES (2, 3, 1822, '2018-07-18', '2018-07-17', 50, 'available');
INSERT INTO `packet_stock` VALUES (3, 5, 1656, '2018-07-18', '2018-07-17', 50, 'available');
INSERT INTO `packet_stock` VALUES (4, 1, 995, '2018-07-18', '2018-07-17', 100, 'available');
INSERT INTO `packet_stock` VALUES (5, 3, 1000, '2018-07-18', '2018-07-19', 100, 'available');
INSERT INTO `packet_stock` VALUES (6, 5, 1000, '2018-07-18', '2018-07-19', 100, 'available');

-- ----------------------------
-- Table structure for privilage
-- ----------------------------
DROP TABLE IF EXISTS `privilage`;
CREATE TABLE `privilage`  (
  `idprivilage` int(11) NOT NULL AUTO_INCREMENT,
  `usertype_idusertype` int(11) NOT NULL,
  `interface_idinterface` int(11) NOT NULL,
  PRIMARY KEY (`idprivilage`) USING BTREE,
  INDEX `fk_privilage_usertype1_idx`(`usertype_idusertype`) USING BTREE,
  INDEX `fk_privilage_interface1_idx`(`interface_idinterface`) USING BTREE,
  CONSTRAINT `fk_privilage_interface1` FOREIGN KEY (`interface_idinterface`) REFERENCES `interfaces` (`idinterface`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_privilage_usertype1` FOREIGN KEY (`usertype_idusertype`) REFERENCES `usertype` (`idusertype`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for product
-- ----------------------------
DROP TABLE IF EXISTS `product`;
CREATE TABLE `product`  (
  `idproduct` int(11) NOT NULL AUTO_INCREMENT,
  `productname` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `img` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `status` enum('available','na') CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'available',
  `type` enum('powder','pieces') CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`idproduct`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of product
-- ----------------------------
INSERT INTO `product` VALUES (2, 'Cardamom', 'img\\itemImages\\051aa0140526fcfa8430992a1199a71adf714570.jpg', 'available', 'powder');
INSERT INTO `product` VALUES (3, 'Cardamom', 'img\\itemImages\\051aa0140526fcfa8430992a1199a71adf714570.jpg', 'available', 'pieces');
INSERT INTO `product` VALUES (4, 'Clove', 'img\\itemImages\\6b31dd420a2aceae8f45e70e7730566b0c928d69.jpg', 'available', 'powder');
INSERT INTO `product` VALUES (5, 'Cassia bark', 'img\\itemImages\\25841569bb7db2f25791998c6b6f114c783c08eb.jpg', 'available', 'pieces');
INSERT INTO `product` VALUES (6, 'Black pepper', 'img\\itemImages\\425258248d99d59dd021cb372f364b66e408fc92.jpg', 'available', 'pieces');
INSERT INTO `product` VALUES (7, 'Cumin', 'img\\itemImages\\586aadda69361edb0cabef05625fd32b02ffbed0.jpg', 'available', 'pieces');
INSERT INTO `product` VALUES (8, 'Coriander', 'img\\itemImages\\1355c158fc40ae24b7cd31a7941260a11466cd7e.jpg', 'available', 'pieces');
INSERT INTO `product` VALUES (10, 'Nutmeg and mace', 'img\\itemImages\\7e6a3e0aa3d2c8c7e31b15eb76511892c1c90103.jpg', 'available', 'pieces');
INSERT INTO `product` VALUES (11, 'Mustard seeds', 'img\\itemImages\\08294c52d6a952a388c3b1121d0958a11ba08b2c.jpg', 'available', 'pieces');
INSERT INTO `product` VALUES (12, 'Fenugreek', 'img\\itemImages\\5e19719deccccae79ab6eac00cb302d3efe52fba.jpg', 'available', 'pieces');
INSERT INTO `product` VALUES (13, 'Turmeric', 'img\\itemImages\\47b1e29e0dbe419383e9d2cc3e5e2113e2c6fc24.jpg', 'available', 'powder');
INSERT INTO `product` VALUES (14, 'Saffron', 'img\\itemImages\\b9da2489181993f23d32dc1d5944631bc5706f22.jpg', 'available', 'pieces');
INSERT INTO `product` VALUES (15, 'miris', 'img\\itemImages\\pp.jpg', 'available', 'powder');

-- ----------------------------
-- Table structure for resetcode
-- ----------------------------
DROP TABLE IF EXISTS `resetcode`;
CREATE TABLE `resetcode`  (
  `idresetCode` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `user_iduser` int(11) NOT NULL,
  PRIMARY KEY (`idresetCode`) USING BTREE,
  INDEX `fk_resetCode_user1_idx`(`user_iduser`) USING BTREE,
  CONSTRAINT `fk_resetCode_user1` FOREIGN KEY (`user_iduser`) REFERENCES `user` (`iduser`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of resetcode
-- ----------------------------
INSERT INTO `resetcode` VALUES (1, 'd4a04e7a3167d58646e07d8f6af5b96e', 40);

-- ----------------------------
-- Table structure for session_activities
-- ----------------------------
DROP TABLE IF EXISTS `session_activities`;
CREATE TABLE `session_activities`  (
  `idsession_activities` int(11) NOT NULL AUTO_INCREMENT,
  `description` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `session_activitiescol` varchar(45) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `login_session_idlogin_session` int(11) NOT NULL,
  PRIMARY KEY (`idsession_activities`) USING BTREE,
  INDEX `fk_session_activities_login_session1_idx`(`login_session_idlogin_session`) USING BTREE,
  CONSTRAINT `fk_session_activities_login_session1` FOREIGN KEY (`login_session_idlogin_session`) REFERENCES `login_session` (`idlogin_session`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for supplier
-- ----------------------------
DROP TABLE IF EXISTS `supplier`;
CREATE TABLE `supplier`  (
  `idsupplier` int(11) NOT NULL,
  `name` varchar(250) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `address` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `email` varchar(250) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `tel` varchar(45) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `product_idproduct` int(11) NOT NULL,
  PRIMARY KEY (`idsupplier`) USING BTREE,
  INDEX `fk_supplier_product1_idx`(`product_idproduct`) USING BTREE,
  CONSTRAINT `fk_supplier_product1` FOREIGN KEY (`product_idproduct`) REFERENCES `product` (`idproduct`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `iduser` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `email` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `password` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `usertype_idusertype` int(11) NOT NULL,
  `date` date NULL DEFAULT NULL,
  `status` tinyint(1) NULL DEFAULT NULL,
  `ooStatus` enum('online','offline') CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'offline',
  PRIMARY KEY (`iduser`) USING BTREE,
  INDEX `fk_user_usertype1_idx`(`usertype_idusertype`) USING BTREE,
  CONSTRAINT `fk_user_usertype1` FOREIGN KEY (`usertype_idusertype`) REFERENCES `usertype` (`idusertype`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 53 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (38, 'admin', 'admin@gmail.com', '879a3d7295b94976aa642dcb646ed154', 1, '2018-07-06', 1, 'offline');
INSERT INTO `user` VALUES (39, 'maldeniya', 'maldeniya@gmail.com', '879a3d7295b94976aa642dcb646ed154', 2, '2018-07-06', 1, 'offline');
INSERT INTO `user` VALUES (40, 'nipun', 'wanipun96@gmail.com', '879a3d7295b94976aa642dcb646ed154', 2, '2018-09-04', 1, 'offline');
INSERT INTO `user` VALUES (41, 'red', 'red@gmail.com', '879a3d7295b94976aa642dcb646ed154', 3, '2018-11-24', 1, 'offline');
INSERT INTO `user` VALUES (42, 'Ishu', 'isuri@gmail.com', '57b3f467fd14b8c61b3f54c302f26a5c', 2, '2018-11-24', 1, 'offline');
INSERT INTO `user` VALUES (43, 'waseem', 'waseem@gmail.com', '879a3d7295b94976aa642dcb646ed154', 2, '2018-11-24', 1, 'offline');
INSERT INTO `user` VALUES (44, 'trex', 'trex@gmail.com', '879a3d7295b94976aa642dcb646ed154', 2, '2018-11-24', 1, 'offline');
INSERT INTO `user` VALUES (45, 'lol', 'rex@gmail.com', '879a3d7295b94976aa642dcb646ed154', 2, '2018-11-24', 1, 'offline');
INSERT INTO `user` VALUES (46, 'lol', 'refdx@gmail.com', '879a3d7295b94976aa642dcb646ed154', 2, '2018-11-24', 1, 'offline');
INSERT INTO `user` VALUES (47, 'shop', 'shop@gmail.com', '879a3d7295b94976aa642dcb646ed154', 3, '2018-11-24', 1, 'offline');
INSERT INTO `user` VALUES (48, 'last', 'last@gmail.com', '879a3d7295b94976aa642dcb646ed154', 2, '2018-11-25', 1, 'offline');
INSERT INTO `user` VALUES (49, 'Sumanadasa', 'Sumane@gmail.com', 'e4266a0692fb16de48119116d39da068', 2, '2018-11-25', 1, 'offline');
INSERT INTO `user` VALUES (50, 'local', 'local@gmail.com', '879a3d7295b94976aa642dcb646ed154', 2, '2018-11-25', 1, 'offline');
INSERT INTO `user` VALUES (51, 'fin', 'fin@gmail.com', '879a3d7295b94976aa642dcb646ed154', 2, '2018-11-26', 1, 'offline');
INSERT INTO `user` VALUES (52, 'dsffd', 'ddd@gmail.com', '879a3d7295b94976aa642dcb646ed154', 3, '2018-11-26', 1, 'offline');

-- ----------------------------
-- Table structure for user_login
-- ----------------------------
DROP TABLE IF EXISTS `user_login`;
CREATE TABLE `user_login`  (
  `iduser_login` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(250) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `password` varchar(45) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `user_iduser` int(11) NOT NULL,
  PRIMARY KEY (`iduser_login`) USING BTREE,
  INDEX `fk_user_login_user1_idx`(`user_iduser`) USING BTREE,
  CONSTRAINT `fk_user_login_user1` FOREIGN KEY (`user_iduser`) REFERENCES `user` (`iduser`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for usertype
-- ----------------------------
DROP TABLE IF EXISTS `usertype`;
CREATE TABLE `usertype`  (
  `idusertype` int(11) NOT NULL AUTO_INCREMENT,
  `userType` varchar(45) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`idusertype`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of usertype
-- ----------------------------
INSERT INTO `usertype` VALUES (1, 'admin');
INSERT INTO `usertype` VALUES (2, 'local');
INSERT INTO `usertype` VALUES (3, 'shop');
INSERT INTO `usertype` VALUES (4, 'employee');

-- ----------------------------
-- Table structure for usertype_discount
-- ----------------------------
DROP TABLE IF EXISTS `usertype_discount`;
CREATE TABLE `usertype_discount`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `percentage` double NULL DEFAULT NULL,
  `usertype_idusertype` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_usertype_discount_usertype1_idx`(`usertype_idusertype`) USING BTREE,
  CONSTRAINT `fk_usertype_discount_usertype1` FOREIGN KEY (`usertype_idusertype`) REFERENCES `usertype` (`idusertype`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for vehicle
-- ----------------------------
DROP TABLE IF EXISTS `vehicle`;
CREATE TABLE `vehicle`  (
  `idvehicle` int(11) NOT NULL,
  `number` varchar(45) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `user_iduser` int(11) NOT NULL,
  `vehicleType_idvehicleType` int(11) NOT NULL,
  `status` enum('available','onDelivery','not available') CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `color` varchar(45) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`idvehicle`) USING BTREE,
  INDEX `fk_vehicle_user1_idx`(`user_iduser`) USING BTREE,
  INDEX `fk_vehicle_vehicleType1_idx`(`vehicleType_idvehicleType`) USING BTREE,
  CONSTRAINT `fk_vehicle_user1` FOREIGN KEY (`user_iduser`) REFERENCES `user` (`iduser`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_vehicle_vehicleType1` FOREIGN KEY (`vehicleType_idvehicleType`) REFERENCES `vehicletype` (`idvehicleType`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for vehicletype
-- ----------------------------
DROP TABLE IF EXISTS `vehicletype`;
CREATE TABLE `vehicletype`  (
  `idvehicleType` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`idvehicleType`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for zip
-- ----------------------------
DROP TABLE IF EXISTS `zip`;
CREATE TABLE `zip`  (
  `idzip` int(11) NOT NULL AUTO_INCREMENT,
  `zipcode` varchar(45) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `charge` double NULL DEFAULT NULL,
  PRIMARY KEY (`idzip`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of zip
-- ----------------------------
INSERT INTO `zip` VALUES (1, '00100', 300);
INSERT INTO `zip` VALUES (2, '00202', 345);
INSERT INTO `zip` VALUES (3, '00800', 50);
INSERT INTO `zip` VALUES (4, '00700', 20);

SET FOREIGN_KEY_CHECKS = 1;
