Feature: Filling of addressbook
    As a user I want to fill the addressbook with entries

    Scenario: Initial state of created address book
        Given addressbook application is running
        When I create a new addressbook
        Then addressbook should be empty

    Scenario: State after adding one entry
        Given addressbook application is running
        When I create a new addressbook
        And I add a new person 'John','Doe','john@m.com','500600700' to address book
        Then '1' entries should be present

    Scenario: State after adding two entries
        Given addressbook application is running
        When I create a new addressbook
        And I add new persons to address book
            | forename  | surname  | email        | phone  |
            | John      | Smith    | john@m.com   | 123123 |
            | Alice     | Thomson  | alice@m.com  | 234234 |
        Then '2' entries should be present

    Scenario Outline: Adding single entry multiple time
        Given addressbook application is running
        When I create a new addressbook
        When I add a new person '<forename>','<lastname>','<email>','<phone>' to address book
        Then '1' entries should be present
        Examples:
            | forename | lastname | email       | phone     |
            | Bob      | Doe      | Bob@m.com   | 123321231 |
            | John     | Smith    | john@m.com  | 123123    |
            | Alice    | Thomson  | alice@m.com | 234234    |
