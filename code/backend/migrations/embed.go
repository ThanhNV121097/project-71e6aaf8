package migrations

import "embed"

// Files holds SQL migrations applied in filename order.
//go:embed *.sql
var Files embed.FS
