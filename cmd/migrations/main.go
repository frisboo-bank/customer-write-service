package main

import (
	"fmt"

	migrationCommand "frisboo-bank/pkg/migration/command"
	"github.com/pterm/pterm"
	"github.com/pterm/pterm/putils"
)

func main() {
	fmt.Println("")
	_ = pterm.DefaultBigText.WithLetters(
		putils.LettersFromStringWithStyle("Customers Write", pterm.FgMagenta.ToStyle()),
		putils.LettersFromStringWithStyle(" Service", pterm.FgLightBlue.ToStyle()),
	).Render()

	err := migrationCommand.NewMigrationCommand().Execute()
	if err != nil {
		panic(err)
	}
}
