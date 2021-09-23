<#
Creates Config Store Server
#>
function CreateConfigStoreIfNotExist() {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $false)][hashtable]$map
  )

  $location = $geoLocation
  $namespace = GetServerName $map.servername
  $rgname = GetGroupName -groupname $map.groupname

  CreateResourceGroupIfNotExists -groupname $rgname

  if (-Not $Global:debug) {
    $resourceExists = (isResourceExists $namespace $rgname $Tags.sqlserver)
    if (-Not $resourceExists) {
      $rgname = GetGroupName $map.groupname
      $username = $map.username
      $password = generatePassword
      $passSecuredString = ConvertTo-SecureString $password -AsPlainText -Force
      $credentials = (New-Object System.Management.Automation.PSCredential ($username, $passSecuredString))
                   
      $provision = New-AzSqlServer `
        -ServerName $namespace `
        -ResourceGroupName $rgname `
        -SqlAdministratorCredentials $credentials `
        -Location $location `
        -ev err `
        -ea Continue

      storeKeyVault -name $username -connectionString $password    
            
      if ($err) {
        Write-Host "Error"
        throw $err
      }
      $text = ("Started Provisioning SQL Server : {0}" -f $provision.ServerName)
      logVerbose $text
    }
    else {
      $text = ("Sql Server already exists : " -f $namespace)
      logVerbose $text
    }
  }
  else {
    $text = ("Create SQL Server in debug mode : " -f $namespace)
    logVerbose $text
  }
}


<#
Creates Config Store Databases
#>
function CreateConfigDatabaseIfNotExists() {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $false)][hashtable]$map
  )    
    
  $server_ = GetServerName -name $map.servername.ToLower()

  $kvname_ = GetKvName
  $dbname = $map.name
  $rgname = GetGroupName $map.groupname

  CreateResourceGroupIfNotExists -groupname $rgname

  if (-Not $Global:debug) {
    $serverExists = (isResourceExists $server_ $rgname $Tags.sqlserver)        
    if ($serverExists) {
      $resourceExists = (isResourceExists $dbname $rgname $Tags.sqldb $server_)

      logVerbose "SQL Server $server_ exists; so proceeding to Database provision"

      if (-Not $resourceExists) {
        $provision = New-AzSqlDatabase `
          -DatabaseName $dbname `
          -ServerName $server_ `
          -ResourceGroupName $rgname `
          -Edition Premium `


        $serverInstance = Get-AzSqlServer -ResourceGroupName $rgname -ServerName $server_
        $secure_pwd = (Get-AzKeyVaultSecret -vaultName $kvname_ -name $serverInstance.SqlAdministratorLogin).SecretValueText
        $ConnectionString = "server=" + $serverInstance.FullyQualifiedDomainName + ";database=" + $dbname + ";uid=" + $serverInstance.SqlAdministratorLogin + ";password=" + $secure_pwd + ";"
        $ConnectionName = ('o365Audit-{0}-{1}' -f $serverInstance.ServerName, $dbname)
        storeKeyVault -connectionString $ConnectionString -name $ConnectionName
                
        $text = ("Provisioning SQL Database : {0}" -f $provision.DatabaseName)
        logVerbose $text
      }
      else {
        logVerbose "ConfigDB already exists: $dbname"
      }
    }
    else {
      logVerbose "SQL Server $server_ does not exist"
    }
  }
  else {
    logVerbose "Create ConfigDB  in debug mode: $dbname"
  } 
}

function generatePassword() {
  $generate = [System.Web.Security.Membership]::GeneratePassword(50, 3)
  $password = ($generate -replace '[\W_]', '')
  return $password
}