package app

import (
	"frisboo-bank/pkg/application/builder"
	"frisboo-bank/pkg/application/contracts"
)

type CustomersWriteApplicationBuilder struct {
	contracts.ApplicationBuilder
}

func NewCustomersWriteApplicationBuilder() (*CustomersWriteApplicationBuilder, error) {
	b, err := builder.NewApplicationBuilder()
	if err != nil {
		return nil, err
	}
	return &CustomersWriteApplicationBuilder{b}, nil
}

func (b *CustomersWriteApplicationBuilder) Build() contracts.Application {
	return NewCustomerApplication(
		b.Modules(),
		b.Providers(),
		b.Decorators(),
		b.Container(),
		b.Logger(),
		b.Environment())
}
