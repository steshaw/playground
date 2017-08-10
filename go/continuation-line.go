//
// Just playing around with long/continuation lines and gofmt.
//
package foo

func main() {
	err := database.QueryRow(
		"select * from users where user_id=?", id,
	).Scan(
		&ReadUser.ID, &ReadUser.Name, &ReadUser.First, &ReadUser.Last, &ReadUser.Email,
	)

	a = b + c + s +
		x + y
}
