package customers

import (
	"frisboo-bank/customers-write-service/internal/customers/constants"
	"frisboo-bank/customers-write-service/internal/customers/contracts"
	"frisboo-bank/customers-write-service/internal/customers/data/repositories"
	applicationContracts "frisboo-bank/pkg/application/contracts"
	"frisboo-bank/pkg/container/dependencies/module"
	"frisboo-bank/pkg/container/dependencies/provider"
	databaseclientContracts "frisboo-bank/pkg/database/database_client/contracts"
	httpserverContracts "frisboo-bank/pkg/http/http_server/contracts"
	loggerContracts "frisboo-bank/pkg/logger/contracts"
	"frisboo-bank/pkg/validation"
)

type customerRepositoryParams struct {
	DBClient databaseclientContracts.DatabaseClient `name:"databaseClientRef"`
	Logger   loggerContracts.Logger
}

type httpServerGroupParams struct {
	HTTPServer httpserverContracts.HTTPServer `name:"httpServerRef"`
}

func ModuleFunc(appBuilder applicationContracts.ApplicationBuilder) module.Module {
	validation.AssertNotNil("appBuilder", appBuilder)

	m := module.ModuleFunc("customers")

	m.AddProvider(provider.ProvideFunc(func(params customerRepositoryParams) contracts.CustomerRepository {
		dbClient := params.DBClient
		logger := params.Logger

		return repositories.NewPostgresCustomerRepository(dbClient, logger, nil)
	}))

	// m.AddProvider(provider.ProvideFunc(grpc.NewCustomerGrpcService))

	m.AddProvider(provider.ProvideFunc(func(params httpServerGroupParams) httpserverContracts.RouteGroup {
		srv := params.HTTPServer

		return srv.RouteBuilder().Root().Group("/customers")
	},
		provider.Name(constants.HTTPServerCustomersGroup),
		provider.NamedDep("httpServerRef", constants.MainHTTPServer),
	))

	return m
}
