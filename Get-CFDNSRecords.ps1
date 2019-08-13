# List DNS Records using the Cloudflare RESTful API

# Authentication: API Token
# Permission needed: dns_records:read
# Documentation: https://api.cloudflare.com/#dns-records-for-a-zone-list-dns-records

Function Get-CFDNSRecords {
    [CmdletBinding()]
    param (
        [Parameter(
            Position = 1,
            Mandatory = $true,
            HelpMessage = 'Enter your Cloudflare Zone Identifier')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [ValidateLength(32, 32)]
        [ValidatePattern("[a-fA-F0-9]")]
        [string]$ZoneID,

        [Parameter(
            Position = 2,
            Mandatory = $true,
            HelpMessage = 'Enter your API Bearer Token')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$APIToken,

        [Parameter(
            Position = 3,
            Mandatory = $false,
            HelpMessage = 'DNS record type. Example: "A"')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("A", "AAAA", "CNAME", "TXT", "SRV", "LOC", "MX", "NS", "SPF", "CERT", "DNSKEY", "DS", "NAPTR", "SMIMEA", "SSHFP", "TLSA", "URI")]
        [string]$Type,
        
        [Parameter(
            Position = 4,
            Mandatory = $false,
            HelpMessage = 'DNS record name. Example: "example.com"')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [ValidateLength(0, 255)]
        [string]$Name,
        
        [Parameter(
            Position = 5,
            Mandatory = $false,
            HelpMessage = 'DNS record content. Example: "127.0.0.1"')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$Content,
        
        [Parameter(
            Position = 6,
            Mandatory = $false,
            HelpMessage = 'Page number of paginated results. Example: "1"')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [int]$Page,
        
        [Parameter(
            Position = 7,
            Mandatory = $false,
            HelpMessage = 'Number of DNS records per page. Example: "20"')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [ValidateRange(5, 100)]
        [int]$PerPage,
        
        [Parameter(
            Position = 8,
            Mandatory = $false,
            HelpMessage = 'Field to order records by. Example: "type"')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("type", "name", "content", "ttl", "proxied")]
        [string]$Order,
        
        [Parameter(
            Position = 9,
            Mandatory = $false,
            HelpMessage = 'Direction to order domains. Example: "desc"')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("asc", "desc")]
        [string]$Direction,
        
        [Parameter(
            Position = 10,
            Mandatory = $false,
            HelpMessage = 'Whether to match all search requirements or at least one (any). Example: "all"')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("any", "all")]
        [string]$Match

    )
    
    $Headers = @{
        "Authorization" = "Bearer $APIToken";
        "Content-Type"  = "application/json"
    }

    $Parameters = @(
        If ($Type) { "type=$Type" };
        If ($Name) { "name=$Name" };
        If ($Content) { "content=$Content" };
        If ($Page) { "page=$Page" };
        If ($PerPage) { "per_page=$PerPage" };
        If ($Order) { "order=$Order" };
        If ($Direction) { "direction=$Direction" };
        If ($Match) { "match=$Match" }
    ) -join "&"
    If (![string]::IsNullOrEmpty($Parameters)) {
        $Parameters = "?" + $Parameters
    }

    $response = Invoke-RestMethod -Headers $Headers -Method GET -URI "https://api.cloudflare.com/client/v4/zones/$ZoneID/dns_records$Parameters"
    $response.result
}

Get-CFDNSRecords
