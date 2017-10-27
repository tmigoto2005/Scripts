#!/bin/bash

#nagios, javamelody etc. use english notation for numbers e.g. 3.145, if you need the setting of your system remove following line
LC_NUMERIC=C 

#init vars	
STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3

hostname=10.90.0.85
port=8080
path=/confidence/monitoring
cparam=
warning=
critical=
printvalue=javamelody_lastValue
unit=M
vmode=
noproxy=
byteunits="B K M G T P"
wgetverbose="-q"

println()
{
	printf "%s\n" "$1"
}

print_help()
{
	println 'Get javamelody monitoring values with the lastValue URL-Parameter, see documentation http://javamelody.googlecode.com/svn/wiki/ExternalAPI.wiki.'
	println ''
	println 'Usage: check_javamelody_http.sh -H host -path pathtojavamelody/monitoring -cpm checkparameter -w warning -c critcal [-noproxy] [-port port] [-pv printvalue] [-unit unit] [-v]'
	println 'Usage:'
	println '-H hostname'
	println '   hostname or ip of javamelody server'
	println '-path pathtojavamelody/monitoring'
	println '   path to javamelody web app'
	println '-cpm checkparameter'
	println '   parameter for javamelody to check'
	println '-w warning'
	println '   warning value'
	println '-c critcal'
	println '   critical value'
	println '-noproxy'
	println '   do not use proxy'
	println '-port'
	println '   port number, 80 is default for http'
	println '-pv printvalue'
	println '   name for checked value'
	println '-unit unit'
	println '   Use unit for value. For units B(ytes), K(iB), M(iB), G(iB), T(iB) and P(iB) lastValue is converted automatically.'
	println '-v'
	println '   verbose ouput'
	println ''
	println 'Examples:'
	println ''
	println '$ check_javamelody_http.sh -H myserver -path app/monitoring -noproxy -cpm cpu -w 90 -c 95 -pv CPU -unit %'
	println 'OK: cpu:0%|cpu=0%;95;98'
	println '$ check_javamelody_http.sh -H myserver -path app/monitoring -noproxy -cpm usedMemory -w 14336 -c 14848 -pv usedMemory -unit M'
	println 'OK: usedMemory:706M|usedMemory=706M;14336;14848'	
	println '$ check_javamelody_http.sh -H myserver -path app/monitoring -cpm httpMeanTimes -c 10000 -w 5000 -noproxy -pv httpMeanTimes -unit ms'
	println 'OK: httpMeanTimes:313ms|httpMeanTimes=313ms;5000;10000'	
	println ''
exit 1
}

bytes_to_hreadable()
{
	numval=$1
	for numunit in $byteunits
	do
		if [ "$2" = $numunit ]; then
			break
		fi		
		# use max scale: bc -l
		numval=`printf "%s / 1024\n" "$numval" | bc -l`
      	done
	printf "%.0f" $numval
}

print_result()
{
	printf "%s: %s:%.0f%s|%s=%.0f%s;%.0f;%.0f\n" "$1" "$printvalue" "$lastValue" "$unit" "$printvalue" "$lastValue" "$unit" "$warning" "$critical"
}

#read multiple arguments
while [ $# -ne 0 ]; do
	case $1 in 
		-H)
		hostname="$2"
		shift
		;;
		
		-path)
		path="$2"
		shift
		;;

		-cpm)
		cparam="$2"
		shift
		;;

		-w)
		warning="$2"
		shift
		;;

		-c)
		critical="$2"
		shift
		;;
		
		-noproxy)
		noproxy="--no-proxy"
		;;

		-port)
		port=":$2"
		shift
		;;

		-pv)
		printvalue="$2"
		shift
		;;

		-unit)
		unit="$2"
		shift
		;;

		-v)
		vmode=v
		wgetverbose=
		;;

		*)
               	printf "Unknown argument: %s" "$1"
               	print_help
               	exit $STATE_UNKNOWN
               	;;
	esac
	shift
done

# validate args
if [ -z "$hostname" ] && [ -z "$cparam" ] && [ -z "$warning" ] && [ -z "$critical" ]; then
	print_help
	exit $STATE_UNKNOWN
fi

# define other querys for javamelody, default is lastValue
case $cparam in

	*)
	lastValue=`wget -O - $noproxy $wgetverbose "http://$hostname$port/$path?part=lastValue&graph=$cparam"`
	;;

esac

if [ "$vmode" = "v" ]; then
	printf "wget result: %s\n" "$lastValue"
fi

if [ $? = "0" ]; then
	
	#integer number needed for comparison and scientific notation removed e.g. 9.63697728E8 if present
	lastValue=`printf "%.0f" $lastValue`
	
	#convert bytes to readable unit e.g. K, M, G etc.
	convertbytes=false
	if [ -n "$unit" ]; then
		for bu in $byteunits
		do
			if [ "$bu" = $unit ]; then
				lastValue=`bytes_to_hreadable "$lastValue" "$unit"`
			fi
		done
	fi

	if [ $lastValue -gt $critical ]; then
		print_result "CRITICAL"
		exit $STATE_CRITICAL
	fi
	if [ $lastValue -gt $warning ]; then
		print_result "WARNING"
		exit $STATE_WARNING
	fi
	
	print_result "OK"
	exit $STATE_OK	
else
	printf "Unknown wget error!"
	exit $STATE_UNKNOWN
fi

