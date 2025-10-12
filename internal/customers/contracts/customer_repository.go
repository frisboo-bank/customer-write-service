package contracts

import (
	"context"

	"frisboo-bank/customer-write-service/internal/customers/models"
)

type CustomerRepository interface {
	SaveCustomer(ctx context.Context, customer *models.Customer) (*models.Customer, error)
	UpdateCustomer(ctx context.Context, customer *models.Customer) (*models.Customer, error)
}
