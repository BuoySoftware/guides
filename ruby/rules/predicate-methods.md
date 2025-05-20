# Predicate Method Naming Convention

## Rule Description

Use the `?` suffix for methods that return a boolean value (predicate methods).

## Why it Matters

Predicate methods are methods that answer a yes/no question about their receiver or arguments. Using the `?` suffix is a Ruby convention that:

- Makes code more readable and self-documenting
- Clearly indicates the method's return type without checking implementation
- Follows the principle of least surprise for Ruby developers
- Makes it easier to distinguish between methods that query state vs methods that perform actions

## Examples

### Good Examples

```ruby
class User
  def admin?
    role == 'admin'
  end

  def active?
    !deactivated_at
  end

  def eligible_for_promotion?(minimum_purchases)
    purchases.count >= minimum_purchases
  end
end

# Usage
user.admin?               # Clear that it returns true/false
user.active?             # Immediately understand it's a state check
user.eligible_for_promotion?(5)  # Obviously a qualification check
```

### Bad Examples

```ruby
class User
  # Don't omit the ? for boolean methods
  def admin
    role == 'admin'
  end

  # Don't use ? for non-boolean methods
  def age?
    calculate_age
  end

  # Don't use is_ prefix with ?
  def is_active?  # redundant, just use active?
    !deactivated_at
  end
end
```

## Best Practices

1. Only use `?` suffix for methods that return `true` or `false`
2. Name the method as a question that can be answered with yes/no
3. Avoid combining `is_` or `has_` prefixes with the `?` suffix
4. Keep predicate methods simple and focused on a single condition
5. Predicate methods should only query state, not modify it

## When to Break the Rule

While this is a strong convention in Ruby, there might be rare cases where you might deviate:

1. When implementing an interface from a non-Ruby system that requires different naming
2. When working with external APIs or frameworks that enforce different conventions

## Related Concepts

- Ruby's built-in predicate methods (e.g., `empty?`, `nil?`, `include?`)
- Rails' predicate methods (e.g., `exists?`, `valid?`, `present?`)
- Boolean method naming in other programming languages

## Additional Resources

- [Ruby Style Guide](https://rubystyle.guide/#bool-methods-qmark)
- [Thoughtbot's Ruby Style Guide](https://github.com/thoughtbot/guides/blob/main/ruby/README.md) 