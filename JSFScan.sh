#!/bin/bash

#LOgo
logo(){

echo " _______ ______ _______ ______                          _     ";
echo "(_______/ _____(_______/ _____)                        | |    ";
echo "     _ ( (____  _____ ( (____   ____ _____ ____     ___| |__  ";
echo " _  | | \____ \|  ___) \____ \ / ___(____ |  _ \   /___|  _ \ ";
echo "| |_| | _____) | |     _____) ( (___/ ___ | | | |_|___ | | | |";
echo " \___/ (______/|_|    (______/ \____\_____|_| |_(_(___/|_| |_|";
echo "                                                              ";

}
logo

source JSFScan.cfg
tools="tools"

#Gather JSFilesUrls
gather_js(){
echo -e "\n\e[36m[\e[32m+\e[36m]\e[92m Started Gathering JsFiles-links\e[0m\n";
cat "$target" | gau | grep -iE "\.js$" | uniq | sort >> jsfile_links_tmp.txt
cat "$target" | subjs >> jsfile_links_tmp.txt
cat $target | hakrawler -d 3 -t $SPIDER_THREADS | grep ".js" | sort -u >> jsfile_links_tmp.txt
gospider -s $target -t $SPIDER_THREADS -d 3 -q -R | grep ".js" | grep -Eo "(http|https)://[a-zA-Z0-9./?=_%:-]*" | sort -u >> jsfile_links_tmp.txt
python3 $tools/getsrc.py $target >> jsfile_links_tmp.txt
cat jsfile_links_tmp.txt | sort -u > jsfile_links.txt

#Check Live_URLS
echo -e "\n\e[36m[\e[32m+\e[36m]\e[92m Checking for live JsFiles-links\e[0m\n";
cat jsfile_links.txt | httpx -follow-redirects -silent -status-code | grep "[200]" | cut -d ' ' -f1 | sort -u > live_jsfile_links.txt
}

#Gather JSFilesUrls with Cookie
gather_js_cookie(){
echo -e "\n\e[36m[\e[32m+\e[36m]\e[92m Started Gathering JsFiles-links Cookie Based\e[0m\n";
cat $target | hakrawler -d 3 -t $SPIDER_THREADS -h "Cookie: $Cookie" | grep ".js" | sort -u >> jsfile_links_tmp_cookie.txt
gospider -s $target -t $SPIDER_THREADS --cookie $Cookie -d 3 -q -R | grep ".js" | grep -Eo "(http|https)://[a-zA-Z0-9./?=_%:-]*" | sort -u >> jsfile_links_tmp_cookie.txt
cat jsfile_links_tmp_cookie.txt | httpx -follow-redirects -silent -status-code | grep "[200]" | cut -d ' ' -f1 | sort -u >> live_jsfile_links.txt
}


#Gather Endpoints From JsFiles
endpoint_js(){
echo -e "\n\e[36m[\e[32m+\e[36m]\e[92m Started gathering Endpoints\e[0m\n";
interlace -tL live_jsfile_links.txt -threads $INTERLACE_THREADS -c "echo 'Scanning _target_ Now' ; python3 ./tools/LinkFinder/linkfinder.py -d -i _target_ -o cli >> endpoints.txt" -v
}

#Gather Secrets From Js Files
secret_js(){
echo -e "\n\e[36m[\e[32m+\e[36m]\e[92m Started Finding Secrets in JSFiles\e[0m\n";
interlace -tL live_jsfile_links.txt -threads $INTERLACE_THREADS -c "python3 ./tools/SecretFinder/SecretFinder.py -i _target_ -o cli >> jslinksecret.txt" -v
}

#Collect Js Files For Maually Search
getjsbeautify(){
echo -e "\n\e[36m[\e[32m+\e[36m]\e[92m Started to Gather JSFiles locally for Manual Testing\e[0m\n";
mkdir -p jsfiles
interlace -tL live_jsfile_links.txt -threads $INTERLACE_THREADS -c "bash ./tools/getjsbeautify.sh _target_" -v
echo -e "\n\e[36m[\e[32m+\e[36m]\e[92m Manually Search For Secrets Using gf or grep in out/\e[0m\n";
}

#Gather JSFilesWordlist
wordlist_js(){
echo -e "\n\e[36m[\e[32m+\e[36m]\e[92m Started Gathering Words From JsFiles-links For Wordlist.\e[0m\n";
cat live_jsfile_links.txt | python3 ./tools/getjswords.py >> temp_jswordlist.txt
cat temp_jswordlist.txt | sort -u >> jswordlist.txt
rm temp_jswordlist.txt
}

#Gather Variables from JSFiles For Xss
var_js(){
echo -e "\n\e[36m[\e[32m+\e[36m]\e[92m Started Finding Varibles in JSFiles For Possible XSS\e[0m\n";
cat live_jsfile_links.txt | while read url ; do bash ./tools/jsvar.sh $url | tee -a js_var.txt ; done
}

#Find DomXSS
domxss_js(){
echo -e "\n\e[36m[\e[32m+\e[36m]\e[92m Scanning JSFiles For Possible DomXSS\e[0m\n";
interlace -tL live_jsfile_links.txt -threads $INTERLACE_THREADS -c "bash ./tools/findomxss.sh _target_" -v
}

#Generate Report
report(){
echo -e "\n\e[36m[\e[32m+\e[36m]\e[92m Generating Report!\e[0m\n";
bash report.sh
}

#Save in Output Folder
output(){
mkdir -p $dir
mv jsfile_links_tmp_cookie.txt jsfile_links_tmp.txt endpoints.txt jsfile_links.txt jslinksecret.txt live_jsfile_links.txt jswordlist.txt js_var.txt domxss_scan.txt report.html $dir/ 2>/dev/null
mv jsfiles/ $dir/
}
while getopts ":l:f:cesmwvdro:-:" opt;do
	case ${opt} in
		- )      case "${OPTARG}" in

			all) 
				endpoint_js
				secret_js
				getjsbeautify
				wordlist_js
				var_js
				domxss_js
				;;

			*)
                                        if [ "$OPTERR" = 1 ] && [ "${optspec:0:1}" != ":" ]; then
                                        echo "Unknown option --${OPTARG}" >&2
                                        fi
                                        ;;
                        esac;; 

		l ) target=$OPTARG
		    gather_js
		    ;;    
        f ) target=$OPTARG
		    open_jsurlfile
		    ;;
		c ) gather_js_cookie
			;;    
		e ) endpoint_js
		    ;;
		s ) secret_js
		    ;;
		m ) getjsbeautify
		    ;;
		w ) wordlist_js
            ;;
		v ) var_js
		    ;;
		d ) domxss_js
		    ;;
		r ) report
		    ;;
		o ) dir=$OPTARG
		    output
		    ;;
		\? | h ) echo "Usage: "
		     echo "       -l   Gather Js Files Links";
		     echo "       -f   Import File Containing JS Urls";
                     echo "       -e   Gather Endpoints For JSFiles";
		     echo "       -s   Find Secrets For JSFiles";
		     echo "       -m   Fetch Js Files for manual testing";
		     echo "       -o   Make an Output Directory to put all things Together";
		     echo "       -w   Make a wordlist using words from jsfiles";
		     echo "       -v   Extract Vairables from the jsfiles";
		     echo "       -d   Scan for Possible DomXSS from jsfiles";
		     echo "       -r   Generate Scan Report in html";
		     echo "	  --all Scan Everything!";
		     ;;
		: ) echo "Invalid Options $OPTARG require an argument";
		    ;;
	esac
done
shift $((OPTIND -1))
