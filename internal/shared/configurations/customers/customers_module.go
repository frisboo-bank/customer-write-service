package customers

import (
	"frisboo-bank/customers-write-service/internal/shared/configurations/customers/infrastructure"

	applicationContracts "frisboo-bank/pkg/application/contracts"
	"frisboo-bank/pkg/container/dependencies/module"
	"frisboo-bank/pkg/validation"
)

func ModuleFunc(appBuilder applicationContracts.ApplicationBuilder) module.Module {
	validation.AssertNotNil("appBuilder", appBuilder)

	m := module.ModuleFunc(
		"customers",

		infrastructure.ModuleFunc(appBuilder),
	)

	return m
}
