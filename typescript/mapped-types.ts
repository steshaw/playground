type Person = {
  firstName: string;
  lastName: string;
};

type PrefixedPerson = {
  [P in keyof Person as `person${Capitalize<P>}`]: Person[P];
};

const person: PrefixedPerson = { personFirstName: "John", personLastName: "Doe" };
console.log(person);
