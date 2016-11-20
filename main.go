package main

import (
	"flag"
	"fmt"
	"io/ioutil"
	"log"
	"os"

	"github.com/ghodss/yaml"
)

func main() {
	flag.Usage = func() {
		fmt.Fprintf(os.Stderr, "usage: %s < file.yaml > file.json\n", os.Args[0])
	}
	helpMode := flag.Bool("h", false, "display usage")
	flag.Parse()
	if *helpMode {
		flag.Usage()
		os.Exit(1)
	}

	buf, err := ioutil.ReadAll(os.Stdin)
	if err != nil {
		log.Fatalf("Error reading stdin: %s", err)
	}

	out, err := yaml.YAMLToJSON(buf)
	if err != nil {
		fmt.Printf("err: %v\n", err)
		return
	}
	fmt.Fprintf(os.Stdout, "%s\n", out)
}
