Task = require './task'

'上海,0360,0360010801,73,上海市,上海市,沪,上海,SHANGHAI,SH,HOTCITY',
'北京,0380,0380011201,73,北京市,北京市,京,北京,BEIJING,BJ,HOTCITY',
'深圳,0320,0320011201,,广东省,深圳市,粤B,深圳,SHENZHEN,SZ,HOTCITY',
'广州,0330,0330020131,,广东省,广州市,粤A,广州,GUANGZHOU,GZ,HOTCITY',
'佛山,0330,0330030119,,广东省,佛山市,粤E,佛山,FESHAN,FS',
'惠州,0330,0330060114,,广东省,惠州市,粤L,惠州,HUIZHOU,HZ',
'南京,0361,0361010901,,江苏省,南京市,苏A,南京,NANJING,NJ,HOTCITY',
'镇江,0361,0361050113,,江苏省,镇江市,苏L,镇江,ZHENJIANG,ZJ',
'无锡,0361,0361070116,,江苏省,无锡市,苏B,无锡,WUXI,WX',
'南通,0361,0361020111,,江苏省,南通市,苏F,南通,NANTONG,NT',
'石家庄,0382,0382010801,,河北省,石家庄市,冀A,石家庄,SHIJIAZHUANG,SJZ',
'唐山,0382,0382050110,,河北省,唐山市,冀B,唐山,TANGSHAN,TS',
'武汉,0331,0331011001,,湖北省,武汉市,鄂A,武汉,WUHAN,WH',
'荆州,0331,0331030112,,湖北省,荆州市,鄂M,荆州,JINGZHOU,JZ',
'沈阳,0390,0390020121,,辽宁省,沈阳市,辽A,沈阳,SHENYANG,SY',
'锦州,0390,0390080113,,辽宁省,锦州市,辽G,锦州,JINZHOU,JS',
'抚顺,0390,0390070110,,辽宁省,抚顺市,辽D,抚顺,FUSHUN,FS',
'鞍山,0390,0390030112,,辽宁省,鞍山市,辽C,鞍山,ANSHAN,AS',
'济南,0367,0367011001,,山东省,济南市,鲁A,济南,JINAN,JN',
'潍坊,0367,0367020113,,山东省,潍坊市,鲁G,潍坊,WEIFANG,WF',
'烟台,0367,0367071501,,山东省,烟台市,鲁F,烟台,YANTAI,YT',
'临沂,0367,0367080107,,山东省,临沂市,鲁Q,临沂,LINYI,LY',
'西安,0370,0370011601,,陕西省,西安市,陕A,西安,XIAN,XA',
'成都,0350,0350011401,,四川省,成都市,川A,成都,CHENGDU,CD'

class Taiping extends Task
  
  encoding: 'utf-8'
  debug: true
  
  prepare: ->
    @host = "http://che.cntaiping.com/"
    entrance = "#{@host}vehicleQuickQuote!landingloadinit.action?channel=tponline-WX-zhongyi&medium=che-eMall-AFFLT-zhongyi-lp-banner"
    
    @form =
      automobileLv1Area: 19
      automobileLv2Area: 19
      claim: '0.9'
      sizeType: 1
      channelType: ''
      mediumNumber: 'che-eMall-AFFLT-zhongyi-lp-banner'
      innerMediumNumber: ''
      channelNumber: 'tponline-WX-zhongyi'
    entrance
  
  
  emulate: (cb) ->
    console.log 'e'
    @request @entrance, (err, res, body) =>
      @request
        method: 'POST'
        url: "#{@host}vehicleQuickQuote.action"
        form:
          quoteBean:
            areaId: '0380011201'
            city_i: @owner.get('area')
            buyDate: "#{@owner.get('first_year')}-#{@owner.get('first_month')}"
            price: @owner.get('price')
            alMobile: @owner.get('mobile')
            automobileNumber: @owner.get('car_number')
            
      , (err, res, body) =>
        cb? null, null, body

module.exports = Taiping

fn = (a, b, c) ->
  console.log a, b, c

new Taiping(null, fn)