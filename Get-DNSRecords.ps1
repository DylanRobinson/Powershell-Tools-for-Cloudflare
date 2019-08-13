Function Get-DNSRecords {
    [CmdletBinding()]
    param (
        [Parameter(
            Position = 1,
            Mandatory = $true,
            HelpMessage = "Enter your Cloudflare Zone Identifier")]
        [string]$ZoneID,

        [Parameter(
            Position = 2,
            Mandatory = $true,
            HelpMessage = "Enter your API Bearer Token")]
        [string]$APIToken
    )
    
    $Headers = @{
        "Authorization" = "Bearer $APIToken";
        "Content-Type"  = "application/json"
    }

    $response = Invoke-RestMethod -Headers $Headers -Method GET -URI "https://api.cloudflare.com/client/v4/zones/$ZoneID/dns_records"
    $response.result
}

Get-DNSRecords
