# GraphQL

A guide for building great GraphQL servers and clients.

## Best Practices

* Use `find` prefix when creating a field to lookup a single data set, ie `findDonation(id: ID!)` vs `donation(id: ID!)`
[Issue 3448](https://github.com/BuoySoftware/BuoyRails/issues/3448)
* Avoid accepting overloaded or multiple arguments for a field, ie `donor(id: ID, email: String)`, create multiple fields instead, ie `findDonorByID(id: ID!)` and `findDonorByEmail(email: String!)`
* Use [GraphQL Batch] to eager load association to avoid n+1 queries.

## Learning

[Production Ready GraphQL](https://book.productionreadygraphql.com)

[GraphQL Batch]: https://github.com/Shopify/graphql-batch
