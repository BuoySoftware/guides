# Change Requests

- Always set the `PaperTrail.request.whodunnit` to your account ID before
  performing a change request.
- Set up Slack notifications for [UrgentChangeRequest]
- Some change requests require an update to a versioned field. You cannot update
  a versioned field successfully without setting the employee ID in the
  PaperTrail request controller info. Find the ID of the employee who set the
  original data by looking at `record.versions`. Then use that employee ID with
  the following command:

  `PaperTrail.request.controller_info = { employee_id: <ID of employee> }`

[urgentchangerequest]: slack-notifications.png

## Donor visit was accidentally ended early

- Confirm the following:
  - Which queue the donor should be in
  - What status the donation should be in (likely `:in_progress` or
    `:checked_in`)
- Update the `donation`
  - For Example: `donation.update!(status: :in_progress)`
- Update the `queued_donor`
  - For Example: `queued_donor.update!(completed_at: nil, donor_queue: :phlebotomy, queued_at: DateTime.current)`
