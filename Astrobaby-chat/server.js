var express = require('express');
var http = require("http");
var url = require("url");
var querystring = require('querystring');

var bodyParser = require('body-parser');
var exec = require('child_process').exec;

//从json文件中读取返回值
fs=require('fs');



var app = express();

//var urlencodedParser = bodyParser.urlencoded({ extended: false });
var urlencodedParser = bodyParser.json();

 ///@dev 设置静态文件允许访问的文件夹
//app.use(express.static('public'));


//allow custom header and CORS 解决跨域问题
app.all('*',function (req, res, next) {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Headers', 'Content-Type, Content-Length, Authorization, Accept, X-Requested-With , yourHeaderFeild');
  res.header('Access-Control-Allow-Methods', 'PUT, POST, GET, DELETE, OPTIONS');

  if (req.method == 'OPTIONS') {
   res.send(200);
    //res.writeHead(200,{'Content-Type':'text/html;charset=utf-8'});
  }
  else {
    next();
  }
});


// 响应cakechat get请求
 app.get('/cakechat',function(request,response){

         var params = url.parse(request.url,true).query;

         //response.writeHead(200,{"Content-Type":'text/plain','charset':'utf-8','Access-Control-Allow-Origin':'*','Access-Control-Allow-Methods':'PUT,POST,GET,DELETE,OPTIONS'});

		console.log("请求参数1="+params.context);
		console.log("请求参数2="+params.emotion);
		
		var file="cakechat.json";
			
	//	var cmdStr = ' python3 tools/test_api.py -f 127.0.0.1 -p 8080 -c '+ params.context +  ' -e ' + params.emotion + ' > cakechat.json ' 
		var cmdStr = 'python3 tools/test_api.py -f 127.0.0.1 -p 8080 -c "'+params.context +  '" -e "' + params.emotion + '" > cakechat.json ' 
		

		
		exec(cmdStr, function(err,stdout,stderr){
			if(err) {
				console.log('get weather api error:'+stderr);
			} else {
				
				var result=fs.readFileSync(file);
				// var data = JSON.stringify(stdout);
				
				console.log("******返回结果********");
				console.log(result);
				response.send(result); //send data to request link.
			}
		});	
		

 });



 //响应cakechat post请求
app.post('/cakechat', urlencodedParser, function (request, response) {

 console.log("cakechat post request");
 // response.status(200);

		console.log(request.body.username);
		console.log(request.body.password);

      
		console.log("请求参数1="+request.body.context);
		console.log("请求参数2="+request.body.emotion);
		
		var file="cakechat.json";
		//var cmdStr = ' python3 tools/test_api.py -f 127.0.0.1 -p 8080 -c '+ request.body.context +  ' -e ' + request.body.emotion + ' > cakechat.json ' 
		var cmdStr = 'python3 tools/test_api.py -f 127.0.0.1 -p 8080 -c "'+request.body.context +  '" -e "' + request.body.emotion + '" > cakechat.json '
				
		exec(cmdStr, function(err,stdout,stderr){
			if(err) {
				console.log('get weather api error:'+stderr);
			} else {
				
				var result=fs.readFileSync(file);
				// var data = JSON.stringify(stdout);
				
				console.log("******返回结果********");
				console.log(result);
				//res.writeHead(200,{'Content-Type':'text/html;charset=utf-8'});
				response.send(result); //send data to request link.
			}
		});	
		

});

/*
app.get('/process_get', function (req, res) {

   // 输出 JSON 格式
   var response = {
       "first_name":req.query.first_name,
       "last_name":req.query.last_name
   };
   console.log(response);
   res.end(JSON.stringify(response));
})
 */
var server = app.listen(8888, function () {

        var host = server.address().address
        var port = server.address().port
        //console.log("*************************")
        //console.log(result.abi);

        //web3 = new Web3(new Web3.providers.HttpProvider("http://192.168.0.193:8545"));
       // web3 = new Web3(new Web3.providers.HttpProvider("http://127.0.0.1:8545"));

       // account_one = web3.eth.accounts[0];
        //var address = "0x6cf79ad10e10d66adcb67cd25e8630c89b4afef7";
        ///@dev 创建合约实例
       // contract = new web3.eth.Contract(result.abi,address);

        //console.log(JSON.stringify(server.address()));
		
		

        console.log("nodejs服务已启动，访问地址： http://"+host+":"+ port);
})
