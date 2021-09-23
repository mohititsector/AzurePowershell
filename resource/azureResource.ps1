. .\resource\keyvault.ps1
. .\resource\configstore.ps1
. .\resource\storage.ps1
. .\resource\servicebus.ps1
. .\resource\trafficmanager.ps1
. .\resource\redis.ps1
. .\resource\cosmosdb.ps1

<#
Store Connetion strings into Key Vault
#>
function storeKeyVault() {
  [CmdletBinding()]
  param (
    [Parameter()]
    [string]
    $connectionString,
    [Parameter()]
    [string]
    $name
  )
  $secretValue = ConvertTo-SecureString $connectionString -AsPlainText -Force 
  $kvname_ = GetKvName
  $setValue = Set-AzKeyVaultSecret -VaultName $kvname_ -Name $name -SecretValue $secretValue
  $keyName = $setValue.Name
  logVerbose ("Stored resource connection string into key vault as name: {0}" -f $keyName)
}


<#
Verifies whether the resource already exists in the Azure Subscription or not. 
#>
function isResourceExists() {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $false)]
    [string]
    $namespace,
    [Parameter(Mandatory = $false)]
    [string]
    $verifyrg,
    [Parameter(Mandatory = $false)]
    [string]
    $verifytag,
    [Parameter(Mandatory = $false)]
    [string]
    $verifyServer,
    [Parameter(Mandatory = $false)]
    [string]
    $verifyDbName
  )
  switch ($verifytag) {
    "redis" { 
      Get-AzRedisCache `
        -Name $namespace `
        -ResourceGroupName $verifyrg `
        -ev error `
        -ea SilentlyContinue
    }
    "kv" {
      $contains = Get-AzKeyVault `
        -VaultName $namespace

      if (-Not $contains) {
        return $false
      }
      return $true
    }
    "sb" {
      Get-AzServiceBusNamespace `
        -ResourceGroupName $verifyrg `
        -Name $namespace `
        -ev error `
        -ea SilentlyContinue
    }
    "st" {
      Get-AzStorageAccount `
        -ResourceGroupName $verifyrg `
        -Name $namespace `
        -ev error `
        -ea SilentlyContinue
    }
    "server" {
      Get-AzSqlServer `
        -ResourceGroupName $verifyrg `
        -ServerName $namespace `
        -ev error `
        -ea SilentlyContinue
    }
    "database" {
      Get-AzSqlDatabase `
        -ResourceGroupName $verifyrg `
        -DatabaseName $namespace `
        -ServerName $verifyServer `
        -ev error `
        -ea SilentlyContinue
    }
    "tm" {
      Get-AzTrafficManagerProfile `
        -ResourceGroupName $verifyrg `
        -Name $namespace `
        -ev error `
        -ea SilentlyContinue
    }
    "cosmosdbaccount" { 
      Get-AzCosmosDBAccount `
        -Name $namespace `
        -ResourceGroupName $verifyrg `
        -ev error `
        -ea SilentlyContinue
    }
    "cosmosdbsqldb" { 
      Get-AzCosmosDBSqlDatabase `
        -Name $namespace `
        -ResourceGroupName $verifyrg `
        -AccountName $verifyServer `
        -ev error `
        -ea SilentlyContinue
    }
    "cosmosdbsqlcontainer" { 
      Get-AzCosmosDBSqlContainer `
        -Name $namespace `
        -ResourceGroupName $verifyrg `
        -AccountName $verifyServer `
        -DatabaseName $verifyDbName `
        -ev error `
        -ea SilentlyContinue
    }
    "eventhub" {
      Get-AzEventHub -ResourceGroupName $verifyrg -Name $namespace -ev error -ErrorAction SilentlyContinue
    }
    Default {
      Write-Error "`nUnknown resource tag supplied at resource exists : "$t
    }
  }

  if (-Not $error) {
    return $true;
  }
    
  logVerbose ("isResourceExists: The resource does not exists in the resource group {0} : {1}" -f $verifyrg, $namespace)
  return $false
}


function encrypt($plainText) {
  $PFXPath = [Environment]::GetFolderPath("Desktop") + "\" + $SecretName + ".pfx" 
  $PFXPassword = '1234'
  #$PFX = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2
  ##################
  
  $PFX = New-Object -TypeName System.Security.Cryptography.X509Certificates.X509Certificate2($PFXPath, $PFXPassword)
  
  $BinCert = $PFX.GetRawCertData() 
  #$bytes = [System.Text.Encoding]::Default.GetBytes($PlainText)
  #$encrypted = $PFX.PublicKey.Key.Encrypt($bytes, $true)
  $base64cipherText = [Convert]::ToBase64String($BinCert)
  return $base64cipherText
  
  #[System.Convert]::ToBase64String($BinCert)
  ##################
  
  
  #$PFX.Import($PFXPath, $PFXPassword, [System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::DefaultKeySet)

  #$bytes = [System.Text.Encoding]::Default.GetBytes($PlainText)
  #$encrypted = $PFX.PublicKey.Key.Encrypt($bytes, $true)
  #$base64cipherText = [Convert]::ToBase64String($encrypted)
  #return $base64cipherText
}

function decrypt($cipherText) {
  $PFXPath = [Environment]::GetFolderPath("Desktop") + "\" + $SecretName + ".pfx" 
  $PFXPassword = '1234'
  $PFX = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2
  $PFX.Import($PFXPath, $PFXPassword, [System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::DefaultKeySet)

  $decodedBytes = [Convert]::FromBase64String($cipherText)
  $decryptedBytes = $PFX.PrivateKey.Decrypt($decodedBytes, $true)
  $decrypted = [System.Text.Encoding]::Default.GetString($decryptedBytes)
  return $decrypted
}

<#
Creates group resource based for the resouce. 
rg-servicename-stamp
#>
function CreateResourceGroupIfNotExists {
  param(
    [Parameter(Mandatory = $false)][string]$groupname
  )
  if (-Not $Global:debug) {
    $PSResourceGroup = Get-AzResourceGroup -Name $groupname -ev message -ea 0
    if ($null -eq $PSResourceGroup) {
      $resourceGroup = New-AzResourceGroup -Name $groupname -Location $geoLocation -Force
      # A two seconds interval is needed to completely provision the resource group.
      # Without waiting for rg creation, the resource creation is throwing error. 
      Start-Sleep -Seconds 2    
      logVerbose $resourceGroup.ResourceGroupName
    }
  }
  else {
    $logtext = "Create ResourceGroup in debug mode: $groupname"
    logVerbose $logtext
  }
}