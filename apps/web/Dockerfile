# Omit `# syntax=docker/dockerfile:1` so BuildKit does not pull from Docker Hub (restricted DNS/CI).
#
# Build from repo root:
#   docker build -f apps/web/Dockerfile .
#
# Stages
#   base          — Node 20 + global pnpm
#   pnpm-registry — pnpm CLI pointed at the same registry (shared by dev + builder)
#   dev           — local dev (docker/dev); compose sets NODE_ENV / CI / telemetry
#   pruner        — turbo prune web --docker → out/json, out/full
#   builder       — frozen lockfile install, then turbo build --filter=web
#   runner        — Next.js standalone + static assets only
#
# Prune pattern: https://turbo.build/repo/docs/guides/tools/docker
# Install layers invalidate only when the pruned dependency graph changes.
#
# Overrides: --build-arg NPM_REGISTRY=...  --build-arg NODE_IMAGE=...
# Use a private registry or mirror, e.g.:
#   --build-arg NPM_REGISTRY=https://your-registry/npm/
#   --build-arg NODE_IMAGE=your-registry/node:20-alpine

ARG NPM_REGISTRY=https://registry.npmjs.org/
ARG NODE_IMAGE=node:20-alpine

# -----------------------------------------------------------------------------
FROM ${NODE_IMAGE} AS base
ARG NPM_REGISTRY
RUN npm config set registry $NPM_REGISTRY
RUN npm install -g pnpm@9.0.0

# -----------------------------------------------------------------------------
FROM base AS pnpm-registry
ARG NPM_REGISTRY
RUN pnpm config set registry "$NPM_REGISTRY" \
    && pnpm config set update-notifier false

# -----------------------------------------------------------------------------
FROM pnpm-registry AS dev
WORKDIR /app

# -----------------------------------------------------------------------------
FROM base AS pruner
WORKDIR /app
RUN npm install -g turbo@2.8.9
COPY . .
RUN turbo prune web --docker

# -----------------------------------------------------------------------------
FROM pnpm-registry AS builder
WORKDIR /app
COPY --from=pruner /app/out/json/ .
# BuildKit cache mount: same pnpm store reused across image builds (DOCKER_BUILDKIT=1)
RUN --mount=type=cache,id=pnpm-store,target=/pnpm/store \
    pnpm install --frozen-lockfile --store-dir=/pnpm/store
COPY --from=pruner /app/out/full/ .
ENV NEXT_TELEMETRY_DISABLED=1
RUN pnpm exec turbo run build --filter=web

# -----------------------------------------------------------------------------
# Same NODE_IMAGE as base (see top-level ARG); override once with --build-arg NODE_IMAGE=...
ARG NODE_IMAGE
FROM ${NODE_IMAGE} AS runner
ENV NODE_ENV=production \
    NEXT_TELEMETRY_DISABLED=1 \
    PORT=10001

RUN addgroup --system --gid 1001 nodejs \
    && adduser --system --uid 1001 nextjs

WORKDIR /app
COPY --from=builder /app/apps/web/public ./apps/web/public
COPY --from=builder --chown=nextjs:nodejs /app/apps/web/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/apps/web/.next/static ./apps/web/.next/static

USER nextjs
CMD ["node", "apps/web/server.js"]
