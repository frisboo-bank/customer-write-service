package models

import (
	"time"

	"github.com/gofrs/uuid"
)

type Customer struct {
	PersonalDetails CustomerPersonalDetails
	Addresses       []CustomerAddress
	Emails          []CustomerEmail
	PhoneNumbers    []CustomerPhoneNumber
	Nationalities   []CustomerNationality
	DisabledAt      time.Time
	DisabledReason  string
	DeletedAt       time.Time
	DeletedReason   string
}

type CustomerPersonalDetails struct {
	ID                   uuid.UUID
	Title                string
	FirstName            string
	MiddleName           string
	LastName             string
	FirstNameInEnglish   string
	MiddleNameInEnglish  string
	LastNameInEnglish    string
	DateOfBirth          time.Time
	CountryOfBirthCode   string
	GenderID             string
	IsPoliticallyExposed bool
	IsUSPerson           bool
	MaritalStatusID      string
	NumberOfDependents   int16
	CreatedAt            time.Time
	UpdatedAt            time.Time
}

type CustomerAddress struct {
	ID           uuid.UUID
	CustomerID   uuid.UUID
	AddressLine1 string
	AddressLine2 string
	AddressLine3 string
	AddressLine4 string
	AddressLine5 string
	City         string
	District     string
	State        string
	Region       string
	PostalCode   string
	CountryCode  string
	IsPrimary    bool
	Verified     bool
	VerifiedAt   time.Time
	DeletedAt    time.Time
	CreatedAt    time.Time
	UpdatedAt    time.Time
}

type CustomerEmail struct {
	ID         uuid.UUID
	CustomerID uuid.UUID
	Email      string
	IsPrimary  bool
	Verified   bool
	VerifiedAt time.Time
	DeletedAt  time.Time
	CreatedAt  time.Time
	UpdatedAt  time.Time
}

type CustomerNationality struct {
	CustomerID  uuid.UUID
	CountryCode string
	DeletedAt   time.Time
	CreatedAt   time.Time
	UpdatedAt   time.Time
}

type CustomerPhoneNumber struct {
	ID          uuid.UUID
	CustomerID  uuid.UUID
	CountryCode string
	PhoneNumber string
	IsPrimary   bool
	Verified    bool
	VerifiedAt  time.Time
	DeletedAt   time.Time
	CreatedAt   time.Time
	UpdatedAt   time.Time
}
