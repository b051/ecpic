Task = require './task'

Area =
  '上海市': '0360010801'
  '北京市': '0380011201'
  '广东省': '0320011201'
  '广东省': '0330020131'
  '广东省': '0330030119'
  '广东省': '0330060114'
  '江苏省': '0361010901'
  '江苏省': '0361050113'
  '江苏省': '0361070116'
  '江苏省': '0361020111'
  '河北省': '0382010801'
  '河北省': '0382050110'
  '湖北省': '0331011001'
  '湖北省': '0331030112'
  '辽宁省': '0390020121'
  '辽宁省': '0390080113'
  '辽宁省': '0390070110'
  '辽宁省': '0390030112'
  '山东省': '0367011001'
  '山东省': '0367020113'
  '山东省': '0367071501'
  '山东省': '0367080107'
  '陕西省': '0370011601'
  '四川省': '0350011401'

Cities = 
  '广州': id: 283, parentId: 282
  '韶关': id: 284, parentId: 282
  '深圳': id: 285, parentId: 282
  '珠海': id: 286, parentId: 282
  '汕头': id: 287, parentId: 282
  '佛山': id: 288, parentId: 282
  '江门': id: 289, parentId: 282
  '湛江': id: 290, parentId: 282
  '茂名': id: 291, parentId: 282
  '肇庆': id: 292, parentId: 282
  '惠州': id: 293, parentId: 282
  '梅州': id: 294, parentId: 282
  '汕尾': id: 295, parentId: 282
  '河源': id: 296, parentId: 282
  '阳江': id: 297, parentId: 282
  '清远': id: 298, parentId: 282
  '东莞': id: 299, parentId: 282
  '中山': id: 300, parentId: 282
  '潮州': id: 301, parentId: 282
  '揭阳': id: 302, parentId: 282
  '云浮': id: 303, parentId: 282
  '高要': id: 628, parentId: 282
  '四会': id: 629, parentId: 282
  '兴宁': id: 630, parentId: 282
  '陆丰': id: 631, parentId: 282
  '阳春': id: 632, parentId: 282
  '英德': id: 633, parentId: 282
  '连州': id: 634, parentId: 282
  '普宁': id: 635, parentId: 282
  '罗定': id: 636, parentId: 282
  '增城': id: 614, parentId: 282
  '从化': id: 615, parentId: 282
  '乐昌': id: 616, parentId: 282
  '南雄': id: 617, parentId: 282
  '台山': id: 618, parentId: 282
  '开平': id: 619, parentId: 282
  '鹤山': id: 620, parentId: 282
  '恩平': id: 621, parentId: 282
  '廉江': id: 622, parentId: 282
  '雷州': id: 623, parentId: 282
  '吴川': id: 624, parentId: 282
  '高州': id: 625, parentId: 282
  '化州': id: 626, parentId: 282
  '信宜': id: 627, parentId: 282
  '杭州': id: 456, parentId: 455
  '宁波': id: 457, parentId: 455
  '温州': id: 458, parentId: 455
  '嘉兴': id: 459, parentId: 455
  '湖州': id: 460, parentId: 455
  '绍兴': id: 461, parentId: 455
  '金华': id: 462, parentId: 455
  '衢州': id: 463, parentId: 455
  '舟山': id: 464, parentId: 455
  '台州': id: 465, parentId: 455
  '丽水': id: 612, parentId: 455
  '建德': id: 591, parentId: 455
  '富阳': id: 592, parentId: 455
  '临安': id: 593, parentId: 455
  '余姚': id: 594, parentId: 455
  '慈溪': id: 595, parentId: 455
  '奉化': id: 596, parentId: 455
  '瑞安': id: 597, parentId: 455
  '乐清': id: 598, parentId: 455
  '海宁': id: 599, parentId: 455
  '平湖': id: 600, parentId: 455
  '桐乡': id: 601, parentId: 455
  '诸暨': id: 602, parentId: 455
  '上虞': id: 603, parentId: 455
  '嵊州': id: 604, parentId: 455
  '兰溪': id: 605, parentId: 455
  '义乌': id: 606, parentId: 455
  '东阳': id: 607, parentId: 455
  '永康': id: 608, parentId: 455
  '江山': id: 609, parentId: 455
  '温岭': id: 610, parentId: 455
  '临海': id: 611, parentId: 455
  '龙泉': id: 613, parentId: 455
  '南京': id: 257, parentId: 256
  '无锡': id: 258, parentId: 256
  '徐州': id: 259, parentId: 256
  '常州': id: 260, parentId: 256
  '苏州': id: 261, parentId: 256
  '南通': id: 262, parentId: 256
  '连云港': id: 263, parentId: 256
  '淮安': id: 264, parentId: 256
  '盐城': id: 265, parentId: 256
  '扬州': id: 266, parentId: 256
  '镇江': id: 267, parentId: 256
  '泰州': id: 268, parentId: 256
  '宿迁': id: 269, parentId: 256
  '江阴': id: 564, parentId: 256
  '宜兴': id: 565, parentId: 256
  '新沂': id: 566, parentId: 256
  '邳州': id: 567, parentId: 256
  '溧阳': id: 568, parentId: 256
  '金坛': id: 569, parentId: 256
  '常熟': id: 570, parentId: 256
  '张家港': id: 571, parentId: 256
  '昆山': id: 572, parentId: 256
  '吴江': id: 573, parentId: 256
  '太仓': id: 574, parentId: 256
  '启东': id: 575, parentId: 256
  '如皋': id: 576, parentId: 256
  '通州': id: 577, parentId: 256
  '海门': id: 578, parentId: 256
  '东台': id: 579, parentId: 256
  '大丰': id: 580, parentId: 256
  '仪征': id: 581, parentId: 256
  '高邮': id: 582, parentId: 256
  '江都': id: 583, parentId: 256
  '丹阳': id: 584, parentId: 256
  '扬中': id: 585, parentId: 256
  '句容': id: 586, parentId: 256
  '兴化': id: 587, parentId: 256
  '靖江': id: 588, parentId: 256
  '泰兴': id: 589, parentId: 256
  '姜堰': id: 590, parentId: 256
  '乌鲁木齐': id: 534, parentId: 533
  '克拉玛依': id: 535, parentId: 533
  '吐鲁番': id: 536, parentId: 533
  '哈密': id: 537, parentId: 533
  '昌吉回族自治州': id: 538, parentId: 533
  '昌吉': id: 539, parentId: 533
  '阜康': id: 540, parentId: 533
  '米泉': id: 541, parentId: 533
  '博尔塔拉蒙古自治州': id: 542, parentId: 533
  '博乐': id: 543, parentId: 533
  '巴音郭楞蒙古自治州': id: 544, parentId: 533
  '库尔勒': id: 545, parentId: 533
  '阿克苏': id: 546, parentId: 533
  '克孜勒苏柯尔克孜自治州': id: 547, parentId: 533
  '阿图什': id: 548, parentId: 533
  '喀什': id: 549, parentId: 533
  '和田': id: 550, parentId: 533
  '伊犁哈萨克自治州': id: 551, parentId: 533
  '伊宁': id: 552, parentId: 533
  '奎屯': id: 553, parentId: 533
  '塔城': id: 554, parentId: 533
  '乌苏': id: 555, parentId: 533
  '阿勒泰': id: 556, parentId: 533
  '石河子': id: 557, parentId: 533
  '阿拉尔': id: 558, parentId: 533
  '图木舒克': id: 559, parentId: 533
  '五家渠': id: 560, parentId: 533
  '兰州': id: 514, parentId: 513
  '嘉峪关': id: 515, parentId: 513
  '金昌': id: 516, parentId: 513
  '白银': id: 517, parentId: 513
  '天水': id: 518, parentId: 513
  '武威': id: 519, parentId: 513
  '张掖': id: 520, parentId: 513
  '平凉': id: 521, parentId: 513
  '酒泉': id: 522, parentId: 513
  '玉门': id: 523, parentId: 513
  '敦煌': id: 524, parentId: 513
  '庆阳': id: 525, parentId: 513
  '定西': id: 526, parentId: 513
  '陇南': id: 527, parentId: 513
  '临夏回族自治州': id: 528, parentId: 513
  '临夏': id: 529, parentId: 513
  '积石山保安族东乡族撒拉族': id: 530, parentId: 513
  '甘南藏族自治州': id: 531, parentId: 513
  '合作': id: 532, parentId: 513
  '银川': id: 506, parentId: 505
  '灵武': id: 507, parentId: 505
  '石嘴山': id: 508, parentId: 505
  '吴忠': id: 509, parentId: 505
  '青铜峡': id: 510, parentId: 505
  '固原': id: 511, parentId: 505
  '中卫': id: 512, parentId: 505
  '西宁': id: 496, parentId: 495
  '海北藏族自治州': id: 497, parentId: 495
  '黄南藏族自治州': id: 498, parentId: 495
  '海南藏族自治州': id: 499, parentId: 495
  '果洛藏族自治州': id: 500, parentId: 495
  '玉树藏族自治州': id: 501, parentId: 495
  '海西蒙古族藏族自治州': id: 502, parentId: 495
  '格尔木': id: 503, parentId: 495
  '德令哈': id: 504, parentId: 495
  '海口': id: 484, parentId: 483
  '三亚': id: 485, parentId: 483
  '五指山': id: 486, parentId: 483
  '琼州': id: 487, parentId: 483
  '儋州': id: 488, parentId: 483
  '文昌': id: 489, parentId: 483
  '万宁': id: 490, parentId: 483
  '东方': id: 491, parentId: 483
  '西沙群岛': id: 492, parentId: 483
  '南沙群岛': id: 493, parentId: 483
  '中沙群岛的岛礁及其海域': id: 494, parentId: 483
  '呼和浩特': id: 478, parentId: 477
  '贵阳': id: 337, parentId: 336
  '六盘水': id: 338, parentId: 336
  '遵义': id: 339, parentId: 336
  '安顺': id: 340, parentId: 336
  '铜仁地区': id: 341, parentId: 336
  '黔西南布依族苗族自治州': id: 342, parentId: 336
  '毕节地区': id: 343, parentId: 336
  '黔东南苗族侗族自治州': id: 344, parentId: 336
  '黔南布依族苗族自治州': id: 345, parentId: 336
  '昆明': id: 320, parentId: 319
  '曲靖': id: 321, parentId: 319
  '玉溪': id: 322, parentId: 319
  '保山': id: 323, parentId: 319
  '昭通': id: 324, parentId: 319
  '丽江': id: 325, parentId: 319
  '思茅': id: 326, parentId: 319
  '临沧': id: 327, parentId: 319
  '楚雄彝族自治州': id: 328, parentId: 319
  '红河哈尼族彝族自治州': id: 329, parentId: 319
  '文山壮族苗族自治州': id: 330, parentId: 319
  '西双版纳傣族自治州': id: 331, parentId: 319
  '大理白族自治州': id: 332, parentId: 319
  '德宏傣族景颇族自治州': id: 333, parentId: 319
  '怒江傈僳族自治州': id: 334, parentId: 319
  '迪庆藏族自治州': id: 335, parentId: 319
  '哈尔滨': id: 94, parentId: 93
  '齐齐哈尔': id: 95, parentId: 93
  '鸡西': id: 96, parentId: 93
  '鹤岗': id: 97, parentId: 93
  '双鸭山': id: 98, parentId: 93
  '大庆': id: 99, parentId: 93
  '伊春': id: 100, parentId: 93
  '佳木斯': id: 101, parentId: 93
  '七台河': id: 102, parentId: 93
  '牡丹江': id: 103, parentId: 93
  '黑河': id: 104, parentId: 93
  '绥化': id: 105, parentId: 93
  '大兴安岭地区': id: 106, parentId: 93
  '长春': id: 108, parentId: 107
  '吉林': id: 109, parentId: 107
  '四平': id: 110, parentId: 107
  '辽源': id: 111, parentId: 107
  '通化': id: 112, parentId: 107
  '白山': id: 113, parentId: 107
  '松原': id: 114, parentId: 107
  '白城': id: 115, parentId: 107
  '延边朝鲜族自治州': id: 116, parentId: 107
  '沈阳': id: 118, parentId: 117
  '大连': id: 119, parentId: 117
  '鞍山': id: 120, parentId: 117
  '抚顺': id: 121, parentId: 117
  '本溪': id: 122, parentId: 117
  '丹东': id: 123, parentId: 117
  '锦州': id: 124, parentId: 117
  '营口': id: 125, parentId: 117
  '阜新': id: 126, parentId: 117
  '辽阳': id: 127, parentId: 117
  '盘锦': id: 128, parentId: 117
  '铁岭': id: 129, parentId: 117
  '朝阳': id: 130, parentId: 117
  '葫芦岛': id: 131, parentId: 117
  '西安': id: 163, parentId: 162
  '铜川': id: 164, parentId: 162
  '宝鸡': id: 165, parentId: 162
  '咸阳': id: 166, parentId: 162
  '渭南': id: 167, parentId: 162
  '延安': id: 168, parentId: 162
  '汉中': id: 169, parentId: 162
  '榆林': id: 170, parentId: 162
  '安康': id: 171, parentId: 162
  '商洛': id: 172, parentId: 162
  '南宁': id: 305, parentId: 304
  '柳州': id: 306, parentId: 304
  '桂林': id: 307, parentId: 304
  '梧州': id: 308, parentId: 304
  '北海': id: 309, parentId: 304
  '防城港': id: 310, parentId: 304
  '钦州': id: 311, parentId: 304
  '贵港': id: 312, parentId: 304
  '玉林': id: 313, parentId: 304
  '百色': id: 314, parentId: 304
  '贺州': id: 315, parentId: 304
  '河池': id: 316, parentId: 304
  '来宾': id: 317, parentId: 304
  '崇左': id: 318, parentId: 304
  '成都': id: 347, parentId: 346
  '自贡': id: 348, parentId: 346
  '攀枝花': id: 349, parentId: 346
  '泸州': id: 350, parentId: 346
  '德阳': id: 351, parentId: 346
  '绵阳': id: 352, parentId: 346
  '广元': id: 353, parentId: 346
  '遂宁': id: 354, parentId: 346
  '内江': id: 355, parentId: 346
  '乐山': id: 356, parentId: 346
  '南充': id: 357, parentId: 346
  '眉山': id: 358, parentId: 346
  '宜宾': id: 359, parentId: 346
  '广安': id: 360, parentId: 346
  '达州': id: 361, parentId: 346
  '雅安': id: 362, parentId: 346
  '巴中': id: 363, parentId: 346
  '资阳': id: 364, parentId: 346
  '阿坝藏族羌族自治州': id: 365, parentId: 346
  '甘孜藏族自治州': id: 366, parentId: 346
  '凉山彝族自治州': id: 367, parentId: 346
  '南昌': id: 271, parentId: 270
  '景德镇': id: 272, parentId: 270
  '萍乡': id: 273, parentId: 270
  '九江': id: 274, parentId: 270
  '新余': id: 275, parentId: 270
  '鹰潭': id: 276, parentId: 270
  '赣州': id: 277, parentId: 270
  '吉安': id: 278, parentId: 270
  '宜春': id: 279, parentId: 270
  '抚州': id: 280, parentId: 270
  '上饶': id: 281, parentId: 270
  '合肥': id: 439, parentId: 438
  '芜湖': id: 440, parentId: 438
  '蚌埠': id: 441, parentId: 438
  '淮南': id: 442, parentId: 438
  '马鞍山': id: 443, parentId: 438
  '淮北': id: 444, parentId: 438
  '铜陵': id: 445, parentId: 438
  '安庆': id: 446, parentId: 438
  '黄山': id: 447, parentId: 438
  '滁州': id: 448, parentId: 438
  '阜阳': id: 449, parentId: 438
  '宿州': id: 450, parentId: 438
  '六安': id: 451, parentId: 438
  '亳州': id: 452, parentId: 438
  '池州': id: 453, parentId: 438
  '宣城': id: 454, parentId: 438
  '太原': id: 151, parentId: 150
  '大同': id: 152, parentId: 150
  '阳泉': id: 153, parentId: 150
  '长治': id: 154, parentId: 150
  '晋城': id: 155, parentId: 150
  '朔州': id: 156, parentId: 150
  '晋中': id: 157, parentId: 150
  '运城': id: 158, parentId: 150
  '忻州': id: 159, parentId: 150
  '临汾': id: 160, parentId: 150
  '吕梁': id: 161, parentId: 150
  '济南': id: 133, parentId: 132
  '青岛': id: 134, parentId: 132
  '淄博': id: 135, parentId: 132
  '枣庄': id: 136, parentId: 132
  '东营': id: 137, parentId: 132
  '烟台': id: 138, parentId: 132
  '潍坊': id: 139, parentId: 132
  '济宁': id: 140, parentId: 132
  '泰安': id: 141, parentId: 132
  '威海': id: 142, parentId: 132
  '日照': id: 143, parentId: 132
  '莱芜': id: 144, parentId: 132
  '临沂': id: 145, parentId: 132
  '德州': id: 146, parentId: 132
  '聊城': id: 147, parentId: 132
  '滨州': id: 148, parentId: 132
  '菏泽': id: 149, parentId: 132
  '石家庄': id: 174, parentId: 173
  '唐山': id: 175, parentId: 173
  '秦皇岛': id: 176, parentId: 173
  '邯郸': id: 177, parentId: 173
  '邢台': id: 178, parentId: 173
  '保定': id: 179, parentId: 173
  '张家口': id: 180, parentId: 173
  '承德': id: 181, parentId: 173
  '沧州': id: 182, parentId: 173
  '廊坊': id: 183, parentId: 173
  '衡水': id: 184, parentId: 173
  '郑州': id: 186, parentId: 185
  '开封': id: 187, parentId: 185
  '洛阳': id: 188, parentId: 185
  '平顶山': id: 189, parentId: 185
  '安阳': id: 190, parentId: 185
  '鹤壁': id: 191, parentId: 185
  '新乡': id: 192, parentId: 185
  '焦作': id: 193, parentId: 185
  '济源': id: 194, parentId: 185
  '濮阳': id: 195, parentId: 185
  '许昌': id: 196, parentId: 185
  '漯河': id: 197, parentId: 185
  '三门峡': id: 198, parentId: 185
  '南阳': id: 199, parentId: 185
  '商丘': id: 200, parentId: 185
  '信阳': id: 201, parentId: 185
  '周口': id: 202, parentId: 185
  '驻马店': id: 203, parentId: 185
  '武汉': id: 205, parentId: 204
  '黄石': id: 206, parentId: 204
  '十堰': id: 207, parentId: 204
  '宜昌': id: 208, parentId: 204
  '襄阳': id: 209, parentId: 204
  '鄂州': id: 210, parentId: 204
  '荆门': id: 211, parentId: 204
  '孝感': id: 212, parentId: 204
  '荆州': id: 213, parentId: 204
  '黄冈': id: 214, parentId: 204
  '咸宁': id: 215, parentId: 204
  '随州': id: 216, parentId: 204
  '恩施自治州': id: 217, parentId: 204
  '仙桃': id: 218, parentId: 204
  '潜江': id: 219, parentId: 204
  '天门': id: 220, parentId: 204
  '神农架林区': id: 221, parentId: 204
  '长沙': id: 223, parentId: 222
  '株洲': id: 224, parentId: 222
  '湘潭': id: 225, parentId: 222
  '衡阳': id: 226, parentId: 222
  '邵阳': id: 227, parentId: 222
  '岳阳': id: 228, parentId: 222
  '常德': id: 229, parentId: 222
  '张家界': id: 230, parentId: 222
  '益阳': id: 231, parentId: 222
  '郴州': id: 232, parentId: 222
  '永州': id: 233, parentId: 222
  '怀化': id: 234, parentId: 222
  '娄底': id: 235, parentId: 222
  '湘西土家族苗族自治州': id: 236, parentId: 222
  '福州': id: 468, parentId: 467
  '厦门': id: 469, parentId: 467
  '莆田': id: 470, parentId: 467
  '三明': id: 471, parentId: 467
  '泉州': id: 472, parentId: 467
  '漳州': id: 473, parentId: 467
  '南平': id: 474, parentId: 467
  '龙岩': id: 475, parentId: 467
  '宁德': id: 476, parentId: 467
  '重庆': id: 54, parentId: 54
  '天津': id: 37, parentId: 37
  '上海': id: 1, parentId: 1
  '北京': id: 19, parentId: 19

hiddenForm = 
  claim: '0.9'
  sizeType: 1
  channelType: ''
  mediumNumber: 'che-eMall-AFFLT-zhongyi-lp-banner'
  innerMediumNumber: ''
  channelNumber: 'tponline-WX-zhongyi'

class Taiping extends Task
  
  encoding: 'utf-8'
  # debug: true
  host: "http://che.cntaiping.com/"
  
  prepare: ->
    entrance = "#{@host}vehicleQuickQuote!landingloadinit.action?channel=tponline-WX-zhongyi&medium=che-eMall-AFFLT-zhongyi-lp-banner"
  
  area: ->
    city = @owner.get('city')
    province = @owner.get('province')
    levels = Cities[city]
    return if not levels
    
    for name, code of Area
      if province.search(name) >= 0 or name.search(province) >= 0
        bean =
          areaId: code
          automobileLv1Area: levels.parentId
          automobileLv2Area: levels.id
          city_i: city
        return bean
  
  emulate: (cb) ->
    @request @entrance, (err, res, body) =>
      bean = @area()
      return cb?() if not bean
      
      extraInfo =
        buyDate: "#{@owner.get('first_year')}-#{@owner.get('first_month')}"
        price: @owner.get('price')
        alMobile: @owner.get('mobile')
        automobileNumber: @owner.get('car_number')
      
      form = {}
      for b in [bean, extraInfo, hiddenForm]
        for k, v of b
          form["quoteBean.#{k}"] = v
      
      @request
        method: 'POST'
        url: "#{@host}vehicleQuickQuote.action"
        form: form
      , (err, res, body) =>
        json = JSON.parse(body).jsonResult
        if json
          cb? "#{json.length}", 'che', 0
        else
          cb? null, null, 1

module.exports = Taiping

# fn = (a, b, c) ->
#   console.log a, b, c
# 
# 
# demoOwner = 'first_year': 2010, 'price': 25, 'first_month': 11, 'car_number': '鄂A1K050', 'mobile': '13995662755', 'city': '武汉', 'province': '湖北'
# 
# demoOwner.get = (key) ->
#   @[key]
# 
# new Taiping(demoOwner, fn)