# CRM Configuration

If you need to work with the CRM and in your development Flex project you'll
need to install the [LSVR CRM plugin](https://github.com/lsvr-software/LifesaverSupport).

Once you've done that, you'll need to update the Webchat studio flow in order to
associate tasks with a donor in our CRM. To do this, we'll need to pass the
donorId as a custom task attribute when a message comes into the Studio flow.
You can configure this by:

1. Visit Twilio and open the Studio editor.
1. Edit the "Webchat Flow" (unless you've renamed it).
1. Edit the "SendMessageToAgent" widget
1. Add the following to the "attributes" JSON:

```json
"donorId": "{{trigger.message.From}}"
```
