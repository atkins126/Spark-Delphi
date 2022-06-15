<?php
/******************************************************************************
  ____                   _
 / ___| _ __   __ _ _ __| | __
 \___ \| '_ \ / _` | '__| |/ /
  ___) | |_) | (_| | |  |   <
 |____/| .__/ \__,_|_|  |_|\_\
       |_|   Game Toolkit™

 Copyright © 2022 tinyBigGAMES™ LLC
 All Rights Reserved.

 Website: https://tinybiggames.com
 Email  : support@tinybiggames.com

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. The origin of this software must not be misrepresented; you must not
   claim that you wrote the original software. If you use this software in
   a product, an acknowledgment in the product documentation would be
   appreciated but is not required.

2. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.

3. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in
   the documentation and/or other materials provided with the
   distribution.

4. Neither the name of the copyright holder nor the names of its
   contributors may be used to endorse or promote products derived
   from this software without specific prior written permission.

5. All video, audio, graphics and other content accessed through the
   software in this distro is the property of the applicable content owner
   and may be protected by applicable copyright law. This License gives
   Customer no rights to such content, and Company disclaims any liability
   for misuse of content.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
-------------------------------------------------------------------------------
Based on:
  https://github.com/telecube/mysql-api

-------------------------------------------------------------------------------
An API connector to a MySQL DB instance for use in a distributed network

It can run on the same server as the databse or separately and has the ability
to specify a readonly cluster of databases while writes go to the master.

The api endpoint expects:
apikey   - to authorise the request
keyspace - the database name you want to connect to
query    - the query you want to run
data     - a json encoded array of values for the PDO prepared statement placeholders

To use the api send a http post|get request, for example;

_GET example:
-------------------------------------------------------------------------------
https://node1.example.com/?apikey=abcde12345&keyspace=mydbname&query=select * from sometable limit 1;&data=[""]


_POST example using curl:
-------------------------------------------------------------------------------
$mysql_api_nodes = array("https://node1.example.com","https://node2.example.com");
$keyspace 	= "mydbname";
$query 		= "insert into sometable (field1, field2, field3) values (?,?,?);";	
$data 		= array($var1, $var2, $var3);
$result 	= mysql_api_query($mysql_api_nodes, '/', array('keyspace'=>$keyspace,'query'=>$query,'data'=>json_encode($data)));

// example curl function
function mysql_api_query($nodes, $path, $data){
	$apikey = "abcde12345"; // get the apikey in here somehow
	$http_auth_user = ""; // these details too
	$http_auth_pass = "";

	$data = array_merge(array('apikey'=>$apikey),$data);
	// loop through the nodes if we don';t get an ok status
	for ($i=0; $i < count($nodes); $i++) { 
	    $res = api_http($nodes[$i].$path,$data,$http_auth_user,$http_auth_pass,10,true);
	    if(isset($res->query_status) && $res->query_status == "OK"){
	       break; 
	    }
	}
	return $res;
}

function api_http($url,$postArr,$httpAuthUser='',$httpAuthPass='',$timeout=60,$json_decode=false){
    if(!isset($timeout)) $timeout=60;
    $curl = curl_init();
    $post = http_build_query($postArr);
    if(isset($referer)){
        curl_setopt ($curl, CURLOPT_REFERER, $referer);
    }
    curl_setopt ($curl, CURLOPT_URL, $url);
    curl_setopt ($curl, CURLOPT_TIMEOUT, $timeout);
    curl_setopt ($curl, CURLOPT_USERAGENT, 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; .NET CLR 1.1.4322)');
    curl_setopt ($curl, CURLOPT_HEADER, false);
    curl_setopt ($curl, CURLOPT_RETURNTRANSFER, true);
	curl_setopt ($curl, CURLOPT_SSL_VERIFYPEER, false);
	curl_setopt ($curl, CURLOPT_SSL_VERIFYHOST, false);
	if($httpAuthUser != '' && $httpAuthPass != ''){
		curl_setopt ($curl, CURLOPT_HTTPAUTH, CURLAUTH_BASIC); 
		curl_setopt ($curl, CURLOPT_USERPWD, $httpAuthUser.':'.$httpAuthPass);
    }
	curl_setopt ($curl, CURLOPT_POST, true);
    curl_setopt ($curl, CURLOPT_POSTFIELDS, $post);
    curl_setopt ($curl, CURLOPT_HTTPHEADER,
        array("Content-type: application/x-www-form-urlencoded"));
    $html = curl_exec ($curl);
    curl_close ($curl);
    if($json_decode){
	    return json_decode($html);
    }else{
	    return $html;
    }
}
******************************************************************************/


// this definition can be checked in the required scripts to ensure they aren't called directly.
define('MAIN_INCLUDED', 1);

// --- Config ---------------------------------------------------------------
class Config
{
	// master detail
	private $master_db_host;
	private $master_db_port;
	private $master_db_user;
	private $master_db_pass;

	// readonly slaves
	private $db_slaves;

	// apikey
	private $apikey;

	// http auth detail
	private $http_auth_enable;
	private $http_auth_realm;
	private $http_auth_user;
	private $http_auth_pass;

	public function __construct(){
		// modify this to point to your config script
    include("/opt/config.php");

		// master detail
    $this->master_db_host 	= $master_db_host; 
    $this->master_db_port 	= $master_db_port; 
    $this->master_db_user 	= $master_db_user; 
    $this->master_db_pass 	= $master_db_pass; 

		// readonly slaves
		$this->db_slaves 		    = $db_slaves;

		// apikey
		$this->apikey 			    = $apikey;

		// http auth detail
		$this->http_auth_enable = $http_auth_enable;
		$this->http_auth_realm 	= $http_auth_realm;
		$this->http_auth_user 	= $http_auth_user;
		$this->http_auth_pass 	= $http_auth_pass;
    }       

	public function get($varname){
		return isset($this->$varname) ? $this->$varname : false;
	}
}

// --- Common ---------------------------------------------------------------
class Common
{
	public static function requested_keyspace(){
		if(isset($_REQUEST['keyspace']) && !empty($_REQUEST['keyspace'])){
			return $_REQUEST['keyspace'];
		}else{
			header("HTTP/1.1 400 Bad Request");
			echo json_encode(array("query_status"=>"ERROR","response"=>"You must set a keyspace!"));
			exit();
		}
	}

	public static function requested_query(){
		if(isset($_REQUEST['query']) && !empty($_REQUEST['query'])){
			return $_REQUEST['query'];
		}else{
			header("HTTP/1.1 400 Bad Request");
			echo json_encode(array("query_status"=>"ERROR","response"=>"You must set a query!"));
			exit();
		}
	}

	public static function requested_data(){
		if(isset($_REQUEST['data']) && !empty($_REQUEST['data'])){
			return json_decode($_REQUEST['data'], true);
		}else{
			header("HTTP/1.1 400 Bad Request");
			echo json_encode(array("query_status"=>"ERROR","response"=>"You must set query data!"));
			exit();
		}
	}
}

//--- Auth -----------------------------------------------------------------
class Auth
{
	public static function api_http()
  {
		global $Config;

		if (!isset($_SERVER['PHP_AUTH_USER'])) {
		    header('WWW-Authenticate: Basic realm="'.$Config->get('http_auth_realm').'"');
		    header('HTTP/1.0 401 Unauthorized');
		    echo 'Access to this site needs to be authenticated!';
		    exit;
		} else {
		    // check the username and password are valid
			$http_auth_user = $Config->get('http_auth_user');
			$http_auth_pass = $Config->get('http_auth_pass');
			if($http_auth_user && $http_auth_pass){
				if($_SERVER['PHP_AUTH_USER'] == $Config->get('http_auth_user') && $_SERVER['PHP_AUTH_PW'] == $Config->get('http_auth_pass')){
					return true;
				}else{
					// user/pass don't match so reject the request
				    header('WWW-Authenticate: Basic realm="'.$Config->get('http_auth_realm').'"');
					header('HTTP/1.1 401 Unauthorized');
				    echo 'Access denied!!';	
			    	exit;			
				}
			}else{
				// no user/pass so reject the request
			    header('WWW-Authenticate: Basic realm="'.$Config->get('http_auth_realm').'"');
				header('HTTP/1.1 401 Unauthorized');
			    echo 'Access denied!!!';	
			    exit;			
			}
		}		
	}

	public static function api_check_key()
  {
		global $Config;

		// get the apikey from config
		$apikey = $Config->get("apikey");

		// check the api key
		if(!isset($_REQUEST["apikey"]) || $_REQUEST["apikey"] != $apikey){
			header('HTTP/1.0 401 Unauthorized');
			echo json_encode(array("query_status"=>"ERROR","response"=>"Unauthorized request."));
			exit();
		}
	}
}

//--- Db ----------------------------------------------------------------------
class Db
{
	public static function pdo_query($q,$data=array(),$link){
		
		$rq_type = substr(strtolower($q), 0, 6);

	    try{
			$res = array();
	    	
	    	$rec = $link->prepare($q);  
	    	
	    	if($rq_type == "select"){
	    		$rec->execute($data); 
				$rec->setFetchMode(\PDO::FETCH_ASSOC);  
				while($rs = $rec->fetch()){
					$res[] = $rs;
				}
	    	}else{
	    		$res = $rec->execute($data); 
	    	}

			$rec->closeCursor();
			return $res;

	    }catch(\PDOException $ex){
			return $ex->getMessage();
	    } 
	}
}

// --- Main -----------------------------------------------------------------
$Config = new Config;
$Common = new Common;
$Auth 	= new Auth;
$Db 	  = new Db;

// check http auth credentials

if($Config->get("http_auth_enable") === true)
{
	$Auth->api_http();
}

// check the apikey is set and valid
$Auth->api_check_key();

$query_start = microtime(true);

// get the keyspace/database
$keyspace 		= $Common->requested_keyspace();
// get the query
$query 			= $Common->requested_query();
$query 			= trim($query);
// get the data
$data 			= $Common->requested_data();

// pdo db connection
try{
	$dbPDO = new PDO('mysql:dbname='.$Common->requested_keyspace().';host='.$Config->get("master_db_host").';port='.$Config->get("master_db_port"), $Config->get("master_db_user"), $Config->get("master_db_pass"));
} catch(PDOException $ex){
	exit( 'Connection failed: ' . $ex->getMessage() );
}
$dbPDO->setAttribute( PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION );

// test the query type
$query_type = substr(strtolower($query), 0, 6);
$response = $Db->pdo_query($query,$data,$dbPDO,$query_type);

$query_status = "OK";

$query_end = microtime(true);
$query_time = $query_end - $query_start;

$response_length = strlen(json_encode($response));

// echo the response
echo json_encode(array("query_status"=>$query_status,"query_time"=>$query_time,"response_length"=>$response_length,"response"=>$response));

?>