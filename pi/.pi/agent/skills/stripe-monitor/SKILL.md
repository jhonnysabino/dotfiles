---
name: stripe-monitor
description: Monitor Stripe payments, subscriptions, disputes, and revenue. Read-only access to payment data for alerts and reporting.
tools:
  - shell
---

# Stripe Payment Monitor

## Authentication

Use the environment variable `STRIPE_SECRET_KEY` for all API requests.
Base URL: `https://api.stripe.com/v1`
All requests use Bearer token authentication:

Authorization: Bearer $STRIPE_SECRET_KEY

## Available Operations

### Check Recent Failed Charges

Retrieve charges that failed in the last 24 hours:

curl -s -G "https://api.stripe.com/v1/charges" \
  -H "Authorization: Bearer $STRIPE_SECRET_KEY" \
  -d "limit=100" \
  -d "created[gte]=$(date -d '24 hours ago' +%s)" \
  | jq '[.data[] | select(.status == "failed")] | length as $count | {failed_count: $count, charges: [.[] | {id: .id, amount: (.amount / 100), currency: .currency, failure_message: .failure_message, customer: .customer, created: (.created | todate)}]}'

### List Active Disputes

Fetch all open disputes requiring attention:

curl -s -G "https://api.stripe.com/v1/disputes" \
  -H "Authorization: Bearer $STRIPE_SECRET_KEY" \
  -d "limit=50" \
  | jq '.data[] | select(.status == "needs_response" or .status == "warning_needs_response") | {id: .id, amount: (.amount / 100), currency: .currency, reason: .reason, due_by: (.evidence_details.due_by | todate), charge: .charge}'

### Get Revenue Summary

Pull balance data for revenue overview:

curl -s "https://api.stripe.com/v1/balance" \
  -H "Authorization: Bearer $STRIPE_SECRET_KEY" \
  | jq '{available: [.available[] | {amount: (.amount / 100), currency: .currency}], pending: [.pending[] | {amount: (.amount / 100), currency: .currency}]}'

### Check Recent Subscription Cancellations

List subscriptions that were canceled in the last 7 days:

curl -s -G "https://api.stripe.com/v1/subscriptions" \
  -H "Authorization: Bearer $STRIPE_SECRET_KEY" \
  -d "status=canceled" \
  -d "limit=50" \
  -d "created[gte]=$(date -d '7 days ago' +%s)" \
  | jq '.data[] | {id: .id, customer: .customer, cancel_reason: .cancellation_details.reason, canceled_at: (.canceled_at | todate), plan: .items.data[0].price.id}'

### List Failed Invoices

Retrieve invoices that failed to collect payment:

curl -s -G "https://api.stripe.com/v1/invoices" \
  -H "Authorization: Bearer $STRIPE_SECRET_KEY" \
  -d "status=uncollectible" \
  -d "limit=25" \
  | jq '.data[] | {id: .id, customer_email: .customer_email, amount_due: (.amount_due / 100), currency: .currency, attempt_count: .attempt_count, next_payment_attempt: .next_payment_attempt}'

## Rules

- This is a READ-ONLY monitoring skill. Never attempt to create, update, or delete any Stripe resources.
- When reporting failed charges, always include the failure reason and customer identifier.
- For disputes, highlight the response deadline. If a dispute is due within 48 hours, flag it as URGENT.
- Convert all amounts from cents to dollars (divide by 100) before presenting to the user.
- Format currency amounts with two decimal places and the currency code.
- Never log or display the full API key in responses or memory files.
- If you receive a 429 rate limit response, wait 10 seconds and retry once.