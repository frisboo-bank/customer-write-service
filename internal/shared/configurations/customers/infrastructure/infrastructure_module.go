package infrastructure

import (
	applicationContracts "frisboo-bank/pkg/application/contracts"
	"frisboo-bank/pkg/container/dependencies/module"
	databaseclient "frisboo-bank/pkg/database/database_client"
	"frisboo-bank/pkg/health"
	httpserver "frisboo-bank/pkg/http/http_server"
	rpcserver "frisboo-bank/pkg/rpc/rpc_server"
	"frisboo-bank/pkg/validation"
)

func ModuleFunc(appBuilder applicationContracts.ApplicationBuilder) module.Module {
	validation.AssertNotNil("appBuilder", appBuilder)

	m := module.ModuleFunc(
		"infrastructure",

		httpserver.ModuleFunc(appBuilder),
		rpcserver.ModuleFunc(appBuilder),
		databaseclient.ModuleFunc(appBuilder),
		health.ModuleFunc(appBuilder),
	)
	return m
}
