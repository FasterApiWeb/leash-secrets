# Rails setup with leash-secrets

Rails credentials and ENV vars should never appear as plaintext secrets in the repo. leash-secrets catches common leaks early.

## 1. Install leash-secrets

```bash
curl -fsSL https://raw.githubusercontent.com/FasterApiWeb/leash-secrets/main/scripts/install.sh | bash
```

## 2. Prefer ENV / credentials over hardcoding

```ruby
# config/database.yml or initializer — good
Rails.application.credentials.aws[:access_key_id]
ENV.fetch("STRIPE_SECRET_KEY")
```

```ruby
# avoid
Stripe.api_key = "sk_live_example_not_real" # will be flagged
```

Use `rails credentials:edit` or your platform's secret store for production values.

## 3. Scan before push

```bash
leash-secrets scan .
```

Keep `master.key` and decrypted credential files out of git. The installer can add a pre-commit hook that blocks known secret patterns.

## 4. CI

Add a scan step in GitHub Actions / CI so PRs cannot introduce Stripe, AWS, or GitHub tokens unnoticed.
