$uri = Get-Random -InputObject @(
    'https://ipinfo.io/ip'
    'https://icanhazip.com'
    'https://ident.me'
    'https://trackip.net/ip'
    'https://checkip.amazonaws.com'
    'https://myexternalip.com/raw'
    'https://wtfismyip.com/text'
    'https://api.seeip.org'
    'https://api.ipify.org'
    'https://secure.informaction.com/ipecho'
    'https://ifconfig.me/ip'
)

$IP = Invoke-RestMethod -Uri "$uri"
$IP