package infrastructure

import (
	"frisboo-bank/pkg/application/builder"
	"frisboo-bank/pkg/application/contracts"
)

type CustomersWriteApplicationInfrastructure struct {
	contracts.ApplicationInfrastructure
}

func NewCustomersWriteApplicationInfrastructure(app contracts.Application) *CustomersWriteApplicationInfrastructure {
	return &CustomersWriteApplicationInfrastructure{builder.NewApplicationInfrastructure(app)}
}

func (i *CustomersWriteApplicationInfrastructure) configureMediator() error {
	return nil
}
