# Named Exports

Prefer Named exports over default exports.

By leveraging named exports and exporting all, we reap two main benefits:

1. We reduce the risk of identifying the same code by two different variable
   names (this also results in better auto complet via TypeScript tooling).
1. We remove the bloat and duplication of exports from the index files.

## Bad

### dir/

```
dir/
  foo/
    foo.ts
    bar.ts
    index.ts
```

### dir/foo/foo.ts

```
const foo = () => {
  ... do some code
}

export default foo;
```

### dir/foo/bar.ts

```
const bar = () => {
  ... do some code
}

export default bar;
```

### dir/foo/index.ts

```
export { default } from "./foo"
export { default as bar } from "./bar"
```

## Good

### dir/

```
dir/
  foo/
    foo.ts
    bar.ts
    index.ts
```

### dir/foo/foo.ts

```
export const foo = () => {
  ... do some code
}
```

### dir/foo/bar.ts

```
export const bar = () => {
  ... do some code
}
```

### dir/foo/index.ts

```
export * from "./foo"
export * from "./bar"
```
