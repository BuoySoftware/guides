# Floating Promises

When leveraging async functions, it's best to await the result or catch and
handle the errors. However, there are valid scenarios where you, the engineer,
may want to intentionally skip waiting or handling the result of an async
call.

One specific example is leveraging the side effects of a React component to
handle the async result of an Apollo query.

```
const ListOfThings: React.FC = (): React.ReactElement => {
  const [getTheThings, { data, error, loading }] = useLazyGetTheThingsQuery();

  const onClick = () => {
    void getTheThings();
  }

  if (loading) return <Loading />;
  if (error) return <ErrorHandler error={error} />;
  if (!data) return <Button onClick={onClick}>Get The Things</Button>

  return <ListedThings data={data} />;
}
```

In the example above, we aren't awaiting or handling the result of calling
`getTheThings()`. All stages of that async execution (loading, data returned,
and error) are handled by side effects and the usage of the `error`, `loading`,
and `data` variables.

## Do

Prefix an asynchronous call with `void` when you are intentionally handling
results and errors elsewhere.

## Don't

Prefix an asynchronous call with `void` to silence the linting error.

## Resources

- [Detailed blog post on eslint's no-floating-promises rule](https://mikebifulco.com/posts/eslint-no-floating-promises)
- [Original issue for working around the eslint rule](typescript-eslint/typescript-eslint#4722)
