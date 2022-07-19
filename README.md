# JSRecon

Script made for all your Javascript Recon Automation. Just pass subdomain list to it and options according to your preference.

# Features
```
0 - Gather Jsfile Links from different sources.
1 - Gather JS Files With Cookie also
2 - Import File Containing JSUrls
3 - Extract Endpoints from Jsfiles
4 - Find Secrets from Jsfiles
5 - Get Jsfiles store locally for manual analysis
6 - Make a Wordlist from Jsfiles
7 - Extract Variable names from jsfiles for possible XSS.
8 - Scan JsFiles For DomXSS.
9 - Generate Html Report.
```

# Installation

There are two ways of executing this script: Either locally on the host machine or within a Docker container 

### Installing all dependencies locally

**Note: Make sure you have installed golang properly before running installation script locally.**

```
$ sudo chmod +x install.sh
$ ./install.sh
```

### Running Tool 

You just have to execute the following commands: 

```
$ cd JSFScan.sh/
$ sudo chmod +x JSFScan.sh
$ bash JSFScan.sh -l target.txt [--options]
```

### For Enhancement 

After complete installation follow these steps: 

```
$ cd JSFScan.sh/tools/SecretFinder

* Open SecretFinder.py and add your regex:
```

```
_regex = {
    'google_api'     : r'AIza[0-9A-Za-z-_]{35}',
    'google_captcha' : r'6L[0-9A-Za-z-_]{38}|^6[0-9a-zA-Z_-]{39}$',
    'google_oauth'   : r'ya29\.[0-9A-Za-z\-_]+',
    'amazon_aws_access_key_id' : r'A[SK]IA[0-9A-Z]{16}',
    'amazon_mws_auth_toke' : r'amzn\\.mws\\.[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}',
    'amazon_aws_url' : r's3\.amazonaws.com[/]+|[a-zA-Z0-9_-]*\.s3\.amazonaws.com',
    'facebook_access_token' : r'EAACEdEose0cBA[0-9A-Za-z]+',
    'authorization_basic' : r'basic\s*[a-zA-Z0-9=:_\+\/-]+',
    'authorization_bearer' : r'bearer\s*[a-zA-Z0-9_\-\.=:_\+\/]+',
    'authorization_api' : r'api[key|\s*]+[a-zA-Z0-9_\-]+',
    'mailgun_api_key' : r'key-[0-9a-zA-Z]{32}',
    'twilio_api_key' : r'SK[0-9a-fA-F]{32}',
    'twilio_account_sid' : r'AC[a-zA-Z0-9_\-]{32}',
    'twilio_app_sid' : r'AP[a-zA-Z0-9_\-]{32}',
    'paypal_braintree_access_token' : r'access_token\$production\$[0-9a-z]{16}\$[0-9a-f]{32}',
    'square_oauth_secret' : r'sq0csp-[ 0-9A-Za-z\-_]{43}|sq0[a-z]{3}-[0-9A-Za-z\-_]{22,43}',
    'square_access_token' : r'sqOatp-[0-9A-Za-z\-_]{22}|EAAA[a-zA-Z0-9]{60}',
    'stripe_standard_api' : r'sk_live_[0-9a-zA-Z]{24}',
    'stripe_restricted_api' : r'rk_live_[0-9a-zA-Z]{24}',
    'github_access_token' : r'[a-zA-Z0-9_-]*:[a-zA-Z0-9_\-]+@github\.com*',
    'rsa_private_key' : r'-----BEGIN RSA PRIVATE KEY-----',
    'ssh_dsa_private_key' : r'-----BEGIN DSA PRIVATE KEY-----',
    'ssh_dc_private_key' : r'-----BEGIN EC PRIVATE KEY-----',
    'pgp_private_block' : r'-----BEGIN PGP PRIVATE KEY BLOCK-----',
    'json_web_token' : r'ey[A-Za-z0-9-_=]+\.[A-Za-z0-9-_=]+\.?[A-Za-z0-9-_.+/=]*$',

    'name_for_my_regex' : r'my_regex',
    # for example
    'example_api_key'    : r'^example\w+{10,50}'
}

```
Note: More regex pattern has been included in Regex_Javascript.txt



# Usage
Target List should be with `https://` and `http://` use httpx or httprobe for this.
```
https://hackerone.com
https://github.com
```

**NOTE: If you feel tool is slow just comment out hakrawler line at 23 in JSFScan.sh script , but it might result in little less jsfileslinks.**

```
 _______ ______ _______ ______                          _     
(_______/ _____(_______/ _____)                        | |    
     _ ( (____  _____ ( (____   ____ _____ ____     ___| |__  
 _  | | \____ \|  ___) \____ \ / ___(____ |  _ \   /___|  _ \ 
| |_| | _____) | |     _____) ( (___/ ___ | | | |_|___ | | | |
 \___/ (______/|_|    (______/ \____\_____|_| |_(_(___/|_| |_|
                                                              
Usage: 
       -l   Gather Js Files Links
       -c   Gather Js Links with Cookies
       -f   Import File Containing JS Urls
       -e   Gather Endpoints For JSFiles
       -s   Find Secrets For JSFiles
       -m   Fetch Js Files for manual testing
       -o   Make an Output Directory to put all things Together
       -w   Make a wordlist using words from jsfiles
       -v   Extract Vairables from the jsfiles
       -d   Scan for Possible DomXSS from jsfiles
       -r   Generate Scan Report in html
       --all Scan Everything!

```
# Check Video Here.
[![JSFScan.sh](https://img.youtube.com/vi/Z13dnarKF-w/0.jpg)](https://www.youtube.com/watch?v=Z13dnarKF-w)
