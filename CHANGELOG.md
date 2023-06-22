# Changelog

## 0.4.0
`0.4.0` is a complete rewrite that ditches React and focuses solely on Phoenix. 
Reasons for that are explained in [#391](https://github.com/zvonimirr/tenantee/pull/391), and some features were cut for the time being, but will likely
be added again shortly. The core functionality was kept (manage properties, tenants and rents).

But, there are some other changes as well:
- Preferences (now called configs) are stored in Redis ([@zvonimirr](https://github.com/zvonimirr))
- Replaced Oban with Quantum for cron-jobs ([@zvonimirr](https://github.com/zvonimirr))
- Rents and communication channels are managed from their own pages ([@zvonimirr](https://github.com/zvonimirr))
- Configuration is forced before adding properties, tenants etc. ([@zvonimirr](https://github.com/zvonimirr))
- Deployment guides for AWS and Fly.io ([@zvonimirr](https://github.com/zvonimirr) and [@lukaevet](https://github.com/lukaevet))

## 0.3.0
### API
- Properties now have a tax percentage field ([@zvonimirr](https://github.com/zvonimirr))
- Tax percentage is applied when calculating monthly revenue ([@zvonimirr](https://github.com/zvonimirr))
- Fix improper CORS origin match ([@zvonimirr](https://github.com/zvonimirr))
- Expenses CRUD ([@zvonimirr](https://github.com/zvonimirr))
- Properties now return a list of expenses ([@zvonimirr](https://github.com/zvonimirr))
- Added communication channels for tenants ([@zvonimirr](https://github.com/zvonimirr))

### UI
- Add contact icons for tenants ([@MilaFazekas](https://github.com/MilaFazekas))
- Tenant names are now aligned properly ([@MilaFazekas](https://github.com/MilaFazekas))
- Dark mode support ([@zvonimirr](https://github.com/zvonimirr))
- Generalized and simplified using Service API's ([@jvince](https://github.com/jvince))
- Refactored pages to use new Service API model ([@jvince](https://github.com/jvince))
- Tax is editable from the UI on a per property basis ([@zvonimirr](https://github.com/zvonimirr))
- Added communication channels for tenants ([@zvonimirr](https://github.com/zvonimirr))
- Communication channels are now in a tenant card modal ([@zvonimirr](https://github.com/zvonimirr))

## 0.2.0
### API
- Rent system API (cron, listing etc.) ([@zvonimirr](https://github.com/zvonimirr))
- SSL support (with Docker and without) ([@zvonimirr](https://github.com/zvonimirr))
- Normalize responses and clean up Swagger docs ([@zvonimirr](https://github.com/zvonimirr))
- Better error handling and test cleanup ([@zvonimirr](https://github.com/zvonimirr))
- Set & list preferences API method ([@zvonimirr](https://github.com/zvonimirr))
- Implement on-the-fly currency conversion ([@zvonimirr](https://github.com/zvonimirr))
- Properties and tenants now return monthly revenue prediction ([@zvonimirr](https://github.com/zvonimirr))
- Tenants now return properties they belong to ([@zvonimirr](https://github.com/zvonimirr))

### UI
- Rent status is now displayed ([@kovaj024](https://github.com/kovaj024))
- Tenant overview page ([@kovaj024](https://github.com/kovaj024))
- Marking rent status via UI ([@kovaj024](https://github.com/kovaj024))
- Settings page to set preferences ([@zvonimirr](https://github.com/zvonimirr))
- Remove React Select Currency ([@zvonimirr](https://github.com/zvonimirr))
- Allow adding/removing tenant to a property from the tenant overview page ([@kovaj024](https://github.com/kovaj024))
- Turn home page into stats page ([@zvonimirr](https://github.com/zvonimirr))
- Allow setting the due date modifier from the UI ([@zvonimirr](https://github.com/zvonimirr))

## 0.1.0

### API
- API health check ([@zvonimirr](https://github.com/zvonimirr))
- Complete CRUD for tenant and property models ([@zvonimirr](https://github.com/zvonimirr))
- Tenant property relation and API methods ([@zvonimirr](https://github.com/zvonimirr))
- ExCoveralls, Phoenix Swagger, Credo and Sobelow setup ([@zvonimirr](https://github.com/zvonimirr))
- Dockerization of the API ([@jvince](https://github.com/jvince))

### UI
- ESLint, Prettier and EditorConfig setup ([@zvonimirr](https://github.com/zvonimirr))
- Drawer menu ([@kovaj024](https://github.com/kovaj024))
- Property listing and overview pages ([@zvonimirr](https://github.com/zvonimirr))
- Tenant listing page ([@zvonimirr](https://github.com/zvonimirr))
- Property creation, deletion and update modals and HTTP calls ([@zvonimirr](https://github.com/zvonimirr))
- Tenant creation and deletion modals and HTTP calls ([@zvonimirr](https://github.com/zvonimirr))
- Tenant update modal and HTTP call ([@kovaj024](https://github.com/kovaj024))
- Dockerization of the UI ([@lukaevet](https://github.com/lukaevet))
