# Change Requests

* Always set the `PaperTrail.request.whodunnit` to your account ID before
  performing a change request.
* Set up Slack notifications for [UrgentChangeRequest]
* Some change requests require an update to a versioned field. You cannot update
  a versioned field successfully without setting the employee ID in the
  PaperTrail request controller info. Find the ID of the employee who set the
  original data by looking at `record.versions`. Then use that employee ID with
  the following command:

  `PaperTrail.request.controller_info = { employee_id: <ID of employee> }`

[UrgentChangeRequest]: slack-notifications.png
