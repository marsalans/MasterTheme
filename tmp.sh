:global sharedSecret "2ppetz3psh" ;
:global radiusDomain "radius.pintime.co" ;
:global radiusAccPort "1713" ;
:global radiusAuthPort "1712" ;
:global nasIdentity "592c0657351e5f0020a6c69a" ;
:global hotspotDynamicIp "hotspotDynamicIp.sh" ;
:global hotspotDomain     "pintime.io" ;
/system identity set name $nasIdentity  ;
:put "Nas identity changed." ;
/system ntp client set enabled=yes primary-ntp=193.190.147.153  ;
:put "Ntp adjusted" ;
/system clock manual set time-zone=+03:30  ;
:put "Clock adjusted" ;
/system clock set time-zone-name=Asia/Tehran  ;
:put "Timezone changed" ;
/radius add service=hotspot domain=$radiusDomain secret=$sharedSecret authentication-port=$radiusAuthPort accounting-port=$radiusAccPort timeout=00:00:05.00 ;
:do {/system scheduler remove dynamicIpSchedulaer ;
} on-error={ :put "Try to remove old dynamic scheduler failed"} ;
/system scheduler add name=dynamicIpSchedulaer on-event=$hotspotDynamicIp  interval=180s disabled=no  ;
:put "Scheduler added" ;
:do {/system script remove $hotspotDynamicIp ;
} on-error={ :put "Try to remove old dynamic ip failed"} ;
:if ([:len [/file find name=$hotspotDynamicIp]] > 0) do={
:global hotspotDynamicIpPath "$hotspotDynamicIp" ;
:put "script found in root" ;
} else={
:global hotspotDynamicIpPath "flash/$hotspotDynamicIp" ;
:put "script found in flash" ;
}
/system script add name=$hotspotDynamicIp source=[/file get $hotspotDynamicIpPath contents ] policy=read,test,write ;
:put "Dynamic ip script added!" ;
/ip hotspot walled-garden add dst-host=$hotspotDomain action=allow ;
:put "Walled garden added for: captiveportal.ir" ;
/ip hotspot walled-garden add dst-host=zarinpal.com action=allow ;
:put "Walled garden added for: zarinpal.com" ;
/ip hotspot walled-garden add dst-host=*.zarinpal.com action=allow ;
:put "Walled garden added for: *.zarinpal.com" ;
/ip hotspot walled-garden add dst-host=hotspotplus.ir action=allow ;
:put "Walled garden added for: hotspotplus.ir" ;
/ip hotspot walled-garden add dst-host=*.hotspotplus.ir action=allow ;
:put "Walled garden added for: *.hotspotplus.ir" ;
/ip hotspot walled-garden add dst-host=*.shaparak.ir action=allow ;
:put "Walled garden added for: *.shaparak.ir" ;
:put "Done!, welcome to hotspot plus" ;