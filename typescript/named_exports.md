# Named Exports

By leveraging named exports we reap two main benefits:

1. We reduce the risk of identifying the same code by two different variable
   names.
1. We remove bloat from index files, making it easier to identify and organize
   named exports.

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

export default foo;
```

### dir/foo/bar.ts

```
export const bar = () => {
  ... do some code
}

export default bar;
```

### dir/foo/index.ts

```
export { default } from "./foo"

export { foo } from "./foo"
export { bar } from "./bar"
```
