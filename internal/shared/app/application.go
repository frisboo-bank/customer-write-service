package app

import (
	"frisboo-bank/customer-write-service/internal/shared/configurations/customers"

	"frisboo-bank/pkg/application/app"
	applicationContracts "frisboo-bank/pkg/application/contracts"
	containerContracts "frisboo-bank/pkg/container/contracts"
	"frisboo-bank/pkg/container/dependencies/decorator"
	"frisboo-bank/pkg/container/dependencies/module"
	"frisboo-bank/pkg/container/dependencies/provider"
	"frisboo-bank/pkg/environment"
	loggerContracts "frisboo-bank/pkg/logger/contracts"
)

type _ = (applicationContracts.Application)

type CustomersWriteApplication struct {
	*customers.CustomersWriteServiceConfigurator
}

func NewCustomerApplication(
	modules []module.Module,
	providers []provider.Provider,
	decorators []decorator.Decorator,
	container containerContracts.Container,
	logger loggerContracts.Logger,
	environment environment.Environment,
) *CustomersWriteApplication {
	nApp := app.NewApplication(
		container,
		logger,
		environment,
		modules,
		providers,
		decorators,
	)

	return &CustomersWriteApplication{
		CustomersWriteServiceConfigurator: customers.NewCustomersWriteServiceConfigurator(nApp),
	}
}
