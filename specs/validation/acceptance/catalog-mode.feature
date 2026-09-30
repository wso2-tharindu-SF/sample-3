Feature: Catalog mode

  @story-3
  Rule: An Internal Operator can switch Service2 between full mode and empty mode

    Scenario: Switching to empty mode
      Given Service2 is in full mode
      When the Internal Operator switches Service2 to empty mode
      Then Service2 serves a catalog with no records

    Scenario: Switching back to full mode
      Given Service2 is in empty mode
      When the Internal Operator switches Service2 to full mode
      Then Service2 serves the fixed 10-record catalog
