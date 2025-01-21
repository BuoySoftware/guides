# Code Structure

## Packwerk

At Buoy we utilize [packwerk] to enable us to organize our code into
packages based on domain concepts or business flows.

### Guide

- Prefer creating packs to encompass business flows (i.e. Processing, Payments).
- Prefer adding pack specific models and concerns inside the pack if possible.
- Prefer setting stewards.
- Avoid creating team based packs.

[packwerk]: https://github.com/Shopify/packwerk

## Object-Oriented Design

- Avoid global variables.
- Avoid long parameter lists.
- Limit dependencies of an object (entities an object depends on).
- Limit an object's dependents (entities that depend on an object).
- [Prefer composition over inheritance].
- Prefer small methods. Between one and five lines is best.
- Prefer small classes with a single, well-defined responsibility. When a class
  exceeds 100 lines, it may be doing too many things.
- [Tell, don't ask].

[Prefer composition over inheritance]: https://thoughtbot.com/blog/reusable-oo-composition-vs-inheritance
[tell, don't ask]: https://robots.thoughtbot.com/tell-dont-ask
