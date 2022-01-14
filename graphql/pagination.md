# Pagination
The following must be included for pagination to work properly:

## Rails
* When adding the new field include `.connection_type`
  * `Types::PhysicalVerificationPlasmaCaseType.connection_type`
* The definition of the type must inherit from [BaseObject](https://github.com/BuoySoftware/BuoyRails/blob/main/app/graphql/types/base_object.rb)
* When running `yarn resolve-gql` the connection should be added to the following javascript files:
  * possibleTypes.ts
  * TableActionsData.ts

## React
* Add the endpoint to apollo/client.ts with `inPlacePagination()`
* Use `TableActionsData` in the request to fetch the pagination information
* Use the `ConnectionTableBuilder` component for pagination functionality

## Resources
[GraphQL Pagination](https://graphql.org/learn/pagination/)
[Apollo Pagination](https://www.apollographql.com/docs/react/pagination/core-api/)
