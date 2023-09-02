# Drop

This package exports `DropAppComponent`, which adds debug pages, repository implementations, and utilities to help integrate [drop_core](../drop_core/README.md) into your Pond app.

## Hooks

- `useQuery(query)`: Runs the `query` and returns a `Model` which listens to the result of running the query.
- `useEntity<MyEntity>(id)`: Runs a query to find the entity of type `MyEntity` with id `id` and returns a `Model` which listens to the result of running the query.

## Debugging

See a list of all the queries run to generate the page in the debug dialog (visible when adding `?_debug=true` to the end of the URL).

In the debug page, view all the `Drop` repositories and examine their contents.
