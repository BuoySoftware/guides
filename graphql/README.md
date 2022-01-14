# GraphQL

A guide for building great GraphQL servers and clients.

## Best Practices

* Use `find` prefix when creating a field to lookup a single data set, ie `findDonation(id: ID!)` vs `donation(id: ID!)`
[Issue 3448](https://github.com/BuoySoftware/BuoyRails/issues/3448)
* Avoid accepting overloaded or multiple arguments for a field, ie `donor(id: ID, email: String)`, create multiple fields instead, ie `findDonorByID(id: ID!)` and `findDonorByEmail(email: String!)`
* Use the [GraphQL Dataloader] pattern to eager load associations and avoid n + 1
  queries. For example, [GraphQL Batch].

### Apollo

* Always include a type's ID field if it has one for caching.
* Colocate queries and mutations in the components they are used
* [Colocate fragments] to split up query logic between components.

## Pagination
[Pagination](./pagination.md)

## Learning

[Production Ready GraphQL](https://book.productionreadygraphql.com)

[GraphQL Dataloader]: https://xuorig.medium.com/the-graphql-dataloader-pattern-visualized-3064a00f319f
[GraphQL Batch]: https://github.com/Shopify/graphql-batch
[Colocate fragments]: https://www.apollographql.com/docs/react/data/fragments/#colocating-fragments
