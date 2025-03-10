# View Components

## Colocate Stimulus controller along with the view component it belongs to

Sometimes view components need associated Stimulus controllers. When this is the case, ideally the controller should be colocated alongside the view component. For example:

```
app/components/
├─ masked_text_component/
│ ├─ masked_text_component.rb
│ ├─ masked_text_component.html.erb
│ └─ masked_text_component.js
```

The JavaScript file should export the controller class:

```js
// masked_text_component.js
import { Controller } from "@hotwired/stimulus"

export class MaskedTextController extends Controller {
  // controller implementation
}
```

The controller will be automatically registered with the identifier `masked-text` (derived from the class name `MaskedTextController`). You can then use this controller in your component's template.

Note: You can export multiple controllers from a single file - each controller's identifier will be automatically generated from its class name (minus the "Controller" suffix).

## Testing

Stimulus controllers should be tested indirectly through feature specs that focus on the component's behavior from a user's perspective.
