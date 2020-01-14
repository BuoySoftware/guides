# Webhooks

Webhooks are utilized by the Twilio Flex Proxy in order to handle when a donor
opts out of SMS messages or opts back in. For local testing, you'll want to set
up an Ngrok account. If you haven't already been invite to the team, ask in
the #engineering Slack channel.

Once you have Ngrok set up, you can do the following:

1. Set the `APPLICATION_HOST` in your `.env` to your Ngrok reserved host name.
1. Visit Twilio
1. Go to "Proxy" under "Engagement Cloud" in the Twilio console.
1. Open the "Flex Proxy Service"
1. Add the following callback URL: `https://YOUR_APPLICATION_HOST_HERE/twilio_proxy_callbacks`
1. Save

Any SMS messages that are sent to your development Flex phone number will now
trigger webhooks to be sent to your development environment.
