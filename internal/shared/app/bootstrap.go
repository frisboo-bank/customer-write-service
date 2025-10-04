package app

import (
	"context"

	"frisboo-bank/customers-write-service/internal/shared/configurations/customers"

	"frisboo-bank/pkg/syserrors"
)

type Bootstrap struct{}

func NewBootstrap() *Bootstrap {
	return &Bootstrap{}
}

func (b *Bootstrap) Run() error {
	appBuilder, err := NewCustomersWriteApplicationBuilder()
	if err != nil {
		return syserrors.Wrap(err, "failed to initialize the application builder")
	}

	appBuilder.ProvideModule(
		customers.ModuleFunc(appBuilder),
	)

	appIface := appBuilder.Build()

	app, ok := appIface.(*CustomersWriteApplication)
	if !ok {
		return syserrors.New("failed to cast application to CustomersWriteApplication")
	}

	if err := app.ConfigureCustomers(); err != nil {
		return syserrors.Wrap(err, "failed to configure customers layer")
	}

	app.MapCustomersEndpoints()

	app.Logger().Info("Starting application...")

	if err := app.Start(context.Background()); err != nil {
		return syserrors.Wrap(err, "failed to start app")
	}

	app.Logger().Info("Application stopped")

	return nil
}
