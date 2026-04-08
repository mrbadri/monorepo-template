# Web monorepo template

A minimal [Turborepo](https://turbo.build/) starter: [pnpm](https://pnpm.io/) workspaces, a Next.js app in `apps/web` (Tailwind v4, shadcn-style setup, React Query, PWA), and shared `@repo/eslint-config` / `@repo/typescript-config`.

Fork or clone this repo, then rename the root `package.json` `name`, update titles in [`apps/web/src/app/layout.tsx`](apps/web/src/app/layout.tsx) and [`apps/web/public/manifest.json`](apps/web/public/manifest.json), and replace icons under `apps/web/public/` if you need your own branding.

## Local development (pnpm)

```sh
pnpm install
pnpm dev
# or only the web app:
pnpm exec turbo dev --filter=web
```

By default the Next.js dev server listens on port **3000** ([http://localhost:3000](http://localhost:3000)).

```sh
pnpm build
pnpm lint
pnpm check-types
```

## Docker (Makefile)

```sh
make help
make dev    # creates docker/dev/.env from .env.example if missing
make prod
make build  # production image: web-monorepo-web:latest
```

Dev and prod compose publish the app on **`127.0.0.1:${WEB_PORT:-10100}`** (container port `10001`). Set `WEB_PORT` in `docker/dev/.env` or `docker/prod/.env`.

### Docker image build args

[`apps/web/Dockerfile`](apps/web/Dockerfile) defaults to the public npm registry and `node:20-alpine`. For a private registry or mirror:

```sh
docker build -f apps/web/Dockerfile \
  --build-arg NPM_REGISTRY=https://your-registry/npm/ \
  --build-arg NODE_IMAGE=your-registry/node:20-alpine \
  -t web-monorepo-web:latest .
```

## Repository layout

| Path | Role |
|------|------|
| `apps/web` | Next.js App Router app |
| `packages/eslint-config` | Shared ESLint config |
| `packages/typescript-config` | Shared TypeScript configs |

## Remote caching (optional)

```sh
pnpm exec turbo login
pnpm exec turbo link
```

See [Turborepo remote caching](https://turborepo.dev/docs/core-concepts/remote-caching).

## Links

- [Tasks](https://turbo.build/repo/docs/crafting-your-repository/running-tasks)
- [Filtering](https://turbo.build/repo/docs/crafting-your-repository/running-tasks#using-filters)
# monorepo-template
