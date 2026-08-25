package migrations

import "embed"

// Files holds SQL migrations embedded beside this package.
//go:embed *.sql
var Files embed.FS
