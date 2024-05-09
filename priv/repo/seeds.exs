# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Et.Repo.insert!(%Et.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Et.Students.Student

[
  {"01", "Nicolas Arocas"},
  {"02", "Kolbjørn Austreng"},
  {"03", "Nikola Barila"},
  {"04", "Andreas Barmen"},
  {"05", "Fried Bauwens"},
  {"06", "Jordi Bernad Bougault"},
  {"07", "Mathieu Binder"},
  {"08", "Michael Blight"},
  {"09", "Helge Bogen"},
  {"10", "Jan Christian Blystad Boger"},
  {"11", "Maximilien Colas"},
  {"12", "Vegard Dalen"},
  {"13", "Kevin Dieste"},
  {"14", "Ole Marcus Egenes"},
  {"15", "Joel Esteban"},
  {"16", "Samuel Farquharson"},
  {"17", "Miquel Fernández Viña"},
  {"18", "Simon Flood"},
  {"19", "David Rene Flucke"},
  {"20", "Jacopo Fossati"},
  {"21", "Wouter Goossens"},
  {"22", "Lars Gundesø"},
  {"23", "Marco Øveraas Gutierres"},
  {"24", "Victor Hakonsen"},
  {"25", "Jacob Hamm"},
  {"26", "Joshua Hemphill"},
  {"27", "Håvard Hjertø"},
  {"29", "Jamie Horgan"},
  {"31", "Oliver Haakonsen"},
  {"32", "Florian Kalide"},
  {"33", "Ayoub Kelkoul"},
  {"34", "Dries Kemme"},
  {"35", "Max Kempenaar"},
  {"36", "Christopher Fredrik Kvæstad"},
  {"37", "Tycho Landa"},
  {"38", "Julian Leys"},
  {"39", "Nikolaos Lorentzos"},
  {"40", "Antonios Lygiros"},
  {"41", "Andrea Mackey"},
  {"42", "Johnatan Margaritha"},
  {"43", "Lucas Martinez Castilla"},
  {"44", "Adrià Morillas Garcia"},
  {"45", "Kelsey Mulder"},
  {"46", "Alejandro Muñoz García"},
  {"47", "Richard Nagy"},
  {"48", "Sery Noé"},
  {"49", "Even Nordeide"},
  {"50", "Kasper Norén"},
  {"51", "Mikael Olsson"},
  {"52", "Alexis Parent"},
  {"53", "Ivan Planman"},
  {"54", "Patrik Mendicini Prytz"},
  {"55", "Eric Renström"},
  {"56", "John Sandberg"},
  {"57", "Cyprien Roux"},
  {"58", "Connor Schrader"},
  {"59", "Vebjørn Stenvold"},
  {"60", "Andreas Strømsvik"},
  {"61", "Christian Stålkrantz"},
  {"62", "Bas Van Puyenbroeck"},
  {"63", "Sander Volden"},
  {"64", "Anthony Wyns"},
  {"65", "Ola Rudi"}
]
|> Enum.map(fn {number, name} -> Student.changeset(%Student{}, %{name: name, number: number}) end)
|> Enum.each(&Et.Repo.insert!/1)
