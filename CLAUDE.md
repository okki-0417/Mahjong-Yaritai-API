# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Rails 7.2.1 API-only application for a Mahjong game platform called "Mahjong Yaritai". The application focuses on "what to discard" problems where users analyze Mahjong hands and vote on which tile to discard.

### Core Architecture

- **Framework**: Rails 7.2.1 (API-only mode)
- **Database**: PostgreSQL with Redis for sessions and background jobs
- **Authentication**: Custom email-only authentication system (no passwords)
- **Background Jobs**: Sidekiq with Redis
- **File Storage**: ActiveStorage (local in dev, S3 in production)
- **APIs**: REST endpoints with OpenAPI 3.0.1 documentation + GraphQL
- **Serialization**: ActiveModel::Serializer

## Key Domain Models

### Authentication System
- **AuthRequest**: Stores email authentication tokens (6-digit codes, 15min expiry)
- **User**: Core user model with avatar (ActiveStorage), email-based auth only
- No password authentication - uses temporary tokens sent via email

### Mahjong Domain
- **Tile**: 34 different Mahjong tiles (suits: man, pin, sou, honor)
- **WhatToDiscardProblem**: 13-tile hand + 1 drawn tile, users vote on discard
- **WhatToDiscardProblemVote**: User votes on which tile to discard
- **Comments & Likes**: Standard social features on problems

### Key Relationships
```ruby
User has_many :created_what_to_discard_problems
WhatToDiscardProblem belongs_to 14 tiles (hand1_id..hand13_id, tsumo_id, dora_id)
WhatToDiscardProblem has_many :votes, :comments, :likes
```

## Development Environment

### Docker Setup
All commands should use Docker Compose:
```bash
# Start services
docker compose up

# Run Rails commands
docker compose exec app bundle exec rails [command]

# Database operations
docker compose exec app bundle exec rails db:create db:migrate db:seed

# Console
docker compose exec app bundle exec rails console

# Tests
docker compose exec app bundle exec rspec
docker compose exec app bundle exec rspec spec/specific_file_spec.rb
```

### Key Services
- **app**: Rails application (port 3001)
- **sidekiq**: Background job worker
- **db**: PostgreSQL database
- **redis**: Session store and job queue

## Testing & Documentation

### RSpec Testing
```bash
# Run all tests
docker compose exec app bundle exec rspec

# Run specific test
docker compose exec app bundle exec rspec spec/requests/users_spec.rb

# Generate API docs from tests
docker compose exec app bundle exec rails rswag:specs:swaggerize
```

### API Documentation
- Swagger UI available at `/api-docs`
- Generated from rswag specs in `spec/requests/`
- OpenAPI 3.0.1 specification

## Key Configuration Patterns

### Environment-Specific Settings
- **Development**: Uses `:local` storage, `:sidekiq` jobs, letter_opener_web for emails
- **Production**: Uses `:amazon` storage (S3), SMTP email, custom logging
- **Test**: Uses `:test` storage, `:test` job adapter

### Custom Middleware & Logging
- `CustomLogger`: Filters out health check logs and frequent session checks
- Session management via Redis with different security settings per environment

### Authentication Flow
1. POST `/auth/request` with email → sends 6-digit token
2. POST `/auth/verification` with token → returns user data + sets session
3. Session managed via Redis, expires after 1 month

## API Structure

### Namespaced Controllers
- `Auth::` - Authentication endpoints
- `Me::` - User-specific actions (profile, withdrawal)
- `WhatToDiscardProblems::` - Nested resources (comments, votes, likes)

### Key Endpoints
- `GET /session` - Current user session (called frequently by frontend)
- `POST /what_to_discard_problems` - Create new problem
- `GET /what_to_discard_problems/:id/votes/result` - Get voting results
- `POST /me/withdrawal` - User account deletion with email notification

## Background Jobs & Email

### Sidekiq Configuration
- Uses Redis for job queue
- Separate Docker container for workers
- Handles email delivery and file processing via ActiveJob

### Email System
- Development: letter_opener_web
- Production: SMTP via Gmail
- Automated emails: auth tokens, withdrawal confirmations

## File Storage & Assets

### ActiveStorage Setup
- Development/Test: Local disk storage
- Production: AWS S3 with proper environment variables
- Avatar URLs generated via serializers with fallback error handling

## Special Architectural Notes

### Cursor-Based Pagination
Custom implementation in `Paginationable` concern for better performance than offset pagination.

### Custom Validators
- Tile sequence validation for Mahjong hand sorting (理牌 validation)
- Localized error messages in Japanese

### Session Security
- Different session configurations per environment
- Redis-based sessions with proper cookie settings
- CSRF protection disabled (API-only)

## Environment Variables

### Required for Development
```
REDIS_HOST=redis
REDIS_PORT=6379
HOST_NAME=localhost:3001
USER_AGENT=your-health-check-agent
```

### Required for Production
```
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_REGION=ap-northeast-1
AWS_S3_BUCKET=
FRONTEND_HOST=
MAIL_ADDRESS=
MAIL_PASSWORD=
```

## Database Commands

```bash
# Create and setup
docker compose exec app bundle exec rails db:create db:migrate

# Seed with Mahjong tiles and test data
docker compose exec app bundle exec rails db:seed

# Reset database
docker compose exec app bundle exec rails db:drop db:create db:migrate db:seed
```

## Deployment

- Configured for Kamal deployment
- Render deployment ready
- Sentry error monitoring integrated
- Custom health check endpoints at `/` and `/up`