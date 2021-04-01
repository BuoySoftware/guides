# Getting Started

To get started, you will need to create an account with Twilio and start a new
Flex project that you can use for development purposes. This will guide you
through that process.

If you haven't already been added to our Flex projects for staging and
production, ask for access in our #engineering Slack channel.

Once you've created your Buoy Twilio account, you can do the following to
configure your Buoy application.

1. Create a new Twilio project with account name `Buoy Development`.
1. Complete the verifications steps.
1. For the "Which product are you here to use?" question select `Flex` as the
   option.
1. The rest of the questions can be whatever values.
1. Update your .env with your Account SID (`TWILIO_ACCOUNT_SID`),
   Auth Token (`TWILIO_AUTH_TOKEN`),
   and Phone Number (`TWILIO_SMS_NUMBER`)
   (This is available from the Twilio dashboard).
1. Create an API key. This can be done by visiting "Settings", then "API Keys".
1. Add the API key and it's secret to your .env file as well (`TWILIO_API_KEY`
   and `TWILIO_API_SECRET` respectively).
1. Within the Twilio console, go to the "Programmable Chat" section (this can be
   found under the All Products and Services ellipses menu at the bottom of the
   left side menu).
1. Grab the SID for the Programmable Chat service that was created as part of
   Flex. This will likely be called "Flex Chat Service". Add this SID to
   `TWILIO_SERVICE_SID` in your .env file.
1. Back in the Twilio console, go to the "Studio" section.
1. Grab the SID of the "Webchat Flow" which was created automatically when your
   Flex project was created.
1. In your terminal, run `rake twilio:create_flex_flow["WEBCHAT_FLOW_SID"]`,
   replacing `WEBCHAT_FLOW_SID` with the Flex Chat Service SID you just grabbed
   from the Twilio console. Note: you may need to run `bin/spring stop` before
   this command so that your updated .env file is loaded.
1. The result of this operation should be "Twilio Flex Flow SID: SID_HERE".
1. Take this SID and add it to your .env file for `TWILIO_FLEX_FLOW_SID`. Note:
   if you need this again laster this is the Messaging Flow SID under the Studio
   Dashboard.

You will now have configured your application to be able to chat from your local
app with your Twilio Flex development project.
