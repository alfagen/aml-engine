# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

AML Engine is a Ruby on Rails mountable engine for anti-money laundering compliance in the Kassa cryptocurrency exchange platform. It provides comprehensive functionality for managing client verification, document processing, and compliance workflows.

## Development Setup

### Prerequisites
- Ruby 2.7.8 (managed via rbenv)
- MySQL database
- Access to main Kassa Admin project for testing

### Testing Commands
```bash
# Run tests from main project directory (required)
cd /home/danil/code/kassa-admin
bundle exec rspec vendor/aml/spec

# Run specific test files
bundle exec rspec vendor/aml/spec/models/aml/order_spec.rb

# Run tests with different formatters
bundle exec rspec vendor/aml/spec --format documentation
bundle exec rspec vendor/aml/spec --format progress
```

**Important**: Tests must be run from the main Kassa Admin project directory, not from within the AML engine directory, as the engine depends on the parent application's configuration and dependencies.

### Available Rake Tasks
```bash
# Generate workflow diagrams for models
bundle exec rake doc:workflow MODEL=Order

# Run default test suite
bundle exec rake spec

# List all available tasks
bundle exec rake -T
```

## Architecture Overview

### Core Domain Models

**AML::Order**: Central entity representing client verification requests
- Workflow states: pending, documents_uploaded, processing, accepted, rejected
- Includes concerns for workflow management, notifications, and card validation
- Located in: `app/models/aml/order.rb`

**AML::Client**: Represents customers undergoing verification
- Profile information and verification status tracking
- Relationship with orders and agreements
- Located in: `app/models/aml/client.rb`

**AML::OrderDocument**: Document uploads for verification
- File handling via CarrierWave uploaders
- Validation and processing workflows
- Located in: `app/models/aml/order_document.rb`

**AML::DocumentKind**: Configurable document type definitions
- Field definitions and validation rules
- Multi-language support via Globalize
- Located in: `app/models/aml/document_kind.rb`

### Workflow System

Uses the `workflow` gem for state management:
- Order states: pending → documents_uploaded → processing → accepted/rejected
- Document states: pending → accepted → rejected
- Configurable transitions and validation rules
- Workflow diagrams can be generated with `rake doc:workflow MODEL=ModelName`

### Authorization System

Implements role-based access control using the `authority` gem:
- Operators can manage orders, clients, and documents
- Different permission levels for various actions
- Authorizers located in: `app/authorizers/aml/`

### API and Serialization

- JSON API serialization using FastJSONAPI
- Serializers for all major models in `app/serializers/aml/`
- RESTful controllers for CRUD operations

### File Upload and Processing

- CarrierWave for file uploads
- Image processing and validation
- Support for multiple document formats
- Uploaders in `app/uploaders/aml/`

## Key Components

### Controllers
- Admin interface controllers in `app/controllers/aml/`
- RESTful API endpoints for order management
- Document processing and validation workflows

### Decorators
- Draper decorators for view logic in `app/decorators/aml/`
- Separation of presentation logic from models

### Mailers
- Notification system for order status changes
- Email templates for client communication
- Located in: `app/mailers/aml/`

### Testing
- Comprehensive RSpec test suite
- Factory Bot factories in `factories/`
- Test helpers and support files
- Dummy Rails app in `spec/dummy/` for isolated testing

## Configuration Requirements

### Engine Initialization
The engine requires configuration in the host application:

```ruby
AML.configure do |config|
  config.allowed_emails = Secrets.aml_allowed_emails
  config.mail_from = Settings.mailer.default_from
  config.logger = ActiveSupport::Logger.new Rails.root.join './log/aml.log'
end
```

### Model Extensions
Host application should extend AML models with User integration:

```ruby
class AML::Operator
  has_one :user, class_name: 'User', foreign_key: :aml_operator_id

  def email
    user&.email || "no user for AML::Operator #{id}"
  end

  def name
    user&.name || "no user AML::Operator #{id}"
  end
end
```

## Dependencies and Gem Management

### Key Dependencies
- Rails 6.x (mountable engine)
- workflow (state management)
- authority (authorization)
- globalize (internationalization)
- carrierwave (file uploads)
- fast_jsonapi (serialization)
- draper (decorators)
- rspec-rails (testing)

### Development Dependencies
- Several gems use custom GitHub branches
- Some dependencies are forked for custom modifications
- Check Gemfile for specific branch requirements

## Common Development Patterns

### Workflow Transitions
```ruby
order = AML::Order.new
order.submit!  # Changes state to documents_uploaded
order.start_processing!  # Changes state to processing
order.accept!  # Changes state to accepted
```

### Document Processing
```ruby
document = order.order_documents.build(document_kind: passport_kind)
document.image = params[:file]
document.save!
document.accept!  # Mark document as accepted
```

### Authorization Checks
```ruby
# In controllers
authorize! :read, order
authorize! :update, client

# In views
if authorized_to?(:manage, order)
  # Show management controls
end
```

## Testing Notes

### Test Dependencies
- Tests require the main Kassa Admin application environment
- Uses DatabaseRewinder for fast test cleanup
- Factory Bot for test data generation

### Common Test Issues
- Missing DummyUser class - ensure proper test helpers are loaded
- Missing test files - ensure `spec/test_files/test.png` exists
- Git dependency issues - may need to run bundle install from main project

### Running Tests
Always run tests from the main project directory:
```bash
cd /home/danil/code/kassa-admin
bundle exec rspec vendor/aml/spec
```

## Integration Points

### Host Application Requirements
- Sorcery authentication system
- Authority authorization integration
- Mail configuration for notifications
- File storage configuration
- User model integration for operators

### Database Schema
- Uses isolated namespace with `aml_` prefix
- Full migration support
- Referential integrity with host application models

This engine is designed as a standalone component that can be mounted in any Rails application requiring AML compliance functionality, with specific integration points for the Kassa Admin platform.