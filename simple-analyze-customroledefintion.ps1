<#

.Synopsis

  Can be used when testing a newly created custom role, to see if there are inadvertnet permissions granted on known risky Azure management APIs. 
  This can be community driven to submit samples of risky API collections.

  1. Reading your custom Role ID and Looking at your Actions and NotActions.
  2. Within Actions and NotActions seeking all provider operations defined in Custom Role ID.
  3. Comparing Actions and NotActions riskyAPIs found, and eliminating risky api from list if implictly or explictly defined in NotActions
  4. Output risky apis not explictly or implictly defined in NotActions, these may be inadvernt priveleges you have granted through Actions.


  More information mentioned here : https://techcommunity.microsoft.com/t5/azure-active-directory-identity/creating-custom-roles-in-the-azure-portal-is-now-in-public/ba-p/1144697


.Requirements

  Az.Resources

.Known Issues
    
  

#>

## To add to this list simply place a coma , and tilda ` and and enter a new line of string for the risky api
# List of Risky API operations to check for
$riskyapilist = @( `
"Microsoft.Authorization/classicAdministrators/write", ` #privilege escalation
"Microsoft.Authorization/roleDefinitions/write", ` #privilege escalation
"Microsoft.Authorization/roleAssignments/write", ` #privilege escalation
"Microsoft.Compute/disks/beginGetAccess/action", ` #data exfiltration
"Microsoft.Compute/snapshots/beginGetAccess/action" #data exfiltration
"Microsoft.Storage/storageAccounts/blobServices/generateUserDelegationKey/action", ` #data exfiltration
"Microsoft.Storage/storageAccounts/listKeys/action" #data exfiltration
)


#Array list based
$confirmedactionriskyapis = [System.Collections.ArrayList]@()
$confirmednotactionriskyapis = [System.Collections.ArrayList]@()


## you can test built in roles and custom roles by their id | https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles
#$roleId = "" # Custom - AzureFileSyncOperator
#$roleId = "" # Custom - SwiftSolvesContributor
#$roleId = "acdd72a7-3385-48ef-bd42-f606fba81ae7" # BuiltIn - Reader
$roleId = "b24988ac-6180-42a0-ab88-20f7382dd24c" # BuiltIn - Contributor


# Future work
# will pass in param later from trigger of custom roleId

#obtain information about roleId
$roledef = Get-AzRoleDefinition -Id $roleId

#actions for roleId
$roleactions = $roledef.Actions

#not actions for roleId
$notroleactions = $roledef.NotActions

#start analyzing the individual apis allowed from custom roleId
ForEach ($roleaction in $roleactions) {

    # obtain all apis from provider type being passed in from each action
    $provops = Get-AzProviderOperation -OperationSearchString $roleaction
    
    # Analyze each provider operation api call against the RiskyAPI list for matches
    ForEach ($provop in $provops){
    
        If ($riskyapilist -contains $provop.operation){
        
            # Add matched risky api to new compare list of defined Actions
            $confirmedactionriskyapis.Add( $provop.Operation )
        
        }

    }

}

#start analyzing the individual apis allowed from custom roleId
ForEach ($notroleaction in $notroleactions) {

    # obtain all apis from provider type being passed in from each action
    $notprovops = Get-AzProviderOperation -OperationSearchString $notroleaction
    
    # Analyze each provider operation api call against the RiskyAPI list for matches
    ForEach ($notprovop in $notprovops){
    
        If ($riskyapilist -contains $notprovop.operation){
        
            # Add matched risky api to new compare list of defined NotActions
            $confirmednotactionriskyapis.Add( $notprovop.Operation )
        
        }

    }

}

#Compare lists and output risky APIs not explictly or implictly defined in NotActions, these may be inadvernt priveleges you have granted.
$confirmedactionriskyapis | Where-Object -FilterScript { $_ -notin $confirmednotactionriskyapis } 

# Some future stuff to add additional context and output to
#| Foreach( ){
#}