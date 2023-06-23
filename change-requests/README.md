# Change Requests

- Set up Slack notifications for [UrgentChangeRequest]
- Always set the `PaperTrail.request.whodunnit` to your account ID before
  performing a change request.

  ```ruby
    PaperTrail.request.whodunnit = Account.find_by!(
      email: "FIRSTNAME@buoysoftware.com"
    ).id
  ```

- Some change requests require an update to a versioned field. You cannot update
  a versioned field successfully without setting the some additional info in the
  PaperTrail request controller info.

  ```ruby
    employee = Employee.find_by!(last_name: "Doe")
    facility = Facility.find_by!(name: "Paris")
    PaperTrail.request.controller_info = {
      employee_id: employee.id,
      facility_id: facility.id,
      location_id: facility.center_location.id
    }
  ```

[UrgentChangeRequest]: slack-notifications.png
