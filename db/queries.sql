-- name: GetCustomer :one
SELECT * FROM customer_personal_information
WHERE id = $1 LIMIT 1;
