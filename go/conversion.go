// From https://talks.golang.org/2017/state-of-go.slide#6
package main

import "fmt"

type Person struct {
	Name     string
	AgeYears int
	SSN      int
}

func main() {
	// And that for some reason, like JSON you also have:
	aux := struct {
		Name     string `json:"full_name"`
		AgeYears int    `json:"age"`
		SSN      int    `json:"social_security"`
	}{
		"Steven Shaw",
		21,
		1000000001,
	}

	aux.Name = "Steven Shaw"
	aux.AgeYears = -1
	aux.SSN = -1
	aux.Name = "Fred Flintstone"

	p1 := Person{
		Name:     aux.Name,
		AgeYears: aux.AgeYears,
		SSN:      aux.SSN,
	}

	p2 := Person(aux)

	var pp = func(varName string, person Person) {
		fmt.Printf("%s.Name = %v\n", varName, person.Name)
	}
	pp("p1", p1)
	pp("p2", p2)
}
