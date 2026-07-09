# Next.js setup with leash-secrets

Next.js apps often mix public `NEXT_PUBLIC_*` values with private server secrets. leash-secrets helps keep the private ones private.

## 1. Install leash-secrets

```bash
curl -fsSL https://raw.githubusercontent.com/FasterApiWeb/leash-secrets/main/scripts/install.sh | bash
```

Windows PowerShell:

```powershell
irm https://raw.githubusercontent.com/FasterApiWeb/leash-secrets/main/scripts/install.ps1 | iex
```

## 2. Environment variable conventions

```bash
# .env.local (never commit real values)
DATABASE_URL=postgresql://USER:PASSWORD@localhost:5432/app
OPENAI_API_KEY=replace-me
NEXT_PUBLIC_APP_URL=http://localhost:3000
```

```ts
// app/api/example/route.ts — good (server-only)
const apiKey = process.env.OPENAI_API_KEY;
if (!apiKey) throw new Error("OPENAI_API_KEY is not set");
```

```ts
// avoid hardcoding
const apiKey = "sk-proj-example-not-a-real-key"; // will be flagged
```

Only prefix variables with `NEXT_PUBLIC_` when they are safe to ship to the browser.

## 3. Scan the repo

```bash
leash-secrets scan .
```

Run this after adding integrations (Stripe, OpenAI, Supabase, etc.).

## 4. Deploy notes

Configure the same server secrets in Vercel/Netlify/your host's environment UI — not in committed `.env` files.
