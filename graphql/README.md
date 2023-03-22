# GraphQL

A guide for building great GraphQL servers and clients.

## Best Practices

- Follow the [Apollo Schema Naming Conventions] document for conventions on
  naming types, fields, and arguments.
- Avoid accepting overloaded or multiple arguments for a field, ie `donor(id: ID, email: String)`, create multiple fields instead, ie `findDonorByID(id: ID!)` and `findDonorByEmail(email: String!)`
- Use the [GraphQL Dataloader] pattern to eager load associations and avoid n + 1
  queries. For example, [GraphQL Batch].
- Use a single argument called input when creating mutations, following the
  Relay spec. [Example](graphql/examples/mutation_input.graphl)

### Apollo

- Always include a type's ID field if it has one for caching.
- Colocate queries and mutations in the components they are used
- [Colocate fragments] to split up query logic between components.

## Learning

[Production Ready GraphQL](https://book.productionreadygraphql.com)

[Apollo Schema Naming Conventions]: https://www.apollographql.com/docs/technotes/TN0002-schema-naming-conventions/
[Colocate fragments]: https://www.apollographql.com/docs/react/data/fragments/#colocating-fragments
[GraphQL Batch]: https://github.com/Shopify/graphql-batch
[GraphQL Dataloader]: https://xuorig.medium.com/the-graphql-dataloader-pattern-visualized-3064a00f319f
