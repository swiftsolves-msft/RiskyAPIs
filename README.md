# Analyze-CustomRoleDefinition
author: Nathan Swift

[New Azure Portal UI experience for creating and editing custom roles is avaliable!](https://techcommunity.microsoft.com/t5/azure-active-directory-identity/creating-custom-roles-in-the-azure-portal-is-now-in-public/ba-p/1144697)

Can be used when testing a newly created custom role, to see if there are inadvertent permissions granted on known risky Azure management APIs. 

Longer term goals include:

    Community driven effort to build .csv or undefined template file you can import that defines risky APIs with some context, classification, and why

    A documented scenario where triggered alert of a new custom role definition executes script.


    <a href="https%3A%2F%2Fgithub.com%2FMarkSimos%2FMicrosoftSecurity%2Fblob%2Fmaster%2FAzure%20Security%20Compass%201.1%2FAzureSecurityCompassIndex.md" target="_blank">
    <img src="https://raw.githubusercontent.com/swiftsolves-msft/RiskyAPIs/blob/master/images/customroleguidance.png"/>
</a>