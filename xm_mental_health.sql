/*
 Navicat Premium Data Transfer

 Source Server         : localdocker_mysql
 Source Server Type    : MySQL
 Source Server Version : 90200
 Source Host           : localhost:3307
 Source Schema         : xm_mental_health1

 Target Server Type    : MySQL
 Target Server Version : 90200
 File Encoding         : 65001

 Date: 21/04/2025 21:49:24
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for admin
-- ----------------------------
DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '账号',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '密码',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '姓名',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '头像',
  `role` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '角色',
  `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '电话',
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '邮箱',
  `type_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '地址',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '管理员表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of admin
-- ----------------------------
INSERT INTO `admin` VALUES (1, 'admin', 'admin', '管理员', 'http://localhost:9090/files/download/admin.png', 'ADMIN', '18899990011', 'admin2@HTN.com', '宁德');

-- ----------------------------
-- Table structure for doctor
-- ----------------------------
DROP TABLE IF EXISTS `doctor`;
CREATE TABLE `doctor`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '账号',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '密码',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '姓名',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '头像',
  `role` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '角色',
  `seniority` int(0) NULL DEFAULT NULL COMMENT '工龄',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '简介',
  `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '电话',
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '邮箱',
  `code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '身份证',
  `certificate` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '资格证',
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '审批状态',
  `type_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '地址',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '心理医生表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of doctor
-- ----------------------------
INSERT INTO `doctor` VALUES (1, 'zhanghua', '123456', '张华（阴阳两虚）', 'http://localhost:9090/files/download/1743246191950-1a608ae32b.png', 'DOCTOR', 8, '张华，毕业于北京中医药大学，获得中医学博士学位，擅长运用中医理论和方法治疗高血压及相关并发症。张华医师深耕高血压的辨证施治，尤其擅长肝阳上亢型、高血压引发的头痛眩晕等症状的调理。通过结合传统中医针灸、草药及调理饮食，帮助患者改善血压波动，恢复身心健康。已有二十余年临床经验，广受患者好评。', '18899997777', 'zhanghua@HTN.com', '321324**********28', 'http://localhost:9090/files/download/医师资格证0.jpg', '审批通过', '莆田');
INSERT INTO `doctor` VALUES (2, 'limei', '123456', '李梅（肝肾阴虚、肝阳上亢）', 'http://localhost:9090/files/download/1744558441472-OIP (3).jpg', 'DOCTOR', 15, '李梅，教授，主任医师，长期从事高血压相关疾病的中医治疗和研究。她在肝肾两虚型及痰瘀内蕴型高血压的治疗方面有深厚的造诣，结合经典中医方剂和现代医学技术，为患者提供个性化的治疗方案。李教授提倡通过调节体内气血、平衡阴阳，以达到稳血压、防并发症的效果。多次主持国家级研究项目，成果丰硕。', '18877776666', 'limei@HTN.com', '324115**********11', 'http://localhost:9090/files/download/医师资格证1.jpg', '审批通过', '');
INSERT INTO `doctor` VALUES (3, 'wangxiao', '123456', '王晓（痰瘀内蕴）', 'http://localhost:9090/files/download/1744558450096-OIP (2).jpg', 'DOCTOR', 25, '王晓，注册中医师，专注于高血压及其并发症的中医调理和治疗。王医师擅长运用阴阳两虚、痰瘀内停等辨证论治法治疗高血压，特别是在结合现代诊疗设备与中医治疗方法上有独特优势。她通过全面的体质辨识，针对患者的不同症状，采用个性化的草药方剂、针灸以及饮食调理，效果显著。拥有十多年临床经验，并为多个高血压患者提供长期跟踪调理。', '18866665555', 'wangxiao@HTN.com', '321425**********22', 'http://localhost:9090/files/download/医师资格证2.jpg', '审批通过', '');
INSERT INTO `doctor` VALUES (4, 'liuqiang', '123456', '刘强 （瘀血内停）', 'http://localhost:9090/files/download/1743245511267-OIP (4).jpg', 'DOCTOR', 16, '刘强，具有十年中医临床经验，专注于高血压患者的中医辨证治疗。尤其对阴阳两虚和瘀血内停型高血压的治疗有独特的见解。他通过多种传统治疗方法如推拿、刮痧、拔罐等辅以草药调理，帮助患者有效缓解高血压症状，并且预防并发症。刘医师在治病的同时强调患者的生活方式调整，倡导健康的饮食习惯和适度的运动。', '18877776666', 'liuqiang@xm.com', '341223**********11', 'http://localhost:9090/files/download/医师资格证3.jpg', '审批通过', '');

-- ----------------------------
-- Table structure for feedback
-- ----------------------------
DROP TABLE IF EXISTS `feedback`;
CREATE TABLE `feedback`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` int(0) NULL DEFAULT NULL COMMENT '用户ID',
  `question` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '反馈问题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '用户想法',
  `time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '反馈时间',
  `reply_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '回复人',
  `reply_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '回复内容',
  `reply_time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '回复时间',
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '反馈状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '反馈建议表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of feedback
-- ----------------------------
INSERT INTO `feedback` VALUES (1, 1, '希望多分享一些高血压方面的宣传知识', '如题，希望管理员多发布一些高血压方面的健康知识', '2025-02-15 13:22:15', 'admin', '感谢反馈，我们会认真考虑！', '2025-02-16 17:22:40', '已回复');

-- ----------------------------
-- Table structure for notice
-- ----------------------------
DROP TABLE IF EXISTS `notice`;
CREATE TABLE `notice`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '公告标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '公告内容',
  `time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '发布时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '系统公告表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of notice
-- ----------------------------
INSERT INTO `notice` VALUES (1, '管理员端功能已上线', '管理员端功能已上线，完成测试', '2025-01-16 15:51:17');
INSERT INTO `notice` VALUES (2, '医生端功能已上线', '医生端功能已上线，完成测试', '2025-02-15 16:14:22');
INSERT INTO `notice` VALUES (3, '小程序端功能已上线', '小程序端功能已上线，完成测试', '2025-03-09 18:05:56');

-- ----------------------------
-- Table structure for propagate
-- ----------------------------
DROP TABLE IF EXISTS `propagate`;
CREATE TABLE `propagate`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `doctor_id` int(0) NULL DEFAULT NULL COMMENT '医生ID',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '宣传标题',
  `img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '宣传封面',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '宣传内容',
  `time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '发布时间',
  `num` int(0) NULL DEFAULT 0 COMMENT '浏览量',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '健康宣传表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of propagate
-- ----------------------------
INSERT INTO `propagate` VALUES (1, 1, '高血压的中医角度分析与调理', 'http://localhost:9090/files/download/1740933692137-OIP.jpg', '<h1 style=\"text-align: center;\">高血压的中医角度分析与调理</h1>\r\n<p style=\"text-align: start; line-height: 2;\"><span style=\"font-size: 16px;\">    高血压是一种常见的慢性疾病，其特点是动脉血压持续升高。随着现代生活节奏的加快，工作压力和不良的生活习惯，高血压的发病率呈上升趋势。西医通过药物控制血压，而中医学则强调辨证施治，从整体调理入手，旨在调整体内的阴阳平衡，恢复人体的自我调节能力。</span></p>\r\n<p style=\"text-align: center;\"><img src=\"http://localhost:9090/files/download/1728369216859-心理健康宣传02.jpg\" alt=\"\" data-href=\"\" style=\"\"></p>\r\n<h2 style=\"text-align: start;\">一、从中医角度看高血压的病因</h2>\r\n<p style=\"text-align: start; line-height: 2;\"><span style=\"font-size: 16px;\">    中医认为，高血压的发生与肝、肾、脾等脏腑的功能失调密切相关。首先，肝气郁结是高血压的重要病因之一。情绪波动、压力过大、长期的抑郁、焦虑等情绪困扰，容易导致肝气郁结，肝气郁结则可引发气滞血瘀，最终引发血压升高。其次，肾精不足也是导致高血压的常见原因。肾为“先天之本”，肾精充足能够滋养全身，而肾精亏虚，尤其是中老年人群中，容易导致阴虚火旺，火热上升，压迫心脉，导致血压升高。另外，脾虚也会影响到气血生化功能，脾气虚弱不能有效运化水湿，形成痰湿，阻碍气血的流畅，间接导致血压升高。</span></p>\r\n<h2 style=\"text-align: start;\">二、高血压的主要表现及其辨证</h2>\r\n<p style=\"text-align: start; line-height: 2;\"><span style=\"font-size: 16px;\">    中医辨证治疗高血压，首先要对症状进行辨别。根据不同的病因，中医将高血压分为几种不同的类型。常见的类型包括肝阳上亢型、肾阴虚型、气滞血瘀型等。肝阳上亢型的患者多表现为头晕头痛、目眩耳鸣、面红目赤等，伴随有情绪波动较大；肾阴虚型的患者则常见腰膝酸软、五心烦热、失眠多梦等症状；气滞血瘀型的患者则表现为胸闷、心悸、乏力、疼痛等。</span></p>\r\n<h2 style=\"text-align: start;\">三、结语</h2>\r\n<p style=\"text-align: start; line-height: 2;\"><span style=\"font-size: 16px;\">    中医治疗高血压不仅仅依赖于药物，更注重整体调理和个体差异。通过辨证施治，中医能够帮助患者从根本上恢复身体的平衡，达到降压的效果。与此同时，配合日常生活中的调理，如保持良好的心态和健康的生活习惯，将更有利于高血压的预防和治疗。</span></p>\r\n<h3 style=\"text-align: start;\">\r\n</h3>', '2025-02-15 14:33:44', 25);
INSERT INTO `propagate` VALUES (2, 1, '全国高血压日！快快收藏这篇文章，助你避开五个高血压误区', 'http://localhost:9090/files/download/1740933698478-OIP-C.jpg', '<h1 style=\"text-align: center;\">全国高血压日！快快收藏这篇文章，助你避开五个高血压误区</h1>\r\n<p style=\"text-align: start; line-height: 2;\"><span style=\"font-size: 16px;\">    市卫健委介绍，今天是“全国高血压日”，近年来，我国的高血压患者有年轻化的趋势，全年龄人群都应养成预防意识。市疾病预防控制中心专家来教大家识别五个高血压误区。一起来看↓</span></p>\r\n<p style=\"text-align: center;\"><img src=\"http://localhost:9090/files/download/1728369216859-心理健康宣传02.jpg\" alt=\"\" data-href=\"\" style=\"\"></p>\r\n<h2 style=\"text-align: start;\">误区一：单次血压高，就是高血压</h2>\r\n<p style=\"text-align: start; line-height: 2;\"><span style=\"font-size: 16px;\">    血压的波动是一个复杂且多变的过程，受到很多因素的影响。当您发现单次血压测量值偏高时，不必过度惊慌。为获取更加准确、真实的血压数据，测量时需注意以下几点：1、确保测量环境安静舒适。2、测量前30分钟内，禁止吸烟、饮酒、摄入咖啡或茶等。3、不要进行剧烈运动或用力活动，并排空膀胱。4、测量前休息至少5分钟，确保身体处于放松状态。值得注意的是，高血压的诊断需要在非同日进行3次血压测量，并且每次测量的收缩压≥140毫米汞柱和/或舒张压≥90毫米汞柱。此外，为了更准确地反映血压状况，建议每次测量2-3次，取平均值作为参考。</span></p>\r\n<h2 style=\"text-align: start;\">误区二：水银血压计，测量更准确</h2>\r\n<p style=\"text-align: start; line-height: 2;\"><span style=\"font-size: 16px;\">    在老一辈人眼中，水银血压计似乎总是与“准确”一词紧密相连。水银柱血压计确实有其独特的准确性，但其使用方法较复杂，需要经过专业培训的医务人员操作，在测量过程中，若不注意放气速度、水平读数、听诊器位置等细节，都可能会产生较大的误差。相比之下，经过国际标准认证的上臂式电子血压计更加适合居家测量。此外，腕式、手指式电子血压计的测量精准度较差，不推荐居家测量时使用。</span></p>\r\n<h2 style=\"text-align: start;\">误区三：做饭用盐少，血压必不高</h2>\r\n<p style=\"text-align: start; line-height: 2;\"><span style=\"font-size: 16px;\">    很多高血压患者都知道做饭要少放盐，盐中的钠元素能导致血压上升，但其他调味品，如汤料包、辣椒酱、豆瓣酱等也含有大量的钠，某些面条、面包、三明治、奶酪、罐装食品等“不太咸”的食物，也可能会含有大量的钠，要注意多加辨别。除了食物之外，非处方药也是钠的“隐形来源”。就诊时，高血压患者应主动告知病史，以便医生在选择药物时避免与药效冲突。</span></p>\r\n<h3 style=\"text-align: start;\">误区四：高压没症状，危害不找我</h3>\r\n<p style=\"text-align: start; line-height: 2;\"><span style=\"font-size: 16px;\">    得了高血压不一定都有明显症状。一方面，大部分高血压患者的靶器官微小损伤是悄然发生的，可能就是没太大感觉；另一方面，不同人的耐受程度也不相同，有些人对于不适症状不敏感，这可能导致诊断的延迟，越晚发现，器官损害就越大。因此，建议35岁及以上人群定期检测血压，早期发现、早期干预，规律服药、控制血压，才能延缓并发症发生，提高远期生活质量。</span></p>\r\n<h3 style=\"text-align: start;\">误区五：吃药多伤身，一降就可停</h3>\r\n<p style=\"text-align: start; line-height: 2;\"><span style=\"font-size: 16px;\">    很多患者对服药仍抱有一定的抵触心理，觉得“是药三分毒”，越少吃药对身体的损伤越小。有些患者可能听说某种食物具有降血压的功效，就大量进食希望以此改善血压水平，或者寻求保健品而非服用具有确定疗效的药品。更常见的是，有些患者一旦血压降到控制标准，就间隔服药，甚至停药。以上做法都是错误的。虽然药物确实可能存在一定的不良反应，但这些不良反应远不如血压不控制造成的损害大，减药、停药会导致血压波动加大，对血管损伤更大。</span></p>\r\n', '2025-02-15 17:31:43', 31);
INSERT INTO `propagate` VALUES (3, 2, '慢性病防治丨正确认识高血压', 'http://localhost:9090/files/download/manxingbfz.jpg', '<h1 style=\"text-align: center;\">慢性病防治正确认识高血压</h1>\r\n<p style=\"text-align: center;\"><img src=\"http://localhost:9090/files/download/1728369216859-心理健康宣传02.jpg\" alt=\"\" data-href=\"\" style=\"\"></p>\r\n<h2 style=\"text-align: start;\">01身体原因</h2>\r\n<p style=\"text-align: start; line-height: 2;\"><span style=\"font-size: 16px;\">    遗传因素影响显著，家族有高血压病史，后代发病风险会大幅提升；年龄增长也是关键因素，血管壁会逐渐失去弹性、变僵硬，导致血液流动阻力增大，一般来说，40 岁以后，高血压患病率明显攀升；此外，身体超重、肥胖，体内脂肪堆积，小动脉硬化，会促使外周血管阻力增加，引发血压上升。</span></p>\r\n<h2 style=\"text-align: start;\">02生活方式</h2>\r\n<p style=\"text-align: start; line-height: 2;\"><span style=\"font-size: 16px;\">    高盐饮食使人体的血容量增加，加重心脏与血管负担，每日摄入钠盐超过 5 克就会埋下隐患；长期过量饮酒，酒精刺激血管收缩，还干扰体内激素平衡，易诱发血压波动；抽烟则让血管内皮受损，加速动脉粥样硬化进程，提升高血压发病几率；缺乏运动、长期精神紧张焦虑，身体会分泌肾上腺素等激素，致使心跳加快、血管收缩，推动血压升高。</span></p>\r\n<h2 style=\"text-align: start;\">03药物与疾病关联</h2>\r\n<p style=\"text-align: start; line-height: 2;\"><span style=\"font-size: 16px;\">    某些药物，比如避孕药、类固醇、某些抗抑郁药物，会干扰身体的激素或体液平衡，引发血压上升；肾脏疾病、内分泌疾病（如原发性醛固酮增多症）、心血管疾病等，或是影响肾脏排水排钠功能，或是改变激素调节，最终导致血压居高不下。</span></p>\r\n<h2 style=\"text-align: start;\">04症状</h2>\r\n<p style=\"text-align: start; line-height: 2;\"><span style=\"font-size: 16px;\">    部分高血压患者初期毫无症状，或仅出现偶尔头晕、头痛、心悸、耳鸣等轻微不适，所以容易被忽视。当血压突然急剧升高，可能造成剧烈头痛、视力模糊、鼻出血、胸闷胸痛等较为严重的症状。</span></p>\r\n<h2 style=\"text-align: start;\">05危害</h2>\r\n<p style=\"text-align: start; line-height: 2;\"><span style=\"font-size: 16px;\">    血压长期过高，会对心脏、大脑、肾脏、眼睛等重要器官都造成损伤。在心脏方面，引发左心室肥厚、扩大，逐步发展成心力衰竭，还会提高冠心病、心律失常的发病风险；作用于脑血管，微小动脉瘤破裂可致脑出血，粥样硬化斑块脱落堵塞血管，会诱发脑梗死；累及肾脏，会破坏肾脏的滤过功能，严重时引发肾衰竭；影响眼睛，造成视网膜病变，视力下降甚至失明。</span></p>\r\n', '2025-02-15 17:33:55', 10);
INSERT INTO `propagate` VALUES (4, 2, '把血压控制在这个数，大大降低风险！记住这几个小方法', 'http://localhost:9090/files/download/测试题_痰瘀内蕴.jpg', '<h1 style=\"text-align: center;\">把血压控制在这个数，大大降低风险！记住这几个小方法</h1>\r\n<p style=\"text-align: center;\"><img src=\"http://localhost:9090/files/download/1728369216859-心理健康宣传02.jpg\" alt=\"\" data-href=\"\" style=\"\"></p>\r\n<h2 style=\"text-align: start;\">坚持运动</h2>\r\n<p style=\"text-align: start; line-height: 2;\"><span style=\"font-size: 16px;\">    对于高血压患者，运动降压确实有效。《中国高血压防治指南（2024年修订版）》推荐对于血压控制良好的高血压患者，推荐以有氧运动为主、抗阻运动为辅的混合训练，也建议同时结合呼吸训练与柔韧性和拉伸训练②，例如快走、慢跑、游泳、自行车、健身操、跳绳等。</span></p>\r\n<h2 style=\"text-align: start;\">低钠饮食</h2>\r\n<p style=\"text-align: start; line-height: 2;\"><span style=\"font-size: 16px;\">    2022年，《中国循环杂志》上发表了一项研究显示，把家里的盐换成低钠盐，每年能减少100万人死亡③。低钠盐是在普通食盐（氯化钠含量 90%～99%）中混入一定比例、同样具有咸味的氯化钾，减少钠的摄入。不过低钠盐中含有钾，对于肾病、血钾高的人群并不适合。</span></p>\r\n<h2 style=\"text-align: start;\">少油低脂</h2>\r\n<p style=\"text-align: start; line-height: 2;\"><span style=\"font-size: 16px;\">    日常饮食中，可以多食用全谷物、水果、蔬菜和低脂乳制品，减少如油炸、奶油等含饱和脂肪和胆固醇的饮食摄入，有助于降低血压。</span></p>\r\n<h2 style=\"text-align: start;\">控制体重</h2>\r\n<p style=\"text-align: start; line-height: 2;\"><span style=\"font-size: 16px;\">    2021年，梅奥诊所发布了药物以外的降压方法，其中就提到了控制体重与腰围④。当一个人超重或肥胖时，减肥往往是控制血压最有效的办法之一，哪怕只是减去一点体重。除了体重，还应重视腰围，过多的腰部赘肉也会增加高血压风险。</span></p>\r\n<h2 style=\"text-align: start;\">充足睡眠</h2>\r\n<p style=\"text-align: start; line-height: 2;\"><span style=\"font-size: 16px;\">    2023年《高血压》杂志发表了一项研究发现，入睡困难、睡眠中断和睡眠时间短均与高血压风险较高相关⑤。与每天睡眠7-8小时相比，报告睡眠时间更短的人，高血压风险显著增加；而且，存在入睡困难或睡眠中断、早醒的人，高血压风险明显更高。</span></p>\r\n<h2 style=\"text-align: start;\">远离烟酒</h2>\r\n<p style=\"text-align: start; line-height: 2;\"><span style=\"font-size: 16px;\">    吸烟会导致血压升高，心率也会升高。烟草中的化学物质会损坏血管壁，引起血管炎症、硬化，并收缩动脉血管，动脉硬化会导致血压升高。而且二手烟、三手烟也会影响血管。饮酒也是导致高血压的重要因素之一。喜好烟酒的高血压患者，尽量戒掉为好。</span></p>\r\n<h2 style=\"text-align: start;\">良好心态</h2>\r\n<p style=\"text-align: start; line-height: 2;\"><span style=\"font-size: 16px;\">    如果心态不好，经常愤怒、暴躁、紧张、焦虑，就容易导致交感神经兴奋，引起血压升高。所以，尽量保持良好心态有利于血压的控制。</span></p>\r\n\r\n\r\n\r\n', '2025-02-15 17:36:44', 41);
INSERT INTO `propagate` VALUES (5, 3, '世界高血压日：提高公众对高血压的认识与预防', 'http://localhost:9090/files/download/1743253568472-R.jpg', '<h1 style=\"text-align: center;\">慢性病防治正确认识高血压</h1>\r\n<p style=\"text-align: start; line-height: 2;\"><span style=\"font-size: 16px;\">    每年的5月17日是世界高血压日，这一天旨在提高全球公众对高血压的认识，并提醒人们关注这一常见的健康问题。高血压被誉为“沉默的杀手”，因为它在早期往往没有明显的症状，但如果得不到有效控制，可能会导致心脏病、脑卒中、肾衰竭等严重健康问题。世界高血压日的设立，不仅让人们意识到高血压的危害，更重要的是鼓励大家采取有效的预防和治疗措施。</span></p>\r\n<p style=\"text-align: center;\"><img src=\"http://localhost:9090/files/download/1728369216859-心理健康宣传02.jpg\" alt=\"\" data-href=\"\" style=\"\"></p>\r\n<h2 style=\"text-align: start;\">一、高血压的全球流行状况</h2>\r\n<p style=\"text-align: start; line-height: 2;\"><span style=\"font-size: 16px;\">    高血压是一种常见的慢性病，全球约有13亿人患有高血压。根据世界卫生组织（WHO）的统计，高血压是全球死亡和残疾的主要原因之一。尽管它在发病初期可能没有明显症状，但其对健康的影响却极为深远，长期高血压会导致心血管疾病、脑卒中、肾衰竭等并发症的发生。而且，随着人们生活方式的改变和人口老龄化，高血压的患病率呈逐年上升趋势，已成为全球健康面临的重要挑战。</span></p>\r\n<h2 style=\"text-align: start;\">二、高血压的危害</h2>\r\n<p style=\"text-align: start; line-height: 2;\"><span style=\"font-size: 16px;\">    高血压的危害不容忽视。它是导致心脏病、脑卒中、肾脏疾病等重大疾病的重要原因。高血压会增加心脏的负担，导致心脏肥大，最终可能引发心力衰竭；它还会损伤血管壁，促进动脉硬化，进一步增加心脑血管事件的风险。此外，长期高血压还可能引起眼底出血、视力丧失等问题，甚至对肾脏造成不可逆的损害，导致肾功能衰竭。因此，高血压的控制与管理，直接关系到人们的健康与生活质量。</span></p>\r\n<h2 style=\"text-align: start;\">三、为什么要重视高血压的防治</h2>\r\n<p style=\"text-align: start; line-height: 2;\"><span style=\"font-size: 16px;\">    虽然高血压的危害巨大，但它是一种可以通过早期筛查、生活方式改变以及药物治疗来有效预防和控制的疾病。许多人并未意识到自己已经患有高血压，因为它通常在初期没有明显症状。然而，如果不进行干预，血压长期升高将给健康带来不可逆的损害。因此，定期监测血压对于高血压的早期发现至关重要。世界高血压日的目标就是提高公众对高血压的认识，普及高血压的防治知识，让更多的人关注自己的血压状况，及时采取措施进行干预。通过定期检测血压，及早发现异常，能够有效降低高血压的危害，防止严重并发症的发生。</span></p>\r\n<h3 style=\"text-align: start;\">四、高血压的预防与控制</h3>\r\n<p style=\"text-align: start; line-height: 2;\"><span style=\"font-size: 16px;\">    高血压的防治不仅仅依赖药物治疗，更多的是通过健康的生活方式来控制血压。首先，合理饮食是预防高血压的重要措施。减少盐的摄入、增加蔬菜水果的摄入，保持饮食清淡，避免高脂肪、高糖分的食物。其次，保持适当的体重和进行规律运动，尤其是有氧运动，如快走、跑步、游泳等，可以增强心血管功能，帮助降低血压。此外，戒烟限酒也是预防高血压的重要手段。吸烟和过度饮酒都容易导致血管收缩，增加心脏负担，从而升高血压。保持充足的睡眠，减少心理压力，避免情绪波动，也是控制血压的重要方面。心理压力和焦虑不仅会导致血压升高，还可能影响心血管健康，因此，学会放松和管理压力，对预防高血压至关重要。</span></p>\r\n<h4 style=\"text-align: start;\">五、世界高血压日的倡导与行动</h4>\r\n<p style=\"text-align: start; line-height: 2;\"><span style=\"font-size: 16px;\">    每年的世界高血压日都有一个特定的主题，旨在促进公众对高血压的关注和采取相应行动。例如，近年来的主题涉及高血压的早期检测、健康饮食、心理压力管理等方面。世界高血压日的活动形式多样，包括健康讲座、义诊、血压测量等，鼓励人们主动参与，关注自己的健康状况。此外，世界高血压日还呼吁全球政府和公共卫生组织加强对高血压防治工作的投入，尤其是在低收入和中等收入国家，通过改善基础设施、普及健康教育、加强早期筛查等手段，减少高血压的负担。</span></p>\r\n<h4 style=\"text-align: start;\">结语</h4>\r\n<p style=\"text-align: start; line-height: 2;\"><span style=\"font-size: 16px;\">    高血压是一种可以通过有效预防和管理来控制的疾病，而世界高血压日则为我们提供了一个重要的契机，提醒我们关注健康、定期监测血压，并通过健康的生活方式减少患病风险。通过科学的饮食、适量的运动、良好的作息和情绪管理，我们每个人都可以为自己的健康保驾护航。让我们在世界高血压日的号召下，行动起来，共同预防高血压，降低其对人类健康的威胁。</span></p>\r\n', '2025-02-15 17:39:38', 17);

-- ----------------------------
-- Table structure for reservation
-- ----------------------------
DROP TABLE IF EXISTS `reservation`;
CREATE TABLE `reservation`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` int(0) NULL DEFAULT NULL COMMENT '用户ID',
  `doctor_id` int(0) NULL DEFAULT NULL COMMENT '医生ID',
  `start` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '开始时间',
  `end` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '结束时间',
  `question` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '问题描述',
  `time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '申请时间',
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '审批状态',
  `reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '拒绝理由（拒绝审核时填写）',
  `suggestion` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '问诊建议（审核通过时填写）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '预约信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of reservation
-- ----------------------------
INSERT INTO `reservation` VALUES (1, 1, 4, '2024-11-13 18:41:31', '2024-11-13 20:41:31', '我最近有点抑郁，想找您聊聊', '2024-11-12 20:41:53', '审核通过', NULL, NULL);
INSERT INTO `reservation` VALUES (2, 1, 1, '2024-11-14 20:53:39', '2024-11-14 21:53:39', '我想和您聊聊', '2024-11-12 20:53:56', '已结束', NULL, NULL);
INSERT INTO `reservation` VALUES (4, 1, 1, '2025-02-15 21:44:25', '2025-03-16 21:44:25', '想你了', '2025-02-15 21:44:54', '审核拒绝', '？', NULL);
INSERT INTO `reservation` VALUES (5, 1, 1, '2025-02-16 00:00:00', '2025-02-17 00:00:00', '头痛', '2025-02-16 17:14:46', '待审核', NULL, NULL);
INSERT INTO `reservation` VALUES (6, 2, 1, '2025-02-16 17:27:04', '2025-03-16 18:27:04', '口干舌燥，苔薄白', '2025-02-16 17:28:20', '待审核', NULL, NULL);
INSERT INTO `reservation` VALUES (7, 1, 2, '2025-04-13 23:19:34', '2025-04-13 23:19:34', '医生你好，我想向您咨询一下我的高血压问题', '2025-04-13 23:19:34', '审核通过', NULL, NULL);

-- ----------------------------
-- Table structure for sideshow
-- ----------------------------
DROP TABLE IF EXISTS `sideshow`;
CREATE TABLE `sideshow`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '封面',
  `propagate_id` int(0) NULL DEFAULT NULL COMMENT '健康宣传ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '轮播图信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sideshow
-- ----------------------------
INSERT INTO `sideshow` VALUES (1, 'http://localhost:9090/files/download/1745237621433-1740933692137-OIP.jpg', 1);
INSERT INTO `sideshow` VALUES (2, 'http://localhost:9090/files/download/1745237655938-1740933698478-OIP-C.jpg', 2);
INSERT INTO `sideshow` VALUES (3, 'http://localhost:9090/files/download/1745237693517-manxingbfz.jpg', 3);

-- ----------------------------
-- Table structure for test_paper
-- ----------------------------
DROP TABLE IF EXISTS `test_paper`;
CREATE TABLE `test_paper`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '试卷名称',
  `img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '试卷封面',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '试卷介绍',
  `type_id` int(0) NULL DEFAULT NULL COMMENT '分类ID',
  `doctor_id` int(0) NULL DEFAULT NULL COMMENT '医生ID',
  `num` int(0) NULL DEFAULT NULL COMMENT '题目数量',
  `score` int(0) NULL DEFAULT NULL COMMENT '试卷总分',
  `ids` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '所有题目ID',
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '试卷状态',
  `test_num` int(0) NULL DEFAULT 0 COMMENT '测试人数',
  `time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '创建时间',
  `a_range` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '底部区间',
  `b_range` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '中部区间',
  `c_range` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '顶部区间',
  `a_answer` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '底部解答',
  `b_answer` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '中部解答',
  `c_answer` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '顶部解答',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '发布问卷表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of test_paper
-- ----------------------------
INSERT INTO `test_paper` VALUES (7, '测试题_肝阳上亢', 'http://localhost:9090/files/download/测试题_肝阳上亢.jpg', '此类高血压通常伴随头痛、眩晕、面红目赤、易怒等症状。患者常感到脾气急躁、焦虑，且有耳鸣、睡眠不安等表现。通过评估这些症状的严重程度，可以帮助判断肝阳上亢的高血压风险。', 1, 2, 10, 100, '[69,73,74,77,72,71,75,78,70,76]', '审核通过', 3, '2025-02-16 11:11:57', '0~40', '41~70', '71~100', '很少有肝阳上亢型高血压的风险', 'y中等风险患肝阳上亢型高血压的风险', '可能存在肝阳上亢型高血压的风险');
INSERT INTO `test_paper` VALUES (8, '测试题_肝肾阴虚', 'http://localhost:9090/files/download/测试题_肝肾阴虚.jpg', '肝肾阴虚型高血压表现为乏力、腰膝酸软、耳鸣、失眠等症状。此类患者常感到体力不支、精神萎靡，且容易出现水肿、记忆力减退等问题。通过评估这些症状来判断肝肾两虚的可能性。', 2, 2, 10, 100, '[80,82,88,87,84,86,83,79,81,85]', '审核通过', 3, '2025-02-16 16:01:04', '0~40', '41~70', '71~100', '你有很小概率为肝肾阴虚型高血压', '你有中等概率为肝肾阴虚型高血压', '可能存在肝肾阴虚型高血压的风险');
INSERT INTO `test_paper` VALUES (9, '测试题_阴阳两虚', 'http://localhost:9090/files/download/1739692948443-OIP.jpg', '该类型的高血压通常表现为手脚冰凉、疲劳、浮肿、气短等症状。患者常感到体力和精神双重疲惫，且容易感到寒冷、失眠等。此问卷帮助评估阴阳两虚的体质及其与高血压的关系。', 3, 1, 10, 100, '[96,93,92,90,94,97,95,91,98,89]', '审核通过', 1, '2025-02-16 16:03:40', '0~40', '41~70', '71~100', '您有很小概率为阴阳两虚型高血压', '您有中等概率为阴阳两虚型高血压', '可能存在阴阳两虚型高血压的风险');
INSERT INTO `test_paper` VALUES (10, '测试题_痰瘀内蕴', 'http://localhost:9090/files/download/测试题_痰瘀内蕴.jpg', ' 痰瘀内蕴型高血压多见于身体沉重、胸闷、头晕、水肿等症状。患者可能有消化不良、体重增加等问题，且常伴有胸口压迫感。此问卷帮助评估痰湿、血瘀的可能性以及它们对高血压的影响。', 4, 3, 10, 100, '[99,101,106,102,105,108,103,100,107,104]', '审核通过', 0, '2025-02-16 16:06:09', '0~40', '41~70', '71~100', '您有很低概率为痰瘀内蕴型高血压', '您有中等概率为痰瘀内蕴型高血压', '可能存在痰瘀内蕴型高血压的风险');
INSERT INTO `test_paper` VALUES (11, '测试题_瘀血内停', 'http://localhost:9090/files/download/测试题_瘀血内停.jpg', '瘀血内停型高血压表现为头痛、胸闷、下肢浮肿、面色暗沉等症状。患者常感到疲劳、便秘、手脚麻木，舌质可能出现暗红或紫点。通过评估这些症状，可以帮助识别瘀血内停型高血压的风险。', 5, 4, 10, 100, '[112,110,116,109,115,114,113,118,117,111]', '审核通过', 3, '2025-02-16 16:08:45', '0~40', '41~70', '71~100', '您有很小概率为瘀血内停型高血压', '您有中等概率为瘀血内停型高血压', '可能存在瘀血内停型高血压的风险');

-- ----------------------------
-- Table structure for test_record
-- ----------------------------
DROP TABLE IF EXISTS `test_record`;
CREATE TABLE `test_record`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `test_paper_id` int(0) NULL DEFAULT NULL COMMENT '测试卷ID',
  `user_id` int(0) NULL DEFAULT NULL COMMENT '用户ID',
  `doctor_id` int(0) NULL DEFAULT NULL COMMENT '医生ID',
  `score` int(0) NULL DEFAULT NULL COMMENT '分数',
  `result` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '测试结果',
  `time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '测试时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '测试记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of test_record
-- ----------------------------
INSERT INTO `test_record` VALUES (2, 3, 2, 2, 50, '您的智力属于正常水平，巴拉巴拉', '2024-11-10 21:37:58');
INSERT INTO `test_record` VALUES (3, 2, 2, 1, 54, '您在人际交往中属于内向型人格，巴拉巴拉', '2024-11-11 21:39:10');
INSERT INTO `test_record` VALUES (4, 3, 1, 2, 0, '您的智力可能比较低下，巴拉巴拉', '2024-11-11 21:58:55');
INSERT INTO `test_record` VALUES (5, 3, 3, 2, 30, '您的智力可能比较低下，巴拉巴拉', '2024-11-12 22:35:14');
INSERT INTO `test_record` VALUES (6, 5, 1, 2, 54, '个性独特', '2025-02-11 10:50:27');
INSERT INTO `test_record` VALUES (7, 6, 1, 1, 10, '您有很大概率属于这个证型', '2025-02-15 21:39:37');
INSERT INTO `test_record` VALUES (8, 11, 1, 4, 48, '您有中等概率为瘀血内停型高血压', '2025-02-16 17:13:11');
INSERT INTO `test_record` VALUES (9, 9, 2, 1, 75, '可能存在阴阳两虚型高血压的风险', '2025-02-16 17:26:56');
INSERT INTO `test_record` VALUES (10, 8, 1, 2, 97, '可能存在肝肾阴虚型高血压的风险', '2025-02-24 22:13:24');
INSERT INTO `test_record` VALUES (11, 7, 1, 2, 79, '可能存在肝阳上亢型高血压的风险', '2025-02-24 22:16:23');
INSERT INTO `test_record` VALUES (12, 8, 1, 2, 94, '可能存在肝肾阴虚型高血压的风险', '2025-02-25 21:03:57');
INSERT INTO `test_record` VALUES (13, 8, 1, 2, 91, '可能存在肝肾阴虚型高血压的风险', '2025-03-09 09:54:35');
INSERT INTO `test_record` VALUES (14, 11, 1, 4, 100, '可能存在瘀血内停型高血压的风险', '2025-03-09 09:56:06');
INSERT INTO `test_record` VALUES (15, 7, 1, 2, 100, '可能存在肝阳上亢型高血压的风险', '2025-03-09 09:57:23');
INSERT INTO `test_record` VALUES (16, 7, 2, 2, 76, '可能存在肝阳上亢型高血压的风险', '2025-03-09 09:59:23');

-- ----------------------------
-- Table structure for topic
-- ----------------------------
DROP TABLE IF EXISTS `topic`;
CREATE TABLE `topic`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '题目名称',
  `type_id` int(0) NULL DEFAULT NULL COMMENT '分类ID',
  `a_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '选项A',
  `a_score` int(0) NULL DEFAULT NULL COMMENT '选项A分数',
  `b_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '选项B',
  `b_score` int(0) NULL DEFAULT NULL COMMENT '选项B分数',
  `c_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '选项C',
  `c_score` int(0) NULL DEFAULT NULL COMMENT '选项C分数',
  `d_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '选项D',
  `d_score` int(0) NULL DEFAULT NULL COMMENT '选项D分数',
  `score` int(0) NULL DEFAULT NULL COMMENT '最高分数',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 119 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '题目信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of topic
-- ----------------------------
INSERT INTO `topic` VALUES (69, '您通常会感到头晕、头痛吗？', 1, '很少或没有', 0, '偶尔感到头晕、头痛', 4, '经常感到头晕、头痛', 7, '常常头晕、头痛且伴随恶心', 10, NULL);
INSERT INTO `topic` VALUES (70, '您的脾气如何？', 1, '比较平和', 0, '有时情绪波动', 4, '比较容易急躁或生气', 7, '常常急躁易怒，情绪不稳', 10, NULL);
INSERT INTO `topic` VALUES (71, '您的睡眠质量如何？', 1, '良好，早睡早起', 0, '有时入睡困难或易醒', 4, '经常失眠或多梦', 7, '睡眠浅、易醒且常伴随烦躁', 10, NULL);
INSERT INTO `topic` VALUES (72, '您是否经常感觉眼睛干涩、眼花或视力模糊？', 1, '很少', 0, '偶尔感到眼睛不适', 4, '经常出现眼睛干涩或眼花', 7, '经常眼睛干涩、头昏眼花，甚至视力模糊', 10, NULL);
INSERT INTO `topic` VALUES (73, '您的饮食习惯如何？', 1, '喜欢清淡的食物，避免辛辣刺激', 0, '偶尔食用辛辣或油腻食物', 4, '经常喜欢吃辛辣、油腻的食物', 7, '常常暴饮暴食，喜欢重口味食物', 10, NULL);
INSERT INTO `topic` VALUES (74, '您是否有便秘的症状？', 1, '很少便秘，排便正常', 0, '偶尔便秘', 4, '经常便秘', 7, '常常便秘且有腹胀感', 10, NULL);
INSERT INTO `topic` VALUES (75, '您是否容易出现耳鸣或听力下降？', 1, '很少', 0, '偶尔感到耳鸣', 4, '经常耳鸣或听力下降', 7, '常常耳鸣、听力严重下降', 10, NULL);
INSERT INTO `topic` VALUES (76, '您是否有经常性口干、口渴的感觉？', 1, '很少', 0, '偶尔口干或口渴', 4, '经常口干、口渴', 7, '经常口干、口渴且喝水量大', 10, NULL);
INSERT INTO `topic` VALUES (77, '您的面色如何？', 1, '比较正常', 0, '偶尔脸红或脸色不均', 4, '经常脸红或脸色潮红', 7, '面色潮红，尤其是情绪波动时', 10, NULL);
INSERT INTO `topic` VALUES (78, '您是否感到头部有明显的胀痛或压迫感？', 1, '很少或没有', 0, '偶尔有头部胀痛感', 4, '经常感到头部胀痛或压迫', 7, '常常感到头部胀痛、压迫，且影响日常活动', 10, NULL);
INSERT INTO `topic` VALUES (79, '您是否感到腰膝酸软、无力？', 2, '很少或没有', 0, '偶尔感到腰膝酸软', 4, '经常感到腰膝酸软、无力', 7, '经常感到腰膝酸软、无力且活动困难', 10, NULL);
INSERT INTO `topic` VALUES (80, '您是否经常出现失眠、多梦的情况？', 2, '很少或没有', 0, '偶尔失眠或多梦', 4, '经常失眠、早醒或多梦', 7, '每晚都难以入睡，且容易醒来', 10, NULL);
INSERT INTO `topic` VALUES (81, '您的耳朵是否经常感到耳鸣或听力下降？', 2, '很少', 0, '偶尔耳鸣', 4, '经常耳鸣或听力模糊', 7, '持续耳鸣，且听力显著下降', 10, NULL);
INSERT INTO `topic` VALUES (82, '您的头发是否出现脱发、发质变差的情况？', 2, '很少或没有', 0, '偶尔掉发', 4, '经常掉发，发质变差', 7, '脱发严重，头发稀疏或干枯', 10, NULL);
INSERT INTO `topic` VALUES (83, '您是否感到眩晕、头晕，尤其在劳累后加重？', 2, '很少', 0, '偶尔眩晕、头晕', 4, '经常眩晕、头晕，尤其在疲劳时', 7, '常常感到眩晕、头晕，特别是在起身或活动时', 10, NULL);
INSERT INTO `topic` VALUES (84, '您是否经常感到手脚冰凉，尤其是在晚上？', 2, '很少', 0, '偶尔感到手脚冰凉', 4, '经常手脚冰凉，尤其在寒冷天气', 7, '常常手脚冰凉，即使在温暖的环境中也感到不适', 10, NULL);
INSERT INTO `topic` VALUES (85, '您是否容易感到疲劳、乏力？', 2, '很少', 0, '偶尔感到疲劳', 4, '经常感到疲劳、乏力', 7, '经常感到严重的疲劳，难以恢复', 10, NULL);
INSERT INTO `topic` VALUES (86, '您是否有消化不良、食欲不振的症状？', 2, '很少', 0, '偶尔食欲不振', 4, '经常食欲不振，感觉胃口不好', 7, '常常食欲不振，消化不良，体重减轻', 10, NULL);
INSERT INTO `topic` VALUES (87, '您的面色如何？', 2, '比较红润，气色较好', 0, '偶尔面色苍白或暗沉', 4, '经常面色苍白，气色差', 7, '面色苍白、无光泽，皮肤干燥', 10, NULL);
INSERT INTO `topic` VALUES (88, '您的睡眠质量如何？', 2, '良好，早睡早起', 0, '偶尔失眠或容易醒', 4, '经常失眠，入睡困难', 7, '常常整夜难以入睡，早醒且难以再入睡', 10, NULL);
INSERT INTO `topic` VALUES (89, '您是否经常感到手脚冰凉，尤其是寒冷天气下？', 3, '很少或没有', 0, '偶尔感到手脚冰凉', 4, '经常手脚冰凉', 7, '常常手脚冰凉，难以取暖', 10, NULL);
INSERT INTO `topic` VALUES (90, '您是否常常感到疲劳、乏力，尤其是早晨起床后？', 3, '很少', 0, '偶尔感到疲劳', 4, '经常感到疲劳、乏力', 7, '每天都感到极度疲劳，几乎不能恢复', 10, NULL);
INSERT INTO `topic` VALUES (91, '您的体重是否有明显变化，尤其是感觉水肿或浮肿？', 3, '很少', 0, '偶尔出现浮肿', 4, '经常浮肿，尤其是早晨起床时', 7, '每天浮肿，尤其是腿部和眼睑', 10, NULL);
INSERT INTO `topic` VALUES (92, '您的面色如何？', 3, '气色较好，面色红润', 0, '偶尔面色苍白或暗沉', 4, '经常面色苍白或发黄', 7, '面色非常苍白，气色差', 10, NULL);
INSERT INTO `topic` VALUES (93, '您是否感到胸闷、气短，尤其是活动后加重？', 3, '很少', 0, '偶尔感到气短或胸闷', 4, '经常气短、胸闷，尤其在运动后', 7, '常常感到气短、胸闷，甚至休息时也有', 10, NULL);
INSERT INTO `topic` VALUES (94, '您是否容易出现心悸、胸口疼痛或不适的感觉？', 3, '很少', 0, '偶尔感到心悸或胸口不适', 4, '经常心悸、胸口不适', 7, '常常心悸或胸口疼痛，且严重影响生活', 10, NULL);
INSERT INTO `topic` VALUES (95, '您的睡眠质量如何？', 3, '良好，容易入睡且睡得深', 0, '偶尔入睡困难或易醒', 4, '经常入睡困难，容易醒来', 7, '每晚都很难入睡，睡眠质量差', 10, NULL);
INSERT INTO `topic` VALUES (96, '您是否有口干、口渴的感觉，特别是晚上？', 3, '很少', 0, '偶尔口干、口渴', 4, '经常口干、口渴', 7, '常常口干、口渴，尤其在夜间', 10, NULL);
INSERT INTO `topic` VALUES (97, '您是否经常感到精神不集中或记忆力减退？', 3, '很少', 0, '偶尔感到精神不集中', 4, '经常感到注意力不集中、记忆力差', 7, '每天都感到记忆力减退，难以集中注意力', 10, NULL);
INSERT INTO `topic` VALUES (98, '您是否感到身体发凉，尤其是晚间或休息时？', 3, '很少', 0, '偶尔感到身体发凉', 4, '经常感到身体发凉，特别是夜间', 7, '常常感到全身发凉，甚至需要加衣物', 10, NULL);
INSERT INTO `topic` VALUES (99, '您是否经常感到身体沉重，尤其是下肢或四肢？', 4, '很少或没有', 0, '偶尔感到身体沉重', 4, '经常感到身体沉重，尤其是下肢', 7, '常常感到四肢沉重，甚至行动不便', 10, NULL);
INSERT INTO `topic` VALUES (100, '您是否容易感到头晕、头重或有一种“脑袋发胀”的感觉？', 4, '很少', 0, '偶尔感到头晕、头重', 4, '经常感到头晕、头重，伴随恶心', 7, '常常头晕、头重，甚至影响正常工作', 10, NULL);
INSERT INTO `topic` VALUES (101, '您的胸部是否感到闷胀或压迫感，尤其是在体力活动后？', 4, '很少', 0, '偶尔感到胸部不适', 4, '经常胸部闷胀、压迫感', 7, '常常感到胸部闷胀、压迫，呼吸困难', 10, NULL);
INSERT INTO `topic` VALUES (102, '您是否经常感到恶心或胃口不佳，尤其是在早晨？', 4, '很少', 0, '偶尔恶心或食欲不振', 4, '经常恶心、胃口不佳', 7, '每天早晨都感到恶心，食欲差', 10, NULL);
INSERT INTO `topic` VALUES (103, '您是否有水肿的现象，尤其是双腿或脚踝部位？', 4, '很少', 0, '偶尔出现浮肿', 4, '经常浮肿，尤其是晚上', 7, '每天都有明显的浮肿，特别是在下肢', 10, NULL);
INSERT INTO `topic` VALUES (104, '您是否容易感到心悸、胸口不适或有胸闷的症状？', 4, '很少', 0, '偶尔感到心悸或胸闷', 4, '经常心悸、胸口不适', 7, '常常心悸、胸闷，甚至有胸痛感', 10, NULL);
INSERT INTO `topic` VALUES (105, '您的大便是否偏于干燥、困难排出？', 4, '很少', 0, '偶尔便秘或大便干燥', 4, '经常便秘，大便干结', 7, '每天都有便秘或大便非常干燥', 10, NULL);
INSERT INTO `topic` VALUES (106, '您是否有头痛的症状，特别是早晨或晚上？', 4, '很少', 0, '偶尔头痛', 4, '经常头痛，尤其是早晨', 7, '每天都感到头痛，且常伴随眩晕', 10, NULL);
INSERT INTO `topic` VALUES (107, '您的体重是否有明显增加，且难以减轻？', 4, '很少体重增加', 0, '偶尔体重有所增加', 4, '经常体重增加，尤其在下半身', 7, '体重增加明显，且难以控制', 10, NULL);
INSERT INTO `topic` VALUES (108, '您的舌苔如何？', 4, '舌苔薄，颜色正常', 0, '舌苔略厚，偶有黄腻', 4, '舌苔较厚，带有黄腻感', 7, '舌苔非常厚，颜色暗黄，且伴随粘腻感', 10, NULL);
INSERT INTO `topic` VALUES (109, '您是否经常感到胸部沉闷或压迫感，尤其是在情绪激动时？', 5, '很少或没有', 0, '偶尔感到胸部不适', 4, '经常感到胸部沉闷、压迫感', 7, '常常胸部沉闷，呼吸困难，影响日常活动', 10, NULL);
INSERT INTO `topic` VALUES (110, '您是否有头痛的症状，特别是头痛剧烈或持续时间较长？', 5, '很少', 0, '偶尔头痛', 4, '经常头痛，且疼痛较剧烈', 7, '常常头痛，尤其是早晨起床时或夜间', 10, NULL);
INSERT INTO `topic` VALUES (111, '您的面色如何？', 5, '面色红润，气色较好', 0, '面色偶尔较暗或偏黄', 4, '面色偏暗，气色不佳', 7, '面色晦暗，常显苍白或青紫', 10, NULL);
INSERT INTO `topic` VALUES (112, '您是否有手脚麻木或刺痛的症状？', 5, '很少或没有', 0, '偶尔感到手脚麻木或刺痛', 4, '经常手脚麻木或刺痛', 7, '常常感到手脚麻木，尤其是在长时间不活动后', 10, NULL);
INSERT INTO `topic` VALUES (113, '您是否容易感到疲劳或乏力，尤其在活动后加重？', 5, '很少', 0, '偶尔感到疲劳', 4, '经常感到疲劳，活动后加重', 7, '每天都感到极度疲劳，且休息后也难以恢复', 10, NULL);
INSERT INTO `topic` VALUES (114, '您的大便是否有干燥、困难排出或便秘的现象？', 5, '很少', 0, '偶尔便秘或排便困难', 4, '经常便秘，大便干燥', 7, '每天都有便秘，且大便非常干燥', 10, NULL);
INSERT INTO `topic` VALUES (115, '您是否经常感到下肢沉重或浮肿？', 5, '很少', 0, '偶尔下肢沉重或浮肿', 4, '经常下肢沉重，尤其是长时间站立后', 7, '每天都有明显的下肢浮肿，尤其在傍晚', 10, NULL);
INSERT INTO `topic` VALUES (116, '您是否感到胸口有异物感，或有喘息、气短的症状？', 5, '很少', 0, '偶尔胸口不适或气短', 4, '经常感到胸口有异物感，尤其在运动后', 7, '常常胸口闷痛或气短，影响日常活动', 10, NULL);
INSERT INTO `topic` VALUES (117, '您是否有容易淤青或皮肤上出现紫色斑点的现象？', 5, '很少', 0, '偶尔出现淤青或紫斑', 4, '经常出现淤青，皮肤容易紫斑', 7, '常常出现淤青或紫斑，尤其在轻微碰撞后', 10, NULL);
INSERT INTO `topic` VALUES (118, '您是否有舌质暗红、舌面有紫点或紫斑的情况？', 5, '很少或没有', 0, '偶尔舌质暗红或有紫点', 4, '经常舌质暗红，且有紫点或紫斑', 7, '每次检查舌头都有明显的紫点或紫斑，舌质暗红', 10, NULL);

-- ----------------------------
-- Table structure for type
-- ----------------------------
DROP TABLE IF EXISTS `type`;
CREATE TABLE `type`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '分类标题',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '心理分类表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of type
-- ----------------------------
INSERT INTO `type` VALUES (1, '肝阳上亢');
INSERT INTO `type` VALUES (2, '肝肾阴虚');
INSERT INTO `type` VALUES (3, '阴阳两虚');
INSERT INTO `type` VALUES (4, '痰瘀内蕴');
INSERT INTO `type` VALUES (5, '瘀血内停');

-- ----------------------------
-- Table structure for type_add_map
-- ----------------------------
DROP TABLE IF EXISTS `type_add_map`;
CREATE TABLE `type_add_map`  (
  `typekey` int(0) NOT NULL COMMENT 'typeKey对应type中id',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'addrss与typekey两相吻合，value++',
  `value` int(0) NOT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of type_add_map
-- ----------------------------
INSERT INTO `type_add_map` VALUES (1, '厦门', 7);
INSERT INTO `type_add_map` VALUES (1, '莆田', 7);
INSERT INTO `type_add_map` VALUES (1, '漳州', 7);
INSERT INTO `type_add_map` VALUES (1, '泉州', 7);
INSERT INTO `type_add_map` VALUES (1, '宁德', 7);
INSERT INTO `type_add_map` VALUES (1, '三明', 7);
INSERT INTO `type_add_map` VALUES (1, '南平', 7);
INSERT INTO `type_add_map` VALUES (1, '龙岩', 7);
INSERT INTO `type_add_map` VALUES (2, '厦门', 9);
INSERT INTO `type_add_map` VALUES (2, '莆田', 3);
INSERT INTO `type_add_map` VALUES (2, '漳州', 7);
INSERT INTO `type_add_map` VALUES (2, '泉州', 0);
INSERT INTO `type_add_map` VALUES (2, '宁德', 0);
INSERT INTO `type_add_map` VALUES (2, '三明', 5);
INSERT INTO `type_add_map` VALUES (2, '南平', 8);
INSERT INTO `type_add_map` VALUES (2, '龙岩', 0);
INSERT INTO `type_add_map` VALUES (2, '福州', 0);
INSERT INTO `type_add_map` VALUES (3, '泉州', 1);
INSERT INTO `type_add_map` VALUES (3, '莆田', 7);
INSERT INTO `type_add_map` VALUES (3, '漳州', 0);
INSERT INTO `type_add_map` VALUES (3, '厦门', 9);
INSERT INTO `type_add_map` VALUES (3, '宁德', 3);
INSERT INTO `type_add_map` VALUES (3, '三明', 0);
INSERT INTO `type_add_map` VALUES (3, '南平', 0);
INSERT INTO `type_add_map` VALUES (3, '龙岩', 0);
INSERT INTO `type_add_map` VALUES (3, '福州', 5);
INSERT INTO `type_add_map` VALUES (4, '厦门', 9);
INSERT INTO `type_add_map` VALUES (4, '莆田', 0);
INSERT INTO `type_add_map` VALUES (4, '漳州', 0);
INSERT INTO `type_add_map` VALUES (4, '泉州', 5);
INSERT INTO `type_add_map` VALUES (4, '宁德', 8);
INSERT INTO `type_add_map` VALUES (4, '三明', 4);
INSERT INTO `type_add_map` VALUES (4, '南平', 0);
INSERT INTO `type_add_map` VALUES (4, '龙岩', 0);
INSERT INTO `type_add_map` VALUES (4, '福州', 0);
INSERT INTO `type_add_map` VALUES (5, '厦门', 10);
INSERT INTO `type_add_map` VALUES (5, '莆田', 10);
INSERT INTO `type_add_map` VALUES (5, '漳州', 10);
INSERT INTO `type_add_map` VALUES (5, '泉州', 10);
INSERT INTO `type_add_map` VALUES (5, '宁德', 10);
INSERT INTO `type_add_map` VALUES (5, '三明', 10);
INSERT INTO `type_add_map` VALUES (5, '南平', 10);
INSERT INTO `type_add_map` VALUES (5, '龙岩', 10);
INSERT INTO `type_add_map` VALUES (5, '福州', 10);

-- ----------------------------
-- Table structure for type_add_map_copy1
-- ----------------------------
DROP TABLE IF EXISTS `type_add_map_copy1`;
CREATE TABLE `type_add_map_copy1`  (
  `typekey` int(0) NOT NULL COMMENT 'typeKey对应type中id',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'addrss与typekey两相吻合，value++',
  `value` int(0) NOT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of type_add_map_copy1
-- ----------------------------
INSERT INTO `type_add_map_copy1` VALUES (1, '厦门', 0);
INSERT INTO `type_add_map_copy1` VALUES (1, '莆田', 0);
INSERT INTO `type_add_map_copy1` VALUES (1, '漳州', 0);
INSERT INTO `type_add_map_copy1` VALUES (1, '泉州', 0);
INSERT INTO `type_add_map_copy1` VALUES (1, '宁德', 0);
INSERT INTO `type_add_map_copy1` VALUES (1, '三明', 0);
INSERT INTO `type_add_map_copy1` VALUES (1, '南平', 2);
INSERT INTO `type_add_map_copy1` VALUES (1, '龙岩', 0);
INSERT INTO `type_add_map_copy1` VALUES (2, '福州', 0);
INSERT INTO `type_add_map_copy1` VALUES (2, '厦门', 0);
INSERT INTO `type_add_map_copy1` VALUES (2, '莆田', 0);
INSERT INTO `type_add_map_copy1` VALUES (2, '漳州', 0);
INSERT INTO `type_add_map_copy1` VALUES (2, '泉州', 0);
INSERT INTO `type_add_map_copy1` VALUES (2, '宁德', 0);
INSERT INTO `type_add_map_copy1` VALUES (2, '三明', 0);
INSERT INTO `type_add_map_copy1` VALUES (2, '南平', 4);
INSERT INTO `type_add_map_copy1` VALUES (2, '龙岩', 0);
INSERT INTO `type_add_map_copy1` VALUES (3, '福州', 0);
INSERT INTO `type_add_map_copy1` VALUES (3, '厦门', 0);
INSERT INTO `type_add_map_copy1` VALUES (3, '莆田', 2);
INSERT INTO `type_add_map_copy1` VALUES (3, '漳州', 0);
INSERT INTO `type_add_map_copy1` VALUES (3, '泉州', 0);
INSERT INTO `type_add_map_copy1` VALUES (3, '宁德', 0);
INSERT INTO `type_add_map_copy1` VALUES (3, '三明', 0);
INSERT INTO `type_add_map_copy1` VALUES (3, '南平', 0);
INSERT INTO `type_add_map_copy1` VALUES (3, '龙岩', 0);
INSERT INTO `type_add_map_copy1` VALUES (4, '福州', 0);
INSERT INTO `type_add_map_copy1` VALUES (4, '厦门', 0);
INSERT INTO `type_add_map_copy1` VALUES (4, '莆田', 0);
INSERT INTO `type_add_map_copy1` VALUES (4, '漳州', 0);
INSERT INTO `type_add_map_copy1` VALUES (4, '泉州', 0);
INSERT INTO `type_add_map_copy1` VALUES (4, '宁德', 0);
INSERT INTO `type_add_map_copy1` VALUES (4, '三明', 0);
INSERT INTO `type_add_map_copy1` VALUES (4, '南平', 0);
INSERT INTO `type_add_map_copy1` VALUES (4, '龙岩', 0);
INSERT INTO `type_add_map_copy1` VALUES (5, '福州', 0);
INSERT INTO `type_add_map_copy1` VALUES (5, '厦门', 0);
INSERT INTO `type_add_map_copy1` VALUES (5, '莆田', 0);
INSERT INTO `type_add_map_copy1` VALUES (5, '漳州', 0);
INSERT INTO `type_add_map_copy1` VALUES (5, '泉州', 0);
INSERT INTO `type_add_map_copy1` VALUES (5, '宁德', 0);
INSERT INTO `type_add_map_copy1` VALUES (5, '三明', 0);
INSERT INTO `type_add_map_copy1` VALUES (5, '南平', 2);
INSERT INTO `type_add_map_copy1` VALUES (5, '龙岩', 0);

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '账号',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '密码',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '姓名',
  `role` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '角色',
  `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '电话',
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '邮箱',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '头像',
  `type_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '地址',
  `age` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '年龄',
  `gender` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '性别',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 'zhangsan', '123456', '张三', 'USER', '18800009999', 'zhangsan@HTN.com', 'http://localhost:9090/files/download/zhangsan.jpeg', '厦门', '24', '男');
INSERT INTO `user` VALUES (2, 'lisi', '123456', '李四', 'USER', '19988887777', 'lisi@HTN.com', 'http://localhost:9090/files/download/lisi.jpeg', '龙岩', '22', '男');
INSERT INTO `user` VALUES (3, 'wangwu', '123456', '王五', 'USER', '18899997777', 'wangwu@HTN.com', 'http://localhost:9090/files/download/wangwu.jpeg', '南平', '23', '女');

SET FOREIGN_KEY_CHECKS = 1;
