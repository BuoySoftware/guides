# Getting Started

To get started, create an account with Twilio and start a new Flex project
that you can use for development purposes. This will guide you through the
process.

If you haven't already been added to our Flex projects for staging and
production, ask for access in our #engineering Slack channel.

Once you've created your Twilio account, you can do the following to configure
your LifesaverRails application.

1. Update your .env with your Account SID and Auth Token (This is available from
   your Twilio dashboard).
1. Create an API key. This can be done by visiting "Settings", then "API Keys".
1. Add the API key and it's secret to your .env file as well.
1. Start a new "Flex" project
1. Within the Twilio console, go to the "Programmable Chat" section.
1. Grab the SID for the programmable chat service that was created as part of
   Flex. This will likely be called "Flex Chat Service". Add this SID to your
  .env file.
1. Back in the Twilio console, go to the "Studio" section.
1. Grab the SID of the "Webchat Flow" which was created automatically when your
   Flex project was created.
1. In your terminal, run `rake twilio:create_flex_flow["WEBCHAT_FLOW_SID"]`,
   replacing WEBCHAT_FLOW_SID with the SID you just grabbed from the Twilio
   console.
1. The result of this operation should be "Twilio Flex Flow SID: SID_HERE".
1. Take this SID and add it to your .env file

You will now have configured your application to be able to chat from your local
app with your Twilio Flex development project.
