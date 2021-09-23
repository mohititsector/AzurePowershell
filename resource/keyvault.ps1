<#
Creates Key Vault 
#>
function CreateKeyVaultIfNotExists {
  $namespace = GetKvName
  $rgname = GetGroupName -groupname $common.keyvaults.groupname

  CreateResourceGroupIfNotExists -groupname $rgname

  if (-Not $Global:debug) {        
    $resourceExists = (isResourceExists $namespace $rgname $Tags.keyvault)
    if (-Not $resourceExists) {
      $provision = New-AzKeyVault `
        -Name $namespace `
        -ResourceGroupName $rgname `
        -Location $geoLocation `
        -ev error `
        -ea 0

      if ($error) {
        throw $error
      }
            
      $log = ("Successfully Provisioned KV: {0}" -f $provision.VaultName)
      logVerbose $log
    }
    else {
      $log = ("KV already exists in the Azure: {0}" -f $namespace)
      logVerbose $log
    }
  }
  else {
    $log = ("Create KV in demo mode: {0}" -f $namespace)
    logVerbose $log
  }
}
