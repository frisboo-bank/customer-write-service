package customers

import (
	"fmt"
	"net/http"

	"frisboo-bank/customers-write-service/internal/shared/configurations/customers/infrastructure"

	"frisboo-bank/pkg/application/contracts"
	"frisboo-bank/pkg/container/dependencies/invoker"
	httpServerContacts "frisboo-bank/pkg/http/http_server/contracts"
	"github.com/labstack/echo/v4"
	"go.uber.org/dig"
)

type CustomersWriteServiceConfigurator struct {
	contracts.Application
	infrastructureConfigurator *infrastructure.CustomersWriteApplicationInfrastructure
}

func NewCustomersWriteServiceConfigurator(app contracts.Application) *CustomersWriteServiceConfigurator {
	infraConfigurator := infrastructure.NewCustomersWriteApplicationInfrastructure(app)

	return &CustomersWriteServiceConfigurator{
		Application:                app,
		infrastructureConfigurator: infraConfigurator,
	}
}

func (c *CustomersWriteServiceConfigurator) ConfigureCustomers() error {
	if err := c.infrastructureConfigurator.ConfigureInfrastructure(); err != nil {
		return err
	}
	return nil
}

type mapCustomersEndpointsParams struct {
	dig.In
	HTTPServer httpServerContacts.HTTPServer `name:"http-server:customers-write-service"`
}

func (c *CustomersWriteServiceConfigurator) MapCustomersEndpoints() {
	c.ResolveFunc(invoker.InvokerFunc(func(params mapCustomersEndpointsParams) {
		srv := params.HTTPServer

		srv.RouteBuilder().RegisterRoutes(func(server any) {
			server.(*echo.Echo).GET("/", func(c echo.Context) error {
				return c.String(http.StatusOK, fmt.Sprintf("%s is running", "customer write service"))
			})
		})
	}))
}
