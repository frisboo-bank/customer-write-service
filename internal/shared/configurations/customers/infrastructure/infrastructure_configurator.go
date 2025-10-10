package infrastructure

import (
	"frisboo-bank/pkg/application/contracts"
)

type InfrastructureConfigurator struct {
	contracts.Application
}

func NewInfrastructureConfigurator(app contracts.Application) *InfrastructureConfigurator {
	return &InfrastructureConfigurator{Application: app}
}

func (ic *InfrastructureConfigurator) ConfigureInfrastructures() {
}
