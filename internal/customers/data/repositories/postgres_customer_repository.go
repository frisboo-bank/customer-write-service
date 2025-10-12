package repositories

import (
	"context"

	"frisboo-bank/customer-write-service/internal/customers/contracts"
	"frisboo-bank/customer-write-service/internal/customers/models"

	databaseclientContracts "frisboo-bank/pkg/database/database_client/contracts"
	loggerContracts "frisboo-bank/pkg/logger/contracts"
	tracerContracts "frisboo-bank/pkg/telemetry/tracing/contracts"
	"frisboo-bank/pkg/validation"
)

var _ contracts.CustomerRepository = (*postgresCustomerRepository)(nil)

type postgresCustomerRepository struct {
	dbClient databaseclientContracts.DatabaseClient
	logger   loggerContracts.Logger
	tracer   tracerContracts.Tracer
}

func NewPostgresCustomerRepository(
	dbClient databaseclientContracts.DatabaseClient,
	logger loggerContracts.Logger,
	tracer tracerContracts.Tracer,
) contracts.CustomerRepository {
	validation.AssertNotNil("dbClient", dbClient)
	validation.AssertNotNil("logger", logger)
	validation.AssertNotNil("tracer", tracer)

	return &postgresCustomerRepository{
		dbClient: dbClient,
		logger:   logger,
		tracer:   tracer,
	}
}

func (p *postgresCustomerRepository) SaveCustomer(
	ctx context.Context,
	customer *models.Customer,
) (*models.Customer, error) {
	p.tracer.Start(ctx, "postgresCustomerRepository.SaveCustomer")

	return nil, nil
}

func (p *postgresCustomerRepository) UpdateCustomer(
	ctx context.Context,
	customer *models.Customer,
) (*models.Customer, error) {
	p.tracer.Start(ctx, "postgresCustomerRepository.UpdateCustomer")

	return nil, nil
}
