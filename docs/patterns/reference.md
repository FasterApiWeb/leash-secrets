# Pattern Reference

Complete reference of all 71 secret detection patterns.

!!! info "Auto-generated"
    This page documents every pattern in the `patterns/` directory. Each entry includes the regex, severity, risk assessment, and recommended fix.

## AWS {#aws}

| ID | Name | Severity | Fix |
|----|------|:--------:|-----|
| `aws-access-key-id` | AWS Access Key ID | 🔴 | `AWS_ACCESS_KEY_ID` env var or IAM roles |
| `aws-secret-access-key` | AWS Secret Access Key | 🔴 | `AWS_SECRET_ACCESS_KEY` env var or IAM roles |
| `aws-session-token` | AWS Session Token | 🔴 | Use AWS SDK credential providers |
| `aws-mws-key` | AWS MWS Key | 🔴 | AWS Secrets Manager or env var |

## GCP {#gcp}

| ID | Name | Severity | Fix |
|----|------|:--------:|-----|
| `gcp-api-key` | Google API Key | 🔴 | `GOOGLE_API_KEY` env var, restrict in GCP console |
| `gcp-oauth-client-secret` | Google OAuth Client Secret | 🔴 | Env var or secret manager |
| `gcp-service-account-key` | GCP Service Account Key | 🔴 | Workload Identity Federation |
| `firebase-config` | Firebase Configuration | 🟡 | Firebase client config is public by design; check security rules |

## Azure {#azure}

| ID | Name | Severity | Fix |
|----|------|:--------:|-----|
| `azure-storage-account-key` | Azure Storage Account Key | 🔴 | Managed Identity or SAS tokens |
| `azure-client-secret` | Azure AD Client Secret | 🔴 | `AZURE_CLIENT_SECRET` env var or Key Vault |
| `azure-connection-string` | Azure Service Connection String | 🔴 | Azure Key Vault or env var |
| `azure-sas-token` | Azure SAS Token | 🟡 | Generate at runtime with minimal scope |

## GitHub & Git {#github}

| ID | Name | Severity | Fix |
|----|------|:--------:|-----|
| `github-pat-fine-grained` | GitHub Fine-Grained PAT | 🔴 | `GITHUB_TOKEN` env var or deploy keys |
| `github-pat-classic` | GitHub Classic PAT | 🔴 | Migrate to fine-grained PAT |
| `github-oauth-token` | GitHub OAuth Token | 🔴 | Secure session storage |
| `github-app-token` | GitHub App Token | 🔴 | Generate at runtime via App private key |
| `github-refresh-token` | GitHub App Refresh Token | 🔴 | Encrypted session storage |
| `gitlab-pat` | GitLab PAT | 🔴 | CI/CD variables or env var |
| `gitlab-pipeline-trigger` | GitLab Pipeline Trigger | 🔴 | CI/CD variables |
| `bitbucket-app-password` | Bitbucket App Password | 🔴 | Env var or Pipelines secure variables |

## AI Providers {#ai-providers}

| ID | Name | Severity | Fix |
|----|------|:--------:|-----|
| `openai-api-key` | OpenAI API Key (legacy) | 🔴 | `OPENAI_API_KEY` env var |
| `openai-api-key-project` | OpenAI Project API Key | 🔴 | `OPENAI_API_KEY` env var |
| `anthropic-api-key` | Anthropic API Key | 🔴 | `ANTHROPIC_API_KEY` env var |
| `cohere-api-key` | Cohere API Key | 🔴 | `COHERE_API_KEY` env var |
| `huggingface-token` | Hugging Face Token | 🔴 | `HF_TOKEN` env var |
| `replicate-api-token` | Replicate API Token | 🔴 | `REPLICATE_API_TOKEN` env var |

## Payments {#payments}

| ID | Name | Severity | Fix |
|----|------|:--------:|-----|
| `stripe-live-secret-key` | Stripe Live Secret Key | 🔴 | `STRIPE_SECRET_KEY` env var. **ROTATE IMMEDIATELY if committed.** |
| `stripe-live-restricted-key` | Stripe Live Restricted Key | 🔴 | Env var with minimal permissions |
| `stripe-webhook-secret` | Stripe Webhook Secret | 🔴 | `STRIPE_WEBHOOK_SECRET` env var |
| `stripe-test-key` | Stripe Test Key | ℹ️ | Still best to use env var |
| `paypal-client-secret` | PayPal Client Secret | 🔴 | `PAYPAL_CLIENT_SECRET` env var |
| `square-access-token` | Square Access Token | 🔴 | `SQUARE_ACCESS_TOKEN` env var |

## Databases {#databases}

| ID | Name | Severity | Fix |
|----|------|:--------:|-----|
| `postgres-connection-string` | PostgreSQL Connection String | 🔴 | `DATABASE_URL` env var |
| `mysql-connection-string` | MySQL Connection String | 🔴 | `DATABASE_URL` env var |
| `mongodb-connection-string` | MongoDB Connection String | 🔴 | `MONGODB_URI` env var |
| `redis-connection-with-password` | Redis Connection with Password | 🔴 | `REDIS_URL` env var |
| `supabase-service-role-key` | Supabase Service Role Key | 🔴 | `SUPABASE_SERVICE_ROLE_KEY` env var. **Never in client code.** |
| `planetscale-password` | PlanetScale Password | 🔴 | `DATABASE_URL` env var |

## Messaging {#messaging}

| ID | Name | Severity | Fix |
|----|------|:--------:|-----|
| `slack-bot-token` | Slack Bot Token | 🔴 | `SLACK_BOT_TOKEN` env var |
| `slack-user-token` | Slack User Token | 🔴 | `SLACK_USER_TOKEN` env var |
| `slack-webhook-url` | Slack Webhook URL | 🟡 | `SLACK_WEBHOOK_URL` env var |
| `discord-bot-token` | Discord Bot Token | 🔴 | `DISCORD_TOKEN` env var |
| `discord-webhook-url` | Discord Webhook URL | 🟡 | `DISCORD_WEBHOOK_URL` env var |
| `twilio-auth-token` | Twilio Auth Token | 🔴 | `TWILIO_AUTH_TOKEN` env var |
| `sendgrid-api-key` | SendGrid API Key | 🔴 | `SENDGRID_API_KEY` env var |
| `mailgun-api-key` | Mailgun API Key | 🔴 | `MAILGUN_API_KEY` env var |
| `telegram-bot-token` | Telegram Bot Token | 🔴 | `TELEGRAM_BOT_TOKEN` env var |

## CI/CD {#ci-cd}

| ID | Name | Severity | Fix |
|----|------|:--------:|-----|
| `npm-token` | npm Access Token | 🔴 | `NPM_TOKEN` env var |
| `pypi-token` | PyPI API Token | 🔴 | Trusted publishing or `TWINE_PASSWORD` |
| `docker-hub-token` | Docker Hub Token | 🔴 | `DOCKER_TOKEN` env var |
| `vercel-token` | Vercel Token | 🔴 | `VERCEL_TOKEN` env var |
| `netlify-token` | Netlify Token | 🔴 | `NETLIFY_AUTH_TOKEN` env var |
| `heroku-api-key` | Heroku API Key | 🔴 | `HEROKU_API_KEY` env var |
| `terraform-cloud-token` | Terraform Cloud Token | 🔴 | `TFE_TOKEN` env var |
| `circleci-token` | CircleCI Token | 🔴 | `CIRCLECI_TOKEN` env var |

## Cryptographic Material {#crypto}

| ID | Name | Severity | Fix |
|----|------|:--------:|-----|
| `rsa-private-key` | RSA Private Key | 🔴 | SSH agent or secret manager |
| `openssh-private-key` | OpenSSH Private Key | 🔴 | SSH agent forwarding |
| `ec-private-key` | EC Private Key | 🔴 | Secret manager |
| `dsa-private-key` | DSA Private Key | 🔴 | Migrate to Ed25519 |
| `pgp-private-key-block` | PGP Private Key | 🔴 | GPG agent |
| `generic-private-key` | Generic Private Key | 🔴 | Certificate manager or vault |
| `pkcs12-password` | PKCS12/PFX Password | 🟡 | Secret manager |

## Generic {#generic}

| ID | Name | Severity | Fix |
|----|------|:--------:|-----|
| `generic-password-assignment` | Hardcoded Password | 🟡 | Env var or secret manager |
| `generic-secret-assignment` | Hardcoded Secret | 🟡 | Env var named after service |
| `generic-api-key-assignment` | Hardcoded API Key | 🟡 | Identify service, use appropriate env var |
| `generic-token-assignment` | Hardcoded Token | 🟡 | Obtain at runtime via OAuth/OIDC |
| `generic-jwt-secret` | JWT Signing Secret | 🔴 | `JWT_SECRET` env var, use RS256 in production |
| `generic-basic-auth-url` | URL with Basic Auth | 🔴 | Separate credentials from URLs |
| `generic-bearer-token-inline` | Inline Bearer Token | 🔴 | Obtain tokens at runtime |
| `generic-encryption-key` | Hardcoded Encryption Key | 🔴 | KMS (AWS KMS, GCP KMS, Azure Key Vault) |
| `ip-address-private` | Private IP Address | ℹ️ | Use DNS names or config variables |
