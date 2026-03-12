@startuml
title Library System - UML Class Diagram

class Author {
id: int
name: string
birthYear: int
}

class Book {
id: int
title: string
isbn: string
year: int
availableCopies: int
isAvailable(): boolean
}

class Category {
id: int
name: string
}

class User {
id: int
name: string
email: string
createdAt: Date
}

class Loan {
id: int
loanDate: Date
dueDate: Date
returnedDate: Date
}

Author "1" -- "0..*" Book : writes
Category "1" -- "0..*" Book : classifies
Book "1" -- "0..*" Loan : loaned in
User "1" -- "0..*" Loan : makes

@enduml
