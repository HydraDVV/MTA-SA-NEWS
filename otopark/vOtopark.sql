/*
Navicat MySQL Data Transfer

Source Server         : VEGOBASE
Source Server Version : 50505
Source Host           : localhost:3306
Source Database       : server

Target Server Type    : MYSQL
Target Server Version : 50505
File Encoding         : 65001

Date: 2021-12-21 21:35:18
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `votopark`
-- ----------------------------
DROP TABLE IF EXISTS `votopark`;
CREATE TABLE `votopark` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `x` varchar(11) NOT NULL,
  `y` varchar(255) NOT NULL,
  `z` varchar(255) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of votopark
-- ----------------------------
INSERT INTO `votopark` VALUES ('1', '1949.047851', '-1815.0263671875', '13.546875');
