# GitHub Labeler Configuration

This repository uses GitHub's automated labeling system to automatically assign labels to pull requests based on the files changed. This enhances automation and maintainability for the repository's PR process.

## Configuration Files

### `.github/workflows/label.yml`
GitHub Actions workflow that runs the labeler action on pull request events. The workflow:
- Triggers on `pull_request_target` events (secure for public repositories)
- Uses the official `actions/labeler@v5` action
- Has appropriate permissions (`contents: read`, `pull-requests: write`)
- Enables `sync-labels` to automatically remove labels when files are removed

### `.github/labeler.yml`
Comprehensive labeling rules with granular patterns for different types of files and code organization.

## Label Categories

### Go Code Organization
- **`go`**: All Go source files (`**/*.go`)
- **`go/api`**: API handlers, controllers, and main entry points
- **`go/internal`**: All internal modules and packages
- **`go/models`**: Data models and entities
- **`go/services`**: Service layer implementation
- **`go/repositories`**: Repository pattern implementations
- **`go/configurations`**: Configuration and setup code
- **`go/contracts`**: Interfaces and contracts
- **`go/dtos`**: Data transfer objects

### Infrastructure & Database
- **`database`**: All database-related files
- **`migrations`**: Database migration scripts
- **`docker`**: Docker files and configurations

### Documentation & Configuration
- **`documentation`**: Markdown files, docs, and README files
- **`security`**: Security-related documentation and files
- **`configuration`**: Application configuration files
- **`json-config`**: JSON configuration files
- **`yaml-config`**: YAML configuration files (excluding workflows)

### Development & Testing
- **`tests`**: Test files and test directories
- **`scripts`**: Build scripts, Makefile, and shell scripts
- **`dependencies`**: Go module files (`go.mod`, `go.sum`)

### Application-Specific
- **`customers`**: Customer service specific code
- **`shared`**: Shared/common code across modules
- **`cmd`**: Application entry points and command-line tools

### GitHub & Metadata
- **`github-actions`**: GitHub Actions workflows and actions
- **`github-metadata`**: Other GitHub configuration files
- **`dependabot`**: Dependency update configuration

## How It Works

1. When a pull request is opened or updated, the labeler workflow is triggered
2. The workflow examines all changed files in the PR
3. Each file path is matched against the patterns defined in `labeler.yml`
4. Matching labels are automatically applied to the PR
5. If files are removed from the PR, corresponding labels are automatically removed (due to `sync-labels: true`)

## Examples

- Changing `internal/customers/models/customer.go` would apply: `go`, `go/internal`, `go/models`, `customers`
- Modifying `db/migrations/001_create_users.sql` would apply: `database`, `migrations`
- Updating `Dockerfile` would apply: `docker`
- Adding documentation in `README.md` would apply: `documentation`

## Benefits

- **Automated Organization**: PRs are automatically categorized by the type of changes
- **Review Routing**: Teams can filter PRs by labels to focus on their areas of expertise
- **Release Planning**: Labels help identify what components are affected in each release
- **Maintainability**: Consistent labeling improves project organization and workflow efficiency
- **Transparency**: Clear visibility into what parts of the codebase are being modified

## Customization

To modify the labeling rules:
1. Edit `.github/labeler.yml`
2. Add, remove, or modify label patterns using glob patterns
3. Test patterns using the validation script or by creating test PRs
4. The changes will take effect on the next PR that triggers the workflow