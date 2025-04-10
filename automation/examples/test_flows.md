# Test Flows

 Test flows should be structued in classes that accept Page and TestBuilder as parameters in the constructor. The class name should reflect the purpose of the related test flows and fall into one of the following two categories: 
 1. Validator - Used for repeated assertions. For example, validating panels on the donation record page.
 2. Builder - Used for repeated actions. For example, e2e flows.

 ## Validator Example
```ts
export class ExamplePageValidators {
  readonly page: Page;
  readonly TB: TestBuilder;

  constructor(page: Page, TB: TestBuilder) {
    this.page = page;
    this.TB = TB;
  }
}
```
 ## Builder Example
```ts
export class RegistrationBuilder {
  readonly profileStep: ProfileStep;

  constructor(context: BrowserContext, page: Page) {
    this.profileStep = new ProfileStep(context, page);
  }
}
```
 ## Methods
Test Builder classes can define one or more async methods that perform validations on different sections of a page. 

These mathods can accept parameters required to complete test scenarios. Assertions can be used to verify expected behavior inside of methods.

Test steps should be defined within the method. 

### Example:
```ts
  async validatePhlebotomySection(fixture: SampleDrawFixture): Promise<void> {
    const phlebotomySection = this.sampleRecordPage.phlebotomySection;

    await this.TB.addTestStep(
      "can validate the Phlebotomy section",
      [
        "confirm the phlebotomy section is visible",
        "confirm the visit type is visible",
        "confirm the ucn is visible",
      ],
      async () => {
        await phlebotomySection.sectionElm.scrollIntoViewIfNeeded();

        await expect(phlebotomySection.sectionElm).toBeVisible();
        expect(await phlebotomySection.cellData("visit_type")).toEqual(
          this.sampleRecordPage.t_visit_type("SAMPLE_ONLY"),
        );
        expect(await phlebotomySection.cellData("unit_control_number")).toEqual(
          fixture.ucn,
        );
      },
    );
  }
```

When the test flow is called inside of a spec, there is no need to add additional test steps. 

### Example:
```ts
  test(
    "screener completes donor registration",
    { tag: ["@TCID-XXXX"] },
    async ({ context, page }) => {
      const registrationBuilder = new RegistrationBuilder(context, page, {
        headless: IS_HEADLESS,
      });

      await registrationBuilder.navigationBuilder.login();
    },
  );
```


